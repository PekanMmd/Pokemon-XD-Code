//
//  XGWarp.swift
//  GoD Tool
//
//  Created by The Steez on 29/10/2017.
//
//

import Cocoa

let kSizeOfInteractionPoint = 0x1C

// some of the offsets overlap because the values at that offset play different roles depending on the type of interaction point
let kIPInteractionMethodOffset = 0x0
let kIPRoomIDOffset = 0x2
let kIPRegionIndexOffset = 0x7
let kIPScriptValueOffset = 0x8
let kIPScriptIndexOffset = 0xa
let kIPScriptParameter1Offset = 0xc
let kIPScriptParameter2Offset = 0x10
let kIPScriptParameter3Offset = 0x14
let kIPTypeOffset = 0xa
let kIPWarpTargetRoomIDOffset = 0xe
let kIPWarpTargetEntryPointIDOffset = 0x13
let kIPWarpSoundEffectOffset = 0x17
let kIPStringIDOffset = 0xe
let kIPDoorIDOffset = 0xe
let kIPElevatorIDOffset = 0xe
let kIPElevatorTargetRoomIDOffset = 0x12
let kIPTargetElevatorIDOffset = 0x16
let kIPElevatorDirectionOffset = 0x1B
let kIPCutsceneIDOffset = 0x16
let kIPCameraIDOffset = 0x18
let kIPPCRoomIDOffset = 0xe
let kIPPCUnknownOffset = 0x13

let kIPWarpValue = 0x4
let kIPDoorValue = 0x5
let kIPElevatorValue = 0x6
let kIPTextValue = game == .XD ? 0xC : 0xB
let kIPCutsceneValue = game == .XD ? 0xD : 0xC
let kIPPCValue = 0xE
let kIPTVValue = 0x13



enum XGInteractionMethods : Int {
	case None = 0
	case WalkThrough = 1
	case WalkInFront = 2
	case PressAButton = 3
	case PressAButton2 = 4 // colosseum only
}
enum XGElevatorDirections : Int {
	case up = 0
	case down = 1
	
	var string : String {
		return self.rawValue == 0 ? "Up" : "Down"
	}
}

enum XGInteractionPointInfo {
	case None
	case Warp(targetRoom: Int, targetEntryID: Int, sound: Bool)
	case Door(id: Int)
	case Text(stringID: Int)
	case Script(scriptIndex: Int, parameter1: Int, parameter2: Int, parameter3: Int) // in colosseum scripts can be called with parameters, maybe xd too?
	case Elevator(elevatorID: Int, targetRoomID: Int, targetElevatorID: Int, direction: XGElevatorDirections)
	case CutsceneWarp(targetRoom: Int, targetEntryID: Int, cutsceneID: Int, cameraFSYSID: Int)
	case PC(roomID: Int, unknown: Int) // parameters are unused
	case TV // colosseum only
	
}


fileprivate var IPData = [XGInteractionPointData]()
fileprivate func getIPData() {
	if IPData.isEmpty {
		for i in 0 ..< CommonIndexes.NumberOfInteractionPoints.value {
			IPData.append(XGInteractionPointData(index: i))
		}
	}
}
var allInteractionPointData : [XGInteractionPointData] {
	getIPData()
	return IPData
}

class XGInteractionPointData: NSObject {
	
	// Each entry is actually a script function call
	// if the script value is 0x596 then the script function is from common.scd
	// if the script value is 0x100 then the script function is from the map's scd
	// the IP type is actually the index of the script function to call
	// e.g. @floor_link (warp 0x4) or @elevator (0x6)
	// the rest of the parameters are the arguments to the function
	
	var index = 0
	var startOffset = 0
	
	var interactionMethod = XGInteractionMethods.None
	var roomID = 0
	var interactionPointIndex = 0
	var info = XGInteractionPointInfo.None
	
