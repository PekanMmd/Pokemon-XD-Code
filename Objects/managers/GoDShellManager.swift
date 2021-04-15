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
		case gcitool
		case gcitoolReplace
		case pbrSaveTool
		case standard(String)
		case file(XGFiles)
        
        var file: XGFiles {
			switch self {
			case .wit: return .wit
			case .wimgt: return .wimgt
			case .gcitool: return .tool("gcitool")
			case .gcitoolReplace: return .tool("gcitool_replace")
			case .pbrSaveTool: return .tool("pbrsavetool")
			case .file(let file): return file
			case .standard(let name):
				let filename = name + (environment == .Windows ? ".exe" : "")
				let folder = environment == .Windows ? XGFolders.Resources : XGFolders.path("/bin")
				return .nameAndFolder(filename, folder)
			}

        }
    }
    
    @discardableResult
	static func run(_ command: Commands, args: String? = nil, printOutput: Bool = true, inputRedirectFile: XGFiles? = nil) -> String? {
        guard command.file.exists else {
			printg("command, \(command.file.fileName), doesn't exist\n\(command.file.path) not found")
            return nil
        }
        
        let task = Process()
        task.executableURL = URL(fileURLWithPath: command.file.path)
        if let args = args {
			let escaped = args.replacingOccurrences(of: "\\ ", with: "<!SPACE>")
			task.arguments = escaped.split(separator: " ").compactMap(String.init).map({ (arg) -> String in
				return arg.replacingOccurrences(of: "<!SPACE>", with: " ")
			})
        }

		if let inputFile = inputRedirectFile, inputFile.exists {
			let fileHandle = FileHandle(forReadingAtPath: inputFile.path)
			task.standardInput = fileHandle
		}
            
        let outPipe = Pipe()
		let errorPipe = Pipe()
        task.standardOutput = outPipe
		task.standardError = errorPipe
		do {
			try task.run()
			task.waitUntilExit()
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
}
