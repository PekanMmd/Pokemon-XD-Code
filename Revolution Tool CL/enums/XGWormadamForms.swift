//
//  XGWormadamForms.swift
//  Revolution Tool CL
//
//  Created by The Steez on 30/12/2018.
//

import Foundation

enum XGWormadamCloaks : Int, Codable, CaseIterable {
	case plant = 0
	case sandy = 1
	case trash = 2
	
	var name : String {
		switch self {
			case .plant : return "Plant"
			case .sandy : return "Sandy"
			case .trash : return "Trash"
		}
	}
}

extension XGWormadamCloaks: XGEnumerable {
	var enumerableName: String {
		return name
	}
	
	var enumerableValue: String? {
		return rawValue.string
	}
	
	static var className: String {
		return "Wormadam Cloaks"
	}
	
	static var allValues: [XGWormadamCloaks] {
		return allCases
	}
}
