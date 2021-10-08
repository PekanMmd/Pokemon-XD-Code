//
//  DiscordPlaysPokemon.swift
//  GoD Tool
//
//  Created by Stars Momodu on 08/10/2021.
//

import Foundation

class DiscordPlaysPokemon {

	struct XDStatusUpdate: Codable {
		let infoKey: String?
		let text: String?
		var game = "XD"

		init(text: String? = nil, key: String? = nil) {
			self.text = text
			self.infoKey = key
		}
	}

	enum ProcessStates {
		case none
		case startup
		case inGame
		case finished

		var acceptInputs: Bool {
			return self != .none && self != .startup && self != .finished
		}

		var postUpdates: Bool {
			return self != .none && self != .startup && self != .finished
		}
	}

	let updatesURL = "http://localhost:8080"
	var processState = ProcessStates.none

	let mapsToIds = [
		"S1_out" : "https://cdn2.bulbagarden.net/upload/0/07/Outskirt_Stand.png",
		"M1_out" : "https://cdn2.bulbagarden.net/upload/2/2a/Phenac_City.png",
		"M2_out" : "https://cdn2.bulbagarden.net/upload/2/21/Pyrite_Town.png",
		"D1_out" : "https://cdn2.bulbagarden.net/upload/5/5e/Cipher_Lab.png",
		"D2_out" : "https://lparchive.org/Pokemon-Colosseum/Update%2014/1-xdwej8.jpg",
		"M3_out" : "https://cdn2.bulbagarden.net/upload/8/8e/Agate_Village.png",
		"M4_out" : "https://cdn2.bulbagarden.net/upload/a/a1/The_Under.png",
		"D4_out" : "https://cdn2.bulbagarden.net/upload/d/da/Realgam_Tower.png",
		"D4_out_2" : "https://cdn2.bulbagarden.net/upload/d/da/Realgam_Tower.png",
		"S2_out" : "https://cdn2.bulbagarden.net/upload/8/81/Snagem_Hideout_XD.png",
		"S2_out_2" : "https://cdn2.bulbagarden.net/upload/8/81/Snagem_Hideout_XD.png",
		"D3_out" : "https://cdn2.bulbagarden.net/upload/8/89/SS_Libra_Wreck.png",
		"D5_out" : "https://cdn2.bulbagarden.net/upload/c/cb/Cipher_Key_Lair.png",
		"M5_out" : "https://cdn2.bulbagarden.net/upload/0/0e/HQ_Lab_Exterior.png",
		"M6_out" : "https://cdn2.bulbagarden.net/upload/e/ee/Gateon_Port.png",
		"S3_out" : "https://cdn2.bulbagarden.net/upload/e/e2/Kaminko_House.png",
		"D6_out_all" : "https://cdn2.bulbagarden.net/upload/b/bb/Citadark_Isle.png",
		"D6_out_foot" : "https://cdn2.bulbagarden.net/upload/b/bb/Citadark_Isle.png",
		"D6_out_dome" : "https://cdn2.bulbagarden.net/upload/b/bb/Citadark_Isle.png",
		"esaba_A" : "https://cdn2.bulbagarden.net/upload/a/a5/Rock_Pok%C3%A9_Spot_XD.png",
		"esaba_B" : "https://bulbapedia.bulbagarden.net/wiki/File:Oasis_Pok%C3%A9_Spot_XD.png",
		"esaba_C" : "https://bulbapedia.bulbagarden.net/wiki/File:Cave_Pok%C3%A9_Spot_XD.png",
		"D7_out" : "https://www.destructoid.com/ul/user/2/242197-593178-GXXE01460png-noscale.jpg",
	]

	func postUpdate(_ text: String, key: String? = nil) {
		if processState.postUpdates {
			XGThreadManager.manager.runInBackgroundAsync(queue: 1) { [weak self] in
				if let updatesURL = self?.updatesURL {
					GoDNetworkingManager.post(updatesURL + "/update", json: XDStatusUpdate(text: text, key: key))
				}
			}
		}
	}

	func launch () {
		let setup = XDProcessSetup()

		setup.onDidChangeMap = { [weak self] (context, process, state) -> Bool in
			switch context.newRoom.name {
			case "title":
				self?.processState = .startup
			default:
				if self?.processState == .startup {
					self?.processState = .inGame
				}
			}
			return true
		}

		setup.onWillChangeMap =  { [weak self] (context, process, state) -> Bool in
			var announcementText = "> Now entering: " + context.nextRoom.mapName + "\n> " + context.nextRoom.name
			print(announcementText)

			if !context.nextRoom.name.contains("_bf") {
				if context.nextRoom.name != state.currentRoom?.name { // check previous room id.
					if let url = self?.mapsToIds[context.nextRoom.name] {
						announcementText += "\n" + url
					}
					self?.postUpdate(announcementText)
				}
			}

			return true
		}



		setup.launch(settings: [
			(key: .Dolphin(.Interface(.DebugModeEnabled)),"no"),
			(key: .Dolphin(.Core(.EnableCheats)),"no"),
			(key: .Dolphin(.Interface(.ConfirmStop)),"yes"),
		], autoSkipWarningScreen: true) { (process) in

			print("Launched Dolphin Process")

			XGThreadManager.manager.runInBackgroundAsync(queue: 2) { [weak self] in
				while process.isRunning {
					if self?.processState.acceptInputs ?? false,
					   let updatesURL = self?.updatesURL {
						usleep(500_000)
						GoDNetworkingManager.get(updatesURL + "/input") { (controller: GCPad?) in
							if let pad = controller {
								process.inputHandler.input(pad)
							}
						}
					} else {
						sleep(5)
					}
				}
				self?.processState = .finished
			}

			return true

		} onFinish: {

			printg("Finished running XD Process")

		}
	}
}
