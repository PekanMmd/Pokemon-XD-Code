//
//  GoDScriptViewer.swift
//  GoDToolOSX
//
//  Created by The Steez on 09/05/2018.
//

import Cocoa

class GoDScriptViewController: GoDTableViewController {
	
	@IBOutlet var scriptView: NSTextView!
	
	@IBOutlet var updateScriptText: NSButton!
	@IBOutlet var increaseSizeMSG: NSButton!
	@IBOutlet var decompileWhenDone: NSButton!
	@IBOutlet var disassembleWhenDone: NSButton!
	@IBOutlet var baseStringIDTextView: NSTextField!

	var filteredScripts = [XGFiles]()
	var scripts : [XGFiles] {
		return XGFolders.XDS.files.filter({ (file) -> Bool in
			return file.fileType == .xds
		}).sorted(by: { (f1, f2) -> Bool in
			return f1.fileName < f2.fileName
		})
	}

	var currentFile : XGFiles?
	
	override func viewDidLoad() {
		super.viewDidLoad()
		table.setShouldUseIntercellSpacing(to: true)
		filteredScripts = scripts
		self.table.reloadData()
		
		XDSScriptCompiler.clearCompilerFlags()
		self.currentFile = nil
	}

	override func numberOfRows(in tableView: NSTableView) -> Int {
		return filteredScripts.count == 0 ? 1 : filteredScripts.count
	}
	
	override func tableView(_ tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
		return 50
	}
	
	override func tableView(_ tableView: GoDTableView, didSelectRow row: Int) {
		super.tableView(tableView, didSelectRow: row)
		if row == -1 {
			return
		}
		if filteredScripts.count > 0 {
			if filteredScripts[row].exists {
				currentFile = filteredScripts[row]
				scriptView.string = filteredScripts[row].text
				scriptView.scrollToBeginningOfDocument(nil)
			}
		}
	}
	
	override func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
		
		let cell = (tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "cell"), owner: self) ?? GoDTableCellView(title: "", colour: GoDDesign.colourBlack(), fontSize: 12, width: widthForTable())) as! GoDTableCellView
		
		cell.identifier = NSUserInterfaceItemIdentifier(rawValue: "cell")
		
		if filteredScripts.count == 0 {
			
			cell.setBackgroundColour(GoDDesign.colourWhite())
			cell.setTitle("No scripts found in XDS folder.\nselect 'Script > Decompile Scripts' and try again.")
			cell.titleField.maximumNumberOfLines = 0

			return cell
		}
		
		let str = filteredScripts[row].fileName
		let prefix = str.substring(from: 0, to: 2)
		
		let map = XGMaps(rawValue: prefix)
		
		if map == nil {
			cell.setBackgroundColour(GoDDesign.colourWhite())
			cell.setTitle(filteredScripts[row].fileName)
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
			
			cell.setTitle(filteredScripts[row].fileName + "\n" + map!.name)
		}
		
		if self.table.selectedRow == row {
			cell.setBackgroundColour(GoDDesign.colourOrange())
		}
		
		return cell
	}

	override func searchBarBehaviourForTableView(_ tableView: GoDTableView) -> GoDSearchBarBehaviour {
		.onTextChange
	}

	override func tableView(_ tableView: GoDTableView, didSearchForText text: String) {

		defer {
			tableView.reloadData()
		}

		guard !text.isEmpty else {
			filteredScripts = scripts
			return
		}

		filteredScripts = scripts.filter({ (file) -> Bool in
			file.fileName.simplified.contains(text.simplified)
		})
	}
	
	@IBAction func compile(_ sender: Any) {
		XDSScriptCompiler.clearCompilerFlags()
		
		let text = self.scriptView.string
		if text.length > 0 {
			if let file = currentFile {
				if file.exists {
					
					text.save(toFile: file)
					
					XDSScriptCompiler.updateStringIDs = self.updateScriptText.state == .on
					XDSScriptCompiler.increaseMSGSize = self.increaseSizeMSG.state == .on
					XDSScriptCompiler.decompileXDS = self.decompileWhenDone.state == .on
					XDSScriptCompiler.writeDisassembly = self.disassembleWhenDone.state == .on
					if let baseID = self.baseStringIDTextView.stringValue.integerValue {
						XDSScriptCompiler.baseStringID = baseID
					}
					if !XDSScriptCompiler.compile(textFile: file) {
						GoDAlertViewController.displayAlert(title: "Compiler Error", text: "\(file.fileName)\n\n\(XDSScriptCompiler.error)")
					} else {
						GoDAlertViewController.displayAlert(title: "Compilation Complete", text: "Successfully compiled script for file" + file.path)
					}
				} else {
					GoDAlertViewController.displayAlert(title: "404", text: "File couldn't be found: " + file.fileName)
				}
			} else {
				GoDAlertViewController.displayAlert(title: "Select a file", text: "Please select a file to compile")
			}
		} else {
			GoDAlertViewController.displayAlert(title: "No text", text: "There is no text to compile")
		}
	}
	
	
}




















