//
//  main.swift
//  XGCommandLineTools
//
//  Created by StarsMmd on 13/11/2015.
//  Copyright © 2015 StarsMmd. All rights reserved.
//
//

import Foundation

ToolProcess.loadISO(exitOnFailure: true)

//// Gecko code US XD hold R for continuous exp gain
//let controller1Offset: UInt32 = 0x80444b20
//let loadControllerOffset = XGASM.loadImmediateShifted32bit(register: .r4, value: controller1Offset)
//
//let jump1 = 0x212fa0
//let jump2 = 0x212ffc
//
//let freespace = XGAssembly.ASMfreeSpaceRAMPointer()!
//
//let jump1asm: ASM = [
//	.b(freespace)
//]
//
//let asm1: ASM = [
//	loadControllerOffset.0,
//	loadControllerOffset.1,
//	.lhz(.r4, .r4, 0),
//	.andi_(.r4, .r4, ControllerButtons.R.rawValue.unsigned),
//	.cmpwi(.r4, 0),
//	.beq_f(0, 12),
//	.cmpwi(.r18, -1),
//	.b_f(0, 8),
//	.cmpwi(.r18, 0),
//	.b(jump1 + 4)
//]
//
//let freespace2 = freespace + (asm1.count * 4)
//
//let jump2asm: ASM = [
//	.b(freespace2)
//]
//
//let asm2: ASM = [
//	loadControllerOffset.0,
//	loadControllerOffset.1,
//	.lhz(.r4, .r4, 0),
//	.andi_(.r4, .r4, ControllerButtons.R.rawValue.unsigned),
//	.cmpwi(.r4, 0),
//	.beq_f(0, 12),
//	.mr(.r24, .r3),
//	.b_f(0, 8),
//	.add(.r24, .r16, .r18),
//	.b(jump2 + 4)
//]
//
//print(XGAssembly.geckoCode(RAMOffset: jump1, asm: jump1asm))
//print(XGAssembly.geckoCode(RAMOffset: jump2, asm: jump2asm))
//print(XGAssembly.geckoCode(RAMOffset: freespace, asm: asm1))
//print(XGAssembly.geckoCode(RAMOffset: freespace2, asm: asm2))



//var roomsWithWarps = [Int]()
//var elevatorCount = 0
//for interactionPoint in XGInteractionPointData.allValues {
////			guard interactionPoint.room?.map != .PokemonHQ,
////				  guard interactionPoint.room?.name != "worldmap" else {
////				continue
////			}
//
//			let info = interactionPoint.info
//
//			switch info {
//			case .Warp:
//				roomsWithWarps.addUnique(interactionPoint.roomID)
//			case .Elevator:
//				elevatorCount += 1
//			case .CutsceneWarp:
//				roomsWithWarps.addUnique(interactionPoint.roomID)
//			default:
//				break
//			}
//}

