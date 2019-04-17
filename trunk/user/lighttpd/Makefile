SRC_NAME=lighttpd-1.4.53
SRC_ARCHIVE=$(SRC_NAME).tar.gz
SRC_URI=https://download.lighttpd.net/lighttpd/releases-1.4.x/$(SRC_ARCHIVE)
MD5_SUM=c6804914dd4da512d4514b1bb17c2420

THISDIR = $(shell pwd)

all: prepare_sources config_test
	$(MAKE) -C $(SRC_NAME)
	$(MAKE) -C $(SRC_NAME) install DESTDIR=$(THISDIR)/install)

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
		--prefix=/opt \
		--without-attr \
		--without-bzip2 \
		--without-fam \
		--without-ldap \
		--without-lua \
		--without-gdbm \
		--with-pcre="$(STAGEDIR)" \
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
	cp -fP $(THISDIR)/install/opt/lib/mod_*.so $(ROMFSDIR)/opt/lib
	cp -fP $(THISDIR)/install/opt/bin/lighttpd $(ROMFSDIR)/opt/bin

