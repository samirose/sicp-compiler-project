SCHEME := plt-r6rs
LIBDIR := lib/
LIBS := lists scheme-syntax wasm-syntax wasm-definitions-table wasm-compiler
LIBDIRS = $(addprefix $(LIBDIR),$(LIBS))
COMPILED_COMPILER := compiled/driver_sps.dep compiled/driver_sps.zo

$(COMPILED_COMPILER) &: $(LIBDIRS) driver.sps
	$(SCHEME) ++path $(LIBDIR) --compile driver.sps

$(LIBDIR)% : %.sls
	rm -rf $@
	$(SCHEME) --install --collections $(LIBDIR) $<
	touch $@

lib/wasm-definitions-table : lib/lists
lib/wasm-compiler : lib/lists lib/scheme-syntax lib/wasm-syntax lib/wasm-definitions-table

.PHONY : compile
compile : $(COMPILED_COMPILER)
	$(SCHEME) ++path $(LIBDIR) driver.sps $<

.PHONY : cleanall
cleanall : cleanlibs cleancompiler

.PHONY : cleancompiler
cleancompiler :
	-rm -rf $(COMPILED_COMPILER)

.PHONY : cleanlibs
cleanlibs :
	-rm -rf $(LIBDIRS)
