//
//  GoDTreasureViewController.swift
//  GoD Tool
//
//  Created by The Steez on 03/11/2018.
//

import Cocoa

class GoDTreasureViewController: GoDTableViewController {
	
	@IBOutlet var room: GoDRoomPopUpButton!
	@IBOutlet var model: GoDPopUpButton!
	@IBOutlet var item: GoDItemPopUpButton!
	@IBOutlet var quantity: NSTextField!
	@IBOutlet var angle: NSTextField!
	@IBOutlet var x: NSTextField!
	@IBOutlet var y: NSTextField!
	@IBOutlet var z: NSTextField!
	
	var currentTreasure = XGTreasure(index: 0)
	
	func sanitise(_ value: Int?, bytes: Int) -> Int {
		guard let val = value else {
			return 0
		}
		if val < 0 {
			return 0
		}
		let max = bytes == 2 ? 0xFFFF : 0xFF
		return min(val, max)
	}
	
	@IBAction func setTreasureRoom(_ sender: GoDRoomPopUpButton) {
		self.currentTreasure.roomID = sender.selectedValue.roomID
	}
	
	@IBAction func save(_ sender: Any) {
		
		
		self.currentTreasure.itemID = item.selectedValue.scriptIndex
		if model.indexOfSelectedItem == 0 {
			self.currentTreasure.modelID = 0
		} else {
			self.currentTreasure.modelID = model.indexOfSelectedItem == 1 ? 0x24 : 0x44
		}
		
		self.currentTreasure.angle = sanitise(angle.stringValue.integerValue, bytes: 2)
		self.currentTreasure.quantity = sanitise(quantity.stringValue.integerValue, bytes: 1)
		if let val = Float(x.stringValue) {
			self.currentTreasure.xCoordinate = val
		}
		if let val = Float(y.stringValue) {
			self.currentTreasure.yCoordinate = val
		}
		if let val = Float(z.stringValue) {
			self.currentTreasure.zCoordinate = val
		}
		
		self.currentTreasure.save()
		self.reloadViewWithActivity()
	}
	
	
	override func viewDidLoad() {
		super.viewDidLoad()
		self.model.setTitles(values: ["-", "Chest", "Sparkle"])
		self.reloadViewWithActivity()
	}

	func reloadViewWithActivity() {
		self.showActivityView {
			self.reloadView()
			self.hideActivityView()
		}
	}
	
	func reloadView() {
		
		self.room.select(self.currentTreasure.room)
		self.model.selectItem(at: 0)
		if currentTreasure.modelID == 0x24 {
			self.model.selectItem(at: 1)
		}
		if currentTreasure.modelID == 0x44 {
			self.model.selectItem(at: 2)
		}
		self.item.select(self.currentTreasure.item)
		self.angle.stringValue = self.currentTreasure.angle.string
		self.x.stringValue = self.currentTreasure.xCoordinate.string
		self.y.stringValue = self.currentTreasure.yCoordinate.string
		self.z.stringValue = self.currentTreasure.zCoordinate.string
		self.quantity.stringValue = self.currentTreasure.quantity.string
		
	}
	
	override func numberOfRows(in tableView: NSTableView) -> Int {
		return CommonIndexes.NumberTreasureBoxes.value
	}
	
	override func tableView(_ tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
		return 40
	}
	
	override func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
		
		let room = XGTreasure(index: row).room.name
		
		let cell = (tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "cell"), owner: self) ?? GoDTableCellView(title: "", colour: GoDDesign.colourBlack(), fontSize: 12, width: widthForTable())) as! GoDTableCellView
		
		cell.setTitle(row.string + " - " + room)
		
		cell.identifier = NSUserInterfaceItemIdentifier(rawValue: "cell")
		cell.translatesAutoresizingMaskIntoConstraints = false
		
		let prefix = room.substring(from: 0, to: 2)
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
			cell.setTitle(row.string + " - " + room + "\n" + map!.name)
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
			self.currentTreasure = XGTreasure(index: row)
		}
		self.reloadViewWithActivity()
		
	}
    
}
