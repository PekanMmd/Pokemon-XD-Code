//
//  SmallStructTables.swift
//  GoD Tool
//
//  Created by Stars Momodu on 03/05/2021.
//

import Foundation

let iconsStruct = GoDStruct(name: "Pokemon Icons", format: [
	.word(name: "Male Face ID", description: "", type: .uintHex),
	.word(name: "Male Body ID", description: "", type: .uintHex),
	.word(name: "Female Face ID", description: "", type: .uintHex),
	.word(name: "female Body ID", description: "", type: .uintHex)
])

let iconsTable = CommonStructTable(file: .indexAndFsysName(region == .JP ? 6 : 0, "common"), properties: iconsStruct, documentByIndex: false)

let pokecouponShopStruct = GoDStruct(name: "Pokecoupon Rewards", format: [
	.short(name: "Coupon Price (in thousands)", description: "Multiply this by 1000 to get the price", type: .int),
	.short(name: "Pokemon or Item ID", description: "Meaning depends on the 'Is Pokemon' flag", type: .uintHex),
	.short(name: "Name ID", description: "", type: .msgID(file: nil)),
	.short(name: "Description ID", description: "", type: .msgID(file: nil)),
	.short(name: "Unknown ID", description: "", type: .uintHex),
	.bitArray(name: "Flags", description: "", bitFieldNames: ["Is Pokemon"])
])

let pokecouponShopTable = CommonStructTable(file: .indexAndFsysName(region == .JP ? 8 : 2, "common"), properties: pokecouponShopStruct)

let experienceStruct = GoDStruct(name: "Experience Table", format: [
	.word(name: "Experience For Level 0", description: "", type: .uint),
	.array(name: "Experience For Level", description: "", property:
		.word(name: "", description: "", type: .uint), count: 100),
])

let experienceTable = CommonStructTable(file: .indexAndFsysName(region == .JP ? 11 : 5, "common"), properties: experienceStruct) { (index, data) -> String? in
	return XGExpRate(rawValue: index)?.string ?? "Experience Rate \(index)"
}
