//
//  DiscordPlaysPokemonXD.swift
//  GoD Tool
//
//  Created by Stars Momodu on 08/10/2021.
//

#if !GUI && os(macOS)
import Foundation
import Swiftcord

class DiscordPlaysOrre: DiscordPlaysOrreEventsHandler {

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

		func loadPrevious(process: XDProcess, rewindCount: Int) {
			guard latestSaveSlot > 0 else {
				return
			}
			var previousSlot = latestSaveSlot
			for _ in 0 ..< rewindCount {
				previousSlot = previousSlot == 1 ? 7 : previousSlot - 1
			}
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

	private let processStateStack = XGStack<ProcessStates>()
	var processState: ProcessStates {
		return processStateStack.peek() ?? .none
	}

	var currentParty: XDTrainer?
	var currentShadowTable: XDShadowDataState?
	var lastFrameAdvanceHeartBeat: Date?
	var lastRenderBufferHeartBeat: Date?
	var process: XDProcess?
	
	let discordBot: SwiftcordClient
	let discordListener: DiscordPlaysOrreEvents
	
	init(discordBotToken: String) {
		discordListener = DiscordPlaysOrreEvents()
		self.discordBot = DiscordBot.setup(
			token: discordBotToken,
			listener: discordListener
		)
		discordListener.eventsHandler = self
	}

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

	func postUpdate(_ text: String, embed: EmbedBuilder, skipContext: Bool = false) {
		postUpdate(text, embeds: [embed], skipContext: skipContext)
	}

	func postUpdate(_ text: String, embeds: [EmbedBuilder]? = nil, skipContext: Bool = false) {
		postInfo(type: .update, text: text, embeds: embeds)
		if !skipContext {
			postContext(text, embeds: embeds)
		}
	}

	func postContext(_ text: String, embed: EmbedBuilder) {
		postContext(text, embeds: [embed])
	}

	func postContext(_ text: String, embeds: [EmbedBuilder]? = nil) {
		postInfo(type: .context, text: text, embeds: embeds)
	}

	func postInfo(type: DiscordPostTypes, text: String, embeds: [EmbedBuilder]? = nil) {
		if processState.postUpdates {
			discordBot.postInfo(type: type, text: text, embeds: embeds)
		}
	}

	func launch () {
		
		let setup = XDProcessSetup()

		setup.onFrameSkipCounter = 120
		setup.onFrame = { [weak self] (process, state) in
			self?.lastFrameAdvanceHeartBeat = Date(timeIntervalSinceNow: 0)
			return true
		}

		setup.onWillRenderSkipCounter = 120
		setup.onWillRender = { [weak self] (context, process, state) in
			self?.lastRenderBufferHeartBeat = Date(timeIntervalSinceNow: 0)
			return true
		}

		var previousRoom: XGRoom?
		setup.onDidChangeMapOrMenu = { [weak self] (context, process, state) -> Bool in
			// Don't continue any sequences from a previous room
			process.inputHandler.clearPendingInput()

			if self?.processState == .pc_menu {
				if let stateStack = self?.processStateStack, !stateStack.isEmpty {
					self?.popState()
				}
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
					GCPad(duration: 3),
					GCPad(duration: 0.5, A: true),
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
						let embed = EmbedBuilder()
							.setTitle(title: context.nextRoom.name)
							.setColor(color: info.1)
							.setThumbnail(url: info.0)
							.addField("📍Location", value: context.nextRoom.mapName)
						self?.postContext("> \(emoji) Now entering: **" + context.nextRoom.mapName + "**", embeds: [embed])
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
				let imageURL = PokeAPI.getImageURL(for: pokemon.speciesName)
				var embed = pokemon.discordEmbed(fieldTypes: [.types, .level, .nature, .ability, .moves])
					.setThumbnail(url: imageURL, height: nil, width: nil)
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
					#if GAME_XD
					if battle.p1TID == 5000,
					   let opponent = battle.p2Trainer {
						let imageName = "trainer_\(opponent.trainerModel.rawValue)"
						let imageURL = "https://raw.githubusercontent.com/StarsMmd/PDA-Assets/main/xd/" + imageName + ".png"
						var embeds = [
							EmbedBuilder()
								.setTitle(title: opponent.trainerClass.name.unformattedString.titleCased + " " + opponent.name.string.titleCased)
								.setColor(color: GoDDesign.colourWhite())
								.setThumbnail(url: imageURL)
						]
						opponent.pokemon.forEach { (pokemon) in
							let species = pokemon.pokemon
							guard species.index > 0 else { return }
							let imageURL = PokeAPI.getImageURL(for: species.name.string)
							embeds.append(
								EmbedBuilder()
									.setTitle(title: species.name.string.titleCased)
									.setColor(color: colour(forType: species.type1) ?? 0)
									.setThumbnail(url: imageURL)
									.addField("Level", value: pokemon.level.string, isInline: false)
							)
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
					#else
					if battle.p1Trainer?.isPlayer == true,
					   let opponent = battle.p2Trainer {
						let imageName = "trainer_\(opponent.trainerModel.rawValue)"
						let imageURL = "https://raw.githubusercontent.com/StarsMmd/PDA-Assets/main/colo/" + imageName + ".png"
						let trainerEmbed = EmbedBuilder()
							.setTitle(title: opponent.trainerClass.name.unformattedString.titleCased + " " + opponent.name.string.titleCased)
							.setColor(color: GoDDesign.colourWhite())
							.setThumbnail(url: imageURL, height: nil, width: nil)
						var embeds = [trainerEmbed]
						opponent.pokemon.forEach { (pokemon) in
							let species = pokemon.species
							guard species.index > 0 else { return }
							let imageURL = PokeAPI.getImageURL(for: species.name.string)
							let embed = EmbedBuilder()
								.setTitle(title: species.name.string.titleCased)
								.setColor(color: colour(forType: species.type1) ?? 0)
								.setThumbnail(url: imageURL, height: nil, width: nil)
								.addField("Level", value: pokemon.level.string, isInline: false)
						}
						self?.postContext("> <:pokeballicon:896975942738673735> Battle!\n" + battle.title, embeds: embeds)

						let opponent = battle.p2Trainer?.trainerModel
						switch opponent {
						case .mirorB: self?.postUpdate("https://lparchive.org/Pokemon-Colosseum-(by-Crosspeice)/Update%2005/90-ypepNe7.gif")
						case .venus: self?.postUpdate("https://lparchive.org/Pokemon-Colosseum-(by-Crosspeice)/Update%2008/220-3F8HvpH.gif")
						case .gonzap: self?.postUpdate("https://lparchive.org/Pokemon-Colosseum-(by-Crosspeice)/Update%2012/125-Gonzap.gif")
						case .dakim: self?.postUpdate("https://lparchive.org/Pokemon-Colosseum-(by-Crosspeice)/Update%2007/10-f6AaZve.gif")
						case .ein: self?.postUpdate("https://lparchive.org/Pokemon-Colosseum-(by-Crosspeice)/Update%2010/194-Ein.gif")
						case .nascour: self?.postUpdate("https://lparchive.org/Pokemon-Colosseum-(by-Crosspeice)/Update%2013/108-nMFXlqn.gif")
						case .fein: self?.postUpdate("https://tenor.com/view/among-us-digibyte-dgb-meme-button-gif-18569623")
						case .evice: self?.postUpdate("https://lparchive.org/Pokemon-Colosseum-(by-Crosspeice)/Update%2013/175-ofMsDO6.gif")
						default: break
						}
					}
					#endif
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

		setup.onPokemonFainted = { [weak self] (context, process, state) -> Bool in
			if context.defendingPokemon.species.index > 0 {
				let defendingPokemon = context.defendingPokemon
				let embed = defendingPokemon.discordEmbed(fieldTypes: [.hp, .status], storedShadowData: state.shadowDataState?.shadowData(pokemon: defendingPokemon))
					.setColor(color: colour(named: "dark red") ?? 0)
				
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
			let imageURL = PokeAPI.getImageURL(for: gift.species.name.string)
			let embed = EmbedBuilder()
				.setTitle(title: gift.giftType)
				.setColor(color: colour(forType: gift.species.type1) ?? 0)
				.setThumbnail(url: imageURL)
				.addField("Pokemon", value: gift.species.name.string.titleCased)
				.addField("Moves", value: moveList)
			
			self?.postUpdate("> 🎁 **" + context.pokemon.species.name.string.titleCased + "** was received!", embed: embed)
			self?.saveSlotsState.save(process: process)
			self?.currentParty = state.trainerState?.value
			return true
		}

		setup.onWillUseMove = { [weak self] (context, process, state) -> Bool in
			if context.attackingPokemon.species.index > 0 {
				let attackingPokemon = context.attackingPokemon
				let move = context.move
				let embed = attackingPokemon.discordEmbed(fieldTypes: [.hp, .status], storedShadowData: state.shadowDataState?.shadowData(pokemon: attackingPokemon))
				self?.postContext(">  " + attackingPokemon.nickname.titleCased + " used \(move.emoji)**" + context.move.name.string.titleCased + "**", embed: embed)
			}
			return true
		}

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
				if game == .XD {
					self?.postContext("> 😡 " + pokemon.nickname.titleCased + " entered **Reverse Mode**!", embed: embed)
				} else {
					self?.postContext("> 😡 " + pokemon.nickname.titleCased + "'s emotions rose to a fever pitch!\nIt entered **Hyper Mode**!", embed: embed)
				}
				
			}
			return true
		}
		
		setup.onDidPromptReleasePokemon = { [weak self] (context, process, state) -> Bool in
			let nopes = [
				"https://tenor.com/view/nope-nope-nope-never-finger-wag-gif-17348381",
				"https://tenor.com/view/no-let-me-think-nope-no-way-hmm-no-gif-22904160",
				"https://tenor.com/view/nah-nevermind-lemme-tell-you-something-listen-hear-me-out-gif-13222326",
				"https://tenor.com/view/disney-hannah-montana-rico-no-moises-arias-gif-15850397"
			]
			if context.shouldRelease,
				let nopeGif = nopes.randomElement() {
				self?.postContext("> ❌ **You can't release Pokemon!**\n" + nopeGif)
				context.shouldRelease = false
			}
			
			return true
		}

		#if GAME_XD
		setup.onWillSetFlag = { [weak self] (context, process, state) -> Bool in
			if context.flagID == XDSFlags.story.rawValue {
				if let storyFlag = XGStoryProgress(rawValue: context.value),
				   storyFlag.rawValue <= XGStoryProgress.defeatedGreevil.rawValue {
					let emoji = (game == .XD) && (storyFlag == XGStoryProgress.defeatedGreevil) ? "<a:goodmichael:896976065296232489>" : "📃"
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
							#if GAME_XD
							self?.postUpdate("> <:pokeballicon:896975942738673735> Team Status:", embeds: trainerData.embeds(trainerModel: .michael1WithoutSnagMachine, shadowTable: state.shadowDataState))
							#else
							self?.postUpdate("> <:pokeballicon:896975942738673735> Team Status:", embeds: trainerData.embeds(trainerModel: .wes, shadowTable: state.shadowDataState))
							#endif
						}
					default:
						break
					}
				}
				self?.saveSlotsState.save(process: process)
			}
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
		
		setup.onSpotMonitorActivated = { [weak self] (process, state) -> Bool in
			var embeds = [EmbedBuilder]()
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

				let imageURL = PokeAPI.getImageURL(for: pokemonName)
				let embed = EmbedBuilder()
					.setTitle(title: spotName)
					.setColor(color: colour(named: colourName) ?? 0)
					.setThumbnail(url: imageURL)
					.addField(pokemonName, value: types)
					.addField("Snacks left", value: snacks.string)
					.addField("Steps per snack", value: stepsPerSnack)
				embeds.append(embed)
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
				let embed = EmbedBuilder()
								.setTitle(title: "Miror B!")
								.setColor(color: colour(named: "crimson") ?? 0)
								.setThumbnail(url: "https://raw.githubusercontent.com/StarsMmd/PDA-Assets/main/xd/trainer_43.png")
								.addField("📍Location", value: location)
				
				self?.postContext("> \(emoji) **Miror B.** has appeared!", embed: embed)
			}
			self?.saveSlotsState.save(process: process)
			return true
		}
		setup.onMirorRadarActivatedPokespot = setup.onMirorRadarActivatedColosseum
		#endif

		setup.launch(processType: .Dolphin(dolphinFile: nil)) { (process) in

			print("Launched Dolphin Process")
			self.process = process
			
			// Process inputs
			XGThreadManager.manager.runInBackgroundAsync(queue: 2) { [weak self] in
				while process.isRunning, self?.processState != .finished {
					guard let self = self else { return }
					let sleepDuration: UInt32 = 500_000
					usleep(sleepDuration)
					
					if self.processState.acceptInputs {
						if let input = discordListener.nextInput() {
							process.inputHandler.input(input)
						}
					}
					discordListener.resetInput()
				}
			}

			// Check heart beat
			XGThreadManager.manager.runInBackgroundAsync(queue: 3) { [weak self] in
				while process.isRunning {
					guard let self = self else { return }
					if let lastHeartBeat = self.lastFrameAdvanceHeartBeat {
						let timeSinceLastHeartBeat =  Date(timeIntervalSinceNow: 0).timeIntervalSince1970 - lastHeartBeat.timeIntervalSince1970
						if timeSinceLastHeartBeat >= 14 {
							process.terminate()
						} else if timeSinceLastHeartBeat >= 7,
								  self.processState != .startup,
								  self.processState != .none {
							self.saveSlotsState.load(process: process)
						}
					}
					if let lastHeartBeat = self.lastRenderBufferHeartBeat {
						let timeSinceLastHeartBeat =  Date(timeIntervalSinceNow: 0).timeIntervalSince1970 - lastHeartBeat.timeIntervalSince1970
						if timeSinceLastHeartBeat >= 20 {
							process.terminate()
						} else if timeSinceLastHeartBeat >= 10,
								  self.processState != .startup,
								  self.processState != .none {
							self.saveSlotsState.load(process: process)
							sleep(2)
						}
					}
					sleep(3)
				}
			}
			
			Task {
				self.discordBot.connect()
			}

		} onLaunchFailed: { error in

			printg("Failed to launch Dolphin Process")

		} onFinish: { [weak self] in
			printg("Finished running XD Process")
			printg("Closing tool")
			ToolProcess.terminate()
		}
	}
	
	func reset() {
		process?.terminate()
	}
	
	func ramDump() {
		let now = Date(timeIntervalSinceNow: 0).referenceString()
		process?.RAMDump(to: .nameAndFolder("RAM Dump " + now + ".bin", .Reference))
	}
	
	func saveState() {
		if let process = process {
			saveSlotsState.save(process: process)
		}
	}
	
	func loadState() {
		if let process = process {
			saveSlotsState.load(process: process)
		}
	}
	
	func rewindState(by: Int) {
		if let process = process {
			saveSlotsState.loadPrevious(process: process, rewindCount: by)
		}
	}
	
	func party() {
		if let process = process {
			if self.processStateStack.contains(.inGame),
			   let party = self.currentParty,
			   let shadowData = self.currentShadowTable {
				#if GAME_XD
				self.postContext("> <:pokeballicon:896975942738673735> Team Status:", embeds: party.embeds(trainerModel: .michael1WithoutSnagMachine, shadowTable: shadowData))
				#else
				self.postContext("> <:pokeballicon:896975942738673735> Team Status:", embeds: party.embeds(trainerModel: .wes, shadowTable: shadowData))
				#endif
			}
		}
	}
	
	func input(pad: GCPad) {
		if self.processState.acceptInputs && XGSettings.current.dppInputDuration > 0 {
			var updatedPad = pad.disableButtons(self.processState.disabledButtons)
			if self.processState == .pc_menu {
				// The controls seems to be more sensitive in the pc menus
				updatedPad.duration = updatedPad.duration * 0.8
			}
			process?.inputHandler.input(updatedPad)
		}
	}
}
#else
class DiscordPlaysOrre {
	func launch () {}
}
#endif
