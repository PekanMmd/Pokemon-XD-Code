//
//  GoDShellManager.swift
//  GoD Tool
//
//  Created by Stars Momodu on 25/02/2020.
//

import Foundation

class GoDShellManager {
    enum Commands: String {
        case ls
		case pwd
        case wit
		case wimgt
		case gcitool
		case gcitoolReplace
        
        var file: XGFiles {
			switch self {
			case .wit: return .wit
			case .wimgt: return .wimgt
			case .gcitool: return .tool("gcitool")
			case .gcitoolReplace: return .tool("gcitool_replace")
			default: return .nameAndFolder(rawValue, folder)
			}
        }
        
        var folder: XGFolders {
            switch self {
			case .wit, .wimgt:
                return .Wiimm
			case .gcitool, .gcitoolReplace:
				return .Resources
            default:
				return environment == .Windows ? .Resources : .path("/bin")
            }
        }
    }
    
    @discardableResult
    static func run(_ command: Commands, args: String? = nil, printOutput: Bool = true) -> String? {
        guard command.file.exists else {
			printg("command, \(command.rawValue), doesn't exist\n\(command.file.path) not found")
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
