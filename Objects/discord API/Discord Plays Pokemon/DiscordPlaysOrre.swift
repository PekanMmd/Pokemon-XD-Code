//
//  DiscordPlaysPokemonXD.swift
//  GoD Tool
//
//  Created by Stars Momodu on 08/10/2021.
//

import Foundation

class DiscordPlaysOrre {

	class SaveSlotsState: Codable {
		private static let file = XGFiles.nameAndFolder("DPP Continuity.json", .Documents)
		private var latestSaveSlot = 0

		func hasStates() -> Bool {
			return latestSaveSlot > 0
		}

		func save(process: XDProcess) {
			incrementSlot()
			process.inputHandler.clearPendingInput()
			process.saveStateToSlot(latestSaveSlot)
			usleep(1_000)
			write()
		}

		func load(process: XDProcess) {
			guard latestSaveSlot > 0 else {
				return
			}
			process.inputHandler.clearPendingInput()
			process.loadStateFromSlot(latestSaveSlot)
			sleep(2)
		}

		func loadPrevious(process: XDProcess) {
			guard latestSaveSlot > 0 else {
				return
			}
			let previousSlot = latestSaveSlot == 1 ? 7 : latestSaveSlot - 1
			process.inputHandler.clearPendingInput()
			process.loadStateFromSlot(previousSlot)
		}

		func write() {
			writeJSON(to: SaveSlotsState.file)
		}

		func reset() {
			latestSaveSlot = 0
			write()
		}

		static func read() -> SaveSlotsState? {
			return try? SaveSlotsState.fromJSON(file: file)
		}

		private func incrementSlot() {
			latestSaveSlot = latestSaveSlot == 7 ? 1 : latestSaveSlot + 1
		}
	}

	struct XDStatusUpdate: Encodable {
		let embeds: [DiscordEmbed]?
		let text: String?
		#if GAME_XD
		var game = "XD"
		#elseif GAME_COLO
		var game = "CM"
		#endif

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
		case pc_menu

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

	let saveSlotsState = SaveSlotsState.read() ?? SaveSlotsState()

	let updatesURL = "http://localhost:8080"
	private let processStateStack = XGStack<ProcessStates>()
	var processState: ProcessStates {
		return processStateStack.peek() ?? .none
	}

	var currentParty: XDTrainer?
	var currentShadowTable: XDShadowDataState?
	var lastFrameAdvanceHeartBeat: Date?
	var lastRenderBufferHeartBeat: Date?

