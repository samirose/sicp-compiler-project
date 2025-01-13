SHELL := bash
.SHELLFLAGS := -o pipefail -c

HOST_SCHEME_FLAGS := --r7rs
HOST_SCHEME_COMPILED_DIR := ./compiled/
HOST_SCHEME_COMPILE_MODULE := guild compile $(HOST_SCHEME_FLAGS)
HOST_SCHEME_RUN_PROGRAM := guile $(HOST_SCHEME_FLAGS) --no-auto-compile
COMPILER_SOURCES := $(wildcard *.scm)
COMPILER_BINARIES := $(COMPILER_SOURCES:%.scm=$(HOST_SCHEME_COMPILED_DIR)%.go)
RUN_COMPILER := $(HOST_SCHEME_RUN_PROGRAM) -L . -C $(HOST_SCHEME_COMPILED_DIR) driver.scm

TEST_UNIT_DIR := test-unit/

.PHONY : help
help :  ## Display this help
help : Makefile test-compiler/test-compiler.mk $(TEST_UNIT_DIR)/test-unit.mk tools/tools.mk
	@echo "Targets:"
	@sed -nE 's/^([[:alnum:]-]+)[[:space:]]*:[^#]*##[[:space:]]*(.*)$$/  \1:	\2/p' $^ \
	  | column -t -s "	"

.PHONY : compile
compile : ## Compiles a scheme file from standard input and outputs WAT to standard output
compile : $(COMPILER_BINARIES)
	$(RUN_COMPILER) $<

.PHONY : compile-compiler
compile-compiler : ## Compiles the compiler with host scheme
compile-compiler : $(COMPILER_BINARIES)

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

include test-compiler/test-compiler.mk

include $(TEST_UNIT_DIR)/test-unit.mk

.PHONY : test
test : ## Executes all tests
test : test-unit test-compiler

.PHONY : clean
clean : ## Removes test outputs, compiled tools and forces compiler re-compilation
clean : clean-test clean-compiler clean-tools

.PHONY : clean-compiler
clean-compiler : ## Forces compiler re-compilation
	-rm -rf $(HOST_SCHEME_COMPILED_DIR)

.PHONY : clean-test
clean-test : ## Removes all test build artefacts and results
clean-test : clean-test-unit clean-test-compiler
