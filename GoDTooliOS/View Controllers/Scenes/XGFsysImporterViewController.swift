//
//  XGFsysImporterViewController.swift
//  XG Tool
//
//  Created by StarsMmd on 30/07/2015.
//  Copyright (c) 2015 StarsMmd. All rights reserved.
//

import UIKit

class XGFsysImporterViewController: XGViewController {
	
	var folder		= XGFolders.Documents
	
	var fsysPicker  = XGPopoverButton()
	var lzssPicker  = XGPopoverButton()
	
	var importButton = XGButton()
	
    override func viewDidLoad() {
        super.viewDidLoad()

		self.setUpUI()
		
    }
	
	func setUpUI() {
		
		importButton = XGButton(title: "Import Files", colour: UIColor.blue, textColour: UIColor.white, action: {self.importFsys()})
		self.addSubview(importButton, name: "i")
		self.addConstraintAlignCenters(view1: importButton, view2: self.contentView)
		
	}
	
	override func popoverDidDismiss() {
	
	
	
	}
	
	func importFsys() {
		
		self.showActivityView { (Bool) -> Void in
			
			XGFiles.fsys("common.fsys").fsysData.shiftAndReplaceFileWithIndex(0, withFile: .lzss("common_rel.lzss"))
			XGFiles.fsys("common.fsys").fsysData.shiftAndReplaceFileWithIndex(2, withFile: .lzss("DeckData_DarkPokemon.lzss"))
			XGFiles.fsys("common.fsys").fsysData.shiftAndReplaceFileWithIndex(4, withFile: .lzss("DeckData_DarkPokemon.lzss"))
			XGFiles.fsys("common_dvdeth.fsys").fsysData.shiftAndReplaceFileWithIndex(0, withFile: .lzss("tableres2.lzss"))
			XGFiles.fsys("deck_archive.fsys").fsysData.shiftAndReplaceFileWithIndex(4, withFile: .lzss("DeckData_DarkPokemon.lzss"))
			XGFiles.fsys("deck_archive.fsys").fsysData.shiftAndReplaceFileWithIndex(5, withFile: .lzss("DeckData_DarkPokemon.lzss"))
			XGFiles.fsys("deck_archive.fsys").fsysData.shiftAndReplaceFileWithIndex(12, withFile: .lzss("DeckData_Story.lzss"))
			XGFiles.fsys("deck_archive.fsys").fsysData.shiftAndReplaceFileWithIndex(13, withFile: .lzss("DeckData_Story.lzss"))
			XGFiles.fsys("deck_archive.fsys").fsysData.shiftAndReplaceFileWithIndex(14, withFile: .lzss("DeckData_Virtual.lzss"))
			XGFiles.fsys("deck_archive.fsys").fsysData.shiftAndReplaceFileWithIndex(15, withFile: .lzss("DeckData_Virtual.lzss"))
			XGFiles.fsys("field_common.fsys").fsysData.shiftAndReplaceFileWithIndex(8, withFile: .lzss("uv_icn_type_big_00.lzss"))
			XGFiles.fsys("field_common.fsys").fsysData.shiftAndReplaceFileWithIndex(9, withFile: .lzss("uv_icn_type_small_00.lzss"))
			XGFiles.fsys("fight_common.fsys").fsysData.shiftAndReplaceFileWithIndex(15, withFile: .lzss("uv_icn_type_big_00.lzss"))
			XGFiles.fsys("fight_common.fsys").fsysData.shiftAndReplaceFileWithIndex(16, withFile: .lzss("uv_icn_type_small_00.lzss"))
			XGFiles.fsys("title.fsys").fsysData.shiftAndReplaceFileWithIndex(12, withFile: .lzss("title_start_00.lzss"))
			
			
			self.hideActivityView()
		}
	}
	
	
	

}



















