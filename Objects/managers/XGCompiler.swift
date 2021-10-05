import Foundation

enum XGCompilerTarget {
	case ogc
	case bare
}

class XGCompiler: NSObject {
    class func compileBinary(startOffset: Int, type: XGCompilerTarget = .bare, sources: [String], linkerScripts: [String], directoryPath: String) -> (instructions: [UInt32], exports: [String:UInt32], patches: [UInt32:UInt32]) {
		var offset = startOffset
		if offset < 0x80000000 {
			offset += 0x80000000
		}

        let directory = URL(fileURLWithPath: directoryPath)

        let compiledFileURL = directory.appendingPathComponent("code.elf")
        try? FileManager.default.removeItem(at: compiledFileURL)

        var args = sources.map{ directory.appendingPathComponent($0).path.escapedPath }.joined(separator: " ")
        args += " -o \(compiledFileURL.path.escapedPath)"
        args += " -I\(directoryPath.escapedPath)"
        args += " -O1 -mcpu=750 -meabi -mhard-float"
        args += " -mno-sdata -Wno-builtin-declaration-mismatch"
        args += " -ffast-math -flto -fwhole-program -fdata-sections -fkeep-static-functions"
        args += " -fno-tree-loop-distribute-patterns -fno-zero-initialized-in-bss"
        args += " -Wl,-Map=\(directory.appendingPathComponent("code.map").path.escapedPath)"
        args += linkerScripts.map {
            var path = directory.appendingPathComponent($0).path.escapedPath
            if $0.prefix(1) == "/" {
                path = $0.escapedPath
            }
            return " -T \(path)"
        }.joined(separator: " ")
        switch type {
        case .ogc:
            args += " -I/opt/devkitpro/libogc/include -DGEKKO -mogc"
            args += " -L/opt/devkitpro/libogc/lib/cube -ldb -lbba -lmad -lasnd -logc -lm"
            args += " -Wl,--gc-sections -Wl,--section-start,.init=\(offset.hexString())"
        case .bare:
            args += " -nolibc -nostdlib -nodefaultlibs"
            args += " -Wl,--gc-sections -Wl,--section-start,.text=\(offset.hexString())"
        }

        // print(args)
        GoDShellManager.run(.gcc, args: args, printOutput: false)

        var out = GoDShellManager.run(.objcopy, args: "--remove-section .comment \(compiledFileURL.path.escapedPath)", printOutput: false)
        print(out!.dropLast())

        out = GoDShellManager.run(.nm, args: "-a \(compiledFileURL.path.escapedPath)", printOutput: false)
        let exports = XGCompiler.getExports(out!)
        let imports = XGCompiler.getImports(out!)

        let patches = XGCompiler.getPatches(sources.map{ directory.appendingPathComponent($0).path }, imports: imports, exports: exports)

        if settings.verbose {
            out = GoDShellManager.run(.objdump, args: "-D \(compiledFileURL.path.escapedPath)", printOutput: false)
            printg("generated asm: \(out!.dropLast())")
        }

        let codeBinaryFileURL = directory.appendingPathComponent("code.bin")
        GoDShellManager.run(.objcopy, args: "-O binary \(compiledFileURL.path.escapedPath) \(codeBinaryFileURL.path.escapedPath)", printOutput: false)

        guard var codeBinaryData = try? Data(contentsOf: codeBinaryFileURL).rawBytes else {
        	fatalError("Could not read output compilation output")
        }

        // pad to the nearest word
        let words = codeBinaryData.count / 4
        let rem = codeBinaryData.count - (words * 4)
        let padding =  4 - rem
        codeBinaryData.append(contentsOf: [UInt8](repeating: 0, count: padding))

        let instructions = codeBinaryData.withUnsafeBytes {
            Array($0.bindMemory(to: UInt32.self)).map(UInt32.init(bigEndian:))
        }

        return (instructions, exports, patches)
    }

    class func compileCode(startOffset: Int, code: String, include: String = "", externSymbols: [String:UInt32] = [:]) -> (instructions: [UInt32], exports: [String:UInt32], patches: [UInt32:UInt32]) {
        let funcName = "__func"

		var offset = startOffset
		if offset < 0x80000000 {
			offset += 0x80000000
		}

        let tmpDir = try? XGTemporaryDirectory()
        // tmpDir!.keepDirectory = true
        let tmpDirPath = tmpDir!.directoryURL.path
        let folder = XGFolders.path(tmpDirPath)

        let includeFile = XGFiles.nameAndFolder("code.h", folder)
	    XGUtility.saveString(XGCompilerConstants.dolphinIncludes+include, toFile: includeFile)

        let codeFile = XGFiles.nameAndFolder("code.c", folder)
	    XGUtility.saveString("""
        #include "code.h"
        void \(funcName)() {
        \(code)
        }
        """, toFile: codeFile)

        let linkFile = XGFiles.nameAndFolder("ngc.ld", folder)
	    XGUtility.saveString(generateLinkerScript(offset: offset, name: funcName), toFile: linkFile)

        let mapFile = XGFiles.nameAndFolder("map.ld", folder)
	    XGUtility.saveString(generateMapScript(), toFile: mapFile)

        let externFile = XGFiles.nameAndFolder("extern.ld", folder)
	    XGUtility.saveString(generateExternScript(externSymbols), toFile: externFile)

