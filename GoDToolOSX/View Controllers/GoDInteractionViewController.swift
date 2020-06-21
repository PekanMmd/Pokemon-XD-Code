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
	
	@IBOutlet var none: NSButton!
	@IBOutlet var warp: NSButton!
	@IBOutlet var door: NSButton!
	@IBOutlet var elevator: NSButton!
	@IBOutlet var text: NSButton!
	@IBOutlet var cutscene: NSButton!
	@IBOutlet var pc: NSButton!
	@IBOutlet var script: NSButton!
	
	@IBOutlet var dataContainer: GoDContainerView!
	
	let targetRoom = GoDRoomPopUpButton()
	let sound = NSButton(checkboxWithTitle: "Sound", target: nil, action: nil)
	let direction = GoDDirectionPopUpButton()
	
	let label1 = NSTextField()
	let field1 = NSTextField() // door id, string id, unknown, elevator id, target entry id
	let label2 = NSTextField()
	let field2 = NSTextField() // target elevator id, string text, cutscene id
	let label3 = NSTextField()
	let field3 = NSTextField() // camera fsys id
	
	let textView = NSTextView()
	let scriptPopUp = GoDPopUpButton()
	
	var currentIndex = -1
	
	func setUpForData(_ data: XGInteractionPointData) {
		self.currentIndex = data.index
		self.roomPopup.select(XGRoom.roomWithID(data.roomID) ?? XGRoom(index: 0))
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
		self.setUpForInfo(data.info)
	}
	
	@IBAction func selectRoom(_ sender: GoDRoomPopUpButton) {
		if self.script.state == .on {
			if let scriptFile = sender.selectedValue.script {
				let titles = scriptFile.ftbl.map { (f) -> String in
					return "@" + f.name
				}
				self.scriptPopUp.setTitles(values: titles)
				self.scriptPopUp.selectItem(at: 0)
			}
		}
	}
	
	
	func setUpForInfo(_ info: XGInteractionPointInfo) {
		hideVariableViews()
		
		switch info {
			
		case .None:
			self.none.state = .on
			
		case .Warp(let targetRoom, let targetEntryID, let sound):
			self.warp.state = .on
			self.targetRoom.isHidden = false
			self.targetRoom.select(XGRoom.roomWithID(targetRoom) ?? XGRoom(index: 0xAF))
			self.field1.isHidden = false
			self.label1.isHidden = false
			field1.stringValue = targetEntryID.string
			label1.stringValue = "Entry point ID"
			self.sound.isHidden = false
			self.sound.state = sound ? .on : .off
			
		case .Door(let id):
			self.door.state = .on
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
			
		case .Text(let stringID):
			self.text.state = .on
			self.field1.isHidden = false
			self.label1.isHidden = false
			self.label1.stringValue = "String ID"
			self.field1.stringValue = stringID.string
			self.textView.isHidden = false
			self.textView.string = getStringSafelyWithID(id: stringID).string
			
		case .Script(let scriptIndex, let parameter1, let parameter2, let parameter3):
			self.script.state = .on
			if let scriptFile = roomPopup.selectedValue.script {
				let titles = scriptFile.ftbl.map { (f) -> String in
					return "@" + f.name
				}
				self.scriptPopUp.setTitles(values: titles)
				self.scriptPopUp.selectItem(at: scriptIndex)
				self.scriptPopUp.isHidden = false
			}
			if game == .Colosseum {
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
			}
			
		case .Elevator(let elevatorID, let targetRoomID, let targetElevatorID, let direction):
			self.elevator.state = .on
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
			
		case .CutsceneWarp(let targetRoom, let targetEntryID, let cutsceneID, let cameraFSYSID):
			self.cutscene.state = .on
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
			
			
		case .PC(let roomID, let unknown):
			self.pc.state = .on
			self.label1.isHidden = false
			self.field1.isHidden = false
			self.targetRoom.isHidden = false
			self.targetRoom.select(XGRoom.roomWithID(roomID) ?? XGRoom(index: 0xAF))
			self.label1.stringValue = "Unknown"
			self.field1.stringValue = unknown.string
			
		case .TV:
			if game == .Colosseum {
				self.none.state = .on
			}
			
		}
	}
	
	@IBAction func setTrigger(_ sender: NSButton) {
		// just so the radio buttons have the same action and will be treated
		// as being in the same set
		return
	}
	
	@IBAction func setType(_ sender: NSButton) {
		var info = game == .XD ? XGInteractionPointInfo.None : .TV
		switch sender.tag {
		case 1: info = .Warp(targetRoom: 0xAF, targetEntryID: 0, sound: false)
		case 2: info = .Door(id: 0)
		case 3: info = .Elevator(elevatorID: 0, targetRoomID: 0xAF, targetElevatorID: 0, direction: .up)
		case 4: info = .Text(stringID: 0)
		case 5: info = .CutsceneWarp(targetRoom: 0xAF, targetEntryID: 0, cutsceneID: 0, cameraFSYSID: 0)
		case 6: info = .PC(roomID: 0xAF, unknown: 0)
		case 7: info = .Script(scriptIndex: 0, parameter1: 0, parameter2: 0, parameter3: 0)
		default:
			break
		}
		self.setUpForInfo(info)
	}
	
	func hideVariableViews() {
		let variableControls : [NSView] = [targetRoom,sound,direction,label1,field1,label2,field2,label3,field3,textView,scriptPopUp]
		for view in variableControls {
			view.isHidden = true
		}
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		self.views["targetRoom"] = targetRoom
		self.views["sound"] = sound
		self.views["direction"] = direction
		self.views["l1"] = label1
		self.views["f1"] = field1
		self.views["l2"] = label2
		self.views["f2"] = field2
		self.views["l3"] = label3
		self.views["f3"] = field3
		self.views["text"] = textView
		self.views["script"] = scriptPopUp
		
		scriptPopUp.setTitles(values: ["-"])
		
		let variableControls : [NSView] = [targetRoom,sound,direction,label1,field1,label2,field2,label3,field3,textView,scriptPopUp]
		for view in variableControls {
			self.dataContainer.addSubview(view)
			view.translatesAutoresizingMaskIntoConstraints = false
			
			if view != targetRoom && view != textView && view != scriptPopUp {
				self.addConstraintEqualWidths(view1: targetRoom, view2: view)
			}
		}
		
		self.addConstraints(visualFormat: "H:|-(10)-[l1]-(10)-[l2]-(10)-|", layoutFormat: [])
		self.addConstraints(visualFormat: "H:|-(10)-[f1]-(10)-[f2]-(10)-|", layoutFormat: [])
		self.addConstraints(visualFormat: "H:|-(10)-[targetRoom]-(10)-[l3]-(10)-|", layoutFormat: [])
		self.addConstraints(visualFormat: "H:[targetRoom]-(10)-[f3]-(10)-|", layoutFormat: [])
		self.addConstraints(visualFormat: "H:|-(10)-[f1]-(10)-[sound]-(10)-|", layoutFormat: [])
		self.addConstraints(visualFormat: "H:|-(10)-[targetRoom]-(10)-[direction]-(10)-|", layoutFormat: [])
		self.addConstraints(visualFormat: "V:|-(10)-[l1(20)][f1(20)]", layoutFormat: [])
		self.addConstraints(visualFormat: "V:|-(10)-[l2(20)][f2(20)]", layoutFormat: [])
		self.addConstraints(visualFormat: "V:|-(20)-[sound(20)]", layoutFormat: [])
		self.addConstraints(visualFormat: "V:[l3(20)][f3(20)]-(10)-|", layoutFormat: [])
		self.addConstraints(visualFormat: "V:[targetRoom(20)]-(20)-|", layoutFormat: [])
		self.addConstraints(visualFormat: "V:[direction(20)]-(20)-|", layoutFormat: [])
		self.addConstraints(visualFormat: "H:|-(10)-[text]-(10)-|", layoutFormat: [])
		self.addConstraints(visualFormat: "V:[text(40)]-(10)-|", layoutFormat: [])
		
		if game == .XD {
			self.addConstraints(visualFormat: "H:|-(10)-[script]-(10)-|", layoutFormat: [])
			self.addConstraints(visualFormat: "V:|-(10)-[script(30)]", layoutFormat: [])
		} else {
			self.addConstraints(visualFormat: "H:|-(10)-[script]-(10)-[l3]", layoutFormat: [])
			self.addConstraints(visualFormat: "V:[script(30)]-(10)-|", layoutFormat: [])
		}
		
		self.hideVariableViews()
		
		if game == .Colosseum {
			self.none.title = "Watch TV"
			self.triggerNone.title = "Press A Button (2)"
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
		
		if self.none.state == .on {
			ip.info = game == .XD ? .None : .TV
		}
		if self.warp.state == .on {
			let targetRoom = self.targetRoom.selectedValue.roomID
			ip.info = .Warp(targetRoom: targetRoom, targetEntryID: self.field1.stringValue.integerValue ?? 0, sound: self.sound.state == .on)
		}
		if self.door.state == .on {
			
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
			
		}
		if self.script.state == .on {
			if game == .XD {
				ip.info = .Script(scriptIndex: self.scriptPopUp.indexOfSelectedItem, parameter1: 0, parameter2: 0, parameter3: 0)
			} else {
				let p1 = self.field1.stringValue.integerValue ?? 0
				let p2 = self.field2.stringValue.integerValue ?? 0
				let p3 = self.field3.stringValue.integerValue ?? 0
				ip.info = .Script(scriptIndex: self.scriptPopUp.indexOfSelectedItem, parameter1: p1, parameter2: p2, parameter3: p3)
			}
		}
		if self.text.state == .on {
			let sid = self.field1.stringValue.integerValue ?? 0
			if sid > 0 {
				if self.textView.string.length > 0 {
					if let string = getStringWithID(id: sid) {
						_ = string.duplicateWithString(self.textView.string).replace()
					} else {
						let roomName = self.roomPopup.selectedValue.name
						let msgFile = XGFiles.msg(roomName)
						if msgFile.exists {
							let msg = msgFile.stringTable
							let string = XGString(string: self.textView.string, file: msgFile, sid: sid)
							if msg.addString(string, increaseSize: true, save: false) {
								msg.save()
							}
						}
					}
				}
			}
			ip.info = .Text(stringID: sid)
		}
		if self.elevator.state == .on {
			let ei = self.field1.stringValue.integerValue ?? 0
			let tei = self.field2.stringValue.integerValue ?? 0
			let dir = self.direction.selectedValue
			let targetRoom = self.targetRoom.selectedValue.roomID
			ip.info = .Elevator(elevatorID: targetRoom, targetRoomID: ei, targetElevatorID: tei, direction: dir)
		}
		if self.cutscene.state == .on {
			let targetRoom = self.targetRoom.selectedValue.roomID
			let te = self.field1.stringValue.integerValue ?? 0
			let ci = self.field2.stringValue.integerValue ?? 0
			let cf = self.field3.stringValue.integerValue ?? 0
			ip.info = .CutsceneWarp(targetRoom: targetRoom, targetEntryID: te, cutsceneID: ci, cameraFSYSID: cf)
		}
		if self.pc.state == .on {
			let targetRoom = self.targetRoom.selectedValue.roomID
			ip.info = .PC(roomID: targetRoom, unknown: self.field1.stringValue.integerValue ?? 0)
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
		
		let cell = (tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "cell"), owner: self) ?? GoDTableCellView(title: "", colour: GoDDesign.colourBlack(), fontSize: 12, width: self.table.width)) as! GoDTableCellView
		
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

























