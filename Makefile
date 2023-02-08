SHELL = /bin/bash
.SHELLFLAGS = -o pipefail -c

.PHONY : help
help : Makefile ## Display this help
	@sed -nE 's/^([[:alnum:]-]+)[[:space:]]*:[^#]*##[[:space:]]*(.*)$$/\1: \2/p' $<

HOST_SCHEME_FLAGS := --r7rs
HOST_SCHEME_COMPILED_DIR := ./compiled/
HOST_SCHEME_COMPILE_MODULE = guild compile $(HOST_SCHEME_FLAGS)
HOST_SCHEME_RUN_PROGRAM = guile $(HOST_SCHEME_FLAGS) --no-auto-compile
COMPILER_SOURCES = $(wildcard *.scm)
COMPILER_BINARIES := $(COMPILER_SOURCES:%.scm=$(HOST_SCHEME_COMPILED_DIR)%.go)
RUN_COMPILER = $(HOST_SCHEME_RUN_PROGRAM) -L . -C $(HOST_SCHEME_COMPILED_DIR) driver.scm

.PHONY : compile
compile : $(COMPILER_BINARIES) ## Compiles a scheme file from standard input and outputs WAT to standard output
	$(RUN_COMPILER) $<

.PHONY : test-runtime
test-runtime : runtime/test/test-runtime.log ## Executes tests for the runtime library

runtime/test/ :
	mkdir -p runtime/test

runtime/test/test-runtime.log : runtime/test/test-runtime.json | runtime/test/
	spectest-interp $< | tee $@.tmp \
	  && mv -f $@.tmp $@

runtime/test/test-runtime.json : runtime/test/test-runtime.wast | runtime/test/
	wast2json $< -o $@

runtime/test/test-runtime.wast : runtime/scheme-base.wat runtime/register-scheme-base.wast runtime/runtime.wast | runtime/test/
	cat $^ > $@

.PHONY : compile-compiler
compile-compiler : $(COMPILER_BINARIES) ## Compiles the compiler with host scheme

binaries = $(patsubst $(HOST_SCHEME_COMPILED_DIR):.go,:,$(patsubst %,$(HOST_SCHEME_COMPILED_DIR)%.go,$(1)))

$(call binaries,compiled-program counted-set definitions-table expression-compiler lexical-env module-compiler scheme-r7rs-syntax scheme-libraries wasm-syntax : lists)
$(call binaries,expression-compiler module-compiler scheme-syntax scheme-r7rs-syntax wasm-syntax : pattern-match)
$(call binaries,assert scheme-libraries scheme-syntax scheme-r7rs-syntax : compilation-error)
$(call binaries,compiled-program : counted-set definitions-table)
$(call binaries,definitions-table : wasm-syntax counted-set)
$(call binaries,scheme-libraries : compiled-program)
$(call binaries,expression-compiler module-compiler : lexical-env scheme-syntax scheme-libraries)
$(call binaries,module-compiler : expression-compiler scheme-r7rs-syntax)
$(call binaries,driver : module-compiler)

$(HOST_SCHEME_COMPILED_DIR) :
	mkdir -p $@

$(COMPILER_BINARIES) : $(HOST_SCHEME_COMPILED_DIR)%.go : %.scm | $(HOST_SCHEME_COMPILED_DIR)
	GUILE_LOAD_COMPILED_PATH=$(HOST_SCHEME_COMPILED_DIR) $(HOST_SCHEME_COMPILE_MODULE) -o $@ $<

