SRC_NAME=openssl-1.0.2r
SRC_ARCHIVE=$(SRC_NAME).tar.gz
SRC_URI=https://www.openssl.org/source/$(SRC_ARCHIVE)
MD5_SUM=0d2baaf04c56d542f6cc757b9c2a2aac

# openssl use CROSS_COMPILE prefix
CC=gcc $(CPUFLAGS)

COPTS=-ffunction-sections -fdata-sections -Wl,--gc-sections -I$(DESTDIR)/include
COPTS+=$(if $(CONFIG_IPV6),-DOPENSSL_USE_IPV6=1,)
COPTS+=-DOPENSSL_SMALL_FOOTPRINT

LOPTS=-Wl,--gc-sections -L$(DESTDIR)/lib

OPENSSL_APPS =

OPENSSL_CIPHERS = no-capieng no-cms no-gmp no-jpake no-rfc3779 no-seed \
                  no-ec2m no-err no-threads no-idea no-rc5 no-ripemd no-rmd160 \
                  no-static-engine no-hw no-md2 no-sse2 no-dso no-ts no-sha0 no-mdc2 no-krb5 \
                  no-smime no-ans1 no-cast no-whirlpool no-sctp no-srp no-ssl2 no-ssl3

ifdef CONFIG_CRYPTO_DEV_LINUX
COPTS+=-DHAVE_CRYPTODEV
else
OPENSSL_APPS += no-speed
OPENSSL_CIPHERS += no-engine
endif

ifneq ($(CONFIG_FIRMWARE_INCLUDE_SSWAN),y)
OPENSSL_CIPHERS += no-rc2
endif

ifneq ($(CONFIG_FIRMWARE_INCLUDE_OPENSSL_EC),y)
OPENSSL_CIPHERS += no-ec
endif

all: prepare_sources config_test
	$(MAKE) depend -C $(SRC_NAME)
	$(MAKE) -C $(SRC_NAME)

include $(EXTERNAL_SOURCES)

config_test:
	( if [ -f ./config_done ]; then \
		echo "the same configuration"; \
	else \
		make configure && touch config_done; \
	fi )

configure:
	( cd $(SRC_NAME) ; \
	./Configure \
		linux-mipsel \
		shared \
		--prefix=/ \
		--install_prefix=$(STAGEDIR) \
		--openssldir=/etc/ssl \
		$(COPTS) \
		$(LOPTS) \
		$(OPENSSL_APPS) \
		$(OPENSSL_CIPHERS) ; \
	)

clean:
	$(MAKE) -C $(SRC_NAME) clean; \
	rm -f config_done

install:
	$(MAKE) -C $(SRC_NAME) install DESTDIR="$(STAGEDIR)"
	rm -f $(DESTDIR)/lib/libssl.a
	rm -f $(DESTDIR)/lib/libcrypto.a

romfs:
	cp -fP $(DESTDIR)/lib/libssl.so* $(ROMFSDIR)/usr/lib
	cp -fP $(DESTDIR)/lib/libcrypto.so* $(ROMFSDIR)/usr/lib
	$(ROMFSINST) /etc_ro/openssl.cnf
ifeq ($(CONFIG_FIRMWARE_INCLUDE_OPENSSL_EXE),y)
	$(ROMFSINST) $(SRC_NAME)/apps/openssl /usr/bin/openssl
endif
