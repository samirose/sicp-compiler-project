COMPILER_TEST_PROGRAMS := $(wildcard test-compiler/test/*.scm)
COMPILER_TEST_HOST_TARGETS := $(COMPILER_TEST_PROGRAMS:test-compiler/test/%.scm=test-compiler/%-host)
COMPILER_TEST_HOST_LOGS := $(COMPILER_TEST_PROGRAMS:test-compiler/test/%.scm=test-compiler/host-log/%.log)
RUN_COMPILER_TEST_HOST := $(HOST_SCHEME_RUN_PROGRAM) -L .. -L ../lib

test-compiler/build/ \
test-compiler/log/ \
test-compiler/host-log/ \
test-compiler/wast-log/ \
test-compiler/wat :
	mkdir -p $@

.PHONY : test-compiler
test-compiler : ## Executes all compiler integration tests
test-compiler : test-compiler-host test-compiler-wast

.PHONY : test-compiler-host
test-compiler-host : ## Executes the compiler integration tests on the host scheme
test-compiler-host : $(COMPILER_TEST_HOST_LOGS)

$(COMPILER_TEST_HOST_TARGETS) : test-compiler/%-host : test-compiler/host-log/%.log

$(COMPILER_TEST_HOST_LOGS) : test-compiler/host-log/%.log : test-compiler/%.scm \
                                                            test-compiler/test/%.scm \
                                                            test-compiler/lib/compiler-test.scm \
                                                            | test-compiler/host-log/
	cd test-compiler/host-log ; \
	rm -f $(notdir $(@:%.log=%.fail.log)) ; \
	$(RUN_COMPILER_TEST_HOST) ../test/$(notdir $<) || \
	(mv -f $(notdir $@) $(notdir $(@:%.log=%.fail.log)) && cat $(notdir $(@:%.log=%.fail.log)))

COMPILER_TEST_WAST_TARGETS := $(COMPILER_TEST_PROGRAMS:test-compiler/test/%.scm=test-compiler/%-wast)
COMPILER_TEST_WAST_TESTS := $(COMPILER_TEST_PROGRAMS:test-compiler/test/%.scm=test-compiler/build/%-test.wast)
COMPILER_TEST_WAST_LOGS := $(COMPILER_TEST_PROGRAMS:test-compiler/test/%.scm=test-compiler/wast-log/%.log)
COMPILER_TEST_WAST_COMPILER := test-compiler/lib/compiler-test-to-wast.scm
COMPILER_TEST_TO_WAST := $(HOST_SCHEME_RUN_PROGRAM) -L . -C $(HOST_SCHEME_COMPILED_DIR) $(COMPILER_TEST_WAST_COMPILER)
COMPILER_TEST_SCM_MODULES := $(wildcard test-compiler/*.scm)
COMPILER_TEST_WAT_MODULES := $(COMPILER_TEST_SCM_MODULES:test-compiler/%.scm=test-compiler/wat/%.wat)

.PHONY : test-compiler-wast
test-compiler-wast : ## Compiles the compiler tests to WAST scripts and executes them
test-compiler-wast : $(COMPILER_TEST_WAST_LOGS) $(COMPILER_TEST_WAT_MODULES)

$(COMPILER_TEST_WAST_TARGETS) : test-compiler/%-wast : test-compiler/wast-log/%.log

$(COMPILER_TEST_WAST_LOGS) : test-compiler/wast-log/%.log : test-compiler/build/%-test.json \
                                                            | test-compiler/wast-log/
	spectest-interp $< | tee $@.tmp \
	  && mv -f $@.tmp $@

test-compiler/build/%-test.json : test-compiler/build/%.wat \
                                  test-compiler/build/%-test.wast \
                                  | test-compiler/build/
	cat $^ | wast2json - -o $@.tmp \
	  && mv -f $@.tmp $@

$(COMPILER_TEST_WAST_TESTS) : test-compiler/lib/compiler-test-to-wast.scm
$(COMPILER_TEST_WAST_TESTS) : test-compiler/build/%-test.wast : test-compiler/test/%.scm \
                                                                | test-compiler/build/
	$(COMPILER_TEST_TO_WAST) < $< > $@.tmp \
	  && mv -f $@.tmp $@

$(COMPILER_TEST_WAT_MODULES) : test-compiler/wat/%.wat : test-compiler/build/%.wat \
                                                         | test-compiler/wat
	wat-desugar $< -o $@

test-compiler/log/%.log : test-compiler/build/%.json | test-compiler/log/
	spectest-interp $< | tee $@.tmp \
	  && mv -f $@.tmp $@

test-compiler/build/%.json : test-compiler/build/%.wat \
                             test-compiler/wast/%.wast \
                             | test-compiler/build/
	cat $^ | wast2json - -o $@.tmp \
	  && mv -f $@.tmp $@

test-compiler/build/%.wat : test-compiler/%.scm $(COMPILER_BINARIES) | test-compiler/build/
	$(RUN_COMPILER) < $< > $@.tmp \
	  && mv -f $@.tmp $@

.PRECIOUS : test-compiler/build/%.json test-compiler/build/%.wast test-compiler/build/%.wat

.PHONY : clean-test-compiler
clean-test-compiler: ## Removes compiler test build artefacts and results
	-rm -rf \
	  test-compiler/build \
	  test-compiler/host-log \
	  test-compiler/wast-log
