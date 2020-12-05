SHELL = /bin/bash
.SHELLFLAGS = -o pipefail -c
LIBDIR := lib/
LIBS := \
	lists \
	pattern-match \
	scheme-syntax \
	scheme-r7rs-syntax \
	lexical-env \
	wasm-syntax \
	wasm-module-definitions \
	compiled-program \
	compilation-error \
	expression-compiler \
	module-compiler
LIBDIRS = $(addprefix $(LIBDIR),$(LIBS))
COMPILED_COMPILER := compiled/driver_sps.dep compiled/driver_sps.zo
SCHEME := plt-r6rs
SCHEME_COMPILE_PROGRAM := plt-r6rs ++path ${LIBDIR} --compile
SCHEME_COMPILE_LIBRARY := plt-r6rs --install --collections ${LIBDIR}
SCHEME_RUN_PROGRAM := plt-r6rs ++path ${LIBDIR}

$(COMPILED_COMPILER) &: $(LIBDIRS) driver.sps
	rm -f $(COMPILED_COMPILER)
	$(SCHEME_COMPILE_PROGRAM) driver.sps

$(LIBDIR)% : %.sls
	rm -rf $@
	$(SCHEME_COMPILE_LIBRARY) $<
	touch $@

RUN_DRIVER = $(SCHEME_RUN_PROGRAM) driver.sps

lib/wasm-module-definitions : lib/lists
lib/compiled-program : lib/wasm-module-definitions
lib/scheme-r7rs-syntax: lib/compilation-error lib/pattern-match
lib/scheme-syntax: lib/compilation-error lib/pattern-match
lib/expression-compiler : \
	lib/lists \
	lib/scheme-syntax \
	lib/lexical-env \
	lib/compiled-program \
	lib/wasm-module-definitions \
	lib/compilation-error
lib/module-compiler : \
	lib/lists \
	lib/scheme-syntax \
	lib/scheme-r7rs-syntax \
	lib/compilation-error \
	lib/lexical-env \
	lib/compiled-program \
	lib/wasm-syntax \
	lib/expression-compiler

.PHONY : compile
compile : $(COMPILED_COMPILER)
	$(RUN_DRIVER) $<

TEST_COMPILER_DIR := test-compiler
COMPILER_TEST_PROGRAMS = $(wildcard $(TEST_COMPILER_DIR)/*.scm)
COMPILER_TEST_LOGS = $(patsubst $(TEST_COMPILER_DIR)/%.scm,$(TEST_COMPILER_DIR)/log/%.log,$(COMPILER_TEST_PROGRAMS))

.PHONY : test-compiler-dirs test-compiler
test-compiler : test-compiler-dirs $(COMPILER_TEST_LOGS)

test-compiler-dirs : $(TEST_COMPILER_DIR)/build $(TEST_COMPILER_DIR)/log
$(TEST_COMPILER_DIR)/build :
	mkdir -p $@
 $(TEST_COMPILER_DIR)/log :
	mkdir -p $@

$(TEST_COMPILER_DIR)/log/%.log : $(TEST_COMPILER_DIR)/build/%.json
	spectest-interp $< | tee $@.tmp \
	  && mv -f $@.tmp $@

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

.PHONY : test-unit-dirs test-unit
test-unit : test-unit-dirs $(UNIT_TEST_LOGS)

test-unit-dirs : $(TEST_UNIT_DIR)/log
$(TEST_UNIT_DIR)/log :
	mkdir -p $@

$(UNIT_TEST_LOGS) : $(TEST_UNIT_DIR)/log/%.log : $(TEST_UNIT_DIR)/%.sps $(LIBDIRS) $(UNIT_TEST_LIBS)
	$(SCHEME_RUN_PROGRAM) $< > $@.tmp \
	  && mv -f $@.tmp $@

.PHONY : test
test : test-unit test-compiler

.PHONY : cleanall
cleanall : cleantest cleancompiler cleanlibs

.PHONY : cleancompiler
cleancompiler :
	-rm -rf $(COMPILED_COMPILER)

.PHONY : cleanlibs
cleanlibs :
	-rm -rf $(LIBDIRS)

.PHONY : cleantest
cleantest :
	-rm -rf $(TEST_UNIT_DIR)/log $(TEST_COMPILER_DIR)/build $(TEST_COMPILER_DIR)/log $(UNIT_TEST_LIBS)
