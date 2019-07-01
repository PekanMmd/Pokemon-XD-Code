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
	
	@objc var index				= 0
	var spot				= XGPokeSpots.rock
	var pokemon				= XGPokemon.pokemon(0)
	
	@objc var minLevel			= 0
	@objc var maxLevel			= 0
	@objc var encounterPercentage	= 0
	@objc var stepsPerSnack		= 0

	@objc var location : String {
		get {
			return spot.string
		}
	}
	
	@objc var startOffset : Int {
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
		self.pokemon = XGPokemon.pokemon(species)
		self.stepsPerSnack = rel.get2BytesAtOffset(start + kStepsPerPokeSnackOffset)
		
	}
	
	@objc func save() {
		
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
		return pokemon.name.string
	}
	
	var enumerableValue: String? {
		return spot.string
	}
	
	static var enumerableClassName: String {
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




















