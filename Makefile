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
TEST_UNIT_DIR := test-unit/

.PHONY : help
help : Makefile $(TEST_COMPILER_DIR)test-compiler.mk $(TEST_UNIT_DIR)/test-unit.mk tools/tools.mk ## Display this help
	@sed -nE 's/^([[:alnum:]-]+)[[:space:]]*:[^#]*##[[:space:]]*(.*)$$/\1: \2/p' $^

.PHONY : compile
compile : $(COMPILER_BINARIES) ## Compiles a scheme file from standard input and outputs WAT to standard output
	$(RUN_COMPILER) $<

.PHONY : compile-compiler
compile-compiler : $(COMPILER_BINARIES) ## Compiles the compiler with host scheme

$(HOST_SCHEME_COMPILED_DIR) :
	mkdir -p $@

COMPILER_DEPENDENCIES := $(HOST_SCHEME_COMPILED_DIR)module-dependencies.mk

include tools/tools.mk
$(COMPILER_DEPENDENCIES) : $(COMPILER_SOURCES) $(TOOL_SCHEME_DEPENDENCIES) | $(HOST_SCHEME_COMPILED_DIR)
	$(RUN_TOOL_SCHEME_DEPENDENCIES) $(COMPILER_SOURCES) \
	  | sed -e 's|\([^[:space:]]*\)\.scm|$(HOST_SCHEME_COMPILED_DIR)\1\.go|g' \
	  | tee $@.tmp && mv -f $@.tmp $@

include $(COMPILER_DEPENDENCIES)

$(COMPILER_BINARIES) : $(HOST_SCHEME_COMPILED_DIR)%.go : %.scm | $(HOST_SCHEME_COMPILED_DIR)
	GUILE_LOAD_COMPILED_PATH=$(HOST_SCHEME_COMPILED_DIR) $(HOST_SCHEME_COMPILE_MODULE) -o $@ $<

include $(TEST_COMPILER_DIR)test-compiler.mk

include $(TEST_UNIT_DIR)/test-unit.mk

.PHONY : test
test : test-unit test-compiler ## Executes all tests

.PHONY : clean
clean : clean-test clean-compiler clean-tools ## Removes test outputs, compiled tools and forces compiler re-compilation

.PHONY : clean-compiler
clean-compiler : ## Forces compiler re-compilation
	-rm -rf $(HOST_SCHEME_COMPILED_DIR)

.PHONY : clean-test
clean-test : clean-test-unit clean-test-compiler ## Removes all test build artefacts and results
