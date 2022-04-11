//
//  Discord.swift
//  GoD Tool
//
//  Created by Stars Momodu on 10/10/2021.
//

import Foundation

struct DiscordEmbed: Encodable {
	struct Thumbnail: Encodable {
		var width = 0
		var height = 0
		var url: String
	}

	struct Author: Encodable {
		var name: String
	}

	struct Field: Encodable {
		var name: String
		var value: String
		var inline: Bool

	}

	let type = "rich"
	var thumbnail: Thumbnail?
	var color: Int?
	var author: Author?
	var fields: [Field]?

	init(title: String, colour: XGColour, imageUrl: String? = nil, fields: [Field]? = nil) {
		self.init(title: title, colour: colour.hex >> 8, imageUrl: imageUrl, fields: fields)
	}

	init(title: String, colour: Int, imageUrl: String? = nil, fields: [Field]? = nil) {
		if let url = imageUrl {
			self.thumbnail = Thumbnail(url: url)
		}
		color = colour
		author = Author(name: title)
		self.fields = fields
	}
}

extension XGPokemon {
	fileprivate var imageURL: String? {
		return nil
	}
}

extension XDPartyPokemon {
	enum EmbedFieldTypes {
		case moves, IVs, level, item, ability, nature, types, heartGauge, catchRate, status, hp, reverseMode, pokeball
	}
	func discordEmbed(fieldTypes: [EmbedFieldTypes], storedShadowData: XDStoredShadowData? = nil) -> DiscordEmbed {
		var fields: [DiscordEmbed.Field] = []

		#if GAME_XD
		let isShadowPokemon = (storedShadowData != nil && shadowID > 0 && !storedShadowData!.hasBeenPurified)
		let useBoostLevel = isShadowPokemon && !storedShadowData!.hasBeenCaught

		var overrideColour: Int? = isShadowPokemon ? colour(named: "dark orchid") : nil

		for field in fieldTypes {
			switch field {
			case .moves:
				var moveList = ""
				var moves = [XGMoves]()
				if isShadowPokemon {
					moves = shadowDeckData.data.shadowMoves.filter { $0.index > 0 }
				}

				for i in moves.count ..< 4 {
					switch i {
					case 0: moves.append(move1)
					case 1: moves.append(move2)
					case 2: moves.append(move3)
					case 3: moves.append(move4)
					default: break
					}
				}

				moves.forEach { (move) in
					if move.index > 0 {
						moveList += "\(move.emoji) " + move.name.string.titleCased + "\n"
					}
				}
				if moveList.last == "\n" {
					moveList.removeLast()
				}
				fields.append(.init(name: "Moves", value: moveList, inline: false))
			case .IVs:
				fields.append(.init(name: "IVs", value: "\(IVHP) ⎮ \(IVattack) ⎮ \(IVdefense) ⎮ \(IVspecialAttack) ⎮ \(IVspecialDefense) ⎮ \(IVspeed)", inline: false))
			case .item:
				fields.append(.init(name: "Item", value: item.name.string.titleCased, inline: true))
			case .heartGauge:
				if let shadowData = storedShadowData {
					fields.append(.init(name: "Heart Gauge", value: shadowData.heartGauage.string, inline: true))
				} else {
					let shadowData = self.shadowDeckData.data
					fields.append(.init(name: "Heart Gauge", value: shadowData.shadowCounter.string, inline: true))
				}
			case .pokeball:
				fields.append(.init(name: "Pokeball", value: pokeballCaughtIn.emoji, inline: true))
			case .level:
				let shadowData = self.shadowDeckData.data
				let levelString = useBoostLevel ? shadowData.level.string + "+ (\(shadowData.shadowBoostLevel))" : level.string
				fields.append(.init(name: "Level", value: levelString, inline: true))
			case .ability:
				fields.append(.init(name: "Ability", value: ability.name.string.titleCased, inline: true))
			case .nature:
				fields.append(.init(name: "Nature", value: nature.string.titleCased, inline: true))
			case .reverseMode:
				overrideColour = colour(named: "firebrick")
			case .types:
				let emoji = species.type1 == species.type2 ? species.type1.emoji : species.type1.emoji + species.type2.emoji
				fields.append(.init(name: "Type", value: emoji, inline: false))
			case .catchRate:
				let catchRate = shadowID > 0 ? shadowDeckData.data.shadowCatchRate : species.stats.catchRate
				fields.append(.init(name: "Catch Rate", value: catchRate.string, inline: true))
			case .status:
				let emoji: String?
				if currentHP == 0 {
					emoji = "<:iconfnt:897922354880073788>"
				} else {
					emoji = status != .none ? status.emoji : nil
				}
				if let emoji = emoji {
					fields.append(.init(name: "Status", value: emoji, inline: true))
				}
			case .hp:
				var hpPercentage = Double(currentHP) / Double(maxHP) * 100
				var blockCount = 0
				while hpPercentage > 0 {
					blockCount += 1
					hpPercentage -= 10
				}
				blockCount = min(blockCount, 10)
				if currentHP < maxHP {
					blockCount = min(blockCount, 9)
				}
				var block = "<:HPgreen:897918891639046154>"
				if blockCount <= 2 { block = "<:HPred:897918891332878386>" }
				else if blockCount <= 5 { block = "<:HPyellow:897918891064446997>" }

				var bar = ""
				for _ in 0 ..< blockCount {
					bar += block
				}
				for _ in blockCount ..< 10 {
					bar += "<:HPgrey:897918891370635274>"
				}
				fields.append(.init(name: "HP", value: bar + "\n\(currentHP)/\(maxHP)", inline: true))
			}
		}
		#else
		var overrideColour: Int? = nil
		#endif
		
		var speciesName = species.name.string
		// for XG
		switch species.index {
		case 252: speciesName = "XD001"
		case 253: speciesName = "Robo Groudon"
		case 254: speciesName = "Robo Kyogre"
		case 255: speciesName = "Mawile"
		case 256: speciesName = "Kirlia"
		case 257: speciesName = "Gardevoir"
		case 258: speciesName = "Marill"
		case 259: speciesName = "Azumarill"
		case 260: speciesName = "Wigglytuff"
		case 261: speciesName = "Snubbull"
		case 262: speciesName = "Granbull"
		case 263: speciesName = "Altaria"
		case 264: speciesName = "Alolan Ninetales"
		case 265: speciesName = "Alolan Marowak"
		case 266: speciesName = "Alolan Sandslash"
		default: break
		}

		return DiscordEmbed(
			title: speciesName.titleCased.spaceToLength(10),
			colour: overrideColour ?? colour(forType: species.type1) ?? 0,
			imageUrl: "pokemon:" + speciesName, // gc pad bot will automatically look up the pokemon's name
			fields: fields)
	}
}

