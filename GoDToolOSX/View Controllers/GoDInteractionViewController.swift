//
//  GoDInteractionViewController.swift
//  GoD Tool
//
//  Created by The Steez on 09/03/2019.
//

import Cocoa

class GoDInteractionViewController: GoDTableViewController {

	@IBOutlet var roomPopup: GoDRoomPopUpButton!
	@IBOutlet var regionField: NSTextField!
	
	@IBOutlet var triggerNone: NSButton!
	@IBOutlet var triggerAButton: NSButton!
	@IBOutlet var triggerWalkUp: NSButton!
	@IBOutlet var triggerWalkThrough: NSButton!

	@IBOutlet weak var scriptTypePopUp: GoDPopUpButton!
	@IBOutlet weak var scriptIndexPopUp: GoDPopUpButton!

	@IBOutlet weak var dataContainer: GoDContainerView!
	@IBOutlet weak var label1: NSTextField!
	@IBOutlet weak var label2: NSTextField!
	@IBOutlet weak var label3: NSTextField!
	@IBOutlet weak var label4: NSTextField!
	@IBOutlet weak var field1: NSTextField!
	@IBOutlet weak var field2: NSTextField!
	@IBOutlet weak var field3: NSTextField!
	@IBOutlet weak var field4: NSTextField!

	let commonFunctionNames = XGFiles.common_rel.scriptData.ftbl.map { $0.name }
	var currentScriptFunctionNames = [String]()

	var scriptFunctionNames: [String] {
		switch scriptTypePopUp.indexOfSelectedItem {
		case 1: return commonFunctionNames
		case 2: return currentScriptFunctionNames.isEmpty ? ["-"] : currentScriptFunctionNames
		default: return ["-"]
		}
	}

	let targetRoom = GoDRoomPopUpButton()
	let sound = NSButton(checkboxWithTitle: "Sound", target: nil, action: nil)
	let direction = GoDDirectionPopUpButton()
	
	let textView = NSTextView()
	
	var currentIndex = -1
	
	func setUpForData(_ data: XGInteractionPointData) {
		scriptTypePopUp.isEnabled = true
		self.currentIndex = data.index
		self.roomPopup.select(XGRoom.roomWithID(data.roomID) ?? XGRoom(index: 0))
		selectRoom(roomPopup)
		self.regionField.stringValue = data.interactionPointIndex.string
		switch data.interactionMethod {
		case .None:
			self.triggerNone.state = .on
		case .WalkThrough:
			self.triggerWalkThrough.state = .on
		case .WalkInFront:
			self.triggerWalkUp.state = .on
		case .PressAButton:
			self.triggerAButton.state = .on
		case .PressAButton2:
			self.triggerNone.state = .on
		}

		self.setUpForInfo(data.info, updatePopUp: true)
	}
	
	@IBAction func selectRoom(_ sender: GoDRoomPopUpButton?) {
		var isScriptValid = true
		if let scriptFile = roomPopup.selectedValue.script {
			currentScriptFunctionNames = scriptFile.scriptData.ftbl.map { (f) -> String in
				return (game == .XD ? "@" : "") + f.name
			}
		} else {
			currentScriptFunctionNames = ["-"]
			isScriptValid = false
		}

		if scriptTypePopUp.indexOfSelectedItem == 2 {
			scriptIndexPopUp.setTitles(values: scriptFunctionNames)
			scriptIndexPopUp.selectItem(at: 0)
			scriptIndexPopUp.isEnabled = isScriptValid
		}
	}

	@IBAction func didSelectScriptType(_ sender: GoDPopUpButton?) {
		scriptIndexPopUp.setTitles(values: scriptFunctionNames)
		scriptIndexPopUp.isEnabled = scriptTypePopUp.indexOfSelectedItem == 1 || (scriptTypePopUp.indexOfSelectedItem == 2 && currentScriptFunctionNames.count > 0)
		scriptIndexPopUp.selectItem(at: 0)
		if sender != nil {
			didSelectScriptIndex(scriptIndexPopUp)
		}
	}

