OS := $(shell uname)

install-flutter:
ifeq ($(OS),Windows_NT)
	choco install flutter
else
	brew tap leoafarias/fvm && brew install flutter
endif

install-fvm:
ifeq ($(OS),Windows_NT)
	choco install fvm
else
	brew tap leoafarias/fvm && brew install fvm
endif

check-fvm:
	@if ! command -v fvm >/dev/null 2>&1; then \
		$(MAKE) install-fvm; \
	fi

check-flutter:
	@if ! command -v flutter >/dev/null 2>&1; then \
		$(MAKE) install-flutter; \
	fi

config: check-fvm check-flutter

init:
	fvm use 3.24.4 && fvm flutter clean && fvm flutter pub get
