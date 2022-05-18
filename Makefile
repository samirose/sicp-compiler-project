SHELL = /bin/bash
.SHELLFLAGS = -o pipefail -c
SCHEME := guile
SCHEME_RUN_PROGRAM := $(SCHEME) --r7rs -L .
COMPILER_SOURCES = $(wildcard *.scm)
RUN_DRIVER = $(SCHEME_RUN_PROGRAM) driver.scm

.PHONY : help
help : Makefile ## Display this help
	@sed -nE 's/^([[:alnum:]-]+)[[:space:]]*:[^#]*##[[:space:]]*(.*)$$/\1: \2/p' $<

.PHONY : compile
compile : ## Compiles a scheme file from standard input and outputs WAT to standard output
	$(RUN_DRIVER) $<

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

TEST_COMPILER_DIR := test-compiler/
COMPILER_TEST_PROGRAMS := $(wildcard $(TEST_COMPILER_DIR)*.scm)
COMPILER_TEST_TARGETS := $(COMPILER_TEST_PROGRAMS:.scm=)
COMPILER_TEST_LOGS = $(COMPILER_TEST_PROGRAMS:$(TEST_COMPILER_DIR)%.scm=$(TEST_COMPILER_DIR)log/%.log)

.PHONY : test-compiler $(COMPILER_TEST_TARGETS)
test-compiler : $(COMPILER_TEST_LOGS) ## Executes the integration tests for the compiler

$(COMPILER_TEST_TARGETS) : $(TEST_COMPILER_DIR)% : $(TEST_COMPILER_DIR)log/%.log

$(TEST_COMPILER_DIR)build/ $(TEST_COMPILER_DIR)log/ :
	mkdir -p $@

$(COMPILER_TEST_LOGS) : $(TEST_COMPILER_DIR)log/%.log : $(TEST_COMPILER_DIR)build/%.json | $(TEST_COMPILER_DIR)log/
	spectest-interp $< | tee $@.tmp \
	  && mv -f $@.tmp $@

$(COMPILER_TEST_LOGS) : $(COMPILER_SOURCES)

$(TEST_COMPILER_DIR)build/%.json : $(TEST_COMPILER_DIR)build/%.wast | $(TEST_COMPILER_DIR)build/
	wast2json $< -o $@

$(TEST_COMPILER_DIR)build/%.wast : runtime/scheme-base.wat runtime/register-scheme-base.wast $(TEST_COMPILER_DIR)build/%.wat $(TEST_COMPILER_DIR)%.wast | $(TEST_COMPILER_DIR)build/
	cat $^ > $@

$(TEST_COMPILER_DIR)build/%.wat : $(TEST_COMPILER_DIR)%.scm $(TEST_COMPILER_DIR)build/ | $(TEST_COMPILER_DIR)build/
	$(RUN_DRIVER) < $< > $@

.PRECIOUS : $(TEST_COMPILER_DIR)build/%.json $(TEST_COMPILER_DIR)build/%.wast $(TEST_COMPILER_DIR)build/%.wat

TEST_UNIT_DIR := test-unit/
UNIT_TEST_PROGRAMS := $(wildcard $(TEST_UNIT_DIR)*.scm)
UNIT_TEST_TARGETS := $(UNIT_TEST_PROGRAMS:.scm=)
UNIT_TEST_LOGS := $(UNIT_TEST_PROGRAMS:$(TEST_UNIT_DIR)%.scm=$(TEST_UNIT_DIR)log/%.log)

.PHONY : test-unit $(UNIT_TEST_TARGETS)
test-unit : $(UNIT_TEST_LOGS) ## Executes the unit tests for the compiler

$(UNIT_TEST_TARGETS) : $(TEST_UNIT_DIR)% : $(TEST_UNIT_DIR)log/%.log

$(TEST_UNIT_DIR)log :
	mkdir -p $@

$(UNIT_TEST_LOGS) : $(TEST_UNIT_DIR)log/%.log : $(TEST_UNIT_DIR)%.scm | $(TEST_UNIT_DIR)log
	$(SCHEME_RUN_PROGRAM) $< > $@.tmp \
	  && mv -f $@.tmp $@

$(UNIT_TEST_LOGS) : $(COMPILER_SOURCES)

.PHONY : tes
test : test-runtime test-unit test-compiler ## Executes all tests

.PHONY : clean
clean : clean-test clean-compiler ## Removes test outputs and forces compiler re-compilation

.PHONY : clean-compiler
clean-compiler : ## Forces compiler re-compilation
	-touch *.scm

.PHONY : clean-test
clean-test : ## Removes test build artefacts and results
	-rm -rf runtime/test $(TEST_UNIT_DIR)log $(TEST_COMPILER_DIR)build $(TEST_COMPILER_DIR)log
