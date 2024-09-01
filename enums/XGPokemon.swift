//
//  XGPokemon.swift
//  XG Tool
//
//  Created by StarsMmd on 01/06/2015.
//  Copyright (c) 2015 StarsMmd. All rights reserved.
//

import Foundation

infix operator ==
func == (m1: XGMoves, m2: XGMoves) -> Bool {
	return m1.index == m2.index
}
func == (p1: XGPokemon, p2: XGPokemon) -> Bool {
	return p1.index == p2.index
}

infix operator <
func < (p1: XGPokemon, p2: XGPokemon) -> Bool {
	return p1.index < p2.index
}



enum XGPokemon: CustomStringConvertible {
	
	case index(Int)
	case nationalIndex(Int)
	
	var description : String {
		get {
			return name.string
		}
	}
	
	var index : Int {
		get {
			switch self {
			case .index(let i):
				if (i > CommonIndexes.NumberOfPokemon.value) || (i < 0) {
					return 0
				}
				return i
			case .nationalIndex(let ni):
				for i in 0 ..< CommonIndexes.NumberOfPokemon.value {
					if XGPokemon.index(i).stats.nationalIndex == ni {
						return i
					}
				}
				return 0
			}
		}
	}
	
	var startOffset : Int {
		get{
			return CommonIndexes.PokemonStats.startOffset + (index * kSizeOfPokemonStats)
		}
	}
	
	var nameID : Int {
		get {
			return Int(XGFiles.common_rel.data!.getWordAtOffset(startOffset + kNameIDOffset))
		}
	}
	
	var name : XGString {
		get {
			let table = XGFiles.common_rel.stringTable
			return table.stringSafelyWithID(nameID)
		}
	}
	
	var ability1: String {
			let a1 = XGFiles.common_rel.data!.getByteAtOffset(startOffset + kAbility1Offset)
			return XGAbilities.index(a1).name.string
	}
	var ability2: String {
			let a2 = XGFiles.common_rel.data!.getByteAtOffset(startOffset + kAbility2Offset)
			return XGAbilities.index(a2).name.string
	}
	
	var type1: XGMoveTypes {
			let type = XGFiles.common_rel.data!.getByteAtOffset(startOffset + kType1Offset)
			return XGMoveTypes.index(type)
	}
	
	var type2: XGMoveTypes {
			let type = XGFiles.common_rel.data!.getByteAtOffset(startOffset + kType2Offset)
			return XGMoveTypes.index(type)
	}
	
	func hasType(type: XGMoveTypes) -> Bool {
		return (self.type1 == type) || (self.type2 == type)
	}
	
	var catchRate: Int {
		return XGFiles.common_rel.data!.getByteAtOffset(startOffset + kCatchRateOffset)
	}
	
	var expRate: XGExpRate {
		let rate = XGFiles.common_rel.data!.getByteAtOffset(startOffset + kEXPRateOffset)
		return XGExpRate(rawValue: rate) ?? .slow
	}
	
	var stats: XGPokemonStats {
		return XGPokemonStats(index: self.index)
	}
	
	func movesForLevel(_ pokeLevel: Int) -> [XGMoves] {
		// Returns the last 4 moves a pokemon would have learned at a level. Gives default move sets like in the GBA games.
		
		var moves = [XGMoves](repeating: XGMoves.index(0), count: 4)
		
		func hasMove(_ move: XGMoves) -> Bool {
			for aMove in moves {
				if move == aMove {
					return true
				}
			}
			return false
		}
		
		let levelUpMoves = XGPokemonStats(index: self.index).levelUpMoves
		
		var moveSlot = 0
		for move in levelUpMoves {
			if (move.level <= pokeLevel) && (move.move.index > 0) {
				
				if hasMove(move.move) {
					continue
				}
				
				moves[(moveSlot % 4)] = move.move
				
			} else {
				return moves
			}
			moveSlot += 1
		}
		
		return moves
	}
	
