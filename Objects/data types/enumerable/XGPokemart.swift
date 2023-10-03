//
//  XGPokemart.swift
//  GoD Tool
//
//  Created by The Steez on 01/11/2017.
//
//

import Foundation

enum XGShopDialogTypes: Int, Codable {
	case pokemart, vendingMachine, shop, herbShop
	#if GAME_XD
	case herbShop2, battleCDs
	#endif
}

enum XGShopTypes: Int, Codable {
	case shop, vendingMachine, bonusDiscCoupons, brokenCoupons, pokeCoupons
	#if GAME_XD
	case battleCDs, herbShop
	#endif
}

final class XGPokemart: GoDCodable {
	let index: Int
	var type: XGShopDialogTypes
	var subtype: XGShopTypes
	var items: [XGItems]
	
	init(index: Int, type: XGShopDialogTypes, subtype: XGShopTypes, items: [XGItems]) {
		self.index = index
		self.type = type
		self.subtype = subtype
		self.items = items
	}
	
	func save() {
		if index < pocket.pokemarts.count {
			pocket.pokemarts[index] = self
			pocket.save()
		} else if index == pocket.pokemarts.count {
			pocket.pokemarts.append(self)
			pocket.save()
		}
	}
	
	static func getMart(withIndex index: Int) -> XGPokemart? {
		guard index < pocket.pokemarts.count else { return nil }
		return pocket.pokemarts[index]
	}
}

extension XGPokemart: XGEnumerable {
	var enumerableName: String {
		return "Mart " + String(format: "%03d", index)
	}
	
	var enumerableValue: String? {
		return nil
	}
	
	static var className: String {
		return "Shops"
	}
	
	static var allValues: [XGPokemart] {
		pocket.pokemarts
	}
}

extension XGPokemart: XGDocumentable {
	
	var documentableName: String {
		return "Shop \(self.index)"
	}
	
	static var DocumentableKeys: [String] {
		return ["type", "subtype", "items"]
	}
	
	func documentableValue(for key: String) -> String {
		switch key {
		case "type":
			return type.rawValue.string
		case "subtype":
			return subtype.rawValue.string
		case "items":
			var itemsString = ""
			for item in items {
				itemsString += "\n" + item.name.string
			}
			return itemsString
		default: return ""
		}
	}
	
	
}