	func pushState(_ state: ProcessStates) {
		processStateStack.push(state)
		switch state {
		case .startup: postContext("> <:pokeballicon:896975942738673735> Input is disabled while the game starts up.")
		case .inGame: postContext("> \(Emoji.protagRun.rawValue) Now accepting inputs. Let's play!")
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
		"esaba_B" : ("https://cdn2.bulbagarden.net/upload/a/a8/Oasis_Pok%C3%A9_Spot_XD.png", GoDDesign.colourLightBlue()),
		"esaba_C" : ("https://cdn2.bulbagarden.net/upload/8/8f/Cave_Pok%C3%A9_Spot_XD.png", GoDDesign.colourDarkGrey()),
		"D7_out" : ("https://www.destructoid.com/ul/user/2/242197-593178-GXXE01460png-noscale.jpg", GoDDesign.colourBrown()),
		"worldmap": ("https://cdn2.bulbagarden.net/upload/4/47/Orre.png", GoDDesign.colourYellow())
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

		setup.onFrame = { [weak self] (process, state) in
			self?.lastFrameAdvanceHeartBeat = Date(timeIntervalSinceNow: 0)
			return true
		}

		setup.onWillRender = { [weak self] (context, process, state) in
			self?.lastRenderBufferHeartBeat = Date(timeIntervalSinceNow: 0)
			return true
		}

		var previousRoom: XGRoom?
		setup.onDidChangeMapOrMenu = { [weak self] (context, process, state) -> Bool in
			// Don't continue any sequences from a previous room
			process.inputHandler.clearPendingInput()

			if self?.processState == .pc_menu {
				self?.popState()
				self?.currentParty = state.trainerState?.value
				self?.currentShadowTable = state.shadowDataState
			}

			switch context.newRoom.name {
			case "pokemon_logo":
				if let savedStates = self?.saveSlotsState,
				   savedStates.hasStates() {
					savedStates.load(process: process)
					self?.pushState(.inGame)
					self?.currentParty = state.trainerState?.value
					self?.currentShadowTable = state.shadowDataState
				}
			case "auto_demo":
				process.inputHandler.input([
					.init(duration: 3),
					.init(duration: 0.5, A: true),
				])
			case "title":
				if let savedStates = self?.saveSlotsState,
				   savedStates.hasStates() {
					savedStates.load(process: process)
					self?.pushState(.inGame)
					self?.currentParty = state.trainerState?.value
					self?.currentShadowTable = state.shadowDataState
				} else {
					self?.pushState(.startup)
					if game == .XD {
						process.inputHandler.input([
							GCPad(duration: 3),
							GCPad(duration: 0.5, A: true),
							GCPad(duration: 3),
							GCPad(duration: 0.5, A: true),
							// Wait to see if a save gets loaded in which case that
							// callback will skip the rest of these inputs
							GCPad(duration: 5),
							GCPad(A: true),
							GCPad(duration: 3),
							GCPad(A: true),
							GCPad(A: true),
							GCPad(duration: 3),
							GCPad(Up: true),
							GCPad(duration: 3),
							GCPad(A: true)
						])
					} else {
						process.inputHandler.input([
							GCPad(duration: 3),
							GCPad(duration: 0.5, A: true),
							GCPad(duration: 3),
							GCPad(duration: 0.5, A: true),
							GCPad(duration: 3),
							GCPad(duration: 0.5, A: true),
							GCPad(duration: 3),
							GCPad(duration: 0.5, A: true),
						])
					}
				}
			case "topmenu":
				// Colosseum only
				if game == .Colosseum {
					process.inputHandler.input([
						GCPad(duration: 3),
						GCPad(A: true),
						GCPad(duration: 3),
						GCPad(Up: true),
						GCPad(duration: 3),
						GCPad(A: true)
					])
				}
			case "pcbox_menu":
				self?.pushState(.pc_menu)
				self?.saveSlotsState.save(process: process)
			case "name_entry_menu":
				if self?.processState == .startup,
				   previousRoom?.name == "title" || previousRoom?.name == "top_menu" {
					process.inputHandler.input([
						GCPad(duration: 3),
						GCPad(Down: true),
						GCPad(duration: 3),
						GCPad(A: true),
						GCPad(duration: 3),
						GCPad(A: true)
					])
				}
			default:
				if self?.processState == .inGame,
				   state.currentRoomState?.value?.name != "title" {
					self?.saveSlotsState.save(process: process)
				}
				if self?.processState == .startup {
					self?.pushState(.inGame)
				}
			}

			previousRoom = context.newRoom
			return true
		}

		setup.onDidReadOrWriteSave = { [weak self] (context, process, state) -> Bool in
			switch context.status {
			case .firstLoadNoSaveData:
				break
			case .readSuccessfully, .previouslyLoadedCleanSave:
				if self?.processState == .startup,
				   game == .XD {
					// XD only
					process.inputHandler.clearPendingInput()
					process.inputHandler.input([
						GCPad(duration: 3),
						GCPad(A: true),
						GCPad(duration: 3),
						GCPad(Up: true),
						GCPad(duration: 3),
						GCPad(A: true)
					])
				}
				self?.currentParty = state.trainerState?.value
				self?.currentShadowTable = state.shadowDataState
			case .wroteSuccessfully:
				self?.saveSlotsState.reset()
			default: break
			}

			return true
		}

		setup.onWillChangeMap =  { [weak self] (context, process, state) -> Bool in
			let emoji = state.currentRoomState?.value?.name == "worldmap" ? "\(Emoji.protagRide.rawValue)" : "\(Emoji.protagRun.rawValue)"
			let announcementText = "> \(emoji) Now entering: " + context.nextRoom.mapName + "\n> " + context.nextRoom.name
			print(announcementText)

			if !context.nextRoom.name.contains("_bf"),
			   !context.nextRoom.name.contains("menu") {
				if context.nextRoom.name != state.currentRoomState?.value?.name { // check previous room id.
					if let info = self?.mapsURLs[context.nextRoom.name] {
						let embed = DiscordEmbed(title: context.nextRoom.name,
												 colour: info.1, imageUrl: info.0,
												 fields: [.init(name: "📍Location", value: context.nextRoom.mapName, inline: false)])
						self?.postContext("> \(emoji) Now entering: **" + context.nextRoom.mapName + "**", embeds: [embed])
					} else {
						self?.postContext(announcementText)
					}
				}
			}

			return true
		}

		#if GAME_XD
		setup.onPurification = { [weak self] (context, process, state) -> Bool in
			if context.pokemon.species.index > 0 {
				let pokemon = context.pokemon
				let name = pokemon.nickname.titleCased
				let embed = pokemon.discordEmbed(fieldTypes: [.types, .level, .nature, .ability, .moves, .IVs])
				self?.postUpdate("> 💖 **" + name + "** was purified!", embed: embed)
				self?.saveSlotsState.save(process: process)
			}
			self?.currentParty = state.trainerState?.value
			self?.currentShadowTable = state.shadowDataState
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
				let fields: [XDPartyPokemon.EmbedFieldTypes] = pokemon.shadowID > 0
					? [.hp, .status, .types, .level, .nature, .ability, .heartGauge, .moves, .IVs]
					: [.hp, .status, .types, .level, .nature, .ability, .moves, .IVs]
				let embed = pokemon.discordEmbed(fieldTypes: fields, storedShadowData: state.shadowDataState?.shadowData(pokemon: pokemon))
				if let battle = state.battleState?.value,
				   battle.battleType != .battle_bingo {
					self?.postUpdate("> **" + name + "** was caught!", embed: embed)
				} else {
					self?.postContext("> **" + name + "** was caught!", embed: embed)
				}
				if pokemon.shadowID > 0 {
					self?.currentShadowTable = state.shadowDataState
				}
			}
			self?.currentParty = state.trainerState?.value
			return true
		}

		setup.onPokeballThrow = { [weak self] (context, process, state) -> Bool in
			if context.pokemon.species.index > 0 {
				let pokemon = context.pokemon.species.name.string.titleCased
				self?.postContext("> <a:michael_throw:896976067884097558>  Threw a **" + context.pokeball.emoji + context.pokeball.name.string.titleCased + "** at " + pokemon + "!")
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
				self?.saveSlotsState.save(process: process)
			}
			self?.currentParty = state.trainerState?.value
			return true
		}

		setup.onBattleStart = { [weak self] (context, process, state) -> Bool in
			if let battle = context.battle {
				self?.currentParty = state.trainerState?.value
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
						var embeds = [DiscordEmbed(title: opponent.trainerClass.name.unformattedString.titleCased + " " + opponent.name.string.titleCased, colour: GoDDesign.colourWhite(), imageUrl: imageURL, fields: nil)]
						opponent.pokemon.forEach { (pokemon) in
							let species = pokemon.pokemon
							guard species.index > 0 else { return }
							embeds.append(DiscordEmbed(title: species.name.string.titleCased,
													   colour: colour(forType: species.type1) ?? 0,
													   imageUrl: "pokemon:" + species.name.string,
													   fields: [.init(name: "Level", value: pokemon.level.string, inline: false)]))
						}
						self?.postContext("> <:pokeballicon:896975942738673735> Battle!\n" + battle.title, embeds: embeds)

						let opponent = battle.p2Trainer?.trainerModel
						switch opponent {
						case .lovrina: self?.postUpdate("https://i.redd.it/3p17uzuw1da31.gif")
						case .mirorB: self?.postUpdate("https://thumbs.gfycat.com/IdealisticLimpingHypsilophodon-max-1mb.gif")
						case .snattle: self?.postUpdate("https://lparchive.org/Pokemon-XD/Update%2009/166-KgYYPZ8.gif")
						case .roboGroudon: self?.postUpdate("https://lparchive.org/Pokemon-XD/Update%2010/46-3YBNg8h.gif")
						case .gonzap: self?.postUpdate("https://lparchive.org/Pokemon-XD/Update%2012/105-xRRFHMk.gif")
						case .gorigan: self?.postUpdate("https://lparchive.org/Pokemon-XD/Update%2013/135-lMVWJdI.gif")
						case .ardos: self?.postUpdate("https://lparchive.org/Pokemon-XD/Update%2015/249-Ardos.gif")
						case .eldes: self?.postUpdate("https://lparchive.org/Pokemon-XD/Update%2016/54-Eldes.gif")
						case .greevil2: self?.postUpdate("https://lparchive.org/Pokemon-XD/Update%2016/114-XD.gif") // lugia battle
						case .greevil: self?.postUpdate("https://lparchive.org/Pokemon-XD/Update%2016/139-cqrnoSl.gif") // final battle
						default: break
						}
					}
				default: break
				}
			}
			return true
		}

