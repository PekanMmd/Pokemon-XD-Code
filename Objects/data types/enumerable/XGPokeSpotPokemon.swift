//
//  XGPokeSpotPokemon.swift
//  XG Tool
//
//  Created by StarsMmd on 08/06/2015.
//  Copyright (c) 2015 StarsMmd. All rights reserved.
//

import Foundation

let kFirstPokeSpotOffset		= 0x2FAC
let kSizeOfPokeSpotData			= 0x0C
let kNumberOfPokeSpotEntries	= 0x0B

let kMinLevelOffset				= 0x00
let kMaxLevelOffset				= 0x01
let kPokeSpotSpeciesOffset		= 0x02
let kEncounterPercentageOffset	= 0x07
let kStepsPerPokeSnackOffset	= 0x0A

final class XGPokeSpotPokemon: NSObject, Codable {
	
	var index					= 0
	var spot					= XGPokeSpots.rock
	var pokemon					= XGPokemon.index(0)
	
	var minLevel				= 0
	var maxLevel				= 0
	var encounterPercentage		= 0
	var stepsPerSnack			= 0

	var location: String {
		get {
			return spot.string
		}
	}
	
	var startOffset: Int {
		get {
			return spot.commonRelIndex.startOffset + (index * kSizeOfPokeSpotData)
		}
	}
	
	init(index: Int, pokespot spot: XGPokeSpots) {
		super.init()
		
		let rel			= XGFiles.common_rel.data!
		self.index		= index
		self.spot		= spot
		
		let start = startOffset
		
		self.minLevel = rel.getByteAtOffset(start + kMinLevelOffset)
		self.maxLevel = rel.getByteAtOffset(start + kMaxLevelOffset)
		self.encounterPercentage = rel.getByteAtOffset(start + kEncounterPercentageOffset)
		
		let species = rel.get2BytesAtOffset(start + kPokeSpotSpeciesOffset)
		self.pokemon = XGPokemon.index(species)
		self.stepsPerSnack = rel.get2BytesAtOffset(start + kStepsPerPokeSnackOffset)
		
	}
	
	func save() {
		
		let rel = XGFiles.common_rel.data!
		let start = startOffset
		
		rel.replaceByteAtOffset(start + kMinLevelOffset, withByte: self.minLevel)
		rel.replaceByteAtOffset(start + kMaxLevelOffset, withByte: self.maxLevel)
		rel.replaceByteAtOffset(start + kEncounterPercentageOffset, withByte: encounterPercentage)
		
		rel.replace2BytesAtOffset(start + kStepsPerPokeSnackOffset, withBytes: stepsPerSnack)
		rel.replace2BytesAtOffset(start + kPokeSpotSpeciesOffset, withBytes: pokemon.index)
		
		rel.save()
	}
	
}

extension XGPokeSpotPokemon: XGEnumerable {
	var enumerableName: String {
		return pokemon.name.string.spaceToLength(20)
	}
	
	var enumerableValue: String? {
		return spot.string
	}
	
	static var className: String {
		return "Pokespot Encounters"
	}
	
	static var allValues: [XGPokeSpotPokemon] {
		var values = [XGPokeSpotPokemon]()
		for spot: XGPokeSpots in [.rock, .oasis, .cave, .all] {
			for i in 0 ..< spot.numberOfEntries {
				values.append(XGPokeSpotPokemon(index: i, pokespot: spot))
			}
		}
		return values
	}
}

extension XGPokeSpotPokemon: XGDocumentable {
	
	var documentableName: String {
		return spot.documentableName + " \(index + 1) " + pokemon.name.string
	}
	
	static var DocumentableKeys: [String] {
		return ["index", "hex index", "location", "species", "min level", "max level", "encounter percentage", "steps per snack"]
	}
	
	func documentableValue(for key: String) -> String {
        switch key {
        case "index":
            return index.string
        case "hex index":
            return index.hexString()
        case "location":
            return location
        case "species":
            return pokemon.name.string
        case "min level":
            return minLevel.string
        case "max level":
            return maxLevel.string
        case "encounter percentage":
            return encounterPercentage.string
        case "steps per snack":
            return stepsPerSnack.string
        default:
            return ""
        }
	}
}
















