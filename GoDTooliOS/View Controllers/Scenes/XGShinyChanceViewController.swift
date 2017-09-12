//
//  XGShinyChanceViewController.swift
//  XG Tool
//
//  Created by StarsMmd on 30/06/2015.
//  Copyright (c) 2015 StarsMmd. All rights reserved.
//

import UIKit

class XGShinyChanceViewController: XGViewController {
	
	var shinyButton = XGTextField()

    override func viewDidLoad() {
        super.viewDidLoad()
		
		self.title = "Shiny Chance Editor"
		
		let sChance = XGDolPatcher.getShinyChance()
		
		shinyButton = XGTextField(title: "Input the Shiny chance percentage", text: "\(sChance)", height: 150, width: 300, action: {
			
			self.showActivityView{ (Bool) -> Void in
				let chance = (self.shinyButton.field.text! as NSString).floatValue
				
				XGDolPatcher.changeShinyChancePercentage(chance)
				
				self.hideActivityView()
			}
		})
		self.addSubview(shinyButton, name: "shiny")
		self.addConstraintAlignCenterX(view1: self.contentView, view2: shinyButton)
		self.addConstraints(visualFormat: "V:|-(100)-[shiny]", layoutFormat: [])
    }


}
