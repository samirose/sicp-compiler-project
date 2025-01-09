COMPILER_TEST_PROGRAMS := $(wildcard $(TEST_COMPILER_DIR)test/*.scm)
COMPILER_TEST_HOST_TARGETS := $(COMPILER_TEST_PROGRAMS:$(TEST_COMPILER_DIR)test/%.scm=$(TEST_COMPILER_DIR)%-host)
COMPILER_TEST_HOST_LOGS := $(COMPILER_TEST_PROGRAMS:$(TEST_COMPILER_DIR)test/%.scm=$(TEST_COMPILER_DIR)host-log/%.log)
RUN_COMPILER_TEST_HOST := $(HOST_SCHEME_RUN_PROGRAM) -L .. -L ../lib

$(TEST_COMPILER_DIR)build/ \
$(TEST_COMPILER_DIR)log/ \
$(TEST_COMPILER_DIR)host-log/ \
$(TEST_COMPILER_DIR)wast-log/ \
$(TEST_COMPILER_DIR)wat :
	mkdir -p $@

.PHONY : test-compiler
test-compiler: test-compiler-host test-compiler-wast

.PHONY : test-compiler-host
test-compiler-host : $(COMPILER_TEST_HOST_LOGS) ## Executes the compiler integration tests on the host scheme

$(COMPILER_TEST_HOST_TARGETS) : $(TEST_COMPILER_DIR)%-host : $(TEST_COMPILER_DIR)host-log/%.log

$(COMPILER_TEST_HOST_LOGS) : $(TEST_COMPILER_DIR)host-log/%.log : $(TEST_COMPILER_DIR)%.scm \
                                                                  $(TEST_COMPILER_DIR)test/%.scm \
                                                                  $(TEST_COMPILER_DIR)/lib/compiler-test.scm \
                                                                  | $(TEST_COMPILER_DIR)host-log/
	cd $(TEST_COMPILER_DIR)host-log ; \
	rm -f $(notdir $(@:%.log=%.fail.log)) ; \
	$(RUN_COMPILER_TEST_HOST) ../test/$(notdir $<) || \
	(mv -f $(notdir $@) $(notdir $(@:%.log=%.fail.log)) && cat $(notdir $(@:%.log=%.fail.log)))

COMPILER_TEST_WAST_TARGETS := $(COMPILER_TEST_PROGRAMS:$(TEST_COMPILER_DIR)test/%.scm=$(TEST_COMPILER_DIR)%-wast)
COMPILER_TEST_WAST_TESTS := $(COMPILER_TEST_PROGRAMS:$(TEST_COMPILER_DIR)test/%.scm=$(TEST_COMPILER_DIR)build/%-test.wast)
COMPILER_TEST_WAST_LOGS := $(COMPILER_TEST_PROGRAMS:$(TEST_COMPILER_DIR)test/%.scm=$(TEST_COMPILER_DIR)wast-log/%.log)
COMPILER_TEST_WAST_COMPILER := $(TEST_COMPILER_DIR)lib/compiler-test-to-wast.scm
COMPILER_TEST_TO_WAST := $(HOST_SCHEME_RUN_PROGRAM) -L . -C $(HOST_SCHEME_COMPILED_DIR) $(COMPILER_TEST_WAST_COMPILER)
COMPILER_TEST_SCM_MODULES := $(wildcard $(TEST_COMPILER_DIR)*.scm)
COMPILER_TEST_WAT_MODULES := $(COMPILER_TEST_SCM_MODULES:$(TEST_COMPILER_DIR)%.scm=$(TEST_COMPILER_DIR)wat/%.wat)

.PHONY : test-compiler-wast
test-compiler-wast : $(COMPILER_TEST_WAST_LOGS) $(COMPILER_TEST_WAT_MODULES) ## Compiles the compiler tests to WAST scripts and executes them

$(COMPILER_TEST_WAST_TARGETS) : $(TEST_COMPILER_DIR)%-wast : $(TEST_COMPILER_DIR)wast-log/%.log

$(COMPILER_TEST_WAST_LOGS) : $(TEST_COMPILER_DIR)wast-log/%.log : $(TEST_COMPILER_DIR)build/%-test.json \
                                                                  | $(TEST_COMPILER_DIR)wast-log/
	spectest-interp $< | tee $@.tmp \
	  && mv -f $@.tmp $@

$(TEST_COMPILER_DIR)build/%-test.json : $(TEST_COMPILER_DIR)build/%.wat \
                                        $(TEST_COMPILER_DIR)build/%-test.wast \
                                        | $(TEST_COMPILER_DIR)build/
	cat $^ | wast2json - -o $@.tmp \
	  && mv -f $@.tmp $@

$(COMPILER_TEST_WAST_TESTS) : $(TEST_COMPILER_DIR)lib/compiler-test-to-wast.scm
$(COMPILER_TEST_WAST_TESTS) : $(TEST_COMPILER_DIR)build/%-test.wast : $(TEST_COMPILER_DIR)test/%.scm \
                                                                      | $(TEST_COMPILER_DIR)build/
	$(COMPILER_TEST_TO_WAST) < $< > $@.tmp \
	  && mv -f $@.tmp $@

$(COMPILER_TEST_WAT_MODULES) : $(TEST_COMPILER_DIR)wat/%.wat : $(TEST_COMPILER_DIR)build/%.wat \
                                                               | $(TEST_COMPILER_DIR)wat
	wat-desugar $< -o $@

$(TEST_COMPILER_DIR)log/%.log : $(TEST_COMPILER_DIR)build/%.json | $(TEST_COMPILER_DIR)log/
	spectest-interp $< | tee $@.tmp \
	  && mv -f $@.tmp $@

$(TEST_COMPILER_DIR)build/%.json : $(TEST_COMPILER_DIR)build/%.wat \
                                   $(TEST_COMPILER_DIR)wast/%.wast \
                                   | $(TEST_COMPILER_DIR)build/
	cat $^ | wast2json - -o $@.tmp \
	  && mv -f $@.tmp $@

$(TEST_COMPILER_DIR)build/%.wat : $(TEST_COMPILER_DIR)%.scm $(COMPILER_BINARIES) | $(TEST_COMPILER_DIR)build/
	$(RUN_COMPILER) < $< > $@.tmp \
	  && mv -f $@.tmp $@

.PRECIOUS : $(TEST_COMPILER_DIR)build/%.json $(TEST_COMPILER_DIR)build/%.wast $(TEST_COMPILER_DIR)build/%.wat

.PHONY : clean-test-compiler
clean-test-compiler: ## Removes compiler test build artefacts and results
	-rm -rf \
	  $(TEST_COMPILER_DIR)build \
	  $(TEST_COMPILER_DIR)host-log \
	  $(TEST_COMPILER_DIR)wast-log
