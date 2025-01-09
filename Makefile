SHELL := bash
.SHELLFLAGS := -o pipefail -c

HOST_SCHEME_FLAGS := --r7rs
HOST_SCHEME_COMPILED_DIR := ./compiled/
HOST_SCHEME_COMPILE_MODULE := guild compile $(HOST_SCHEME_FLAGS)
HOST_SCHEME_RUN_PROGRAM := guile $(HOST_SCHEME_FLAGS) --no-auto-compile
COMPILER_SOURCES := $(wildcard *.scm)
COMPILER_BINARIES := $(COMPILER_SOURCES:%.scm=$(HOST_SCHEME_COMPILED_DIR)%.go)
RUN_COMPILER := $(HOST_SCHEME_RUN_PROGRAM) -L . -C $(HOST_SCHEME_COMPILED_DIR) driver.scm

TEST_COMPILER_DIR := test-compiler/

.PHONY : help
help : Makefile $(TEST_COMPILER_DIR)test-compiler.mk ## Display this help
	@sed -nE 's/^([[:alnum:]-]+)[[:space:]]*:[^#]*##[[:space:]]*(.*)$$/\1: \2/p' $^

.PHONY : compile
compile : $(COMPILER_BINARIES) ## Compiles a scheme file from standard input and outputs WAT to standard output
	$(RUN_COMPILER) $<

.PHONY : compile-compiler
compile-compiler : $(COMPILER_BINARIES) ## Compiles the compiler with host scheme

$(HOST_SCHEME_COMPILED_DIR) :
	mkdir -p $@

COMPILER_DEPENDENCIES := $(HOST_SCHEME_COMPILED_DIR)module-dependencies.mk

tools/compiled:
	mkdir -p $@

tools/compiled/%.go: tools/%.scm | tools/compiled
	$(HOST_SCHEME_COMPILE_MODULE) -o $@ $<

$(COMPILER_DEPENDENCIES) : $(COMPILER_SOURCES) tools/compiled/scheme-dependencies.go | $(HOST_SCHEME_COMPILED_DIR)
	$(HOST_SCHEME_RUN_PROGRAM) -C tools/compiled tools/scheme-dependencies.scm $(COMPILER_SOURCES) \
	  | sed -e 's|\([^[:space:]]*\)\.scm|$(HOST_SCHEME_COMPILED_DIR)\1\.go|g' \
	  | tee $@.tmp && mv -f $@.tmp $@

include $(COMPILER_DEPENDENCIES)

$(COMPILER_BINARIES) : $(HOST_SCHEME_COMPILED_DIR)%.go : %.scm | $(HOST_SCHEME_COMPILED_DIR)
	GUILE_LOAD_COMPILED_PATH=$(HOST_SCHEME_COMPILED_DIR) $(HOST_SCHEME_COMPILE_MODULE) -o $@ $<

include $(TEST_COMPILER_DIR)test-compiler.mk

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
test : test-unit test-compiler ## Executes all tests

.PHONY : clean
clean : clean-test clean-compiler clean-tools ## Removes test outputs, compiled tools and forces compiler re-compilation

.PHONY : clean-compiler
clean-compiler : ## Forces compiler re-compilation
	-rm -rf $(HOST_SCHEME_COMPILED_DIR)

.PHONY : clean-test
clean-test : clean-test-compiler ## Removes all test build artefacts and results
	-rm -rf \
	  $(TEST_UNIT_DIR)log \
	  $(TEST_UNIT_DIR)compiled

.PHONY : clean-tools
clean-tools:  ## Removes tools build artefacts
	-rm -rf tools/compiled
