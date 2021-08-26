//
//  TypeMatchupsTable.swift
//  GoD Tool
//
//  Created by Stars Momodu on 24/08/2021.
//

import Foundation

let typeMatchupsStructTable = TypeMatchupsTable()

class TypeMatchupsTable: CommonStructTable {
	init() {
		let format = (0 ..< kNumberOfTypes).map({ (i) -> GoDStructProperties in
			return .byte(name: "Effect against " + XGMoveTypes.index(i).name, description: "", type: .typeEffectiveness)
		})
		super.init(file: .indexAndFsysName(region == .JP ? 10 : 4, "common"), properties: GoDStruct(name: "Type Matchups", format: format), documentByIndex: false) { (index, _) -> String? in
			if index < kNumberOfTypes {
				return XGMoveTypes.index(index).name
			}
			return "UnusedMatchup_\(index - kNumberOfTypes + 1)"
		}
	}
}
