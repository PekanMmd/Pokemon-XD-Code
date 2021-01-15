.PHONY: setup build

all: build

setup:
ifeq ($(OS),Windows_NT) 
	@echo Hello NT
	@cmd /q /c "CLI Compilers\link.bat"
else
	@echo Hello Unix
	@./CLI\ Compilers/link.sh
endif

build: setup
	swift build

build-god-tool:
	swift build --product GoD-CLI
