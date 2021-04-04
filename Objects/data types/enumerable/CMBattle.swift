//
//  CMBattle.swift
//  Colosseum Tool
//
//  Created by The Steez on 23/08/2018.
//

import Foundation

final class XGBattle {

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