extension XGMoveTypes {
	var emoji: String {
		switch rawValue {
		case XGMoveTypes.normal.rawValue: return "<:normalicon:896942163496153128>"
		case XGMoveTypes.fighting.rawValue: return "<:fighting:896942163194171442>"
		case XGMoveTypes.flying.rawValue: return "<:flyingicon:896942163185782844>"
		case XGMoveTypes.poison.rawValue: return "<:poisonicon:896942163462619216>"
		case XGMoveTypes.ground.rawValue: return "<:groundicon:896942163445809253>"
		case XGMoveTypes.rock.rawValue: return "<:rockicon:896942163684913262>"
		case XGMoveTypes.bug.rawValue: return "<:bugicon:896942163026391080>"
		case XGMoveTypes.ghost.rawValue: return "<:ghosticon:896942163403890728>"
		case XGMoveTypes.steel.rawValue: return "<:steelicon:896942163454230559>"
		case XGMoveTypes.none.rawValue: return XGMoveTypes.none.name.simplified == "fairy" ? "<:fairyicon:896942163093491772>" : "❓"
		case XGMoveTypes.fire.rawValue: return "<:fireicon:896942163340967986>"
		case XGMoveTypes.water.rawValue: return "<:watericon:896942163944964136>"
		case XGMoveTypes.grass.rawValue: return "<:grassicon:896942163416457227>"
		case XGMoveTypes.electric.rawValue: return "<:electricicon:896942163089321994>"
		case XGMoveTypes.psychic.rawValue: return "<:psychicicon:896942163663912980>"
		case XGMoveTypes.ice.rawValue: return "<:iceicon:896942163462615141>"
		case XGMoveTypes.dragon.rawValue: return "<:dragonicon:896942163001233458>"
		case XGMoveTypes.dark.rawValue: return "<:darkicon:896942163269681193>"
		default: return ""
		}
	}

