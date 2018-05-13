//
//  GoDScriptViewer.swift
//  GoDToolOSX
//
//  Created by The Steez on 09/05/2018.
//

import Cocoa

class GoDScriptViewController: GoDTableViewController {
	
	@IBOutlet var scriptView: NSTextView!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		self.table.tableView.intercellSpacing = NSSize(width: 0, height: 1)
		self.table.reloadData()
	}
	
	var scripts : [XGFiles] {
		return XGFolders.Scripts.files.filter({ (file) -> Bool in
			return file.fileName.contains(".scd")
		}).sorted(by: { (f1, f2) -> Bool in
			return f1.fileName < f2.fileName
		})
	}
	
	override func numberOfRows(in tableView: NSTableView) -> Int {
		return scripts.count == 0 ? 1 : scripts.count
	}
	
	override func tableView(_ tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
		return 50
	}
	
	override func tableView(_ tableView: GoDTableView, didSelectRow row: Int) {
		if scripts.count > 0 {
			if self.scripts[row].exists {
				self.scriptView.string = scripts[row].scriptData.description
				self.scriptView.scrollToBeginningOfDocument(nil)
			}
			self.table.reloadData()
		} else {
			self.table.reloadData()
		}
	}
	
	override func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
		
		let cell = (tableView.make(withIdentifier: "cell", owner: self) ?? GoDTableCellView(title: "", colour: GoDDesign.colourBlack(), showsImage: true, image: nil, background: nil, fontSize: 12, width: self.table.width)) as! GoDTableCellView
		
		cell.identifier = "cell"
		cell.titleField.maximumNumberOfLines = 2
		
		if scripts.count == 0 {
			
			cell.setBackgroundColour(GoDDesign.colourWhite())
			cell.setTitle("No scripts found in Scripts folder.\nExtract ISO and try again.")
			
			return cell
		}
		
		let str = scripts[row].fileName
		let index2 = str.index(str.startIndex, offsetBy: 2)
		let prefix = str.substring(to: index2)
		
		let map = XGMaps(rawValue: prefix)
		
		if map == nil {
			cell.setBackgroundColour(GoDDesign.colourWhite())
			cell.setTitle(scripts[row].fileName)
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
			}
			
			cell.setBackgroundColour(colour)
			
			cell.setTitle(scripts[row].fileName + "\n" + map!.name)
			
			if self.table.selectedRow == row {
				cell.setBackgroundColour(GoDDesign.colourOrange())
			}
		}
		
		
		return cell
	}
}
