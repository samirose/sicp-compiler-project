SCHEME := plt-r6rs
LIBDIR := lib/
LIBS := lists scheme-syntax wasm-syntax wasm-definitions-table wasm-compiler
LIBDIRS = $(addprefix $(LIBDIR),$(LIBS))
COMPILED_COMPILER := compiled/driver_sps.dep compiled/driver_sps.zo

$(COMPILED_COMPILER) &: $(LIBDIRS) driver.sps
	$(SCHEME) ++path $(LIBDIR) --compile driver.sps

$(LIBDIR)% : %.sls
	rm -rf $@
	$(SCHEME) --install --collections $(LIBDIR) $<
	touch $@

lib/wasm-definitions-table : lib/lists
lib/wasm-compiler : lib/lists lib/scheme-syntax lib/wasm-syntax lib/wasm-definitions-table

.PHONY : compile
compile : $(COMPILED_COMPILER)
	$(SCHEME) ++path $(LIBDIR) driver.sps $<


TEST_PROGRAMS = $(wildcard test/*.scm)
TEST_LOGS = $(patsubst test/%.scm,test/log/%.log,$(TEST_PROGRAMS))

.PHONY : test
test : $(TEST_LOGS)

test/build:
	mkdir -p test/build

test/log :
	mkdir -p test/log

$(TEST_LOGS) : test/log/%.log : test/build/%.json test/log
	spectest-interp $< | tee $@

test/build/%.json : test/build/%.wast
	wast2json $< -o $@

test/build/%.wast : test/build/%.wat test/%.wast
	cat $^ > $@

test/build/%.wat : test/%.scm $(COMPILED_COMPILER) test/build
	$(SCHEME) ++path $(LIBDIR) driver.sps < $< > $@


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
	-rm -rf test/build test/log
