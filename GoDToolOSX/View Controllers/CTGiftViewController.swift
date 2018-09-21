//
//  CTGiftViewController.swift
//  GoDToolCL
//
//  Created by The Steez on 07/06/2018.
//

import Cocoa

class GoDGiftViewController: GoDTableViewController {
	
	var currentGift : XGGiftPokemon = XGDemoStarterPokemon(index: 0)
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
			self.table.reloadData()
			self.hideActivityView()
		}
	}
	
	
	func loadGifts() {
		
		self.gifts = []
		
		for i in 0 ..< 2 {
			self.gifts.append(XGDemoStarterPokemon(index: i))
		}
		
		for i in 0 ..< kNumberOfDistroPokemon {
			self.gifts.append(CMGiftPokemon(index: i))
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
		
		let cell = (tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "cell"), owner: self) ?? GoDTableCellView(title: "", colour: GoDDesign.colourBlack(), showsImage: true, image: nil, background: nil, fontSize: 12, width: self.table.width)) as! GoDTableCellView
		
		cell.identifier = NSUserInterfaceItemIdentifier(rawValue: "cell")
		
		cell.titleField.maximumNumberOfLines = 2
		
		let mon = gifts[row]
		cell.setTitle(mon.species.name.string + " Lv. \(mon.level)\n" + mon.giftType)
		cell.setImage(image: mon.species.face)
		
		var colour = GoDDesign.colourYellow()
		if row > 1 {
			colour = GoDDesign.colourRed()
		}
		if row > 3 {
			colour = GoDDesign.colourBlue()
		}
		
		cell.setBackgroundColour(colour)
		
		if self.table.selectedRow == row {
			cell.setBackgroundColour(GoDDesign.colourOrange())
		}
		
		return cell
	}
	
	override func tableView(_ tableView: GoDTableView, didSelectRow row: Int) {
		if row >= 0 && row < gifts.count {
			self.showActivityView {
				self.loadGifts()
				self.currentGift = self.gifts[row]
				
				self.pokemonView.setUp()
				
				self.hideActivityView()
			}
		}
	}
}


