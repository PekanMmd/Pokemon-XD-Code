#! /bin/bash
cd -- "$(dirname "$0")" #changes the terminal's directory to the directory where the script was launched
swiftc -emit-executable -o out/GoD\ Tool\ CLI.app/GoD\ Tool\ CLI GoD-CLI/main.swift extensions/OSXExtensions.swift enums/XGFiles.swift objects/file\ formats/XGISO.swift
swiftc -emit-executable -o out/Colosseum\ Tool\ CLI.app/Colosseum\ Tool\ CLI Colosseum-CLI/main.swift extensions/OSXExtensions.swift
