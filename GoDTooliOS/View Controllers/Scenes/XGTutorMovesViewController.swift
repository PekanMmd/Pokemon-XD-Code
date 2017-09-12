//
//  XGTutorMovesViewController.swift
//  XG Tool
//
//  Created by StarsMmd on 07/08/2015.
//  Copyright (c) 2015 StarsMmd. All rights reserved.
//

import UIKit

class XGTutorMovesViewController: XGTableViewController {
	
	var currentMove = XGTMs.tutor(1).move
	
	var name = XGTextField()
	var location = XGButtonField()
	var move = XGPopoverButton()
	
	var saveButton = XGButton()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		self.name = XGTextField(title: "", text: "", height: 100, width: 200, action: {  })
		self.name.isUserInteractionEnabled = false
		self.addSubview(name, name: "name")
		
		self.location = XGButtonField(title: "Availability", text: "", colour: UIColor.blue, height: 100, width: 200, action: {
			let tmove = XGTMs.tutor(self.currentIndexPath.row + 1)
			tmove.replaceTutorFlag(tmove.tutorFlag.cycle())
			self.save()
			self.update()
		})
		self.addSubview(location, name: "loc")
		
		self.move = XGPopoverButton(title: "", colour: UIColor.clear, textColour: UIColor.black, popover: XGMovePopover(), viewController: self)
		self.addSubview(move, name: "move")
		self.addConstraintSize(view: self.move, height: 100, width: 200)
		
		self.saveButton = XGButton(title: "Save", colour: UIColor.blue, textColour: UIColor.white, action: { self.save() })
		self.addSubview(saveButton, name: "save")
		self.addConstraintSize(view: self.saveButton, height: 100, width: 200)
		
		self.createDummyViewsEqualWidths(3, baseName: "h")
		self.createDummyViewsEqualHeights(4, baseName: "v")
		
		self.addConstraints(visualFormat: "H:|[h1][name][h2][loc][h3]|", layoutFormat: [.alignAllTop, .alignAllBottom])
		self.addConstraints(visualFormat: "V:|[v1][h2][v2][move][v3][save][v4]|", layoutFormat: .alignAllCenterX)
		
		
		self.update()
	}
	
	func update() {
		self.showActivityView { (Bool) -> Void in
			
			let tm = XGTMs.tutor(self.currentIndexPath.row + 1)
			
			self.name.text = "Tutor Move " + "\(self.currentIndexPath.row + 1)"
			self.location.text = tm.tutorFlag.string
			self.move.textLabel.text = self.currentMove.name.string
			self.move.setBackgroundImage(self.currentMove.type.image, for: UIControlState())
			
			self.hideActivityView()
		}
		
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		var cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! XGTableViewCell!
		if cell == nil {
			cell = XGTableViewCell(style: .subtitle, reuseIdentifier: "cell")
		}
		
		let tm = XGTMs.tutor(indexPath.row + 1)
		
		cell?.title = tm.move.name.string
		cell?.subtitle = tm.tutorFlag.string
		cell?.background = tm.move.type.image
		
		return cell!
	}
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		self.currentIndexPath = indexPath
		self.currentMove = XGTMs.tutor(indexPath.row + 1).move
		self.update()
	}
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return kNumberOfTutorMoves
	}
	
	override func popoverDidDismiss() {
		if self.popoverPresenter == self.move {
			self.currentMove = self.selectedItem as! XGMoves
			self.move.popover.dismiss(animated: true)
			self.update()
		}
	}
	
	func save() {
		self.showActivityView { (Bool) -> Void in
			
			XGTMs.tutor(self.currentIndexPath.row + 1).replaceWithMove(self.currentMove)
			
			self.table.reloadRows(at: [self.currentIndexPath], with: .fade)
			self.table.selectRow(at: self.currentIndexPath, animated: false, scrollPosition: .none)
			
			self.hideActivityView()
		}
	}

}