	@IBAction func didSelectScriptIndex(_ sender: GoDPopUpButton) {
		var info = XGInteractionPointInfo.None
		let scriptIndex = sender.indexOfSelectedItem
		if scriptTypePopUp.indexOfSelectedItem == 2 {
			info = .CurrentScript(scriptIndex: scriptIndex, parameter1: 0, parameter2: 0, parameter3: 0, parameter4: 0)
		} else {
			if scriptTypePopUp.indexOfSelectedItem > 0 {
				switch scriptIndex {
				case kIPWarpValue: info = .Warp(targetRoom: 0xAF, targetEntryID: 0, sound: false)
				case kIPDoorValue: info = .Door(id: 0)
				case kIPElevatorValue: info = .Elevator(elevatorID: 0, targetRoomID: 0xAF, targetElevatorID: 0, direction: .up)
				case kIPTextValue: info = .Text(stringID: 0)
				case kIPCutsceneValue: info = .CutsceneWarp(targetRoom: 0xAF, targetEntryID: 0, cutsceneID: 0, cameraFSYSID: 0)
				case kIPPCValue: info = .PC(roomID: 0xAF, unknown: 0)
				default:
					if scriptTypePopUp.indexOfSelectedItem == 1 {
						info = .CommonScript(scriptIndex: scriptIndex, parameter1: 0, parameter2: 0, parameter3: 0, parameter4: 0)
					} else {
						info = .CurrentScript(scriptIndex: scriptIndex, parameter1: 0, parameter2: 0, parameter3: 0, parameter4: 0)
					}
				}
			}
		}
		self.setUpForInfo(info)
	}

