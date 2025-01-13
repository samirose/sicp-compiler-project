tools/compiled:
	mkdir -p $@

tools/compiled/%.go: tools/%.scm | tools/compiled
	$(HOST_SCHEME_COMPILE_MODULE) -o $@ $<

TOOL_SCHEME_DEPENDENCIES := tools/compiled/scheme-dependencies.go
RUN_TOOL_SCHEME_DEPENDENCIES := $(HOST_SCHEME_RUN_PROGRAM) -C tools/compiled tools/scheme-dependencies.scm

.PHONY : clean-tools
clean-tools:  ## Removes tools build artefacts
	-rm -rf tools/compiled
