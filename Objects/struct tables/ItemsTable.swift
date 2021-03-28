//
//  ItemsTable.swift
//  GoD Tool
//
//  Created by Stars Momodu on 24/03/2021.
//

import Foundation

let itemsStruct = GoDStruct(name: "Item", format: [
	.byte(name: "Pocket", description: "Which pocket in the bag the item goes in", type: .itemPocket),
	.byte(name: "Is Locked", description: "Can't be held or tossed", type: .bool),
	.byte(name: "Padding", description: "", type: .null),
	.byte(name: "Unknown Flag", description: "", type: .bool),
	.byte(name: "Battle Item ID", description: "Referred to by the ASM to determine item effect when used in battle", type: .uintHex),
	.short(name: "Price", description: "", type: .uint),
	.short(name: "Coupon Price", description: "", type: .uint),
	.short(name: "Hold Item ID", description: "Referred to by the ASM to determine item effect when held in battle", type: .uint),
	.word(name: "Padding 2", description: "", type: .null),
	.word(name: "Name ID", description: "", type: .msgID(file: .common_rel)),
	.word(name: "Description ID", description: "", type: .msgID(file: .typeAndFsysName(.msg, "pocket_menu"))),
	.word(name: "Parameter", description: "Determines effectiveness of item", type: .uint),
	.word(name: "Function Pointer", description: "Offset of ASM function the item triggers. This is set at run time but if you set it in the game file for an item that doesn't normally get set then it will keep that value.", type: .uintHex),
	.word(name: "Function Pointer 2", description: "Offset of ASM function the item triggers. This is set at run time but if you set it in the game file for an item that doesn't normally get set then it will keep that value.", type: .uintHex),
	.array(name: "Happiness effects", description: "Determines how much a pokemon's happiness changes when consuming this item. The amount varies based on the current happiness in 2 tiers.", property: .byte(name: "Happiness Effect", description: "", type: .int), count: 3)
])

let validItemStruct = GoDStruct(name: "Valid Item", format: [
	.short(name: "Item ID", description: "", type: .itemID)
])

#if GAME_XD
let itemsTable = CommonStructTable(index: .Items, properties: itemsStruct)
let validItemsTable = CommonStructTable(index: .ValidItems, properties: validItemStruct)
#else
let itemsTable = GoDStructTable(file: .dol, properties: itemsStruct) { (file) -> Int in
	kFirstItemOffset
} numberOfEntriesInFile: { (file) -> Int in
	kNumberOfItems
}

let validItemsTable = GoDStructTable(file: .dol, properties: validItemStruct) { (file) -> Int in
	return kFirstValidItemOffset
} numberOfEntriesInFile: { (file) -> Int in
	return 1220
}
#endif