	func randomShadowMoveset(atLevel level: Int) -> [XGMoves] {
		// Chooses 4 moves from all the different ways the mon can learn moves (level up, tms, egg moves)
		// to create a more interesting moveset similar to the movesets shadows have in colo/xd.
		
		let stats = self.stats
		let levelMoveset = movesForLevel(level)
		let levelUpMoves = stats.levelUpMoves
			.map(\.move)
			.filter { $0.index > 0 }
		let futureLevelUpMoves = stats.levelUpMoves
			.filter { $0.level > level }
			.map(\.move)
			.filter { $0.index > 0 }
		let eggMoves = stats.eggMoves.filter { $0.index > 0 }
		let tms = stats.learnableTMs
			.enumerated()
			.compactMap { (index, canLearn) -> XGMoves? in
				guard canLearn, index < kNumberOfTMsAndHMs else { return nil }
				return XGTMs.tm(index + 1).move
			}
		let damagingTMs = tms.filter { $0.data.basePower > 0 }
		#if GAME_XD
		let tutorMoves = stats.tutorMoves
			.enumerated()
			.compactMap { (index, canLearn) -> XGMoves? in
				guard canLearn, index < kNumberOfTutorMoves else { return nil }
				return XGTMs.tutor(index + 1).move
			}
		#endif
		let specialMoves: [XGMoves] = [
			move("refresh"),
			move("heal bell"),
			move("follow me"),
			move("sing"),
			move("sweet kiss"),
			move("charm"),
			move("helping hand"),
			move("baton pass"),
			move("morning sun")
		].compactMap {
			// filter out any moves that don't exist in case the game is modded
			return $0
		}
		
		var allMoves = [XGMoves]()
		var allStatusMoves = [XGMoves]()
		for move in levelUpMoves + eggMoves + tms {
			allMoves.addUnique(move)
			if move.data.basePower == 0 {
				allStatusMoves.addUnique(move)
			}
		}
		
		#if GAME_XD
		for move in tutorMoves {
			allMoves.addUnique(move)
			if move.data.basePower == 0 {
				allStatusMoves.addUnique(move)
			}
		}
		#endif
		
		let pool1 = levelMoveset.count > 0 ? levelMoveset : levelUpMoves
		let pool2 = specialMoves.count > 4 ? specialMoves : allStatusMoves
		let pool3 = damagingTMs.count > 0 ? damagingTMs : tms
		var pool4 = eggMoves + futureLevelUpMoves
		#if GAME_XD
		if pool4.count < 3 { pool4 += tutorMoves.count > 1 ? tutorMoves : levelUpMoves }
		#else
		if pool4.count < 3 { pool4 += levelUpMoves }
		#endif
		
		var moves = [XGMoves]()
		func rollMove(fromPool pool: [XGMoves], useFilters: Bool) -> XGMoves {
			var subpool = pool
			if useFilters {
				if Bool.random() {
					// STAB
					let stabPool = subpool.filter {
						let moveType = $0.type
						return (moveType == stats.type1) || (moveType == stats.type2)
					}
					if stabPool.count > 0 {
						subpool = stabPool
					}
				}
				
				if Int.random(in: 0 ..< 3) != 0 {
					// damaging
					let damagingPool = subpool.filter {
						$0.data.basePower > 0
					}
					if damagingPool.count > 3 {
						subpool = damagingPool
					}
				}
			}
			guard subpool.count > 0 else { return .index(0) }
			guard subpool.count > 1 else { return subpool[0] }

			var rollCount = 0
			while rollCount < 100 {
				if let randomMove = subpool.randomElement(),
				   !moves.contains(randomMove){
					return randomMove
				}
				rollCount += 1
			}
			return .index(0)
		}
		
		func rollMoveset() {
			moves = []
			[pool1, pool3, pool4].forEach {
				moves.append(rollMove(fromPool: $0, useFilters: true))
			}
			moves.shuffle()
			moves.insert(rollMove(fromPool: pool2, useFilters: false), at: 1)
			
			for i in 0 ..< 4 {
				if moves[i].index == 0 {
					moves[i] = rollMove(fromPool: allMoves, useFilters: false)
				}
			}
			
			moves.sort { (m1, m2) in
				m1.index != 0
			}
		}
		
		func isMovesetValid() -> Bool {
			return moves.contains(where: {
				let moveType = $0.type
				return (moveType == stats.type1) || (moveType == stats.type2)
			}) && moves.contains(where: {
				$0.data.basePower > 0
			})
		}
		
		var rollNumber = 0
		while rollNumber < 100 {
			rollMoveset()
			if isMovesetValid() {
				return moves
			}
			rollNumber += 1
		}
		
		return moves
	}
	
	static func random() -> XGPokemon {
		var rand = 0
		while (rand == 0) || (XGPokemon.index(rand).catchRate == 0) {
			rand = Int.random(in: 1 ..< kNumberOfPokemon)
		}
		return XGPokemon.index(rand)
	}
	
	static func allPokemon() -> [XGPokemon] {
		var mons = [XGPokemon]()
		for i in 0 ..< kNumberOfPokemon {
			mons.append(.index(i))
		}
		return mons
	}
}

func allPokemon() -> [String : XGPokemon] {
	
	var dic = [String : XGPokemon]()
	
	for i in 0 ..< kNumberOfPokemon {
		
		let a = XGPokemon.index(i)
		
		dic[a.name.string.lowercased()] = a
		
	}
	
	return dic
}

let pokemons = allPokemon()

func pokemon(_ name: String) -> XGPokemon {
	if XGSettings.current.verbose && (pokemons[name.lowercased()] == nil) { printg("couldn't find: " + name) }
	return pokemons[name.lowercased()] ?? .index(0)
}

func allPokemonArray() -> [XGPokemon] {
	var pokes: [XGPokemon] = []
	for i in 0 ..< kNumberOfPokemon {
		pokes.append(XGPokemon.index(i))
	}
	return pokes
}

extension XGPokemon: Codable {
	enum CodingKeys: String, CodingKey {
		case index, name
	}
	
	init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		let index = try container.decode(Int.self, forKey: .index)
		self = .index(index)
	}
	
	func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(self.index, forKey: .index)
		try container.encode(self.name.string, forKey: .name)
	}
}

extension XGPokemon: XGEnumerable {
	var enumerableName: String {
		return name.string.spaceToLength(20)
	}
	
	var enumerableValue: String? {
		return index.string
	}
	
	static var className: String {
		return "Pokemon"
	}
	
	static var allValues: [XGPokemon] {
		return XGPokemon.allPokemon()
	}
}








