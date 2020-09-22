//
//  GoDCollisionViewController.swift
//  GoDToolCL
//
//  Created by The Steez on 28/05/2018.
//

import Cocoa

class GoDCollisionViewController: GoDTableViewController {
	
	@IBOutlet var openglView: GoDOpenGLView!
	@IBOutlet var metalView: GoDMetalView!
	
	var useMetal = true
	var renderView : NSView {
		return useMetal ? self.metalView : self.openglView
	}

	var filteredCols = [XGFiles]()

	var cols: [XGFiles] {
		return XGFolders.Col.files.filter({ (file) -> Bool in
			return file.fileType == .ccd
		}).sorted(by: { (f1, f2) -> Bool in
			return f1.fileName < f2.fileName
		})
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		table.setShouldUseIntercellSpacing(to: true)
		filteredCols = cols
		self.table.reloadData()
		
		if useMetal {
			self.openglView.isHidden = true
			self.openglView.removeFromSuperview()
			self.openglView = nil
			self.metalView.setup()
		} else {
			self.metalView.isHidden = true
		}
	}

	override func viewWillDisappear() {
		super.viewWillDisappear()
		if useMetal {
			metalView.stopTimer()
		}
	}

	override func viewWillAppear() {
		if useMetal, metalView.isSetup {
			metalView.startTimer()
		}
	}
	
	override func numberOfRows(in tableView: NSTableView) -> Int {
		return filteredCols.count == 0 ? 1 : filteredCols.count
	}
	
	override func tableView(_ tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
		return 50
	}
	
	override func tableView(_ tableView: GoDTableView, didSelectRow row: Int) {
		super.tableView(tableView, didSelectRow: row)
		if row == -1 {
			return
		}

		if filteredCols.count > 0 {
			if filteredCols[row].exists {
				if useMetal {
					metalView.stopTimer()
					metalView.file = self.filteredCols[row]
					metalManager.render()
					metalView.startTimer()
				} else {
					openglView.file = self.filteredCols[row]
					openglView.render()
				}
			}
		}
	}
	
	override func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
		
		let cell = (tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "cell"), owner: self) ?? GoDTableCellView(title: "", colour: GoDDesign.colourBlack(), fontSize: 12, width: widthForTable())) as! GoDTableCellView
		
		cell.identifier = NSUserInterfaceItemIdentifier(rawValue: "cell")
		
		if filteredCols.count == 0 {
			
			cell.setBackgroundColour(GoDDesign.colourWhite())
			cell.setTitle("No \(XGFileTypes.ccd.fileExtension) files found in \(XGFolders.Col.path).\nExtract ISO and try again.")
			
			return cell
		}
		
		let str = filteredCols[row].fileName
		let prefix = str.substring(from: 0, to: 2)
		
		let map = XGMaps(rawValue: prefix)
		
		if map == nil {
			cell.setBackgroundColour(GoDDesign.colourWhite())
			cell.setTitle(filteredCols[row].fileName)
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
			
			cell.setTitle(filteredCols[row].fileName + "\n" + map!.name)
			
		}
		
		if self.table.selectedRow == row {
			cell.setBackgroundColour(GoDDesign.colourOrange())
		}
		
		return cell
	}
	
	override func keyDown(with event: NSEvent) {
		if let view = self.metalView {
//			printg("pressed key:", event.keyCode)
			if let keyName = KeyCodeName(rawValue: event.keyCode) {
				if view.dictionaryOfKeys[keyName] != true {
					view.dictionaryOfKeys[keyName] = true
				}
			}
		} else { super.keyDown(with: event) }
	}
	
	override func keyUp(with event: NSEvent) {
		if let view = self.metalView {
			if let keyName = KeyCodeName(rawValue: event.keyCode) {
				view.dictionaryOfKeys[keyName] = false
			}
		} else { super.keyUp(with: event) }
	}
	
	override func mouseDragged(with event: NSEvent) {
		if let view = self.metalView {
			view.mouseEvent(deltaX: Float(event.deltaX), deltaY: Float(event.deltaY))
		}
	}

	override func searchBarBehaviourForTableView(_ tableView: GoDTableView) -> GoDSearchBarBehaviour {
		.onTextChange
	}

	override func tableView(_ tableView: GoDTableView, didSearchForText text: String) {

		defer {
			tableView.reloadData()
		}

		guard !text.isEmpty else {
			filteredCols = cols
			return
		}

		filteredCols = cols.filter({ (file) -> Bool in
			file.fileName.lowercased().contains(text.lowercased())
		})
	}
	
}

















