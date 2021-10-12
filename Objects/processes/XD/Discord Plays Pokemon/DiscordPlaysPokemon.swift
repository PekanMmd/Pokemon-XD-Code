//
//  DiscordPlaysPokemon.swift
//  GoD Tool
//
//  Created by Stars Momodu on 08/10/2021.
//

import Foundation

class DiscordPlaysPokemon {

	struct XDStatusUpdate: Encodable {
		let embeds: [DiscordEmbed]?
		let text: String?
		var game = "XD"

		init(text: String? = nil, embeds: [DiscordEmbed]? = nil) {
			self.text = text
			self.embeds = embeds
		}
	}

	enum ProcessStates {
		case none
		case startup
		case inGame
		case finished
		case evolution

		var acceptOverrides: Bool {
			return self != .none && self != .finished
		}

		var acceptInputs: Bool {
			return self != .none && self != .finished && self != .startup
		}

		var postUpdates: Bool {
			return self != .none && self != .finished
		}

		var disabledButtons: [ControllerButtons] {
			switch self {
			case .evolution: return [.B]
			default: return []
			}
		}
	}

	let updatesURL = "http://localhost:8080"
	private let processStateStack = XGStack<ProcessStates>()
	var processState: ProcessStates {
		return processStateStack.peek() ?? .none
	}
	func pushState(_ state: ProcessStates) {
		processStateStack.push(state)
		switch state {
		case .startup: postContext("> <:pokeballicon:896975942738673735> Input is disabled while starting up game.")
		case .inGame: postContext("> <a:michael_run:896978303892750416> Now accepting inputs. Let's play!")
		case .evolution: postContext("> <:evolution:897055856657575957> **B** button is disabled until the evolution is finished.")
		default: break
		}
	}
	func popState() {
		processStateStack.pop()
	}

	var shouldRelaunchOnDolphinClosed = false

	let mapsURLs = [
		"S1_out" : ("https://cdn2.bulbagarden.net/upload/0/07/Outskirt_Stand.png", GoDDesign.colourOrange()),
		"M1_out" : ("https://cdn2.bulbagarden.net/upload/2/2a/Phenac_City.png", GoDDesign.colourLightBlue()),
		"M2_out" : ("https://cdn2.bulbagarden.net/upload/2/21/Pyrite_Town.png", GoDDesign.colourRed()),
		"D1_out" : ("https://cdn2.bulbagarden.net/upload/5/5e/Cipher_Lab.png", GoDDesign.colourBabyPink()),
		"D2_out" : ("https://lparchive.org/Pokemon-Colosseum/Update%2014/1-xdwej8.jpg", GoDDesign.colourRed()),
		"M3_out" : ("https://cdn2.bulbagarden.net/upload/8/8e/Agate_Village.png", GoDDesign.colourGreen()),
		"M4_out" : ("https://cdn2.bulbagarden.net/upload/a/a1/The_Under.png", GoDDesign.colourGrey()),
		"D4_out" : ("https://cdn2.bulbagarden.net/upload/d/da/Realgam_Tower.png", GoDDesign.colourLightGreen()),
		"D4_out_2" : ("https://cdn2.bulbagarden.net/upload/d/da/Realgam_Tower.png", GoDDesign.colourLightGreen()),
		"S2_out" : ("https://cdn2.bulbagarden.net/upload/8/81/Snagem_Hideout_XD.png", GoDDesign.colourRed()),
		"S2_out_2" : ("https://cdn2.bulbagarden.net/upload/8/81/Snagem_Hideout_XD.png", GoDDesign.colourRed()),
		"D3_out" : ("https://cdn2.bulbagarden.net/upload/8/89/SS_Libra_Wreck.png", GoDDesign.colourLightOrange()),
		"D5_out" : ("https://cdn2.bulbagarden.net/upload/c/cb/Cipher_Key_Lair.png", GoDDesign.colourLightPurple()),
		"M5_out" : ("https://cdn2.bulbagarden.net/upload/0/0e/HQ_Lab_Exterior.png", GoDDesign.colourNavy()),
		"M6_out" : ("https://cdn2.bulbagarden.net/upload/e/ee/Gateon_Port.png", GoDDesign.colourBlue()),
		"S3_out" : ("https://cdn2.bulbagarden.net/upload/e/e2/Kaminko_House.png", GoDDesign.colourLightGrey()),
		"D6_out_all" : ("https://cdn2.bulbagarden.net/upload/b/bb/Citadark_Isle.png", GoDDesign.colourPurple()),
		"esaba_A" : ("https://cdn2.bulbagarden.net/upload/a/a5/Rock_Pok%C3%A9_Spot_XD.png", GoDDesign.colourBrown()),
		"esaba_B" : ("https://bulbapedia.bulbagarden.net/wiki/File:Oasis_Pok%C3%A9_Spot_XD.png", GoDDesign.colourLightBlue()),
		"esaba_C" : ("https://bulbapedia.bulbagarden.net/wiki/File:Cave_Pok%C3%A9_Spot_XD.png", GoDDesign.colourDarkGrey()),
		"D7_out" : ("https://www.destructoid.com/ul/user/2/242197-593178-GXXE01460png-noscale.jpg", GoDDesign.colourBrown())
	]

