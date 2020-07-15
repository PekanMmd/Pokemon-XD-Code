//
//  GoDTypeViewController.swift
//  GoD Tool
//
//  Created by The Steez on 26/10/2018.
//

import Cocoa

class GoDTypeViewController: GoDTableViewController {
	
	@IBOutlet var nameID: NSTextField!
	@IBOutlet var name: NSTextField!
	
	@IBOutlet var physical: NSButton!
	@IBOutlet var special: NSButton!
	@IBOutlet var neither: NSButton!
	
	@IBAction func radioCategory(_ sender: NSButton) {
		if sender == physical {
			currentType.category = .physical
		} else if sender == special {
			currentType.category = .special
		} else {
			currentType.category = .none
		}
	}
	
	@IBOutlet var normalLabel: NSTextField!
	@IBOutlet var fightLabel: NSTextField!
	@IBOutlet var flyLabel: NSTextField!
	@IBOutlet var poisonLabel: NSTextField!
	@IBOutlet var groundLabel: NSTextField!
	@IBOutlet var rockLabel: NSTextField!
	@IBOutlet var bugLabel: NSTextField!
	@IBOutlet var ghostLabel: NSTextField!
	@IBOutlet var steelLabel: NSTextField!
	@IBOutlet var fairyLabel: NSTextField!
	@IBOutlet var fireLabel: NSTextField!
	@IBOutlet var waterLabel: NSTextField!
	@IBOutlet var grassLabel: NSTextField!
	@IBOutlet var electricLabel: NSTextField!
	@IBOutlet var psychicLabel: NSTextField!
	@IBOutlet var iceLabel: NSTextField!
	@IBOutlet var dragonLabel: NSTextField!
	@IBOutlet var darkLabel: NSTextField!
	var labels = [NSTextField]()
	
	@IBOutlet var normal: GoDEffectivenessPopUpButton!
	@IBOutlet var fight: GoDEffectivenessPopUpButton!
	@IBOutlet var fly: GoDEffectivenessPopUpButton!
	@IBOutlet var poison: GoDEffectivenessPopUpButton!
	@IBOutlet var ground: GoDEffectivenessPopUpButton!
	@IBOutlet var rock: GoDEffectivenessPopUpButton!
	@IBOutlet var bug: GoDEffectivenessPopUpButton!
	@IBOutlet var ghost: GoDEffectivenessPopUpButton!
	@IBOutlet var steel: GoDEffectivenessPopUpButton!
	@IBOutlet var fairy: GoDEffectivenessPopUpButton!
	@IBOutlet var fire: GoDEffectivenessPopUpButton!
	@IBOutlet var water: GoDEffectivenessPopUpButton!
	@IBOutlet var grass: GoDEffectivenessPopUpButton!
	@IBOutlet var electric: GoDEffectivenessPopUpButton!
	@IBOutlet var psychic: GoDEffectivenessPopUpButton!
	@IBOutlet var ice: GoDEffectivenessPopUpButton!
	@IBOutlet var dragon: GoDEffectivenessPopUpButton!
	@IBOutlet var dark: GoDEffectivenessPopUpButton!
	var popups = [GoDEffectivenessPopUpButton]()
	
	
	@IBAction func save(_ sender: Any) {
		
		if currentType != nil {
			
			if nameID.stringValue.integerValue != nil {
				var value = nameID.stringValue.integerValue!
				value = value < 0 ? 0 : value
				value = value > kMaxStringID ? kMaxStringID : value
				
				currentType.nameID = value
				
				if name.stringValue.length > 0 {
                    let string = currentType.name.duplicateWithString(name.stringValue)
                    if !string.table.stringTable.addString(string, increaseSize: true, save: true) {
						printg("Failed to set type name:", name.stringValue)
					}
				}
			}
			
			for i in 0 ..< kNumberOfTypes {
				currentType.effectivenessTable[i] = popups[i].selectedValue
			}
			
			currentType.save()
		}
		setUp()
		self.table.reloadData()
	}
	
	
	var currentType : XGType!
	
	func setUp() {
		if let type = currentType {
			nameID.stringValue = type.nameID.string
			name.stringValue = type.name.string
			for i in 0 ..< kNumberOfTypes {
				popups[i].select(type.effectivenessTable[i])
			}
			
			physical.state = .off
			special.state = .off
			neither.state = .off
			
			switch type.category {
				case .physical: physical.state = .on
				case .special: special.state = .on
				default: neither.state = .on
			}
		}
	}

	override func numberOfRows(in tableView: NSTableView) -> Int {
		return kNumberOfTypes
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()

		if game == .PBR {
			physical.isHidden = true
			special.isHidden = true
			neither.isHidden = true
		}

		labels = [normalLabel, fightLabel, flyLabel, poisonLabel, groundLabel, rockLabel, bugLabel, ghostLabel, steelLabel, fairyLabel, fireLabel, waterLabel, grassLabel, electricLabel, psychicLabel, iceLabel, dragonLabel, darkLabel]
		popups = [normal, fight, fly, poison, ground, rock, bug, ghost, steel, fairy, fire, water, grass, electric, psychic, ice, dragon, dark]
		
		for i in 0 ..< kNumberOfTypes {
			let type = XGMoveTypes.type(i)
			labels[i].stringValue = type.enumerableName
			popups[i].select(.neutral)
		}
	}
	
	override func tableView(_ tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
		return 40
	}
	
	override func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
		
		let cell = (tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "cell"), owner: self) ?? GoDTableCellView(title: "", colour: GoDDesign.colourBlack(), background: XGFiles.typeImage(row).image, fontSize: 16, width: widthForTable())) as! GoDTableCellView
		
		let type = XGMoveTypes.type(row)
		cell.setTitle(type.data.name.unformattedString)
		cell.setBackgroundImage(XGFiles.typeImage(row).image)
		
		cell.identifier = NSUserInterfaceItemIdentifier(rawValue: "cell")
		cell.translatesAutoresizingMaskIntoConstraints = false
		
		cell.alphaValue = self.table.selectedRow == row ? 1 : 0.9
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
			self.currentType = XGType(index: row)
			self.setUp()
		}
	}
    
}
