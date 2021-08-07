//
//  CMBattle.swift
//  Colosseum Tool
//
//  Created by The Steez on 23/08/2018.
//

import Foundation

final class XGBattle: CustomStringConvertible {

	let index: Int
	private let data: GoDStructData

	var battleStyle: XGBattleStyles {
		get {
			return XGBattleStyles(rawValue: data.get("Battle Style") ?? 0) ?? .none
		}
		set {
			data.update("Battle Style", with: newValue.valueFor6v6)
		}
	}

	var battleType: XGBattleTypes {
		get {
			return XGBattleTypes(rawValue: data.get("Battle Type") ?? 0) ?? .none
		}
		set {
			data.update("Battle Type", with: newValue.rawValue)
		}
	}

	var battleField: XGBattleField {
		get {
			return XGBattleField(index: data.get("Battle Field ID") ?? 0)
		}
		set {
			data.update("Battle Field ID", with: newValue.index)
		}
	}

	var BGMusicID: Int {
		get {
			return data.get("BGM ID") ?? 0
		}
		set {
			data.update("BGM ID", with: newValue)
		}
	}

	var players: [(id: Int, controller: XGTrainerController)] {
		get {
			guard let playersStructs: [GoDStructData] = data.get("Players") else { return [] }
			return playersStructs.map { (playerData) -> (Int, XGTrainerController) in
				let id: Int = playerData.get("Trainer ID") ?? 0
				let controller: XGTrainerController = XGTrainerController(rawValue: playerData.get("Controller Index") ?? 0) ?? .AI
				return (id, controller)
			}
		}
		set {
			guard let playersStructs: [GoDStructData] = data.get("Players") else { return }
			for i in 0 ..< min(playersStructs.count, newValue.count) {
				let newData = newValue[i]
				playersStructs[i].update("Trainer ID", with: newData.id)
				playersStructs[i].update("Controller Index", with: newData.controller)
			}

			data.update("Players", with: playersStructs)
		}
	}

	var p1Trainer : XGTrainer? {
		let id = players[0].id
		if id == 0 {
			return nil
		}
		return XGTrainer(index: id)
	}

	var p2Trainer : XGTrainer? {
		let id = players[1].id
		if id == 0 {
			return nil
		}
		return XGTrainer(index: id)
	}

	var p3Trainer : XGTrainer? {
		let id = players[2].id
		if id == 0 {
			return nil
		}
		return XGTrainer(index: id)
	}

	var p4Trainer : XGTrainer? {
		let id = players[3].id
		if id == 0 {
			return nil
		}
		return XGTrainer(index: id)
	}

	var title : String {
		let p1t = p1Trainer
		let p1 = p1t == nil ? "Invalid" : (players[0].id == 1 ? "Player" : p1t!.name.string)

		let p2t = p2Trainer
		let p2 = p2t == nil ? "Invalid" : (players[1].id == 1 ? "Player" : p2t!.name.string)

		let p3t = p3Trainer
		let p3 = p3t == nil ? "Invalid" : (players[2].id == 1 ? "Player" : p3t!.name.string)

		let p4t = p4Trainer
		let p4 = p4t == nil ? "Invalid" : (players[3].id == 1 ? "Player" : p4t!.name.string)

		var str = p1 + ( p3t == nil && p4t == nil ? " vs. " : " & ")
		str += p2 + ( p3t == nil && p4t == nil ? "" : " vs. ")
		if p3t != nil || p4t != nil { str += p3 + " & " + p4 }

		return str
	}

	var description: String {
		let p1t = p1Trainer
		let p2t = p2Trainer
		let p3t = p3Trainer
		let p4t = p4Trainer

		var desc = title + "\n"
		desc += "\(battleStyle.name) battle - (\(battleType.name))\n\n"

		if p1t != nil, players[0].id != 1 {
			desc += p1t!.fullDescription + "\n"
		}

		if p2t != nil, players[1].id != 1 {
			desc += p2t!.fullDescription + "\n"
		}

		if p3t != nil, players[2].id != 1 {
			desc += p3t!.fullDescription + "\n"
		}

		if p4t != nil, players[3].id != 1 {
			desc += p4t!.fullDescription + "\n"
		}

		return desc
	}

	init?(index: Int) {
		guard let data = battlesTable.dataForEntry(index) else {
			return nil
		}
		self.data = data
		self.index = index
	}

	func save() {
		data.save()
	}

	class func battleForTrainer(index: Int) -> XGBattle? {
		return XGBattle.allValues.first(where: { battle in
			battle.players.contains(where: { (id, _) -> Bool in
				return id == index
			})
		})
	}
}

extension XGBattle: XGEnumerable {
	var enumerableName: String {
		return "Battle \(index)"
	}

	var enumerableValue: String? {
		return nil
	}

	static var className: String {
		return "Battles"
	}

	static var allValues: [XGBattle] {
		var battles = [XGBattle]()
		(0 ..< CommonIndexes.NumberOfBattles.value).forEach { (index) in
			if let battle = XGBattle(index: index) {
				battles.append(battle)
			}
		}
		return battles
	}
}
