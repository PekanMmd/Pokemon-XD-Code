//
//  XGLevelUpMovesPopover.swift
//  XG Tool
//
//  Created by StarsMmd on 06/08/2015.
//  Copyright (c) 2015 StarsMmd. All rights reserved.
//

import UIKit

class XGLevelUpMovesPopover: XGTableViewController {
	
	var stats = XGPokemonStats(index: 0)
	var popover = UIPopoverController(contentViewController: UIViewController())
	
	var level = XGValueTextField()
	var move = XGPopoverButton()
	var saveButton = XGButton()
	var dismissButton = XGButton()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		self.setUpUI()
	}
	
	func setUpUI() {
		self.showActivityView { (Bool) -> Void in
			self.level = XGValueTextField(title: "Level", value: 1, min: 0, max: 100, height: 100, width: 200, action: { self.stats.levelUpMoves[self.currentIndexPath.row].level = self.level.value; self.update() })
			self.addSubview(self.level, name: "level")
			
			self.move = XGPopoverButton(title: "", colour: UIColor.clear, textColour: UIColor.black, popover: XGMovePopover(), viewController: self)
			self.addSubview(self.move, name: "move")
			self.addConstraintSize(view: self.move, height: 100, width: 200)
			
			self.saveButton = XGButton(title: "Save", colour: UIColor.blue, textColour: UIColor.white, action: {self.save()})
			self.addSubview(self.saveButton, name: "save")
			self.addConstraintSize(view: self.saveButton, height: 70, width: 100)
			
			self.dismissButton = XGButton(title: "Close", colour: UIColor.red, textColour: UIColor.white, action: {self.dismiss()})
			self.addSubview(self.dismissButton, name: "dismiss")
			self.addConstraintSize(view: self.dismissButton, height: 70, width: 100)
			
			self.createDummyViewsEqualWidths(3, baseName: "h")
			self.createDummyViewsEqualHeights(4, baseName: "v")
			
			self.addConstraints(visualFormat: "H:|[h1][save][h2][dismiss][h3]|", layoutFormat: [.alignAllTop, .alignAllBottom])
			self.addConstraints(visualFormat: "V:|[v1][level][v2][move][v3][h2][v4]|", layoutFormat: .alignAllCenterX)
			
			self.hideActivityView()
			self.table.reloadData()
			self.update()
		}
	}
	
	func update() {
		self.showActivityView { (Bool) -> Void in
			let lumove = self.stats.levelUpMoves[self.currentIndexPath.row]
			
			self.level.value = lumove.level
			self.move.textLabel.text = lumove.move.name.string
			self.move.setBackgroundImage(lumove.move.type.image, for: UIControlState())
			
			self.hideActivityView()
		}
	}
	
	override func popoverDidDismiss() {
		self.showActivityView { (Bool) -> Void in
			self.stats.levelUpMoves[self.currentIndexPath.row].move = self.selectedItem as! XGMoves
			self.move.popover.dismiss(animated: true)
			self.update()
		}
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		var cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! XGTableViewCell!
		if cell == nil {
			cell = XGTableViewCell(style: .subtitle, reuseIdentifier: "cell")
		}
		
		let lumove = self.stats.levelUpMoves[indexPath.row]
		
		cell?.title = "Level \(lumove.level) : " + lumove.move.name.string
		cell?.background = lumove.move.type.image
		
		return cell!
	}
	
	override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return 50
	}
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return stats.levelUpMoves.count
	}
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		self.currentIndexPath = indexPath
		self.update()
	}
	
	
	func dismiss() {
		popover.dismiss(animated: true)
	}
	
	func save() {
		self.showActivityView { (Bool) -> Void in
			self.stats.save()
			self.table.reloadRows(at: [self.currentIndexPath], with: .fade)
			self.table.selectRow(at: self.currentIndexPath, animated: true, scrollPosition: .none)
			
			self.hideActivityView()
		}
	}
	

}






