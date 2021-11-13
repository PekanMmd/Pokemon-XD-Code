//
//  GoDShellManager.swift
//  GoD Tool
//
//  Created by Stars Momodu on 25/02/2020.
//

import Foundation

class GoDShellManager {
    enum Commands {
        case wit
		case wimgt
		case nedcenc
		case gcitool
		case gcitoolReplace
		case pbrSaveTool
		case appleScript
		case standard(String)
		case file(XGFiles)
        
        var file: XGFiles {
			switch self {
			case .wit: return .wit
			case .wimgt: return .wimgt
			case .nedcenc: return .nedcenc
			case .gcitool: return .tool("gcitool")
			case .gcitoolReplace: return .tool("gcitool_replace")
			case .pbrSaveTool: return .tool("pbrsavetool")
			case .appleScript: return .nameAndFolder("osascript", XGFolders.path("/usr/bin"))
			case .file(let file): return file
			case .standard(let name):
				let filename = name + (environment == .Windows ? ".exe" : "")
				let folder = environment == .Windows ? XGFolders.Resources : XGFolders.path("/bin")
				return .nameAndFolder(filename, folder)
			}

        }
    }
    
    @discardableResult
	static func run(_ command: Commands, args: String?, printOutput: Bool = true, inputRedirectFile: XGFiles? = nil) -> String? {
		var splitArgs = [String]()
		if let args = args {
			let escaped = args.replacingOccurrences(of: "\\ ", with: "<!SPACE>")
			splitArgs = escaped.split(separator: " ").compactMap(String.init).map({ (arg) -> String in
				return arg.replacingOccurrences(of: "<!SPACE>", with: " ")
			})
		}
		return run(command, args: splitArgs, printOutput: printOutput, inputRedirectFile: inputRedirectFile)
	}

	@discardableResult
	static func run(_ command: Commands, args: [String] = [], printOutput: Bool = true, inputRedirectFile: XGFiles? = nil) -> String? {
        guard command.file.exists else {
			printg("command, \(command.file.fileName), doesn't exist\n\(command.file.path) not found")
            return nil
        }
        
        let process = Process()
        process.executableURL = URL(fileURLWithPath: command.file.path)
		process.arguments = args

		if let inputFile = inputRedirectFile, inputFile.exists {
			let fileHandle = FileHandle(forReadingAtPath: inputFile.path)
			process.standardInput = fileHandle
		}
            
        let outPipe = Pipe()
		let errorPipe = Pipe()
        process.standardOutput = outPipe
		process.standardError = errorPipe
		do {
			try process.run()
			process.waitUntilExit()
		} catch let error {
			printg("Shell error:", error)
			return nil
		}

        let data = outPipe.fileHandleForReading.readDataToEndOfFile()
        let output = NSString(data: data, encoding: String.Encoding.utf8.rawValue)! as String

		let errorData = errorPipe.fileHandleForReading.readDataToEndOfFile()
		if let error = NSString(data: errorData, encoding: String.Encoding.utf8.rawValue) as String? {
			printg(error)
		}

        if printOutput { printg(output) }
        return output
    }

	@discardableResult
	static func runAsync(_ command: Commands, args: String?, inputRedirectFile: XGFiles? = nil, outputRedirectFile: XGFiles? = nil, errorRedirectFile: XGFiles? = nil) -> GoDProcess? {
		var splitArgs = [String]()
		if let args = args {
			let escaped = args.replacingOccurrences(of: "\\ ", with: "<!SPACE>")
			splitArgs = escaped.split(separator: " ").compactMap(String.init).map({ (arg) -> String in
				return arg.replacingOccurrences(of: "<!SPACE>", with: " ")
			})
		}
		return runAsync(command, args: splitArgs, inputRedirectFile: inputRedirectFile, outputRedirectFile: outputRedirectFile, errorRedirectFile: errorRedirectFile)
	}

	@discardableResult
	static func runAsync(_ command: Commands, args: [String] = [], inputRedirectFile: XGFiles? = nil, outputRedirectFile: XGFiles? = nil, errorRedirectFile: XGFiles? = nil) -> GoDProcess? {
		guard command.file.exists else {
			printg("command, \(command.file.fileName), doesn't exist\n\(command.file.path) not found")
			return nil
		}

		let process = Process()
		process.executableURL = URL(fileURLWithPath: command.file.path)
		process.arguments = args

		if let inputFile = inputRedirectFile, inputFile.exists {
			let fileHandle = FileHandle(forReadingAtPath: inputFile.path)
			process.standardInput = fileHandle
		}

		if let outputFile = outputRedirectFile {
			let fileHandle = FileHandle(forWritingAtPath: outputFile.path)
			process.standardOutput = fileHandle
		} else {
			process.standardOutput = nil
		}

		if let errorFile = errorRedirectFile {
			let fileHandle = FileHandle(forWritingAtPath: errorFile.path)
			process.standardError = fileHandle
		} else {
			process.standardError = nil
		}

		do {
			try process.run()
			return GoDProcess(process: process)
		} catch let error {
			printg("Shell error:", error)
		}
		return nil
	}

	#if os(OSX)
	@discardableResult
	static func runAppleScript(_ script: String) -> String? {
		let escapedScript = script.replacingOccurrences(of: "\n", with: " ")
		return run(.appleScript, args: ["-e", escapedScript])
	}
	#endif
	
}
