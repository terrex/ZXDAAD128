.DEFAULT_GOAL := all

%:
	$(MAKE) -C src $@
	$(MAKE) -C DCP $@
