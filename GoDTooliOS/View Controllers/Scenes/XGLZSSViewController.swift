//
//  XGLZSSViewController.swift
//  XG Tool
//
//  Created by The Steez on 30/07/2015.
//  Copyright (c) 2015 Ovation International. All rights reserved.
//

import UIKit


class XGLZSSViewController: XGTableViewController {
	
	var compress = XGButton()
	

    override func viewDidLoad() {
        super.viewDidLoad()

       self.setUpUI()
    }

	func setUpUI() {
		
		compress = XGButton(title: "Compress Files", colour: UIColor.blue, textColour: UIColor.white, action: { self.compressFiles() })
		self.addSubview(compress, name: "c")
		self.addConstraintAlignCenters(view1: compress, view2: self.contentView)
		
	}
	
	func compressFiles() {
		
		self.showActivityView { (Bool) -> Void in
			
			XGLZSS.Input(.common_rel).compress()
			XGLZSS.Input(.tableres2).compress()
			XGLZSS.Input(.deck(.DeckStory)).compress()
			XGLZSS.Input(.deck(.DeckDarkPokemon)).compress()
			XGLZSS.Input(.deck(.DeckVirtual)).compress()
			XGLZSS.Input(.nameAndFolder("uv_icn_type_big_00.fdat", .Output)).compress()
			XGLZSS.Input(.nameAndFolder("uv_icn_type_small_00.fdat", .Output)).compress()
			XGLZSS.Input(.stringTable("fight.fdat")).compress()
			XGLZSS.Input(.stringTable("pocket_menu.fdat")).compress()
			XGLZSS.Input(.nameAndFolder("title_start_00.fdat", .Output)).compress()
			
			
			self.hideActivityView()
		}
		
	}
	
	
}