        return XGCompiler.compileBinary(startOffset: startOffset, type: .bare, sources: ["code.c"], linkerScripts: ["ngc.ld", "map.ld", "external.ld"], directoryPath: tmpDirPath)
    }

    class func getPatches(_ sources: [String], imports: [String:UInt32], exports: [String:UInt32]) -> [UInt32:UInt32] {
        var patches : [UInt32:UInt32] = [:]

        let pattern = "^PATCH_CALL\\((.*), (.*)\\)" 
        let regex = try! NSRegularExpression(pattern: pattern)

        for source in sources {
            let contents = try! String(contentsOf: URL(fileURLWithPath: source))
            let lines = contents.components(separatedBy: CharacterSet.newlines)
            
            for line in lines {
                let lineRange = NSRange(location: 0, length: line.utf16.count)
                guard let match = regex.firstMatch(in: line, options: [], range: lineRange) else { continue }

                let locationRange = Range(match.range(at: 1), in: line)!
                let location = String(line[locationRange])

                var address : UInt32
                if let val = imports[location] {
                    address = val
                } else {
                    address = UInt32(location.dropFirst(2), radix: 16)!
                }

                let symbolRange = Range(match.range(at: 2), in: line)!
                let symbol = String(line[symbolRange])

                let code = exports[symbol]!

                patches[address] = code
            }

        }

        return patches
    }

    class func applyPatches(_ patches: [UInt32:UInt32]) { 
        for (absCallLocation, absCallTarget) in patches {
            let callLocation = Int(absCallLocation) - 0x80000000
            let callTarget = Int(absCallTarget) - 0x80000000
            print("Patching function call at \(absCallLocation.hexString())")
            XGAssembly.replaceRamASM(RAMOffset: callLocation, newASM: [.bl(callTarget)])
        }
    }

    class func getExports(_ text: String) -> [String:UInt32] {
        return XGCompiler.parseNameMangling(text, include: ["T", "t", "d"])
    }

    class func getImports(_ text: String) -> [String:UInt32] {
        return XGCompiler.parseNameMangling(text, include: ["A"])
    }

    class func parseNameMangling(_ text: String, include: [Character]) -> [String:UInt32] {
        let lines = text.components(separatedBy: CharacterSet.newlines)

        var symbols: [String:UInt32] = [:]

        for line in lines {
            // skip empty lines and unnamed symbols
            if line.length == 0 || line.components(separatedBy: .whitespacesAndNewlines).filter({!$0.isEmpty}).count != 3 {
                continue
            }
            let scanner = Scanner(string: line)

            let startAddress = UInt32(scanner.scanUInt64(representation: .hexadecimal)!)
            let symbolType = scanner.scanCharacter()!
            let symbolName = scanner.scanUpToString("\n")!

            if !include.contains(symbolType) {
                continue
            }
            symbols[symbolName] = startAddress
        }

        return symbols
    }

    class func getDolphinMap() -> String {
        let appSupportURL = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first
        let appURLs = try? FileManager.default.contentsOfDirectory(at: appSupportURL!, includingPropertiesForKeys: nil)
        let appURL = appURLs!.filter{ ["Dolphin", "dolphin-emu"].contains($0.lastPathComponent) }.first
        return appURL!.appendingPathComponent("Maps/GXXE01.map").path
    }

    class func parseDolphinMap() -> [String:UInt32] {
        let path = XGCompiler.getDolphinMap()
        let text = try! String(contentsOfFile: path, encoding: String.Encoding.utf8)
        let lines = text.components(separatedBy: CharacterSet.newlines)

        var symbols: [String:UInt32] = [:]

        for line in lines {
            if line.first == "." || line.count == 0 {
                continue
            }
            let charset = CharacterSet(charactersIn: ":/<>,'%?&")
            if line.rangeOfCharacter(from: charset) != nil {
                continue
            }

            let scanner = Scanner(string: line)

            let startAddress = UInt32(scanner.scanUInt64(representation: .hexadecimal)!)
            let _ /* symbolLength */ = scanner.scanUInt64(representation: .hexadecimal)!
            let _ /* virtualAddress */ = scanner.scanUInt64(representation: .hexadecimal)!
            let _ /* number */ = scanner.scanInt(representation: .decimal)!
            let symbolName = String(scanner.string[scanner.currentIndex...])

            symbols[symbolName] = startAddress
        }

        return symbols
    }

    class func checkForCompiler() throws {

    }

    class func generateExternScript(_ externSymbols: [String:UInt32] = [:]) -> String {
        var symbols = [String]()
        for (symbol, address) in externSymbols {
            symbols.append("\(symbol) = \(address.hexString());")
        }

        return symbols.joined(separator: "\n")
    } 

    class func generateMapScript() -> String {
        let symbolMap = parseDolphinMap() 
        return generateExternScript(symbolMap)
    }

    class func generateLinkerScript(offset: Int, name: String) -> String {
        return """
        OUTPUT_FORMAT("elf32-powerpc", "elf32-powerpc", "elf32-powerpc")
        OUTPUT_ARCH(powerpc:common)
        ENTRY(\(name))

        SECTIONS {
            . = \(offset.hexString());

            .text : {
                *(.text)
            } =0

            . = ALIGN(32);
            .data : {
                SORT(CONSTRUCTORS)
            }
        }
        """
    }
}
