ifndef SRC_URI
	$(info "SRC_URI is empty, external sources will be disabled")
	call config_test
endif

ifndef MD5_SUM
	$(error "md5sum is empty, downloaded file could not be verified")
endif

.PHONY: prepare_sources
prepare_sources: patch_test files_test
	@echo Sources prepared

.PHONY: dowload_test
dowload_test:
	@if [ ! -f "$(SRC_ARCHIVE)" ] ; then \
		echo "Downloading..." ; \
		wget -t5 --timeout=20 --no-check-certificate -q -O "$(SRC_ARCHIVE)" "$(SRC_URI)"; \
	fi
	MD5SUM_TMP="$$(md5sum $(SRC_ARCHIVE) | cut -d ' ' -f1)" && \
	if [ "$$MD5SUM_TMP" != '$(MD5_SUM)' ] ; then \
			echo "md5sum mismatch!" ; \
			exit 1 ; \
	fi
	@echo "Extracting..."
	@tar -xf "$(SRC_ARCHIVE)"

.PHONY: patch_test
patch_test: dowload_test
	( if [ -d "$(SRC_NAME)/../patches" ] ; then \
		cd "$(SRC_NAME)" ; \
		( if [ ! -f ../patching_done ]; then \
			for file in ../patches/*.patch ; do \
				patch -p1 < $$file ; \
			done ; \
			echo "Patching done" && touch ../patching_done ; \
		fi ) \
	fi )

.PHONY: files_test
files_test:
	@if [ -d "$(SRC_NAME)/../files" ] ; then \
		cp -r $(SRC_NAME)/../files/* $(SRC_NAME)/ ; \
	fi

.PHONY: cleanall
cleanall:
	rm -f patching_done
	rm -f "$(SRC_ARCHIVE)"
	rm -rf "$(SRC_NAME)"

