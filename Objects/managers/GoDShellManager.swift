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
        
        var file: XGFiles {
            return .nameAndFolder(rawValue, folder)
        }
        
        var folder: XGFolders {
            switch self {
            case .wit:
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
            task.arguments = args.split(separator: " ").compactMap(String.init)
        }
            
        let pipe = Pipe()
        task.standardOutput = pipe
        task.launch()

        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        let output: String = NSString(data: data, encoding: String.Encoding.utf8.rawValue)! as String

        if printOutput { printg(output) }
        return output
    }
}