	func setUpForInfo(_ info: XGInteractionPointInfo, updatePopUp: Bool = false) {
		hideVariableViews()
		
		switch info {
		case .None:
			if (updatePopUp) {
				scriptTypePopUp.selectItem(at: 0)
				scriptIndexPopUp.selectItem(at: 0)
			}
			
		case .Warp(let targetRoom, let targetEntryID, let sound):
			self.targetRoom.isHidden = false
			self.targetRoom.select(XGRoom.roomWithID(targetRoom) ?? XGRoom(index: 0xAF))
			self.field1.isHidden = false
			self.label1.isHidden = false
			field1.stringValue = targetEntryID.string
			label1.stringValue = "Entry point ID"
			self.sound.isHidden = false
			self.sound.state = sound ? .on : .off
			if updatePopUp {
				scriptTypePopUp.selectItem(at: 1)
				didSelectScriptType(nil)
				scriptIndexPopUp.selectItem(at: info.scriptIndex)
			}
			
		case .Door(let id):
			self.field1.isHidden = false
			self.label1.isHidden = false
			label1.stringValue = "Door ID"
			field1.stringValue = id.string
			self.field2.isHidden = false
			self.label2.isHidden = false
			label2.stringValue = "File Identifier"
			field2.stringValue = ""
			
			if id < CommonIndexes.NumberOfDoors.value {
				let door = XGDoor(index: id)
				field2.stringValue = door.fileIdentifier.hexString()
			}
			if updatePopUp {
				scriptTypePopUp.selectItem(at: 1)
				didSelectScriptType(nil)
				scriptIndexPopUp.selectItem(at: info.scriptIndex)
			}
			
		case .Text(let stringID):
			self.field1.isHidden = false
			self.label1.isHidden = false
			self.label1.stringValue = "String ID"
			self.field1.stringValue = stringID.string
			self.textView.isHidden = false
			self.textView.string = getStringSafelyWithID(id: stringID).string
			if updatePopUp {
				scriptTypePopUp.selectItem(at: 1)
				didSelectScriptType(nil)
				scriptIndexPopUp.selectItem(at: info.scriptIndex)
			}
			
		case .CurrentScript(_, let parameter1, let parameter2, let parameter3, let parameter4):
			self.field1.isHidden = false
			self.label1.isHidden = false
			self.label1.stringValue = "Parameter1"
			self.field1.stringValue = parameter1.string
			self.field2.isHidden = false
			self.label2.isHidden = false
			self.label2.stringValue = "Parameter2"
			self.field2.stringValue = parameter2.string
			self.field3.isHidden = false
			self.label3.isHidden = false
			self.label3.stringValue = "Parameter3"
			self.field3.stringValue = parameter3.string
			self.field4.isHidden = false
			self.label4.isHidden = false
			self.label4.stringValue = "Parameter4"
			self.field4.stringValue = parameter4.string
			if updatePopUp {
				scriptTypePopUp.selectItem(at: 2)
				didSelectScriptType(nil)
				scriptIndexPopUp.selectItem(at: info.scriptIndex)
			}

		case .CommonScript(_, let parameter1, let parameter2, let parameter3, let parameter4):
			self.label1.isHidden = false
			self.field1.isHidden = false
			self.label1.stringValue = "Parameter1"
			self.field1.stringValue = parameter1.string
			self.field2.isHidden = false
			self.label2.isHidden = false
			self.label2.stringValue = "Parameter2"
			self.field2.stringValue = parameter2.string
			self.field3.isHidden = false
			self.label3.isHidden = false
			self.label3.stringValue = "Parameter3"
			self.field3.stringValue = parameter3.string
			self.field4.isHidden = false
			self.label4.isHidden = false
			self.label4.stringValue = "Parameter4"
			self.field4.stringValue = parameter4.string
			if updatePopUp {
				scriptTypePopUp.selectItem(at: 1)
				didSelectScriptType(nil)
				scriptIndexPopUp.selectItem(at: info.scriptIndex)
			}
			
		case .Elevator(let elevatorID, let targetRoomID, let targetElevatorID, let direction):
			self.label1.isHidden = false
			self.field1.isHidden = false
			self.label2.isHidden = false
			self.field2.isHidden = false
			self.targetRoom.isHidden = false
			self.direction.isHidden = false
			self.label1.stringValue = "Elevator ID"
			self.label2.stringValue = "Target Elevator ID"
			self.field1.stringValue = elevatorID.string
			self.field2.stringValue = targetElevatorID.string
			self.targetRoom.select(XGRoom.roomWithID(targetRoomID) ?? XGRoom(index: 0xAF))
			self.direction.select(direction)
			if updatePopUp {
				scriptTypePopUp.selectItem(at: 1)
				didSelectScriptType(nil)
				scriptIndexPopUp.selectItem(at: info.scriptIndex)
			}
			
		case .CutsceneWarp(let targetRoom, let targetEntryID, let cutsceneID, let cameraFSYSID):
			self.label1.isHidden = false
			self.field1.isHidden = false
			self.label2.isHidden = false
			self.field2.isHidden = false
			self.label3.isHidden = false
			self.field3.isHidden = false
			self.targetRoom.isHidden = false
			self.targetRoom.select(XGRoom.roomWithID(targetRoom) ?? XGRoom(index: 0xAF))
			label1.stringValue = "Entry ID"
			label2.stringValue = "Cutscene ID"
			label3.stringValue = "Camera ID"
			field1.stringValue = targetEntryID.string
			field2.stringValue = cutsceneID.string
			field3.stringValue = cameraFSYSID.string
			if updatePopUp {
				scriptTypePopUp.selectItem(at: 1)
				didSelectScriptType(nil)
				scriptIndexPopUp.selectItem(at: info.scriptIndex)
			}
			
		case .PC(let roomID, let unknown):
			self.label1.isHidden = false
			self.field1.isHidden = false
			self.targetRoom.isHidden = false
			self.targetRoom.select(XGRoom.roomWithID(roomID) ?? XGRoom(index: 0xAF))
			self.label1.stringValue = "Unknown"
			self.field1.stringValue = unknown.string
			if updatePopUp {
				scriptTypePopUp.selectItem(at: 1)
				didSelectScriptType(nil)
				scriptIndexPopUp.selectItem(at: info.scriptIndex)
			}
		}
	}
	
	@IBAction func setTrigger(_ sender: NSButton) {
		// just so the radio buttons have the same action and will be treated
		// as being in the same set
		return
	}
	