	override var description: String {
		var desc = "Interaction Point: \(index) - offset: \(startOffset.hexString())"
		
		var roomName = "-"
		if let room = XGRoom.roomWithID(roomID) {
			roomName = room.name
		}
		desc += " Room: \(roomName) (\(roomID.hexString()))\n"
		
		switch interactionMethod {
		case .WalkInFront:
			desc += "Walk in front of Interaction Region: \(interactionPointIndex)\n"
		case .WalkThrough:
			desc += "Walk through Interaction Region: \(interactionPointIndex)\n"
		case .PressAButton:
			desc += "Press A on Interaction Region: \(interactionPointIndex)\n"
		case .PressAButton2:
			desc += "Press A (2) on Interaction Region: \(interactionPointIndex)\n"
		default:
			break
		}
		
		switch info {
			
		case .None:
			break
		case .Warp(let targetRoom, let targetEntryID, let sound):
			var roomName = "-"
			if let room = XGRoom.roomWithID(targetRoom) {
				roomName = room.name
			}
			desc += "Warp to \(roomName) at Entry point: \(targetEntryID) \(sound ? "with" : "without") sound effect\n"
		case .Door(let id):
			desc += "Open door with id: \(id)\n"
		case .Text(let stringID):
			desc += "Display text: \"\(getStringSafelyWithID(id: stringID))\"\n"
		case .Script(let scriptIndex, let parameter1, let parameter2, let parameter3):
			desc += "Call script with id: \(scriptIndex)"
			if game == .XD {
				if let room = XGRoom.roomWithID(roomID) {
					if let script = room.script {
						if scriptIndex < script.ftbl.count {
							desc += " @\(script.ftbl[scriptIndex].name)"
						}
					}
				}
			} else {
				desc += " with parameter 1: \(parameter1)\n"
				desc += " with parameter 2: \(parameter2)\n"
				desc += " with parameter 3: \(parameter3)\n"
			}
			desc += "\n"
		case .Elevator(let elevatorID, let targetRoomID, let targetElevatorID, let direction):
			desc += "Use Elevator with id \(elevatorID) to go \(direction == .up ? "up" : "down")\n"
			var roomName = "-"
			if let room = XGRoom.roomWithID(targetRoomID) {
				roomName = room.name
			}
			desc += "to room \(roomName) elevator with id: \(targetElevatorID)\n"
		case .PC(let roomID, let unknown):
			desc += "Use PC roomID: \(roomID.hexString()) unknown: \(unknown)\n"
		case .CutsceneWarp(let targetRoom, let targetEntryID, let cutsceneID, let cameraFSYSID):
			var roomName = "-"
			if let room = XGRoom.roomWithID(targetRoom) {
				roomName = room.name
			}
			desc += "Cutscene warp \(cutsceneID.hexString()) to \(roomName) at Entry point: \(targetEntryID) with camera file \(cameraFSYSID.hexString())\n"
		case .TV:
			desc += "Watch TV\n"
		}
		
		return desc
	}
	
