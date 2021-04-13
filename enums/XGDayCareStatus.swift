//
//  XGDayCareStatus.swift
//  GoD Tool
//
//  Created by Stars Momodu on 12/04/2021.
//

import Foundation

enum XGDayCareStatus: Int {
	case notVisited = -1
	case noPokemonDeposited = 0
	case pokemonDeposited = 1

	var name: String {
		switch self {
		case .notVisited: return "Day Care Not Visited Yet"
		case .noPokemonDeposited: return "No Pokemon Deposited"
		case .pokemonDeposited: return "Pokemon Deposited"
		}
	}
}
