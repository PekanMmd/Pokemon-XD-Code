//
//  XGTrainerModels.swift
//  XG Tool
//
//  Created by StarsMmd on 31/05/2015.
//  Copyright (c) 2015 StarsMmd. All rights reserved.
//

import Foundation

let kNumberOfTrainerModels = 12

enum PBRSkinTones: Int, Codable {
	case light, medium, dark
	var name: String {
		switch self {
		case .light: return "Light"; case .medium: return "Medium"; case .dark: return "Dark"
		}
	}
}

struct PBRTrainerCustomizationOptions: Codable {
	enum Types: Int, CaseIterable {
		case hats, hair, faces, tops, bottoms, shoes, hands, bags, glasses, badges
	}
	let hats: [PBRTrainerClothing]
	let hairColours: [PBRTrainerClothing]
	let faces: [PBRTrainerClothing]
	let tops: [PBRTrainerClothing]
	let bottoms: [PBRTrainerClothing]
	let shoes: [PBRTrainerClothing]
	let hands: [PBRTrainerClothing]
	let bags: [PBRTrainerClothing]
	let glasses: [PBRTrainerClothing]
	let badges: [PBRTrainerClothing]

	func getClothing(type: Types, index: Int) -> PBRTrainerClothing? {
		let entry: [PBRTrainerClothing]
		switch type {
		case .hats: entry = hats
		case .hair: entry = hairColours
		case .faces: entry = faces
		case .tops: entry = tops
		case .bottoms: entry = bottoms
		case .shoes: entry = shoes
		case .hands: entry = hands
		case .bags: entry = bags
		case .glasses: entry = glasses
		case .badges: entry = badges
		}
		guard index < entry.count else { return nil }
		return entry[index]
	}
}

enum XGTrainerModels: Int, CaseIterable {

	case none	= 0
	case youngBoy = 1
	case coolBoy = 2
	case muscleMan = 3
	case youngGirl = 4
	case coolGirl = 5
	case littleGirl = 6
	case poketopiaBoy = 7
	case poketopiaGirl = 8
	case masterJoe = 9
	case masterSashay = 10
	case masterKruger = 11
	case masterMysterial = 12
	case lucas = 13
	case dawn = 14
	
	var name: String {
		switch self {
		case .none: return "None"
		case .youngBoy: return "Young Boy"
		case .coolBoy: return "Cool Boy"
		case .muscleMan: return "Muscle Man"
		case .youngGirl: return "Young Girl"
		case .coolGirl: return "Cool Girl"
		case .littleGirl: return "Little Girl"
		case .poketopiaBoy: return "Poketopia Boy"
		case .poketopiaGirl: return "Poketopia Girl"
		case .masterJoe: return "Master Joe"
		case .masterSashay: return "Master Sashay"
		case .masterKruger: return "Master Kruger"
		case .masterMysterial: return "Master Mysterial"
		case .lucas: return "Lucas"
		case .dawn: return "Dawn"
		}
	}
	
	var pkxFSYS: XGFsys? {
		return nil
	}
	
	var pkxData: XGMutableData? {
		return nil
	}

	var clothingOptions: PBRTrainerCustomizationOptions? {
		guard rawValue > 0, rawValue < XGTrainerModels.poketopiaBoy.rawValue else { return nil }
		let mappingTable = GoDDataTable.trainerCustomTable
		let numberOfClothingTypes = 10
		let firstEntryIndex = (rawValue - 1) * numberOfClothingTypes
		var itemsLists = [[PBRTrainerClothing]]()
		for itemType in PBRTrainerCustomizationOptions.Types.allCases {
			let currentEntryIndex = firstEntryIndex + itemType.rawValue
			if let entry = mappingTable.entryWithIndex(currentEntryIndex) {
				let startID = entry.getShort(0)
				let endID = entry.getShort(2)
				var items = [PBRTrainerClothing]()
				for i in startID ..< endID {
					let clothingItem = PBRTrainerClothing(index: i)
					items.append(clothingItem)
				}
				itemsLists.append(items)
			}
		}
		return PBRTrainerCustomizationOptions(hats: itemsLists[0], hairColours: itemsLists[1], faces: itemsLists[2], tops: itemsLists[3], bottoms: itemsLists[4], shoes: itemsLists[5], hands: itemsLists[6], bags: itemsLists[7], glasses: itemsLists[8], badges: itemsLists[9])
	}
}

struct PBRTrainerClothing: Codable, CustomStringConvertible {
	var nameID: Int = 0
	var descriptionID: Int = 0

	var description: String {
		return name.unformattedString
	}

	var name: XGString {
		return getStringSafelyWithID(id: nameID)
	}

	var descriptionString: XGString {
		return getStringSafelyWithID(id: descriptionID)
	}

	init(index: Int) {
		let table = GoDDataTable.trainerCustomParts
		guard let entry = table.entryWithIndex(index) else { return }
		nameID = entry.getShort(40)
		descriptionID = entry.getShort(42)
	}
}