	func hideVariableViews() {
		let variableControls : [NSView] = [targetRoom,sound,direction,label1,field1,label2,field2,label3,field3,label4,field4,textView]
		for view in variableControls {
			view.isHidden = true
		}
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		scriptTypePopUp.setTitles(values: [
			"-",
			"Common",
			"Current Room"
		])
		scriptTypePopUp.isEnabled = false
		scriptIndexPopUp.isEnabled = false
		
		let variableControls: [NSView] = [targetRoom,sound,direction,textView]
		for view in variableControls {
			self.dataContainer.addSubview(view)
			view.translatesAutoresizingMaskIntoConstraints = false
			
			if view != textView {
				field1.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
			}
		}

		sound.centerYAnchor.constraint(equalTo: field2.centerYAnchor).isActive = true
		sound.leadingAnchor.constraint(equalTo: field2.leadingAnchor).isActive = true
		sound.trailingAnchor.constraint(equalTo: field2.trailingAnchor).isActive = true
		direction.centerYAnchor.constraint(equalTo: field3.centerYAnchor).isActive = true
		direction.leadingAnchor.constraint(equalTo: field3.leadingAnchor).isActive = true
		direction.trailingAnchor.constraint(equalTo: field3.trailingAnchor).isActive = true
		targetRoom.centerYAnchor.constraint(equalTo: field4.centerYAnchor).isActive = true
		targetRoom.leadingAnchor.constraint(equalTo: field4.leadingAnchor).isActive = true
		targetRoom.trailingAnchor.constraint(equalTo: field4.trailingAnchor).isActive = true
		textView.leadingAnchor.constraint(equalTo: field3.leadingAnchor).isActive = true
		textView.trailingAnchor.constraint(equalTo: field4.trailingAnchor).isActive = true
		textView.topAnchor.constraint(equalTo: label4.topAnchor).isActive = true
		textView.bottomAnchor.constraint(equalTo: field4.bottomAnchor).isActive = true
		
		hideVariableViews()
		
		if game == .Colosseum {
			triggerNone.title = "Press A Button (2)"
		}
	}
	
	
	@IBAction func save(_ sender: Any) {
		guard self.currentIndex >= 0 else {
			return
		}
		
		let ip = XGInteractionPointData(index: self.currentIndex)
		
		ip.roomID = self.roomPopup.selectedValue.roomID
		ip.interactionPointIndex = self.regionField.stringValue.integerValue ?? 0
		
		if self.triggerNone.state == .on {
			ip.interactionMethod = game == .XD ? .None : .PressAButton2
		}
		if self.triggerWalkUp.state == .on {
			ip.interactionMethod = .WalkInFront
		}
		if self.triggerWalkThrough.state == .on {
			ip.interactionMethod = .WalkThrough
		}
		if self.triggerAButton.state == .on {
			ip.interactionMethod = .PressAButton
		}
		
		if scriptTypePopUp.indexOfSelectedItem == 0 {
			ip.info = .None
		} else if scriptTypePopUp.indexOfSelectedItem == 1 {
			switch scriptIndexPopUp.indexOfSelectedItem {
			case kIPWarpValue:
				let targetRoom = self.targetRoom.selectedValue.roomID
				ip.info = .Warp(targetRoom: targetRoom, targetEntryID: self.field1.stringValue.integerValue ?? 0, sound: self.sound.state == .on)
			case kIPDoorValue:
				let doorID = self.field1.stringValue.integerValue
				ip.info = .Door(id: doorID ?? 0)

				if let id = doorID {

					if id < CommonIndexes.NumberOfDoors.value {
						let door = XGDoor(index: id)
						door.roomID = ip.roomID

						if let fileIdentifier = self.field2.stringValue.integerValue {
							if fileIdentifier & 0xFF00 == 0x1000 {
								door.fileIdentifier = fileIdentifier.unsigned
							}
						}

						door.save()
					}
				}
			case kIPTextValue:
				let sid = self.field1.stringValue.integerValue ?? 0
				if sid > 0 {
					if self.textView.string.length > 0 {
						if let string = getStringWithID(id: sid) {
							_ = string.duplicateWithString(self.textView.string).replace()
						} else {
							let roomName = self.roomPopup.selectedValue.name
							let msgFile = XGFiles.typeAndFsysName(.msg, roomName)
							let msg = msgFile.stringTable
							let string = XGString(string: self.textView.string, file: msgFile, sid: sid)
							if msg.addString(string, increaseSize: true, save: false) {
								msg.save()
							}
						}
					}
				}
				ip.info = .Text(stringID: sid)
			case kIPElevatorValue:
				let ei = self.field1.stringValue.integerValue ?? 0
				let tei = self.field2.stringValue.integerValue ?? 0
				let dir = self.direction.selectedValue
				let targetRoom = self.targetRoom.selectedValue.roomID
				ip.info = .Elevator(elevatorID: targetRoom, targetRoomID: ei, targetElevatorID: tei, direction: dir)
			case kIPCutsceneValue:
				let targetRoom = self.targetRoom.selectedValue.roomID
				let te = self.field1.stringValue.integerValue ?? 0
				let ci = self.field2.stringValue.integerValue ?? 0
				let cf = self.field3.stringValue.integerValue ?? 0
				ip.info = .CutsceneWarp(targetRoom: targetRoom, targetEntryID: te, cutsceneID: ci, cameraFSYSID: cf)

			case kIPPCValue:
				let targetRoom = self.targetRoom.selectedValue.roomID
				ip.info = .PC(roomID: targetRoom, unknown: self.field1.stringValue.integerValue ?? 0)

			default:
				let p1 = self.field1.stringValue.integerValue ?? 0
				let p2 = self.field2.stringValue.integerValue ?? 0
				let p3 = self.field3.stringValue.integerValue ?? 0
				let p4 = self.field4.stringValue.integerValue ?? 0
				ip.info = .CommonScript(scriptIndex: scriptIndexPopUp.indexOfSelectedItem, parameter1: p1, parameter2: p2, parameter3: p3, parameter4: p4)
			}
		} else {
			let p1 = self.field1.stringValue.integerValue ?? 0
			let p2 = self.field2.stringValue.integerValue ?? 0
			let p3 = self.field3.stringValue.integerValue ?? 0
			let p4 = self.field4.stringValue.integerValue ?? 0
			ip.info = .CurrentScript(scriptIndex: scriptIndexPopUp.indexOfSelectedItem, parameter1: p1, parameter2: p2, parameter3: p3, parameter4: p4)
		}
		
		ip.save()
		
		self.setUpForData(ip)
		
	}
	
