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
		
		title = "Gift Pokemon Editor"
		
		loadGifts()
		pokemonView.delegate = self
		
		table.reloadData()
		table.setShouldUseIntercellSpacing(to: true)
		
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
		self.gifts = XGGiftPokemonManager.allGiftPokemon()
	}
	
	@IBAction func save(_ sender: Any) {
		self.showActivityView {
			self.currentGift.save()
			self.reloadAllData()
			self.hideActivityView()
		}
	}
	
	override func widthForTable() -> CGFloat {
		return 200
	}
	
	override func numberOfRows(in tableView: NSTableView) -> Int {
		return  gifts.count
	}
	
	override func tableView(_ tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
		return 50
	}
	
	override func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
		
		let cell = (tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "cell"), owner: self) ?? GoDTableCellView(title: "", colour: GoDDesign.colourBlack(), fontSize: 12, width: widthForTable())) as! GoDTableCellView
		
		cell.identifier = NSUserInterfaceItemIdentifier(rawValue: "cell")
		
		cell.titleField.maximumNumberOfLines = 2
		
		let mon = gifts[row]
		cell.setTitle(mon.species.name.string + " Lv. \(mon.level)\n" + mon.giftType)
		cell.setImage(image: mon.species.face)
		
		cell.setBackgroundColour(GoDDesign.colourPurple())
		
		var colour = GoDDesign.colourWhite()
		if game == .XD {
			if row == 0 {
				colour = GoDDesign.colourBrown()
			} else if row < 3 {
				colour = GoDDesign.colourBlue()
			}  else if row < 5 {
				colour = GoDDesign.colourYellow()
			} else if row < 7 {
				colour = GoDDesign.colourGreen()
			} else if row == 7 {
				colour = GoDDesign.colourPurple()
			} else if row == 8 {
				colour = GoDDesign.colourBabyPink()
			} else if row < 12 {
				colour = GoDDesign.colourGrey()
			} else {
				colour = GoDDesign.colourRed()
			}
			cell.setBackgroundColour(colour)
			
			if self.table.selectedRow == row {
				cell.setBackgroundColour(GoDDesign.colourOrange())
			}
		} else {
			if row < 2 {
				colour = GoDDesign.colourBlue()
			} else if row < 4 {
				colour = GoDDesign.colourRed()
			} else {
				colour = GoDDesign.colourGreen()
			}
			cell.setBackgroundColour(colour)
			
			if self.table.selectedRow == row {
				cell.setBackgroundColour(GoDDesign.colourOrange())
			}
		}
		
		return cell
	}
	
	override func tableView(_ tableView: GoDTableView, didSelectRow row: Int) {
		super.tableView(tableView, didSelectRow: row)
		if row == -1 {
			return
		}
		self.showActivityView {
			self.loadGifts()
			self.currentGift = self.gifts[row]
			
			self.pokemonView.setUp()
			
			self.hideActivityView()
		}
		
	}
}
