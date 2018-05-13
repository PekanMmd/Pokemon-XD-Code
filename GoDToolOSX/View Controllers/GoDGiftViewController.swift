//
//  GoDGiftViewController.swift
//  GoDToolOSX
//
//  Created by The Steez on 09/05/2018.
//

import Cocoa

class GoDGiftViewController: GoDTableViewController {

	var currentGift : XGGiftPokemon = XGStarterPokemon()
	var gifts : [XGGiftPokemon] = []
	
	@IBOutlet var pokemonView: GoDGiftPokemonView!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		self.title = "Gift Pokemon Editor"
		
		loadGifts()
		pokemonView.delegate = self
		
		self.table.reloadData()
		self.table.tableView.intercellSpacing = NSSize(width: 0, height: 1)
		
	}
	
	func reloadAllData() {
		self.showActivityView {
			self.loadGifts()
			let row = self.table.selectedRow
			self.table.reloadData()
			self.table.selectedRow = row
			self.tableView(self.table, didSelectRow: row)
			self.hideActivityView()
		}
	}
	
	
	func loadGifts() {
		
		self.gifts = []
		self.gifts.append(XGStarterPokemon())
		
		for i in 0 ..< 2 {
			self.gifts.append(XGDemoStarterPokemon(index: i))
		}
		
		for i in 0 ..< 3 {
			self.gifts.append(XGMtBattlePrizePokemon(index: i))
		}
		
		self.gifts.append(XGTradeShadowPokemon())
		
		for i in 0 ..< 4 {
			self.gifts.append(XGTradePokemon(index: i))
		}
		
	}
	
	@IBAction func save(_ sender: Any) {
		self.showActivityView {
			self.currentGift.save()
			self.reloadAllData()
			self.hideActivityView()
		}
	}
	
	override func widthForTable() -> NSNumber {
		return 200
	}
	
	override func numberOfRows(in tableView: NSTableView) -> Int {
		return  gifts.count
	}
	
	override func tableView(_ tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
		return 50
	}
	
	override func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
		
		let cell = (tableView.make(withIdentifier: "cell", owner: self) ?? GoDTableCellView(title: "", colour: GoDDesign.colourBlack(), showsImage: true, image: nil, background: nil, fontSize: 12, width: self.table.width)) as! GoDTableCellView
		
		cell.identifier = "cell"
		
		cell.titleField.maximumNumberOfLines = 2
		
		let mon = gifts[row]
		cell.setTitle(mon.species.name.string + " Lv. \(mon.level)\n" + mon.giftType)
		cell.setImage(image: mon.species.face)
		
		cell.setBackgroundColour(GoDDesign.colourPurple())
		
		var colour = GoDDesign.colourWhite()
		
		if row == 0 {
			colour = GoDDesign.colourYellow()
		} else if row < 3 {
			colour = GoDDesign.colourBlue()
		} else if row < 6 {
			colour = GoDDesign.colourRed()
		} else if row == 6 {
			colour = GoDDesign.colourPurple()
		} else {
			colour = GoDDesign.colourGreen()
		}
		cell.setBackgroundColour(colour)
		
		if self.table.selectedRow == row {
			cell.setBackgroundColour(GoDDesign.colourOrange())
		}
		
		return cell
	}
	
	override func tableView(_ tableView: GoDTableView, didSelectRow row: Int) {
		self.showActivityView {
			self.loadGifts()
			self.currentGift = self.gifts[row]
			
			self.pokemonView.setUp()
			
			self.hideActivityView()
		}
		
	}
}
