//
//  XGSettings.swift
//  GoD Tool
//
//  Created by Stars Momodu on 09/09/2019.
//

import Foundation

private let settingsFile = XGFiles.nameAndFolder("Settings.json", XGFolders.Documents)
var settings = XGSettings.load()

class XGSettings {
	var verbose = false
	var increaseFileSizes = true
	var enableExperimentalFeatures = false
	var inputDuration = 0.3
	
	private struct Settings: Codable {
		
		var verbose: Bool?
		var increaseFileSizes: Bool?
		var enableExperimentalFeatures: Bool?
		var inputDuration: Double?
		
		enum CodingKeys: String, CodingKey {
			case verbose = "Verbose Logs"
			case increaseFileSizes = "Increase File Sizes"
			case enableExperimentalFeatures = "Enable Experimental Features"
			case inputDuration = "The default duration (seconds) for button inputs when running Dolphin"
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
		if let experimental = settings.enableExperimentalFeatures {
			self.enableExperimentalFeatures = experimental
		}

		if let duration = settings.inputDuration {
			self.inputDuration = duration
		}
	}
	
	func save() {
		let settingsData = Settings(verbose: verbose,
									increaseFileSizes: increaseFileSizes,
									enableExperimentalFeatures: enableExperimentalFeatures,
									inputDuration: inputDuration
									)
		settingsData.writeJSON(to: settingsFile)
	}

	static func reload() {
		settings = load()
	}
	
	fileprivate static func load() -> XGSettings {
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
		settings.save()
		return settings
	}
}