TEST_COMPILER_DIR := test-compiler/
COMPILER_TEST_MODULES := $(wildcard $(TEST_COMPILER_DIR)*.scm)
COMPILER_TEST_TARGETS := $(COMPILER_TEST_MODULES:.scm=)
COMPILER_TEST_LOGS = $(COMPILER_TEST_MODULES:$(TEST_COMPILER_DIR)%.scm=$(TEST_COMPILER_DIR)log/%.log)
COMPILER_TEST_PROGRAMS := $(wildcard $(TEST_COMPILER_DIR)test/*.scm)
COMPILER_TEST_HOST_TARGETS := $(COMPILER_TEST_PROGRAMS:$(TEST_COMPILER_DIR)test/%.scm=$(TEST_COMPILER_DIR)%-host)
COMPILER_TEST_HOST_LOGS := $(COMPILER_TEST_PROGRAMS:$(TEST_COMPILER_DIR)test/%.scm=$(TEST_COMPILER_DIR)host-log/%.log)
RUN_COMPILER_TEST_HOST = $(HOST_SCHEME_RUN_PROGRAM) -L .. -L ../lib

$(TEST_COMPILER_DIR)build/ \
$(TEST_COMPILER_DIR)log/ \
$(TEST_COMPILER_DIR)host-log/ \
$(TEST_COMPILER_DIR)wast-log/ :
	mkdir -p $@

.PHONY : test-compiler-host $(COMPILER_TEST_HOST_TARGETS)
test-compiler-host : $(COMPILER_TEST_HOST_LOGS) ## Executes the compiler integration tests on the host scheme

$(COMPILER_TEST_HOST_TARGETS) : $(TEST_COMPILER_DIR)%-host : $(TEST_COMPILER_DIR)host-log/%.log

$(COMPILER_TEST_HOST_LOGS) : $(TEST_COMPILER_DIR)host-log/%.log : $(TEST_COMPILER_DIR)%.scm $(TEST_COMPILER_DIR)test/%.scm | $(TEST_COMPILER_DIR)host-log/
	cd $(TEST_COMPILER_DIR)host-log ; \
	rm -f $(notdir $(@:%.log=%.fail.log)) ; \
	$(RUN_COMPILER_TEST_HOST) ../test/$(notdir $<) || \
	(mv -f $(notdir $@) $(notdir $(@:%.log=%.fail.log)) && cat $(notdir $(@:%.log=%.fail.log)))

COMPILER_TEST_WAST_TARGETS := $(COMPILER_TEST_PROGRAMS:$(TEST_COMPILER_DIR)test/%.scm=$(TEST_COMPILER_DIR)%-wast)
COMPILER_TEST_WAST_TESTS := $(COMPILER_TEST_PROGRAMS:$(TEST_COMPILER_DIR)test/%.scm=$(TEST_COMPILER_DIR)build/%-test.wast)
COMPILER_TEST_WAST_LOGS := $(COMPILER_TEST_PROGRAMS:$(TEST_COMPILER_DIR)test/%.scm=$(TEST_COMPILER_DIR)wast-log/%.log)
COMPILER_TEST_WAST_COMPILER := $(TEST_COMPILER_DIR)lib/compiler-test-to-wast.scm
COMPILER_TEST_TO_WAST := $(HOST_SCHEME_RUN_PROGRAM) -L . -C $(HOST_SCHEME_COMPILED_DIR) $(COMPILER_TEST_WAST_COMPILER)

.PHONY : test-compiler-wast $(COMPILER_TEST_WAST_TARGETS)
test-compiler-wast : $(COMPILER_TEST_WAST_LOGS) ## Compiles the compiler tests to WAST scripts and executes them

$(COMPILER_TEST_WAST_TARGETS) : $(TEST_COMPILER_DIR)%-wast : $(TEST_COMPILER_DIR)wast-log/%.log

$(COMPILER_TEST_WAST_LOGS) : $(TEST_COMPILER_DIR)wast-log/%.log : $(TEST_COMPILER_DIR)build/%-test.json | $(TEST_COMPILER_DIR)wast-log/
	spectest-interp $< | tee $@.tmp \
	  && mv -f $@.tmp $@

$(TEST_COMPILER_DIR)build/%-test.json : $(TEST_COMPILER_DIR)build/test-prelude.wast \
                                        $(TEST_COMPILER_DIR)build/%.wat \
                                        $(TEST_COMPILER_DIR)build/%-test.wast \
                                        | $(TEST_COMPILER_DIR)build/
	cat $^ | wast2json - -o $@

$(COMPILER_TEST_WAST_TESTS) : $(TEST_COMPILER_DIR)lib/compiler-test-to-wast.scm
$(COMPILER_TEST_WAST_TESTS) : $(TEST_COMPILER_DIR)build/%-test.wast : $(TEST_COMPILER_DIR)test/%.scm | $(TEST_COMPILER_DIR)build/
	$(COMPILER_TEST_TO_WAST) < $< > $@.tmp \
	  && mv -f $@.tmp $@

.PHONY : test-compiler $(COMPILER_TEST_TARGETS)
test-compiler : $(COMPILER_TEST_LOGS) ## Executes the integration tests for the compiler

$(COMPILER_TEST_TARGETS) : $(TEST_COMPILER_DIR)% : $(TEST_COMPILER_DIR)log/%.log

$(COMPILER_TEST_LOGS) : $(TEST_COMPILER_DIR)log/%.log : $(TEST_COMPILER_DIR)build/%.json | $(TEST_COMPILER_DIR)log/
	spectest-interp $< | tee $@.tmp \
	  && mv -f $@.tmp $@

$(TEST_COMPILER_DIR)build/%.json : $(TEST_COMPILER_DIR)build/test-prelude.wast \
                                   $(TEST_COMPILER_DIR)build/%.wat \
                                   $(TEST_COMPILER_DIR)%.wast \
                                   | $(TEST_COMPILER_DIR)build/
	cat $^ | wast2json - -o $@

$(TEST_COMPILER_DIR)build/test-prelude.wast : runtime/scheme-base.wat \
                                              runtime/register-scheme-base.wast \
                                              | $(TEST_COMPILER_DIR)build/
	cat $^ > $@

$(TEST_COMPILER_DIR)build/%.wat : $(TEST_COMPILER_DIR)%.scm $(COMPILER_BINARIES) | $(TEST_COMPILER_DIR)build/
	$(RUN_COMPILER) < $< > $@

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
test : test-runtime test-unit test-compiler-host test-compiler-wast test-compiler ## Executes all tests

.PHONY : clean
clean : clean-test clean-compiler ## Removes test outputs and forces compiler re-compilation

.PHONY : clean-compiler
clean-compiler : ## Forces compiler re-compilation
	-rm -rf $(HOST_SCHEME_COMPILED_DIR)

.PHONY : clean-test
clean-test : ## Removes test build artefacts and results
	-rm -rf \
	  runtime/test \
	  $(TEST_UNIT_DIR)log \
	  $(TEST_UNIT_DIR)compiled \
	  $(TEST_COMPILER_DIR)build \
	  $(TEST_COMPILER_DIR)log \
	  $(TEST_COMPILER_DIR)host-log \
	  $(TEST_COMPILER_DIR)wast-log
