.PHONY: setup copy build build-god build-colo build-pbr clean

all: build

setup:
	./CLI\ Compilers/link.sh

copy:
	./CLI\ Compilers/copy.sh

build: setup
	swift build

build-god:
	swift build --product GoD-CLI

build-colo:
	swift build --product Colosseum-CLI

build-pbr:
	swift build --product PBR-CLI

clean:
	rm -rf .build
