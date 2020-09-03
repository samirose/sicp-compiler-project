SHELL = /bin/bash
.SHELLFLAGS = -o pipefail -c
SCHEME := plt-r6rs
LIBDIR := lib/
LIBS := lists \
        scheme-syntax \
		scheme-r7rs-syntax \
		lexical-env \
		wasm-syntax \
		wasm-module-definitions \
		compiled-program \
		wasm-compiler
LIBDIRS = $(addprefix $(LIBDIR),$(LIBS))
COMPILED_COMPILER := compiled/driver_sps.dep compiled/driver_sps.zo

$(COMPILED_COMPILER) &: $(LIBDIRS) driver.sps
	$(SCHEME) ++path $(LIBDIR) --compile driver.sps

$(LIBDIR)% : %.sls
	rm -rf $@
	$(SCHEME) --install --collections $(LIBDIR) $<

RUN_DRIVER = $(SCHEME) ++path $(LIBDIR) driver.sps

lib/wasm-module-definitions : lib/lists
lib/compiled-program : lib/wasm-module-definitions
lib/wasm-compiler : lib/lists \
                    lib/lexical-env \
					lib/scheme-syntax \
					lib/scheme-r7rs-syntax \
					lib/wasm-syntax \
					lib/compiled-program \
					lib/wasm-module-definitions

.PHONY : compile
compile : $(COMPILED_COMPILER)
	$(RUN_DRIVER) $<

TEST_COMPILER_DIR := test-compiler
COMPILER_TEST_PROGRAMS = $(wildcard $(TEST_COMPILER_DIR)/*.scm)
COMPILER_TEST_LOGS = $(patsubst $(TEST_COMPILER_DIR)/%.scm,$(TEST_COMPILER_DIR)/log/%.log,$(COMPILER_TEST_PROGRAMS))

.PHONY : test-compiler
test-compiler : $(COMPILER_TEST_LOGS)

$(TEST_COMPILER_DIR)/build $(TEST_COMPILER_DIR)/log:
	mkdir -p $@

$(COMPILER_TEST_LOGS) : $(TEST_COMPILER_DIR)/log/%.log : $(TEST_COMPILER_DIR)/build/%.json $(TEST_COMPILER_DIR)/log
	spectest-interp $< | tee $@

$(TEST_COMPILER_DIR)/build/%.json : $(TEST_COMPILER_DIR)/build/%.wast
	wast2json $< -o $@

$(TEST_COMPILER_DIR)/build/%.wast : $(TEST_COMPILER_DIR)/build/%.wat $(TEST_COMPILER_DIR)/%.wast
	cat $^ > $@

$(TEST_COMPILER_DIR)/build/%.wat : $(TEST_COMPILER_DIR)/%.scm $(COMPILED_COMPILER) $(TEST_COMPILER_DIR)/build
	$(RUN_DRIVER) < $< > $@

.PRECIOUS : $(TEST_COMPILER_DIR)/build/%.json $(TEST_COMPILER_DIR)/build/%.wast $(TEST_COMPILER_DIR)/build/%.wat

TEST_UNIT_DIR := test-unit
UNIT_TEST_LIBS = lib/assert
UNIT_TEST_PROGRAMS = $(wildcard $(TEST_UNIT_DIR)/*.sps)
UNIT_TEST_LOGS = $(patsubst $(TEST_UNIT_DIR)/%.sps,$(TEST_UNIT_DIR)/log/%.log,$(UNIT_TEST_PROGRAMS))

.PHONY : test-unit
test-unit : $(UNIT_TEST_LOGS)

$(TEST_UNIT_DIR)/log:
	mkdir -p $@

$(UNIT_TEST_LOGS) : $(TEST_UNIT_DIR)/log/%.log : $(TEST_UNIT_DIR)/%.sps $(TEST_UNIT_DIR)/log $(LIBDIRS) $(UNIT_TEST_LIBS)
	$(SCHEME) ++path $(LIBDIR) $< > $@

.PHONY : test
test : test-unit test-compiler

.PHONY : cleanall
cleanall : cleantest cleanlibs cleancompiler

.PHONY : cleancompiler
cleancompiler :
	-rm -rf $(COMPILED_COMPILER)

.PHONY : cleanlibs
cleanlibs :
	-rm -rf $(LIBDIRS)

.PHONY : cleantest
cleantest :
	-rm -rf $(TEST_UNIT_DIR)/log $(TEST_COMPILER_DIR)/build $(TEST_COMPILER_DIR)/log $(UNIT_TEST_LIBS)
