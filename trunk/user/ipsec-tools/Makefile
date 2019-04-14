SRC_NAME=ipsec-tools-0.8.2
SRC_ARCHIVE=$(SRC_NAME).tar.gz
SRC_URI=https://netcologne.dl.sourceforge.net/project/ipsec-tools/ipsec-tools/0.8.2/$(SRC_ARCHIVE)
MD5_SUM=8c222aedb897820e946aac203113b650

THISDIR = $(shell pwd)

all: prepare_sources config_test
	$(MAKE) -C $(SRC_NAME)
	$(MAKE) -C $(SRC_NAME) install DESTDIR=$(THISDIR)/install

include $(EXTERNAL_SOURCES)

config_test:
	( if [ -f ./config_done ]; then \
		echo "the same configuration"; \
	else \
		make configure && touch config_done; \
	fi )

configure:
	( cd $(SRC_NAME) ; \
	./configure \
		--prefix= \
		--with-kernel-headers="$(KERNEL_HEADERS_PATH)" \
		--without-readline \
		--without-libradius \
		--without-libpam \
		--enable-dpd \
		--enable-hybrid \
		--enable-security-context=no \
		--enable-natt \
		--enable-adminport \
		--enable-frag \
		--with-openssl="$(STAGEDIR)" \
		OPENSSL_CFLAGS="-I$(STAGEDIR)/include" \
		OPENSSL_LIBS="-L$(STAGEDIR)/lib -lssl -lcrypto" \
		--host=$(HOST_TARGET) \
		--build=$(HOST_BUILD) ; \
	)

clean:
	$(MAKE) -C $(SRC_NAME) clean
	rm -rf $(THISDIR)/install
	rm -f config_done

romfs:
	mkdir -p $(ROMFSDIR)/var/racoon
	cp -fP $(THISDIR)/install/lib/*.so.* $(ROMFSDIR)/usr/lib
	cp -fP $(THISDIR)/install/sbin/* $(ROMFSDIR)/usr/sbin

