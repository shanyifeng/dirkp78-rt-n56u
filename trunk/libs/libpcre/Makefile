SRC_NAME=pcre-8.43
SRC_ARCHIVE=$(SRC_NAME).tar.gz
SRC_URI=https://ftp.pcre.org/pub/pcre/$(SRC_ARCHIVE)
MD5_SUM=e775489c9f024a92ca0f431301ef4c5c

CFLAGS += -fPIC

all: prepare_sources config_test
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
	./configure \
		--prefix=/ \
		--enable-utf8 \
		--enable-unicode-properties \
		--enable-pcre16 \
		--with-match-limit-recursion=16000 \
		--disable-cpp \
		--host=$(HOST_TARGET) \
		--build=$(HOST_BUILD) ; \
	)

clean:
	$(MAKE) -C $(SRC_NAME) clean; \
	rm -f config_done

install:
	$(MAKE) -C $(SRC_NAME) install

romfs:
	cp -fP $(DESTDIR)/lib/libpcre.so* $(ROMFSDIR)/lib