	override func numberOfRows(in tableView: NSTableView) -> Int {
		return CommonIndexes.NumberOfInteractionPoints.value
	}
	
	override func tableView(_ tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
		return 40
	}
	
	override func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
		
		let data = XGInteractionPointData(index: row)
		let room = XGRoom.roomWithID(data.roomID) ?? XGRoom(index: 0)
		
		let cell = (tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "cell"), owner: self) ?? GoDTableCellView(title: "", colour: GoDDesign.colourBlack(), fontSize: 12, width: widthForTable())) as! GoDTableCellView
		
		cell.identifier = NSUserInterfaceItemIdentifier(rawValue: "cell")
		cell.translatesAutoresizingMaskIntoConstraints = false
		
		let prefix = room.name.substring(from: 0, to: 2)
		let map = XGMaps(rawValue: prefix)
		
		if map == nil {
			cell.setBackgroundColour(GoDDesign.colourWhite())
		} else {
			var colour = GoDDesign.colourWhite()
			
			switch map! {
			case .AgateVillage:
				colour = GoDDesign.colourGreen()
			case .CipherKeyLair:
				colour = GoDDesign.colourLightPurple()
			case .CitadarkIsle:
				colour = GoDDesign.colourPurple()
			case .GateonPort:
				colour = GoDDesign.colourBlue()
			case .KaminkosHouse:
				colour = GoDDesign.colourLightGrey()
			case .MtBattle:
				colour = GoDDesign.colourRed()
			case .OrreColosseum:
				colour = GoDDesign.colourBrown()
			case .OutskirtStand:
				colour = GoDDesign.colourOrange()
			case .PhenacCity:
				colour = GoDDesign.colourLightBlue()
			case .PokemonHQ:
				colour = GoDDesign.colourNavy()
			case .PyriteTown:
				colour = GoDDesign.colourRed()
			case .RealgamTower:
				colour = GoDDesign.colourLightGreen()
			case .ShadowLab:
				colour = GoDDesign.colourBabyPink()
			case .SnagemHideout:
				colour = GoDDesign.colourRed()
			case .SSLibra:
				colour = GoDDesign.colourLightOrange()
			case .Pokespot:
				colour = GoDDesign.colourYellow()
			case .TheUnder:
				colour = GoDDesign.colourGrey()
			default:
				colour = GoDDesign.colourWhite()
			}
			
			cell.setBackgroundColour(colour)
			cell.setTitle(row.string + " - " + room.name + "\n" + map!.name)
		}
		
		if self.table.selectedRow == row {
			cell.setBackgroundColour(GoDDesign.colourOrange())
		}
		
		if self.table.selectedRow == row {
			cell.addBorder(colour: GoDDesign.colourBlack(), width: 1)
		} else {
			cell.removeBorder()
		}
		
		return cell
	}
	
	override func tableView(_ tableView: GoDTableView, didSelectRow row: Int) {
		super.tableView(tableView, didSelectRow: row)
		if row >= 0 {
			let data = XGInteractionPointData(index: row)
			self.setUpForData(data)
		}
		
	}

}

























