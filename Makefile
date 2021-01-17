.PHONY: setup build

all: build

setup:
ifeq ($(OS),Windows_NT) 
	@cmd /q /c "CLI Compilers\link.bat"
else
	@./CLI\ Compilers/link.sh
endif

build: setup
ifeq ($(OS),Windows_NT) 
	cmd /c "CLI Compilers\env.bat" swift build
else
	swift build
endif

build-god:
ifeq ($(OS),Windows_NT) 
	cmd /c "CLI Compilers\env.bat" swift --product GoD-CLI
else
	swift build --product GoD-CLI
endif

build-colo:
ifeq ($(OS),Windows_NT) 
	cmd /c "CLI Compilers\env.bat" swift --product 	swift build --product Colosseum-CLI
else
	swift build --product Colosseum-CLI
endif

build-pbr:
ifeq ($(OS),Windows_NT) 
	cmd /c "CLI Compilers\env.bat" swift --product 	swift build --product PBR-CLI
else
	swift build --product PBR-CLI
endif