	var nameEmoji: String {
		switch rawValue {
		case XGMoveTypes.normal.rawValue: return "<:NormalIC:897192945889968128>"
		case XGMoveTypes.fighting.rawValue: return "<:FightingIC:897192945055305759>"
		case XGMoveTypes.flying.rawValue: return "<:FlyingIC:897192945588006932>"
		case XGMoveTypes.poison.rawValue: return ":PoisonIC:897192945957093456>"
		case XGMoveTypes.ground.rawValue: return "<:GroundIC:897192946061967411>"
		case XGMoveTypes.rock.rawValue: return "<:RockIC:897192945961279528>"
		case XGMoveTypes.bug.rawValue: return "<:BugIC:897192944845606922>"
		case XGMoveTypes.ghost.rawValue: return "<:GhostIC:897192945827074058>"
		case XGMoveTypes.steel.rawValue: return "<:SteelIC:897192945889996862>"
		case XGMoveTypes.none.rawValue: return XGMoveTypes.none.name.simplified == "fairy" ? "<:FairyIC:897192944925278249>" : "❓"
		case XGMoveTypes.fire.rawValue: return "<:FireIC:897192945449570365>"
		case XGMoveTypes.water.rawValue: return "<:WaterIC:897192945910968361>"
		case XGMoveTypes.grass.rawValue: return "<:GrassIC:897192945894182923>"
		case XGMoveTypes.electric.rawValue: return "<:ElectricIC:897192945084682341>"
		case XGMoveTypes.psychic.rawValue: return "<:PsychicIC:897192946103889920>"
		case XGMoveTypes.ice.rawValue: return "<:IceIC:897192945256640513>"
		case XGMoveTypes.dragon.rawValue: return "<:DragonIC:897192944841404438>"
		case XGMoveTypes.dark.rawValue: return "<:DarkIC:897192944715571220>"
		default: return ""
		}
	}
}

extension XGMoves {
	var emoji: String {
		return isShadowMove ?  "<:shadowicon:896942082604814376>" : type.emoji
	}
}

extension XGItems {
	var emoji: String {
		guard index > 0 else { return "" }
		switch index {
		case item("pokeball").index: return "<:pokeball:896942163605213234>"
		case item("greatball").index: return "<:greatball:896942163319988274>"
		case item("ultraball").index: return "<:ultraball:896942163680706571>"
		case item("masterball").index: return "<:masterball:896942163437432832>"
		case item("netball").index: return "<:netball:896942163626176583>"
		case item("nestball").index: return "<:nestball:896942163454218280>"
		case item("repeatball").index: return "<:repeatball:896942163617787914>"
		case item("timerball").index: return "<:timerball:896942163718451230>"
		case item("luxuryball").index: return "<:luxuryball:896942163437432892>"
		case item("premierball").index: return "<:premierball:896942163416453171>"
		case item("diveball").index: return "<:diveball:896942162967679087>"
		case item("safariball").index: return "<:safariball:896942163651362906>"
		default: return ""
		}
	}
}

extension XGNonVolatileStatusEffects {
	var emoji: String {
		switch self {
		case .none: return ""
		case .poison: return "<:iconpsn:897922354984914954>"
		case .badPoison: return "<:iconpsn:897922354984914954>"
		case .paralysis: return "<:iconpar:897922354976542741>"
		case .burn: return "<:iconbrn:897922354859114536>"
		case .freeze: return "<:iconfrz:897922354926202920>"
		case .sleep: return "<:iconslp:897922354959749140>"
		}
	}
}

extension XDTrainer {
	func embeds(trainerModel: XGTrainerModels, shadowTable: XDShadowDataState?, useCompactVersion: Bool = false) -> [DiscordEmbed] {
		let imageName = "trainer_\(trainerModel.rawValue)"
		let imageURL = "https://raw.githubusercontent.com/StarsMmd/PDA-Assets/main/xd/" + imageName + ".png"
		var embeds = [
			DiscordEmbed(title: name?.titleCased ?? "???", colour: GoDDesign.colourWhite(), imageUrl: imageURL, fields: nil)
		]
		partyPokemon.forEach { (mon) in
			guard let pokemon = mon,
				pokemon.species.index > 0 else { return }
			let shadowData = shadowTable?.shadowData(pokemon: pokemon)
			let fullFieldTypes: [XDPartyPokemon.EmbedFieldTypes] = (shadowData == nil || shadowData?.hasBeenPurified == true)
				? [.hp, .status, .types, .pokeball, .level, .nature, .ability, .item, .moves, .IVs]
				: [.hp, .status, .types, .pokeball, .level, .nature, .ability, .item, .heartGauge, .moves, .IVs]
			let fieldTypes: [XDPartyPokemon.EmbedFieldTypes] = useCompactVersion
				? [.types, .level]
				: fullFieldTypes
			embeds.append(pokemon.discordEmbed(fieldTypes: fieldTypes, storedShadowData: shadowData))
		}
		return embeds
	}
}

enum Emoji: String {
	#if GAME_XD
	case protagRun = "<a:michael_run:896978303892750416>"
	case protagRide = "<a:michael_scooter:896976067464663061>"
	#else
	case protagRun = "<a:michael_run:896978303892750416>"
	case protagRide = "<a:michael_scooter:896976067464663061>"
	#endif
}
