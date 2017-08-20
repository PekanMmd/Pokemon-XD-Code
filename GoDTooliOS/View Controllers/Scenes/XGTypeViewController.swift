//
//  XGTypeViewController.swift
//  XG Tool
//
//  Created by The Steez on 30/06/2015.
//  Copyright (c) 2015 Ovation International. All rights reserved.
//

import UIKit

class XGTypeViewController: XGTableViewController {
	
	var type = XGType(index: 0)
	
	var nameField = XGTextField()
	var categoryField = XGButtonField()
	var effectivenessButtons = [XGButtonField](repeating: XGButtonField(), count: kNumberOfTypes)

    override func viewDidLoad() {
        super.viewDidLoad()
		
        self.setUpUI()
		self.updateUI()
    }
	
	func setUpUI() {
		
		self.title = "Type Editor"
		
		nameField = XGTextField(title: "Name", text: "", height: 60, width: 300, action: {
			XGString(string: self.nameField.text, file: .common_rel, sid: self.type.nameID).replace()
			self.updateUI()
		})
		nameField.field.backgroundColor = UIColor.red
		nameField.field.textColor = UIColor.black
		self.addSubview(nameField, name: "name")
		
		categoryField = XGButtonField(title: "Category", text: type.category.string, height: 60, width: 300, action: {
			self.type.category = self.type.category.cycle()
			self.updateUI()
		})
		self.categoryField.field.backgroundColor = UIColor.blue
		categoryField.field.textColor = UIColor.black
		self.addSubview(categoryField, name: "cat")
		
		for i in 0 ..< kNumberOfTypes {
			
			let inx = i
			
			effectivenessButtons[inx] = XGButtonField(title: XGMoveTypes(rawValue: i)!.name, text: self.type.effectivenessTable[i].string, height: 50, width: 90, action: {
				self.type.effectivenessTable[inx] = self.type.effectivenessTable[inx].cycle()
				self.updateUI()
			})
			effectivenessButtons[i].field.backgroundColor = UIColor.yellow
			effectivenessButtons[i].field.textColor = UIColor.black
			self.addSubview(effectivenessButtons[i], name: "eb\(i + 1)")
		}
		
		let save = XGButton(title: "Save", colour: UIColor.green, textColour: UIColor.black, action: {
			self.saveData()
		})
		self.addSubview(save, name: "save")
		self.addConstraintSize(view: save, height: 60, width: 300)
		
		self.createDummyViewsEqualWidths(7 , baseName: "a")
		self.createDummyViewsEqualWidths(7 , baseName: "b")
		self.createDummyViewsEqualWidths(7 , baseName: "c")
		self.createDummyViewsEqualHeights(6, baseName: "y")
		
		self.addConstraintAlignCenterX(view1: self.contentView, view2: nameField)
		self.addConstraints(visualFormat: "H:|[a1][eb1][a2][eb2][a3][eb3][a4][eb4][a5][eb5][a6][eb6][a7]|", layoutFormat: [.alignAllTop, .alignAllBottom])
		self.addConstraints(visualFormat: "H:|[b1][eb7][b2][eb8][b3][eb9][b4][eb10][b5][eb11][b6][eb12][b7]|", layoutFormat: [.alignAllTop, .alignAllBottom])
		self.addConstraints(visualFormat: "H:|[c1][eb13][c2][eb14][c3][eb15][c4][eb16][c5][eb17][c6][eb18][c7]|", layoutFormat: [.alignAllTop, .alignAllBottom])
		
		self.addConstraints(visualFormat: "V:|-(20)-[name][y1][cat][y2][a4][y3][b4][y4][c4][y5][save][y6]|", layoutFormat: .alignAllCenterX)
		
	}
	
	func updateUI() {
		self.showActivityView { (Bool) -> Void in
		
			self.nameField.text = self.type.name.string
			self.categoryField.text = self.type.category.string
			
			for i in 0 ..< self.effectivenessButtons.count {
				
				self.effectivenessButtons[i].text = self.type.effectivenessTable[i].string
				
			}
			
			self.hideActivityView()
		}
		
	}
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return kNumberOfTypes
	}
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		self.currentIndexPath = indexPath
		self.type = XGType(index: indexPath.row)
		self.updateUI()
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		var cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! XGTableViewCell!
		if cell == nil {
			cell = XGTableViewCell(style: .subtitle, reuseIdentifier: "cell")
		}
		
		let type = XGMoveTypes(rawValue: indexPath.row) ?? .normal
		
		cell?.title = type.name
		cell?.background = type.image
		
		return cell!
	}
	
	func saveData() {
		self.showActivityView { (Bool) -> Void in
			self.type.save()
			
			self.table.reloadRows(at: [self.currentIndexPath], with: .fade)
			self.table.selectRow(at: self.currentIndexPath, animated: false, scrollPosition: .none)
			
			self.hideActivityView()
		}
	}

}



















