UNIT_TEST_PROGRAMS := $(wildcard test-unit/*.scm)
UNIT_TEST_BINARIES := $(UNIT_TEST_PROGRAMS:test-unit/%.scm=test-unit/compiled/%.go)
UNIT_TEST_TARGETS := $(UNIT_TEST_PROGRAMS:.scm=)
UNIT_TEST_LOGS := $(UNIT_TEST_PROGRAMS:test-unit/%.scm=test-unit/log/%.log)
RUN_UNIT_TEST := $(HOST_SCHEME_RUN_PROGRAM) -C test-unit/compiled -C $(HOST_SCHEME_COMPILED_DIR)

.PHONY : test-unit
test-unit : ## Executes the unit tests for the compiler
test-unit : $(UNIT_TEST_LOGS)

$(UNIT_TEST_TARGETS) : test-unit/% : test-unit/log/%.log

test-unit/log test-unit/compiled :
	mkdir -p $@

$(UNIT_TEST_BINARIES) : test-unit/compiled/%.go : test-unit/%.scm | test-unit/compiled
	$(HOST_SCHEME_COMPILE_MODULE) -L . -o $@ $<

$(UNIT_TEST_LOGS) : test-unit/log/%.log : test-unit/%.scm | test-unit/log
	$(RUN_UNIT_TEST) $< > $@.tmp \
	  && mv -f $@.tmp $@

$(UNIT_TEST_LOGS) : $(UNIT_TEST_BINARIES)
$(UNIT_TEST_BINARIES) : $(COMPILER_BINARIES)

.PHONY : clean-test-unit
clean-test-unit : ## Removes unit test build artefacts and results
	-rm -rf \
	  test-unit/log \
	  test-unit/compiled