	@objc init(index: Int) {
		super.init()
		
		self.index = index
		self.startOffset = CommonIndexes.InteractionPoints.startOffset + (index * kSizeOfInteractionPoint)
		
		let rel = XGFiles.common_rel.data!
		
		self.roomID = rel.get2BytesAtOffset(startOffset + kIPRoomIDOffset)
		self.interactionPointIndex = rel.getByteAtOffset(startOffset + kIPRegionIndexOffset)
		
		let methodID = rel.getByteAtOffset(startOffset + kIPInteractionMethodOffset)
		if let method = XGInteractionMethods(rawValue: methodID) {
			self.interactionMethod = method
		} else {
			printg("Unknown interaction method: \(methodID) for point with index: \(index)")
		}
		
		let unknownValue = rel.get2BytesAtOffset(startOffset + kIPScriptValueOffset)
		
		if unknownValue == 0x100 {
			
			let scriptID = rel.get2BytesAtOffset(startOffset + kIPScriptIndexOffset)
			let parameter1 = rel.get4BytesAtOffset(startOffset + kIPScriptParameter1Offset)
			let parameter2 = rel.get4BytesAtOffset(startOffset + kIPScriptParameter2Offset)
			let parameter3 = rel.get4BytesAtOffset(startOffset + kIPScriptParameter3Offset)
			self.info = .Script(scriptIndex: scriptID, parameter1: parameter1, parameter2: parameter2, parameter3: parameter3)
			
		} else if unknownValue != 0x596 {
			printg("Unknown variable value: \(unknownValue) for point with index: \(index)")
		} else {
			
			let interactionType = rel.get2BytesAtOffset(startOffset + kIPTypeOffset)
			
			switch interactionType {
				
			case kIPWarpValue:
				let targetRoom = rel.get2BytesAtOffset(startOffset + kIPWarpTargetRoomIDOffset)
				let entryID = rel.getByteAtOffset(startOffset + kIPWarpTargetEntryPointIDOffset)
				let sound = rel.getByteAtOffset(startOffset + kIPWarpSoundEffectOffset) == 1
				self.info = .Warp(targetRoom: targetRoom, targetEntryID: entryID, sound: sound)
			case kIPDoorValue:
				self.info = .Door(id: rel.get2BytesAtOffset(startOffset + kIPDoorIDOffset))
			case kIPElevatorValue:
				let elevID = rel.get2BytesAtOffset(startOffset + kIPElevatorIDOffset)
				let targetRoom = rel.get2BytesAtOffset(startOffset + kIPElevatorTargetRoomIDOffset)
				let targetElevID = rel.get2BytesAtOffset(startOffset + kIPTargetElevatorIDOffset)
				let direction = XGElevatorDirections(rawValue: rel.getByteAtOffset(startOffset + kIPElevatorDirectionOffset)) ?? .up
				self.info = .Elevator(elevatorID: elevID, targetRoomID: targetRoom, targetElevatorID: targetElevID, direction: direction)
			case kIPTextValue:
				self.info = .Text(stringID: rel.get2BytesAtOffset(startOffset + kIPStringIDOffset))
			case kIPCutsceneValue:
				let targetRoom = rel.get2BytesAtOffset(startOffset + kIPWarpTargetRoomIDOffset)
				let entryID = rel.getByteAtOffset(startOffset + kIPWarpTargetEntryPointIDOffset)
				let cutsceneID = rel.get2BytesAtOffset(startOffset + kIPCutsceneIDOffset)
				let camera = rel.get2BytesAtOffset(startOffset + kIPCameraIDOffset)
				self.info = .CutsceneWarp(targetRoom: targetRoom, targetEntryID: entryID, cutsceneID: cutsceneID, cameraFSYSID: camera)
			case kIPPCValue:
				let roomID = rel.get2BytesAtOffset(startOffset + kIPPCRoomIDOffset)
				let unknown = rel.getByteAtOffset(startOffset + kIPPCUnknownOffset)
				self.info = .PC(roomID: roomID, unknown: unknown)
			case kIPTVValue:
				self.info = .TV
			case 0:
				self.info = .None
				
			default:
				printg("Unknown interaction type: \(interactionType) for point with index: \(index)")
			}
			
		}
		
	}
	
