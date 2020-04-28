SCHEME=plt-r6rs
LIBDIR=lib
LIBS=lists scheme-syntax wasm-syntax wasm-definitions-table wasm-compiler
LIBDIRS=$(addprefix $(LIBDIR)/,$(LIBS))
LIBFILES=$(addsuffix /main.ss,$(LIBDIRS))

$(LIBDIR)/%/main.ss: %.sls
	rm -rf $(dir $@)
	$(SCHEME) --install --collections $(LIBDIR) $<

.PHONY: run clean

run: driver.sps $(LIBFILES)
	$(SCHEME) ++path $(LIBDIR) $<

clean:
	rm -rf $(LIBDIRS)