		setup.onBattleEnd = { [weak self] (context, process, state) in
			self?.saveSlotsState.save(process: process)
			self?.currentParty = state.trainerState?.value
			return true
		}

		setup.onTurnStart = { [weak self] (context, process, state) in
			self?.saveSlotsState.save(process: process)
			return true
		}

		setup.onWildBattleGenerated = { [weak self] (context, process, state) -> Bool in
			if let trainer = context.trainer {
				let monsCount = trainer.partyPokemon.count
				if monsCount > 0,
				   let mon = trainer.partyPokemon[0] {
					self?.postContext("> <:researchencounter:882358521243504710>  A wild **" + mon.species.name.string.titleCased + "** appeared!",
									  embed: mon.discordEmbed(fieldTypes: [.types, .level, .catchRate]))
				}
			}
			return true
		}

		setup.onPokemonFainted = { [weak self] (context, process, state) -> Bool in
			if context.defendingPokemon.species.index > 0 {
				let defendingPokemon = context.defendingPokemon
				var embed = defendingPokemon.discordEmbed(fieldTypes: [.hp, .status], storedShadowData: state.shadowDataState?.shadowData(pokemon: defendingPokemon))
				embed.color = colour(named: "dark red") ?? 0
				if context.attackingPokemon.species.index > 0,
				   context.attackingPokemon.PID != defendingPokemon.PID,
				   context.attackingPokemon.TID != defendingPokemon.TID {
					let attackingPokemon = context.attackingPokemon.nickname.titleCased
					self?.postContext("> <:iconfnt:897922354880073788> " + attackingPokemon + " knocked out **" + defendingPokemon.nickname.titleCased + "!**", embed: embed)
				} else {
					self?.postContext("> <:iconfnt:897922354880073788> **" + defendingPokemon.nickname.titleCased + "** fainted!", embed: embed)
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
			self?.saveSlotsState.save(process: process)
			self?.currentParty = state.trainerState?.value
			return true
		}
		#endif

		setup.onWillUseMove = { [weak self] (context, process, state) -> Bool in
			if context.attackingPokemon.species.index > 0 {
				let attackingPokemon = context.attackingPokemon
				let move = context.move
				let embed = attackingPokemon.discordEmbed(fieldTypes: [.hp, .status], storedShadowData: state.shadowDataState?.shadowData(pokemon: attackingPokemon))
				self?.postContext(">  " + attackingPokemon.nickname.titleCased + " used \(move.emoji)**" + context.move.name.string.titleCased + "**", embed: embed)
			}
			return true
		}

		#if GAME_XD
		setup.onBattleDamageOrHealing = { [weak self] (context, process, state) -> Bool in
			let defendingPokemon = context.defendingPokemon
			if defendingPokemon.species.index > 0,
			   defendingPokemon.currentHP > 0 {
				let embed = defendingPokemon.discordEmbed(fieldTypes: [.hp, .status], storedShadowData: state.shadowDataState?.shadowData(pokemon: defendingPokemon))
				self?.postContext("", embed: embed)
			}
			return true
		}

		setup.onTeamWhiteOut = { [weak self] (process, state) -> Bool in
			self?.postUpdate("> <:oof:864554659883253771> Oof! _The team was wiped out!_")
			return true
		}

		setup.onShadowPokemonEncountered = { [weak self] (context, process, state) -> Bool in
			if context.pokemon.species.index > 0 {
				let pokemon = context.pokemon
				let name = pokemon.speciesName.titleCased
				let fields: [XDPartyPokemon.EmbedFieldTypes] = [.types, .level, .catchRate]
				let embed = pokemon.discordEmbed(fieldTypes: fields, storedShadowData: state.shadowDataState?.shadowData(pokemon: pokemon))
				self?.postUpdate("> ⚠️ The aura reader responded to **Shadow " + name + "**!", embed: embed)
				self?.currentShadowTable = state.shadowDataState
			}
			return true
		}

		setup.onPokemonDidEnterReverseMode = { [weak self] (context, process, state) -> Bool in
			if context.pokemon.species.index > 0 {
				let pokemon = context.pokemon
				let embed = pokemon.discordEmbed(fieldTypes: [.hp, .status, .types, .reverseMode], storedShadowData: state.shadowDataState?.shadowData(pokemon: pokemon))
				self?.postContext("> 😡 " + pokemon.nickname.titleCased + " entered **\(game == .XD ? "Reverse Mode" : "Hyper Mode")**!", embed: embed)
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

					switch storyFlag {
					case .completedTutorialBattle:
						self?.currentParty = state.trainerState?.value
						self?.currentShadowTable = state.shadowDataState
						fallthrough
					case .defeatedLovrinaInCipherLab: fallthrough
					case .battledMirorBAtCavePokespot: fallthrough
					case .battledExolAtONBS: fallthrough
					case .defeatedSnattleInPhenacCity: fallthrough
					case .defeatedMirorBAtOutskirtStand: fallthrough
					case .reclaimedSnagMachine: fallthrough
					case .defeatedGoriganAtShadowPokemonFactory: fallthrough
					case .defeatedEldes: fallthrough
					case .defeatedGreevil:
						if let player = state.trainerState,
						   let trainerData = player.value {
							self?.postUpdate("> <:pokeballicon:896975942738673735> Team Status:", embeds: trainerData.embeds(trainerModel: .michael1WithoutSnagMachine, shadowTable: state.shadowDataState))
						}
					default:
						break
					}
				}
				self?.saveSlotsState.save(process: process)
			}
			return true
		}
		#endif

		#if GAME_XD
		setup.onSpotMonitorActivated = { [weak self] (process, state) -> Bool in
			var embeds = [DiscordEmbed]()
			func addEmbedForSpawn(spot: XGPokeSpots, species: XGPokemon, snacks: Int) {
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

				let stepsPerSnack = spot.entries.first(where: { $0.pokemon.index == species.index })?.stepsPerSnack.string
					?? XGPokeSpots.all.entries.first(where: { $0.pokemon.index == species.index })?.stepsPerSnack.string
					?? "?"

				embeds.append(DiscordEmbed(title: spotName,
										   colour: colour(named: colourName) ?? 0,
										   imageUrl: "pokemon:" + pokemonName,
										   fields: [
											DiscordEmbed.Field(name: pokemonName, value: types, inline: false),
											DiscordEmbed.Field(name: "Snacks left", value: snacks.string, inline: true),
											DiscordEmbed.Field(name: "Steps per snack", value: stepsPerSnack, inline: true),
										   ]
				))
			}
			if let spawn = state.flagsState?.getSpawnAtPokespot(.rock),
			   let snacks = state.flagsState?.getSnacksAtPokespot(.rock),
			   spawn.index > 0 {
				addEmbedForSpawn(spot: .rock, species: spawn, snacks: snacks)
			}
			if let spawn = state.flagsState?.getSpawnAtPokespot(.oasis),
			   let snacks = state.flagsState?.getSnacksAtPokespot(.oasis),
			   spawn.index > 0 {
				addEmbedForSpawn(spot: .oasis, species: spawn, snacks: snacks)
			}
			if let spawn = state.flagsState?.getSpawnAtPokespot(.cave),
			   let snacks = state.flagsState?.getSnacksAtPokespot(.cave),
			   spawn.index > 0 {
				addEmbedForSpawn(spot: .cave, species: spawn, snacks: snacks)
			}
			let addendum = embeds.count > 0 ? "\n> Current spawns:" : ""
			self?.postContext("> <:researchencounter:882358521243504710> the spot monitor is responding to a **wild pokemon**!" + addendum, embeds: embeds)
			self?.saveSlotsState.save(process: process)
			return true
		}

		setup.onMirorRadarActivatedColosseum = { [weak self] (process, state) -> Bool in
			if let location = state.flagsState?.mirorBLocation?.mapName {
				let emoji = "<a:mirorbxd:897190854941356072>"
				let embed = DiscordEmbed(title: "Miror B!",
										 colour: colour(named: "crimson") ?? 0,
										 imageUrl: "https://raw.githubusercontent.com/StarsMmd/PDA-Assets/main/xd/trainer_43.png",
										 fields: [.init(name: "📍Location", value: location, inline: false)])
				self?.postContext("> \(emoji) **Miror B.** has appeared!", embed: embed)
			}
			self?.saveSlotsState.save(process: process)
			return true
		}
		setup.onMirorRadarActivatedPokespot = setup.onMirorRadarActivatedColosseum
		#endif

		setup.launch(processType: .Dolphin(dolphinFile: nil, isoFile: nil)) { (process) in

			print("Launched Dolphin Process")

			var overridePending = false
			func getInputEndpoint() -> String {
				defer {
					overridePending = false
				}
				return overridePending ? "/override" : "/input"
			}

			var lastInputEndTime = Date(timeIntervalSinceNow: 0)

			XGThreadManager.manager.runInBackgroundAsync(queue: 2) { [weak self] in
				while process.isRunning {
					guard let self = self else { return }

					if self.processState.acceptInputs || self.processState.acceptOverrides {
						guard XGSettings.current.inputPollDuration > 0 else {
							sleep(5)
							continue
						}
						let sleepDuration = XGSettings.current.inputPollDuration > 0 ? XGSettings.current.inputPollDuration * 1000 : 10_000_000
						usleep(sleepDuration)
						GoDNetworkingManager.get(self.updatesURL + getInputEndpoint()) { (controller: GCPad?) in
							if let pad = controller {
								switch pad.tag {
								case "terminate":
									self.shouldRelaunchOnDolphinClosed = false
									process.terminate()
									return

								case "reset":
									self.shouldRelaunchOnDolphinClosed = true
									process.terminate()
									return

								case "dump-ram":
									let now = Date(timeIntervalSinceNow: 0).referenceString()
									process.RAMDump(to: .nameAndFolder("RAM Dump " + now + ".bin", .Reference))

								case "override-pending":
									overridePending = true

								case "reload-settings":
									XGSettings.reload()

								case "save-state":
									self.saveSlotsState.save(process: process)

								case "load-state":
									self.saveSlotsState.load(process: process)

								case "load-previous-state":
									self.saveSlotsState.loadPrevious(process: process)

								case "override":
									process.inputHandler.input(pad)

								case "team-status":
									if self.processStateStack.contains(.inGame),
									   let party = self.currentParty,
									   let shadowData = self.currentShadowTable {
										#if GAME_XD
										self.postContext("> <:pokeballicon:896975942738673735> Team Status:", embeds: party.embeds(trainerModel: .michael1WithoutSnagMachine, shadowTable: shadowData))
										#else
										self.postContext("> <:pokeballicon:896975942738673735> Team Status:", embeds: party.embeds(trainerModel: .wes, shadowTable: shadowData))
										#endif
									}
									fallthrough

								default:
									let timeSinceLastInputEnd =  Date(timeIntervalSinceNow: 0).timeIntervalSince1970 - lastInputEndTime.timeIntervalSince1970
									guard timeSinceLastInputEnd >= 0 else {
										return
									}
									if self.processState.acceptInputs && XGSettings.current.inputPollDuration > 0 {
										var updatedPad = pad.disableButtons(self.processState.disabledButtons)
										if self.processState == .pc_menu {
											// The controls seems to be more sensitive in the pc menus
											updatedPad.duration = updatedPad.duration * 0.8
										}
										process.inputHandler.input(updatedPad)
										lastInputEndTime = Date(timeIntervalSinceNow: updatedPad.duration)
									}
								}
							}
						}
					} else {
						sleep(5)
					}
				}
				self?.pushState(.finished)
			}

			// Check heart beat
			XGThreadManager.manager.runInBackgroundAsync(queue: 3) { [weak self] in
				while process.isRunning {
					guard let self = self else { return }
					if let lastHeartBeat = self.lastFrameAdvanceHeartBeat {
						let timeSinceLastHeartBeat =  Date(timeIntervalSinceNow: 0).timeIntervalSince1970 - lastHeartBeat.timeIntervalSince1970
						if timeSinceLastHeartBeat >= 21 {
							self.shouldRelaunchOnDolphinClosed = false
							process.terminate()
						} else if timeSinceLastHeartBeat >= 14 {
							self.shouldRelaunchOnDolphinClosed = true
							process.terminate()
						} else if timeSinceLastHeartBeat >= 7,
								  self.processState != .startup,
								  self.processState != .none {
							self.saveSlotsState.load(process: process)
						}
					}
					if let lastHeartBeat = self.lastRenderBufferHeartBeat {
						let timeSinceLastHeartBeat =  Date(timeIntervalSinceNow: 0).timeIntervalSince1970 - lastHeartBeat.timeIntervalSince1970
						if timeSinceLastHeartBeat >= 21 {
							self.shouldRelaunchOnDolphinClosed = false
							process.terminate()
						} else if timeSinceLastHeartBeat >= 14 {
							self.shouldRelaunchOnDolphinClosed = true
							process.terminate()
						} else if timeSinceLastHeartBeat >= 7,
								  self.processState != .startup,
								  self.processState != .none {
							self.saveSlotsState.load(process: process)
							sleep(2)
						}
					}
					sleep(3)
				}
			}

			return true

		} onFinish: { [weak self] in

			printg("Finished running XD Process")

			if self?.shouldRelaunchOnDolphinClosed == true {
				self?.shouldRelaunchOnDolphinClosed = false
				printg("Process marked for relaunch")
				DiscordPlaysOrre().launch()
			} else {
				printg("Closing tool")
				ToolProcess.terminate()
			}

		}
	}
}