	func save() {
		let rel = XGFiles.common_rel.data!
		
		// first clear all data as different IP types use different offsets
		rel.replaceBytesFromOffset(startOffset, withByteStream: [Int](repeating: 0, count: kSizeOfInteractionPoint))
		
		rel.replaceByteAtOffset(startOffset + kIPInteractionMethodOffset, withByte: self.interactionMethod.rawValue)
		rel.replace2BytesAtOffset(startOffset + kIPRoomIDOffset, withBytes: self.roomID)
		rel.replaceByteAtOffset(startOffset + kIPRegionIndexOffset, withByte: self.interactionPointIndex)
		
		switch self.info {
		case .Script: rel.replace2BytesAtOffset(startOffset + kIPScriptValueOffset, withBytes: 0x100)
		default: rel.replace2BytesAtOffset(startOffset + kIPScriptValueOffset, withBytes: 0x596)
		}
		
		switch self.info {
		case .None:
			break
			
		case .Warp(let targetRoom, let targetEntryID, let sound):
			rel.replace2BytesAtOffset(startOffset + kIPTypeOffset, withBytes: kIPWarpValue)
			rel.replace2BytesAtOffset(startOffset + kIPWarpTargetRoomIDOffset, withBytes: targetRoom)
			rel.replaceByteAtOffset(startOffset + kIPWarpTargetEntryPointIDOffset, withByte: targetEntryID)
			rel.replaceByteAtOffset(startOffset + kIPWarpSoundEffectOffset, withByte: sound ? 1 : 0)
			
		case .Door(let id):
			rel.replace2BytesAtOffset(startOffset + kIPTypeOffset, withBytes: kIPDoorValue)
			rel.replace2BytesAtOffset(startOffset + kIPDoorIDOffset, withBytes: id)
			
		case .Elevator(let elevatorID, let targetRoomID, let targetElevatorID, let direction):
			rel.replace2BytesAtOffset(startOffset + kIPTypeOffset, withBytes: kIPElevatorValue)
			rel.replace2BytesAtOffset(startOffset + kIPElevatorIDOffset, withBytes: elevatorID)
			rel.replace2BytesAtOffset(startOffset + kIPElevatorTargetRoomIDOffset, withBytes: targetRoomID)
			rel.replace2BytesAtOffset(startOffset + kIPTargetElevatorIDOffset, withBytes: targetElevatorID)
			rel.replaceByteAtOffset(startOffset + kIPElevatorDirectionOffset, withByte: direction.rawValue)
			
		case .Text(let stringID):
			rel.replace2BytesAtOffset(startOffset + kIPTypeOffset, withBytes: kIPTextValue)
			rel.replace2BytesAtOffset(startOffset + kIPStringIDOffset, withBytes: stringID)
			
		case .Script(let scriptIndex, let parameter1, let parameter2, let parameter3):
			rel.replace2BytesAtOffset(startOffset + kIPScriptIndexOffset, withBytes: scriptIndex)
			rel.replace4BytesAtOffset(startOffset + kIPScriptParameter1Offset, withBytes: parameter1)
			rel.replace4BytesAtOffset(startOffset + kIPScriptParameter2Offset, withBytes: parameter2)
			rel.replace4BytesAtOffset(startOffset + kIPScriptParameter2Offset, withBytes: parameter3)
		
		case .CutsceneWarp(let targetRoom, let targetEntryID, let cutsceneID, let cameraFSYSID):
			rel.replace2BytesAtOffset(startOffset + kIPTypeOffset, withBytes: kIPCutsceneValue)
			rel.replace2BytesAtOffset(startOffset + kIPWarpTargetRoomIDOffset, withBytes: targetRoom)
			rel.replaceByteAtOffset(startOffset + kIPWarpTargetEntryPointIDOffset, withByte: targetEntryID)
			rel.replace2BytesAtOffset(startOffset + kIPCutsceneIDOffset, withBytes: cutsceneID)
			rel.replace2BytesAtOffset(startOffset + kIPCameraIDOffset, withBytes: cameraFSYSID)
			rel.replaceByteAtOffset(startOffset + kIPCameraIDOffset + 1, withByte: 0x18) // .cam filetype
			
		case .PC(let roomID, let unknown):
			rel.replace2BytesAtOffset(startOffset + kIPTypeOffset, withBytes: kIPPCValue)
			rel.replace2BytesAtOffset(startOffset + kIPPCRoomIDOffset, withBytes: roomID)
			rel.replaceByteAtOffset(startOffset + kIPPCUnknownOffset, withByte: unknown)
		case .TV:
			rel.replace2BytesAtOffset(startOffset + kIPTypeOffset, withBytes: kIPTVValue)
		}
		
		rel.save()
	}

}

let kSizeOfMapEntryLocation = 0x10
let kIPAngleOffset = 0x0
let kILXOffset = 0x4
let kILYOffset = 0x8
let kILZOffset = 0xC

class XGMapEntryLocation : NSObject {
	
	@objc var index = 0
	@objc var startOffset = 0
	
	@objc var xCoordinate : Float = 0
	@objc var yCoordinate : Float = 0
	@objc var zCoordinate : Float = 0
	@objc var angle = 0
	
	@objc var room : XGRoom {
		return XGRoom.roomWithName(self.file.fileName.removeFileExtensions())!
	}
	
	var file : XGFiles!
	
	init(file: XGFiles, index: Int, startOffset: Int) {
		super.init()
		
		self.index = index
		self.startOffset = startOffset
		self.file = file
		
		let data = file.data!
		
		self.xCoordinate = data.getWordAtOffset(startOffset + kILXOffset).hexToSignedFloat()
		self.yCoordinate = data.getWordAtOffset(startOffset + kILYOffset).hexToSignedFloat()
		self.zCoordinate = data.getWordAtOffset(startOffset + kILZOffset).hexToSignedFloat()
		self.angle = data.get2BytesAtOffset(startOffset + kIPAngleOffset)
		
	}
	
	@objc func save() {
		let data = file.data!
		
		data.replace2BytesAtOffset(startOffset + kIPAngleOffset, withBytes: self.angle)
		data.replaceWordAtOffset(startOffset + kILXOffset, withBytes: self.xCoordinate.bitPattern)
		data.replaceWordAtOffset(startOffset + kILYOffset, withBytes: self.yCoordinate.bitPattern)
		data.replaceWordAtOffset(startOffset + kILZOffset, withBytes: self.zCoordinate.bitPattern)
		
		data.save()
	}
	
}
