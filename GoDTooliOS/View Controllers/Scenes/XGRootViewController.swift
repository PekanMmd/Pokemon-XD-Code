//
//  XGRootViewController.swift
//  XG Tool
//
//  Created by StarsMmd on 26/05/2015.
//  Copyright (c) 2015 StarsMmd. All rights reserved.
//

import UIKit

class XGRootViewController: UITableViewController {
	
	let toolTitles = ["Pokemon Stats Editor", "Trainer Editor", "String Table Reader", "Item Editor", "Move Editor", "TM Editor", "Tutor Move Editor", "Type Editor", "Texture Importer", "Gift Pokemon Editor", "Pokespot Editor", "Shiny Chance", "Dol Patcher", "LZSS Compressor", "FSYS Importer","Extract Files From ISO (Coming Soon)"]
	let toolSegues = ["toStatsVC", "toDeckPickerVC", "toStringTableReader", "toItemVC", "toMoveVC", "toTMVC", "toTutorVC", "toTypeVC", "toTextureImporter", "toGiftVC", "toSpotVC", "toShinyVC", "toDolVC", "toLZSSVC", "toFSYSVC"]

    override func viewDidLoad() {
        super.viewDidLoad()
		
		self.setUpNavigationBar()
		self.setUpUI()
//		self.createDirectories()
//		self.copyResourcesFromMainBundle()
		
	}
	
	func createDirectories() {
		
		// main directories
		XGFolders.StringTables.createDirectory()
		XGFolders.Decks.createDirectory()
		XGFolders.DOL.createDirectory()
		XGFolders.Common.createDirectory()
		XGFolders.TextureImporter.createDirectory()
		XGFolders.Images.createDirectory()
		XGFolders.JSON.createDirectory()
		XGFolders.FSYS.createDirectory()
		XGFolders.LZSS.createDirectory()
		
		// subdirectories
		XGFolders.PNG.createDirectory()
		XGFolders.FDAT.createDirectory()
		XGFolders.Output.createDirectory()
		XGFolders.PokeFace.createDirectory()
		XGFolders.PokeBody.createDirectory()
		XGFolders.Types.createDirectory()
		XGFolders.Trainers.createDirectory()
		
	}
	
	func copyResourcesFromMainBundle() {
		
//		XGFolders.DOL.copyResource(.DOL)
//		XGFolders.Common.copyResource(.FDAT("common_rel"))
//		XGFolders.Common.copyResource(.FDAT("tableres2"))
//		XGFolders.StringTables.copyResource(.FDAT("pocket_menu"))
//		XGFolders.StringTables.copyResource(.FDAT("pda_menu"))
//		
//		XGFolders.Decks.copyResource(.BIN("DeckData_Bingo"))
//		XGFolders.Decks.copyResource(.BIN("DeckData_Colosseum"))
//		XGFolders.Decks.copyResource(.BIN("DeckData_DarkPokemon"))
//		XGFolders.Decks.copyResource(.BIN("DeckData_Hundred"))
//		XGFolders.Decks.copyResource(.BIN("DeckData_Imasugu"))
//		XGFolders.Decks.copyResource(.BIN("DeckData_Sample"))
//		XGFolders.Decks.copyResource(.BIN("DeckData_Story"))
//		XGFolders.Decks.copyResource(.BIN("DeckData_Virtual"))
		
//		XGFolders.JSON.copyResource(.JSON("Move Effects"))
//		for var i = 0; i < kNumberOfTypes; i += 1 {
//			XGFolders.Types.copyResource(.PNG(String(i)))
//		}
//		XGFolders.Types.copyResource(.PNG("shadow"))
		
	}
	
	func setUpNavigationBar() {
		
		let titleTextAttributes = [NSForegroundColorAttributeName : UIColor.orange]
		self.navigationController?.navigationBar.titleTextAttributes = titleTextAttributes
		self.navigationController?.navigationBar.barTintColor = UIColor.black
		self.navigationController?.navigationBar.tintColor = UIColor.orange
		self.navigationController?.navigationBar.isTranslucent = false
		
	}
	
	func setUpUI() {
		
		self.title = "XG Tool"
		
		self.tableView.separatorStyle = .none
		self.view.backgroundColor = UIColor.orange
		
	}

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // Return the number of sections.
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        return toolTitles.count
    }
	
	override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return 150
	}

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "rootCell") as! XGRootTableViewCell!
		if cell == nil {
			cell = XGRootTableViewCell(style: .default, reuseIdentifier: "rootCell")
		}
		
		cell?.title.textColor = UIColor.black
		
		let row = indexPath.row
		
		if row < self.toolTitles.count {
			cell?.title.text = self.toolTitles[row]
		} else {
			cell?.title.text = ""
		}
		
		cell?.background.image = UIImage(named: "Tool Cell")!

        return cell!
    }
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let row = indexPath.row
		
		if row < self.toolSegues.count {
			self.performSegue(withIdentifier: self.toolSegues[row], sender: self)
		} else {
			// Extract files like string tables
			
//			let iso = XGISO()
			
			
		}
	}

}




























