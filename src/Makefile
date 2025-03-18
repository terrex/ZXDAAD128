
all: build

build:
	./build.sh

install:
	install -m755 drb128.php $(DESTDIR)/usr/bin/drb128
	install -m755 DAADMaker128.php $(DESTDIR)/usr/bin/DAADMaker128
	install -m755 DAADMakerPlus3.php $(DESTDIR)/usr/bin/DAADMakerPlus3

clean:
	$(RM) drb128.php DAADMaker128.php DAADMakerPlus3.php loader.bin loaderplus3.bin asm/loader.sym asm/loaderplus3.sym ZXD128_*
