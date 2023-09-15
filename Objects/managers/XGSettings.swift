//
//  XGSettings.swift
//  GoD Tool
//
//  Created by Stars Momodu on 09/09/2019.
//

import Foundation

let settingsFile = XGFiles.nameAndFolder("Settings.json", XGFolders.Documents)

class XGSettings {

	static var current = XGSettings.load()

	var verbose = false
	var increaseFileSizes = true
	var enableExperimentalFeatures = false
	var dppInputDuration: Double = 0.18 // How long a button press lasts by default when input into Dolphin
	var dppInputChannelID: UInt64?
	var dppUpdatesChannelID: UInt64?
	var dppControllerBotID: String?
	
	private struct Settings: Codable {
		
		var verbose: Bool?
		var increaseFileSizes: Bool?
		var enableExperimentalFeatures: Bool?
		var dppInputDuration: Double?
		var dppInputChannelID: UInt64?
		var dppUpdatesChannelID: UInt64?
		var dppControllerBotID: String?
		
		enum CodingKeys: String, CodingKey {
			case verbose = "Verbose Logs"
			case increaseFileSizes = "Increase File Sizes"
			case enableExperimentalFeatures = "Enable Experimental Features"
			case dppInputDuration = "The default duration (seconds) for button inputs when running Dolphin"
			case dppInputChannelID = "The discord channel id where dpp players input commands"
			case dppUpdatesChannelID = "The discord channel id where dpp important updates are posted"
			case dppControllerBotID = "The bot token for the controller input for dpp"
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

		if let duration = settings.dppInputDuration {
			self.dppInputDuration = duration
		}

		if let inputChannel = settings.dppInputChannelID {
			self.dppInputChannelID = inputChannel
		}
		
		if let updatesChannel = settings.dppUpdatesChannelID {
			self.dppUpdatesChannelID = updatesChannel
		}
		
		if let botToken = settings.dppControllerBotID {
			self.dppControllerBotID = botToken
		}
	}
	
	func save() {
		guard XGISO.inputISOFile != nil else { return }
		let settingsData = Settings(verbose: verbose,
									increaseFileSizes: increaseFileSizes,
									enableExperimentalFeatures: enableExperimentalFeatures,
									dppInputDuration: dppInputDuration,
									dppInputChannelID: dppInputChannelID,
									dppUpdatesChannelID: dppUpdatesChannelID,
									dppControllerBotID: dppControllerBotID
									)
		settingsData.writeJSON(to: settingsFile)
	}

	static func reload() {
		XGSettings.current = load()
	}
	
	fileprivate static func load() -> XGSettings {
		if XGISO.inputISOFile != nil, settingsFile.exists {
			do {
				let loadedSettings = try Settings.fromJSON(file: settingsFile)
				let settings = XGSettings(settings: loadedSettings)
				settings.save()
				return settings
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
