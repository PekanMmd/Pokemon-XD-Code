//
//  MoveStatsTable.swift
//  GoD Tool
//
//  Created by Stars Momodu on 20/03/2021.
//

import Foundation

let movesTable = CommonStructTable(index: region == .JP ? 31 : 30, properties: GoDStruct(name: "Moves", format: [
	.short(name: "Effect", description: "", type: .moveEffectID),
	.short(name: "Targets", description: "", type: .moveTarget),
	.short(name: "Unknown", description: "Unused?", type: .uint),
	.byte(name: "Contest Appeal", description: "The contest appeal type for the move", type: .contestAppeal),
	.short(name: "Name ID", description: "", type: .msgID(file: nil)),
	.short(name: "Description ID", description: "", type: .msgID(file: nil)),
	.short(name: "Description ID 2", description: "", type: .msgID(file: nil)),
	.byte(name: "Category", description: "Physical, Special or Status", type: .moveCategory),
	.byte(name: "Base Power", description: "", type: .uint),
	.byte(name: "Type", description: "", type: .typeID),
	.byte(name: "Base Accuracy", description: "", type: .percentage),
	.byte(name: "Base PP", description: "How much PP the move has by default", type: .uint),
	.byte(name: "Effect Accuracy", description: "The probability of the secondary effect activating", type: .percentage),
	.byte(name: "Priority", description: "", type: .int),
	.bitArray(name: "Flags", description: "", bitFieldNames: [
		"Unknown Flag 8",
		"Unknown Flag 7",
		"Can Add King's Rock Effect",
		"Copyable By Mirror Move",
		"Stolen By Snatch",
		"Reflected By Magic Coat",
		"Blocked By Protect",
		"Makes Contact"
	]),
	.byte(name: "Move effect type", description: "A broad category for the move's effect such as damaging or stat boost. Possibly used by the AI to strategise.", type: .moveEffectType),
	.byte(name: "Unknown 2", description: "", type: .uint),
]), documentByIndex: false)
