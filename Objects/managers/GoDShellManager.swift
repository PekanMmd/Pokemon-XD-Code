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
        case wit
		case wimgt
        
        var file: XGFiles {
            return .nameAndFolder(rawValue, folder)
        }
        
        var folder: XGFolders {
            switch self {
			case .wit, .wimgt:
                return .Resources
            default:
                return .path("/usr/bin")
            }
        }
    }
    
    @discardableResult
    static func run(_ command: Commands, args: String? = nil, printOutput: Bool = true) -> String? {
        guard command.file.exists else {
			printg("command, \(command.rawValue), doesn't exist\n\(command.file.path)")
            return nil
        }
        
        let task = Process()
        task.launchPath = command.file.path
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
        task.launch()
		task.waitUntilExit()

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
