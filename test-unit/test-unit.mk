UNIT_TEST_PROGRAMS := $(wildcard $(TEST_UNIT_DIR)*.scm)
UNIT_TEST_BINARIES := $(UNIT_TEST_PROGRAMS:$(TEST_UNIT_DIR)%.scm=$(TEST_UNIT_DIR)compiled/%.go)
UNIT_TEST_TARGETS := $(UNIT_TEST_PROGRAMS:.scm=)
UNIT_TEST_LOGS := $(UNIT_TEST_PROGRAMS:$(TEST_UNIT_DIR)%.scm=$(TEST_UNIT_DIR)log/%.log)
RUN_UNIT_TEST := $(HOST_SCHEME_RUN_PROGRAM) -C $(TEST_UNIT_DIR)compiled -C $(HOST_SCHEME_COMPILED_DIR)

.PHONY : test-unit
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

.PHONY : clean-test-unit
clean-test-unit : ## Removes unit test build artefacts and results
	-rm -rf \
	  $(TEST_UNIT_DIR)log \
	  $(TEST_UNIT_DIR)compiled
