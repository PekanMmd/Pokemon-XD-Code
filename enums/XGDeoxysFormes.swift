//
//  XGDeoxysFormes.swift
//  GoDToolCL
//
//  Created by The Steez on 20/04/2018.
//

import Foundation

enum XGDeoxysFormes : Int, Codable, CaseIterable {
	case normal  = 0
	case attack  = 1
	case defense = 2
	case speed   = 3
	
	var name : String {
		switch self {
			case .normal: return "Normal"
			case .attack: return "Attack"
			case .defense: return "Defense"
			case .speed: return "Speed"
		}
	}
}

extension XGDeoxysFormes: XGEnumerable {
	var enumerableName: String {
		return name
	}
	
	var enumerableValue: String? {
		return rawValue.string
	}
	
	static var enumerableClassName: String {
		return "Deoxys Formes"
	}
	
	static var allValues: [XGDeoxysFormes] {
		return allCases
	}
}