	func postUpdate(_ text: String, embed: DiscordEmbed, skipContext: Bool = false) {
		postUpdate(text, embeds: [embed], skipContext: skipContext)
	}

	func postUpdate(_ text: String, embeds: [DiscordEmbed]? = nil, skipContext: Bool = false) {
		postInfo(endpoint: "update", text: text, embeds: embeds)
		if !skipContext {
			postContext(text, embeds: embeds)
		}
	}

	func postContext(_ text: String, embed: DiscordEmbed) {
		postContext(text, embeds: [embed])
	}

	func postContext(_ text: String, embeds: [DiscordEmbed]? = nil) {
		postInfo(endpoint: "context", text: text, embeds: embeds)
	}

	func postInfo(endpoint: String, text: String, embeds: [DiscordEmbed]? = nil) {
		if processState.postUpdates {
			XGThreadManager.manager.runInBackgroundAsync(queue: 1) { [weak self] in
				if let updatesURL = self?.updatesURL {
					GoDNetworkingManager.post(updatesURL + "/" + endpoint, json: XDStatusUpdate(text: text.replacingOccurrences(of: "é", with: "e"), embeds: embeds))
				}
			}
		}
	}

	func launch () {
		let setup = XDProcessSetup()

		var previousRoom: XGRoom?
		setup.onDidChangeMap = { [weak self] (context, process, state) -> Bool in
			// Don't continue any sequences from a previous room
			process.inputHandler.clearPendingInput()

			if context.newRoom.name == "title"
				&& previousRoom?.name == "title" {
				// This should be the name entry menu on a new game
				process.inputHandler.input([
					.init(duration: 3),
					.init(Down: true),
					.init(duration: 3),
					.init(A: true),
					.init(duration: 3),
					.init(A: true)
				])
			}
			guard context.newRoom.roomID != previousRoom?.roomID else {
				return true
			}
			switch context.newRoom.name {
			case "title":
				self?.pushState(.startup)
				process.inputHandler.input([
					.init(duration: 3),
					.init(duration: 0.5, A: true),
					.init(duration: 3),
					.init(duration: 0.5, A: true),
					// Wait to see if a save gets loaded in which case that
					// callback will skip the rest of these inputs
					.init(duration: 5),
					.init(A: true),
					.init(duration: 3),
					.init(A: true),
					.init(A: true),
					.init(duration: 3),
					.init(Up: true),
					.init(duration: 3),
					.init(A: true)
				])
			default:
				if self?.processState == .startup {
					self?.pushState(.inGame)
				}
			}
			previousRoom = context.newRoom
			return true
		}

		setup.onDidLoadSave = { (context, process, state) -> Bool in
			switch context.status {
			case .firstLoadNoSaveData:
				break
			case .success, .previouslyLoadedNCleanSaveNoData:
				process.inputHandler.clearPendingInput()
				process.inputHandler.input([
					.init(duration: 3),
					.init(A: true),
					.init(duration: 3),
					.init(Up: true),
					.init(duration: 3),
					.init(A: true)
				])
			default: break
			}

			return true
		}

		setup.onWillChangeMap =  { [weak self] (context, process, state) -> Bool in
			let emoji = state.currentRoomState?.value?.name == "worldmap" ? "<a:michael_scooter:896976067464663061>" : "<a:michael_run:896978303892750416>"
			let announcementText = "> \(emoji) Now entering: **" + context.nextRoom.mapName + "**" + "\n> " + context.nextRoom.name
			print(announcementText)

			if !context.nextRoom.name.contains("_bf") {
				if context.nextRoom.name != state.currentRoomState?.value?.name { // check previous room id.
					if let info = self?.mapsURLs[context.nextRoom.name] {
						let embed = DiscordEmbed(title: context.nextRoom.name,
												 colour: info.1, imageUrl: info.0,
												 fields: [.init(name: "📍Location", value: context.nextRoom.mapName, inline: false)])
						self?.postContext("> \(emoji) Now entering: " + context.nextRoom.name, embeds: [embed])
					} else {
						self?.postContext(announcementText)
					}
				}
			}

			return true
		}

		setup.onPurification = { [weak self] (context, process, state) -> Bool in
			if context.pokemon.species.index > 0 {
				let pokemon = context.pokemon
				let name = pokemon.nickname.titleCased
				let embed = pokemon.discordEmbed(fieldTypes: [.types, .level, .nature, .ability, .moves, .IVs])
				self?.postUpdate("> 💖 **" + name + "** was purified!", embed: embed)
			}
			return true
		}

		setup.onCaptureFailed = { [weak self] (context, process, state) -> Bool in
			if context.pokemon.species.index > 0 {
				let pokemon = context.pokemon
				let name = pokemon.speciesName.titleCased
				let embed = pokemon.discordEmbed(fieldTypes: [], storedShadowData: state.shadowDataState?.shadowData(pokemon: pokemon))
				self?.postContext("> ❌ **" + name + "** broke free!", embed: embed)
			}
			return true
		}

		setup.onCaptureSucceeded = { [weak self] (context, process, state) -> Bool in
			if context.pokemon.species.index > 0 {
				let pokemon = context.pokemon
				let name = pokemon.nickname.titleCased
				let fields: [XDPartyPokemon.EmbedFieldTypes] = [.types, .level, .nature, .ability, .heartGauge, .moves, .IVs]
				let embed = pokemon.discordEmbed(fieldTypes: fields, storedShadowData: state.shadowDataState?.shadowData(pokemon: pokemon))
				self?.postUpdate("> \(pokemon.pokeballCaughtIn.emoji)  **" + name + "** was caught!", embed: embed)
			}
			return true
		}

		setup.onPokeballThrow = { [weak self] (context, process, state) -> Bool in
			if context.pokemon.species.index > 0 {
				let pokemon = context.pokemon.species.name.string.titleCased
				self?.postContext("> <a:michael_throw:896976067884097558>  Threw a **" + context.pokeball.name.string.titleCased + "** at " + pokemon + "!")
			}
			return true
		}

		setup.onWillEvolve = { [weak self] (context, process, state) -> Bool in
			if context.pokemon.species.index > 0 {
				process.inputHandler.clearPendingInput()
				self?.pushState(.evolution)
				let pokemon = context.pokemon
				let evolvedForm = context.evolvedForm.stats
				let name = pokemon.nickname.titleCased
				pokemon.species = .index(evolvedForm.index)
				if pokemon.nickname == pokemon.speciesName {
					pokemon.nickname = evolvedForm.name.string
				}
				pokemon.speciesName = evolvedForm.name.string
				var embed = pokemon.discordEmbed(fieldTypes: [.types, .level, .nature, .ability, .moves])
				embed.thumbnail?.url = "pokemon:" + evolvedForm.name.string
				self?.postUpdate("> <:evolution:897055856657575957> " + name + " is evolving into **" + evolvedForm.name.string.titleCased + "**!", embed: embed)
			}
			return true
		}

		setup.onDidEvolve = { [weak self] (context, process, state) -> Bool in
			if self?.processState == .evolution {
				self?.popState()
			}
			return true
		}

		setup.onBattleStart = { [weak self] (context, process, state) -> Bool in
			if let battle = context.battle {
				switch battle.battleType {
				case .story: fallthrough
				case .colosseum_prelim: fallthrough
				case .colosseum_final: fallthrough
				case .colosseum_orre_prelim: fallthrough
				case .colosseum_orre_final: fallthrough
				case .mt_battle: fallthrough
				case .mt_battle_final:
					if battle.p1TID == 5000,
					   let opponent = battle.p2Trainer {
						let imageName = "trainer_\(opponent.trainerModel.rawValue)"
						let imageURL = "https://raw.githubusercontent.com/StarsMmd/PDA-Assets/main/xd/" + imageName + ".png"
						var embeds = [DiscordEmbed(title: opponent.name.string.titleCased, colour: GoDDesign.colourWhite(), imageUrl: imageURL, fields: nil)]
						opponent.pokemon.forEach { (pokemon) in
							let species = pokemon.pokemon
							guard species.index > 0 else { return }
							embeds.append(DiscordEmbed(title: species.name.string.titleCased,
													   colour: colour(forType: species.type1) ?? 0,
													   imageUrl: "pokemon:" + species.name.string,
													   fields: [.init(name: "Level", value: pokemon.level.string, inline: false)]))
						}
						self?.postContext("> <:pokeballicon:896975942738673735> Battle!\n" + battle.title, embeds: embeds)
					}
				case .wild_pokemon:
					self?.postContext("> <:researchencounter:882358521243504710>  A wild " + "Pokemon" + " appeared!")
				default: break
				}
			}

			return true
		}

		setup.onPokemonFainted = { [weak self] (context, process, state) -> Bool in
			if context.defendingPokemon.species.index > 0 {
				let defendingPokemon = context.defendingPokemon
				var embed = defendingPokemon.discordEmbed(fieldTypes: [], storedShadowData: state.shadowDataState?.shadowData(pokemon: defendingPokemon))
				embed.color = colour(named: "dark red") ?? 0
				if context.attackingPokemon.species.index > 0,
				   context.attackingPokemon.PID != defendingPokemon.PID,
				   context.attackingPokemon.TID != defendingPokemon.TID {
					let attackingPokemon = context.attackingPokemon.nickname.titleCased
					self?.postContext("> 😵 " + attackingPokemon + " knocked out **" + defendingPokemon.nickname.titleCased + "!**", embed: embed)
				} else {
					self?.postContext("> 😵‍💫 **" + defendingPokemon.nickname.titleCased + "** fainted!", embed: embed)
				}
			}
			return true
		}

		setup.onReceiveGiftPokemon = { [weak self] (context, process, state) -> Bool in
			let gift = context.pokemon
			var moveList = ""
			let moves = [gift.move1, gift.move2, gift.move3, gift.move4]
			moves.forEach { (move) in
				if move.index > 0 {
					moveList += move.name.string.titleCased + "\n"
				}
			}
			if moveList.last == "\n" {
				moveList.removeLast()
			}
			let embed = DiscordEmbed(title: gift.giftType,
									 colour: colour(forType: gift.species.type1) ?? 0,
									 imageUrl: "pokemon:" + gift.species.name.string,
									 fields: [
										.init(name: "Pokemon", value: gift.species.name.string.titleCased, inline: false),
										.init(name: "Moves", value: moveList, inline: false)
									 ])
			self?.postUpdate("> 🎁 **" + context.pokemon.species.name.string.titleCased + "** was received!", embed: embed)
			return true
		}

		setup.onWillUseMove = { [weak self] (context, process, state) -> Bool in
			if context.attackingPokemon.species.index > 0 {
				let attackingPokemon = context.attackingPokemon
				let move = context.move
				let embed = attackingPokemon.discordEmbed(fieldTypes: [.types], storedShadowData: state.shadowDataState?.shadowData(pokemon: attackingPokemon))
				self?.postContext(">  " + attackingPokemon.nickname.titleCased + " used \(move.emoji)**" + context.move.name.string.titleCased + "**", embed: embed)
			}
			return true
		}

		setup.onTeamWhiteOut = { [weak self] (process, state) -> Bool in
			self?.postContext("> <:oof:754445642956537979> Oof! _The team was wiped out!_")
			return true
		}

		setup.onSpotMonitorActivated = { [weak self] (process, state) -> Bool in
			var embeds = [DiscordEmbed]()
			func addEmbedForSpawn(spot: XGPokeSpots, species: XGPokemon) {
				let colourName: String
				let pokemonName = species.name.string.titleCased
				let types = species.type1 == species.type2 ? species.type1.emoji : species.type1.emoji + species.type2.emoji
				let spotName: String

				switch spot {
				case .rock:
					colourName = "peru"
					spotName = "Rock Pokespot"
				case .oasis:
					colourName = "dodger blue"
					spotName = "Oasis Pokespot"
				case .cave:
					colourName = "dark slate gray"
					spotName = "Cave Pokespot"
				case .all:
					return
				}

				embeds.append(DiscordEmbed(title: spotName,
										   colour: colour(named: colourName) ?? 0,
										   imageUrl: "pokemon:" + pokemonName,
										   fields: [DiscordEmbed.Field(name: pokemonName, value: types, inline: true)]
				))
			}
			if let spawn = state.flagsState?.getSpawnAtPokespot(.rock) {
				addEmbedForSpawn(spot: .rock, species: spawn)
			}
			if let spawn = state.flagsState?.getSpawnAtPokespot(.oasis) {
				addEmbedForSpawn(spot: .oasis, species: spawn)
			}
			if let spawn = state.flagsState?.getSpawnAtPokespot(.cave) {
				addEmbedForSpawn(spot: .cave, species: spawn)
			}
			let addendum = embeds.count > 0 ? "\n> Current spawns:" : ""
			self?.postContext("> <:researchencounter:882358521243504710> the spot monitor is responding to a **wild pokemon**!" + addendum)
			return true
		}

		setup.onMirorRadarActivated = { [weak self] (process, state) -> Bool in
			if let location = state.flagsState?.mirorBLocation?.mapName {
				let emoji = "<a:mirorbxd:897190854941356072>"
				let embed = DiscordEmbed(title: "Miror B!",
										 colour: colour(named: "crimson") ?? 0,
										 imageUrl: "https://raw.githubusercontent.com/StarsMmd/PDA-Assets/main/xd/trainer_43.png",
										 fields: [.init(name: "📍Location", value: location, inline: false)])
				self?.postContext("> \(emoji) **Miror B.** has appeared!", embed: embed)
			}
			return true
		}

		setup.onShadowPokemonEncountered = { [weak self] (context, process, state) -> Bool in
			if context.pokemon.species.index > 0 {
				let pokemon = context.pokemon
				let name = pokemon.speciesName.titleCased
				let fields: [XDPartyPokemon.EmbedFieldTypes] = [.types, .level]
				let embed = pokemon.discordEmbed(fieldTypes: fields, storedShadowData: state.shadowDataState?.shadowData(pokemon: pokemon))
				self?.postUpdate("> ⚠️ The aura reader responded to **Shadow " + name + "**!", embed: embed)
			}
			return true
		}

		setup.onPokemonDidEnterReverseMode = { [weak self] (context, process, state) -> Bool in
			if context.pokemon.species.index > 0 {
				let pokemon = context.pokemon
				let embed = pokemon.discordEmbed(fieldTypes: [.types], storedShadowData: state.shadowDataState?.shadowData(pokemon: pokemon))
				self?.postContext("> 😡 " + pokemon.nickname.titleCased + " entered **Reverse Mode**!", embed: embed)
			}
			return true
		}

		setup.onWillSetFlag = { [weak self] (context, process, state) -> Bool in
			if context.flagID == XDSFlags.story.rawValue {
				if let storyFlag = XGStoryProgress(rawValue: context.value),
				   storyFlag.rawValue <= XGStoryProgress.defeatedGreevil.rawValue {
					let emoji = storyFlag == XGStoryProgress.defeatedGreevil ? "<a:goodmichael:896976065296232489>" : "📃"
					self?.postUpdate("> \(emoji) **Progress \(storyFlag.progress)**: " + storyFlag.name
										.replacingOccurrences(of: "_", with: " ").titleCased
										.replacingOccurrences(of: "Pda", with: "PDA")
										, skipContext: true)
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

			var overridePending = false
			func getInputEndpoint() -> String {
				defer {
					overridePending = false
				}
				return overridePending ? "/override" : "/input"
			}

			XGThreadManager.manager.runInBackgroundAsync(queue: 2) { [weak self] in
				while process.isRunning {
					guard let self = self else { return }

					if self.processState.acceptInputs || self.processState.acceptOverrides {
						usleep(500_000)
						GoDNetworkingManager.get(self.updatesURL + getInputEndpoint()) { (controller: GCPad?) in
							if let pad = controller {
								if pad.tag == "terminate" || pad.tag == "reset" {
									if pad.tag == "reset" {
										self.shouldRelaunchOnDolphinClosed = true
									}
									process.terminate()
								} else if pad.tag == "override-pending" {
									overridePending = true
								} else if pad.tag == "reload-settings" {
									XGSettings.reload()
									
							   } else if pad.tag == "override" {
									process.inputHandler.input(pad)
								} else if self.processState.acceptInputs {
									let updatedPad = pad.disableButtons(self.processState.disabledButtons)
									process.inputHandler.input(updatedPad)
								}
							}
						}
					} else {
						sleep(5)
					}
				}
				self?.pushState(.finished)
			}

			return true

		} onFinish: { [weak self] in

			printg("Finished running XD Process")

			if self?.shouldRelaunchOnDolphinClosed == true {
				printg("Process marked for relaunch")
				self?.launch()
			} else {
				printg("Closing tool")
				ToolProcess.terminate()
			}

		}
	}
}
