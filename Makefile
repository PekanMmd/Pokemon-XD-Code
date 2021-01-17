.PHONY: setup build build-god build-colo build-pbr

all: build

setup:
	./CLI\ Compilers/link.sh

build: setup
	swift build

build-god:
	swift build --product GoD-CLI

build-colo:
	swift build --product Colosseum-CLI

build-pbr:
	swift build --product PBR-CLI
