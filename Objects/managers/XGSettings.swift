//
//  XGSettings.swift
//  GoD Tool
//
//  Created by Stars Momodu on 09/09/2019.
//

import Foundation

private let settingsFile = XGFiles.nameAndFolder("Settings.json", XGFolders.Documents)
let settings = XGSettings.load()

class XGSettings {
	var verbose = false
	var increaseFileSizes = true
	
	private struct Settings: Codable {
		
		var verbose: Bool?
		var increaseFileSizes: Bool?
		
		enum CodingKeys: String, CodingKey {
			case verbose = "Verbose Logs"
			case increaseFileSizes = "Increase File Sizes"
		}
	}
	
	private init() {}
	
	private init(settings: Settings) {
		if let verbose = settings.verbose {
			self.verbose = verbose
		}
		if let increaseFileSizes = settings.increaseFileSizes {
			self.increaseFileSizes = increaseFileSizes
		}
	}
	
	func save() {
		let settingsData = Settings(verbose: verbose, increaseFileSizes: increaseFileSizes)
		settingsData.writeJSON(to: settingsFile)
	}
	
	static func load() -> XGSettings {
		if settingsFile.exists {
			do {
				let settings = try Settings.fromJSON(file: settingsFile)
				return XGSettings(settings: settings)
			} catch {
				printg("Error loading settings file: \(settingsFile.path)")
				printg("Overwriting settings with new file. Corrupt file will be renamed.")
				settingsFile.rename("Settings Corrupt.json")
			}
		}
		
		let settings = XGSettings()
		return settings
	}
}
