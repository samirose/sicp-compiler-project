SHELL := bash
.SHELLFLAGS := -o pipefail -c

.PHONY : help
help : Makefile ## Display this help
	@sed -nE 's/^([[:alnum:]-]+)[[:space:]]*:[^#]*##[[:space:]]*(.*)$$/\1: \2/p' $<

HOST_SCHEME_FLAGS := --r7rs
HOST_SCHEME_COMPILED_DIR := ./compiled/
HOST_SCHEME_COMPILE_MODULE := guild compile $(HOST_SCHEME_FLAGS)
HOST_SCHEME_RUN_PROGRAM := guile $(HOST_SCHEME_FLAGS) --no-auto-compile
COMPILER_SOURCES := $(wildcard *.scm)
COMPILER_BINARIES := $(COMPILER_SOURCES:%.scm=$(HOST_SCHEME_COMPILED_DIR)%.go)
RUN_COMPILER := $(HOST_SCHEME_RUN_PROGRAM) -L . -C $(HOST_SCHEME_COMPILED_DIR) driver.scm

.PHONY : compile
compile : $(COMPILER_BINARIES) ## Compiles a scheme file from standard input and outputs WAT to standard output
	$(RUN_COMPILER) $<

.PHONY : compile-compiler
compile-compiler : $(COMPILER_BINARIES) ## Compiles the compiler with host scheme

$(HOST_SCHEME_COMPILED_DIR) :
	mkdir -p $@

COMPILER_DEPENDENCIES := $(HOST_SCHEME_COMPILED_DIR)module-dependencies.mk
$(COMPILER_DEPENDENCIES) : $(COMPILER_SOURCES) tools/scheme-dependencies.scm | $(HOST_SCHEME_COMPILED_DIR)
	$(HOST_SCHEME_RUN_PROGRAM) tools/scheme-dependencies.scm $(COMPILER_SOURCES) \
	  | sed -e 's|\([^[:space:]]*\)\.scm|$(HOST_SCHEME_COMPILED_DIR)\1\.go|g' \
	  | tee $@.tmp && mv -f $@.tmp $@

include $(COMPILER_DEPENDENCIES)

$(COMPILER_BINARIES) : $(HOST_SCHEME_COMPILED_DIR)%.go : %.scm | $(HOST_SCHEME_COMPILED_DIR)
	GUILE_LOAD_COMPILED_PATH=$(HOST_SCHEME_COMPILED_DIR) $(HOST_SCHEME_COMPILE_MODULE) -o $@ $<

TEST_COMPILER_DIR := test-compiler/
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

.PHONY : test-compiler-host $(COMPILER_TEST_HOST_TARGETS)
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

.PHONY : test-compiler-wast $(COMPILER_TEST_WAST_TARGETS)
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

TEST_UNIT_DIR := test-unit/
UNIT_TEST_PROGRAMS := $(wildcard $(TEST_UNIT_DIR)*.scm)
UNIT_TEST_BINARIES := $(UNIT_TEST_PROGRAMS:$(TEST_UNIT_DIR)%.scm=$(TEST_UNIT_DIR)compiled/%.go)
UNIT_TEST_TARGETS := $(UNIT_TEST_PROGRAMS:.scm=)
UNIT_TEST_LOGS := $(UNIT_TEST_PROGRAMS:$(TEST_UNIT_DIR)%.scm=$(TEST_UNIT_DIR)log/%.log)
RUN_UNIT_TEST := $(HOST_SCHEME_RUN_PROGRAM) -C $(TEST_UNIT_DIR)compiled -C $(HOST_SCHEME_COMPILED_DIR)

.PHONY : test-unit $(UNIT_TEST_TARGETS)
test-unit : $(UNIT_TEST_LOGS) ## Executes the unit tests for the compiler

$(UNIT_TEST_TARGETS) : $(TEST_UNIT_DIR)% : $(TEST_UNIT_DIR)log/%.log

$(TEST_UNIT_DIR)log $(TEST_UNIT_DIR)compiled :
	mkdir -p $@

$(UNIT_TEST_BINARIES) : $(TEST_UNIT_DIR)compiled/%.go : $(TEST_UNIT_DIR)%.scm | $(TEST_UNIT_DIR)compiled
	$(HOST_SCHEME_COMPILE_MODULE) -L . -o $@ $<

$(UNIT_TEST_LOGS) : $(TEST_UNIT_DIR)log/%.log : $(TEST_UNIT_DIR)%.scm | $(TEST_UNIT_DIR)log
	$(RUN_UNIT_TEST) $< > $@.tmp \
	  && mv -f $@.tmp $@

$(UNIT_TEST_LOGS) : $(UNIT_TEST_BINARIES)
$(UNIT_TEST_BINARIES) : $(COMPILER_BINARIES)

.PHONY : test
test : test-unit test-compiler-host test-compiler-wast ## Executes all tests

.PHONY : clean
clean : clean-test clean-compiler ## Removes test outputs and forces compiler re-compilation

.PHONY : clean-compiler
clean-compiler : ## Forces compiler re-compilation
	-rm -rf $(HOST_SCHEME_COMPILED_DIR)

.PHONY : clean-test
clean-test : ## Removes test build artefacts and results
	-rm -rf \
	  $(TEST_UNIT_DIR)log \
	  $(TEST_UNIT_DIR)compiled \
	  $(TEST_COMPILER_DIR)build \
	  $(TEST_COMPILER_DIR)log \
	  $(TEST_COMPILER_DIR)host-log \
	  $(TEST_COMPILER_DIR)wast-log
