//
//  XGGiftPokemonViewController.swift
//  XG Tool
//
//  Created by The Steez on 01/08/2015.
//  Copyright (c) 2015 Ovation International. All rights reserved.
//

import UIKit

class XGGiftPokemonViewController: XGTableViewController {
	
	var gifts : [XGGiftPokemon] = []
	
	var currentPokemon : XGGiftPokemon = XGStarterPokemon()
	
	var level	= XGValueTextField()
	var species	= XGPopoverButton()
	var move1	= XGPopoverButton()
	var move2	= XGPopoverButton()
	var move3	= XGPopoverButton()
	var move4	= XGPopoverButton()
	var shiny	= XGButton()
	var saveButton	= XGButton()

    override func viewDidLoad() {
        super.viewDidLoad()
		
		self.setUpUI()
		self.loadGifts()
		self.reloadTable()

        // Do any additional setup after loading the view.
    }
	
	func loadGifts() {
		
		self.gifts.append(XGStarterPokemon())
		
		for i in 0 ..< 2 {
			self.gifts.append(XGDemoStarterPokemon(index: i))
		}
		
		for i in 0 ..< 3 {
			self.gifts.append(XGMtBattlePrizePokemon(index: i))
		}
		
		for i in 0 ..< 4 {
			self.gifts.append(XGTradePokemon(index: i))
		}
		
		self.gifts.append(XGTradeShadowPokemon())
		
	}
	
	func reloadTable() {
		self.table.reloadData()
	}
	
	func setUpUI() {
		self.showActivityView { (Bool) -> Void in
			
			self.level = XGValueTextField(title: "level", min: 1, max: 100, height: 30, width: 200, action: { self.currentPokemon.level = self.level.value; self.updateUI() })
			self.addSubview(self.level, name: "level")
			
			self.species = XGPopoverButton(title: "", colour: UIColor.red, textColour: UIColor.black, popover: XGPokemonPopover(), viewController: self)
			self.addSubview(self.species, name: "spec")
			self.addConstraintSize(view: self.species, height: 60, width: 200)
			
			self.move1	= XGPopoverButton(title: "", colour: UIColor.blue, textColour: UIColor.black, popover: XGMovePopover(), viewController: self)
			self.addSubview(self.move1, name: "m1")
			self.addConstraintSize(view: self.move1, height: 60, width: 150)
			
			self.move2	= XGPopoverButton(title: "", colour: UIColor.blue, textColour: UIColor.black, popover: XGMovePopover(), viewController: self)
			self.addSubview(self.move2, name: "m2")
			self.addConstraintSize(view: self.move2, height: 60, width: 150)
			
			self.move3	= XGPopoverButton(title: "", colour: UIColor.blue, textColour: UIColor.black, popover: XGMovePopover(), viewController: self)
			self.addSubview(self.move3, name: "m3")
			self.addConstraintSize(view: self.move3, height: 60, width: 150)
			
			self.move4	= XGPopoverButton(title: "", colour: UIColor.blue, textColour: UIColor.black, popover: XGMovePopover(), viewController: self)
			self.addSubview(self.move4, name: "m4")
			self.addConstraintSize(view: self.move4, height: 60, width: 150)
			
			self.shiny	= XGButton(title: "", colour: UIColor.yellow, textColour: UIColor.black, action: { self.currentPokemon.shinyValue = self.currentPokemon.shinyValue.cycle(); self.updateUI() })
			self.addSubview(self.shiny, name: "shiny")
			self.addConstraintSize(view: self.shiny, height: 60, width: 200)
			
			self.saveButton = XGButton(title: "Save", colour: UIColor.blue, textColour: UIColor.white, action: { self.save() })
			self.addSubview(self.saveButton, name: "save")
			self.addConstraintSize(view: self.saveButton, height: 60, width: 200)
			
			self.createDummyViewsEqualWidths(3, baseName: "a")
			self.createDummyViewsEqualWidths(5, baseName: "b")
			self.createDummyViewsEqualWidths(2, baseName: "c")
			self.createDummyViewsEqualWidths(2, baseName: "d")
			
			self.createDummyViewsEqualHeights(5, baseName: "v")
			
			self.addConstraints(visualFormat: "H:|[a1][spec][a2][level][a3]|", layoutFormat: [.alignAllTop, .alignAllBottom])
			self.addConstraints(visualFormat: "H:|[b1][m1][b2][m2][b3][m3][b4][m4][b5]|", layoutFormat: [.alignAllTop, .alignAllBottom])
			self.addConstraints(visualFormat: "H:|[c1][shiny][c2]|", layoutFormat: [.alignAllTop, .alignAllBottom])
			self.addConstraints(visualFormat: "H:|[d1][save][d2]|", layoutFormat: [.alignAllTop, .alignAllBottom])
			
			self.addConstraints(visualFormat: "V:|[v1][a2][v2][b3][v3][shiny][v4][save][v5]|", layoutFormat: .alignAllCenterX)
			
			self.updateUI()
			
			self.hideActivityView()
		}
		
	}
	
	func updateUI() {
		self.showActivityView { (Bool) -> Void in
			
			self.level.value = self.currentPokemon.level
			self.species.textLabel.text = self.currentPokemon.species.name.string
			self.shiny.textLabel.text = self.currentPokemon.shinyValue.string
			self.move1.textLabel.text = self.currentPokemon.move1.name.string
			self.move2.textLabel.text = self.currentPokemon.move2.name.string
			self.move3.textLabel.text = self.currentPokemon.move3.name.string
			self.move4.textLabel.text = self.currentPokemon.move4.name.string
			self.move1.setBackgroundImage(self.currentPokemon.move1.type.image, for: UIControlState())
			self.move2.setBackgroundImage(self.currentPokemon.move2.type.image, for: UIControlState())
			self.move3.setBackgroundImage(self.currentPokemon.move3.type.image, for: UIControlState())
			self.move4.setBackgroundImage(self.currentPokemon.move4.type.image, for: UIControlState())
			
			self.hideActivityView()
		}
	}
	
	override func popoverDidDismiss() {
		
		if popoverPresenter == self.species {
			self.currentPokemon.species = selectedItem as! XGPokemon
		} else if popoverPresenter == self.move1 {
			self.currentPokemon.move1 = selectedItem as! XGMoves
		} else if popoverPresenter == self.move2 {
			self.currentPokemon.move2 = selectedItem as! XGMoves
		} else if popoverPresenter == self.move3 {
			self.currentPokemon.move3 = selectedItem as! XGMoves
		} else if popoverPresenter == self.move4 {
			self.currentPokemon.move4 = selectedItem as! XGMoves
		}
		
		self.popoverPresenter.popover.dismiss(animated: true)
		self.updateUI()
		
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		var cell = table.dequeueReusableCell(withIdentifier: "cell") as! XGTableViewCell!
		if cell == nil {
			cell = XGTableViewCell(style: .subtitle, reuseIdentifier: "cell")
		}
		
		let gift = gifts[indexPath.row]
		let poke = gift.species
		
		cell?.picture = poke.face
		cell?.title = poke.name.string
		
		let type = poke.type1
		cell?.background = type.image
		
		cell?.subtitle = gift.giftType
		
		if type == XGMoveTypes.dark {
			cell?.textLabel?.textColor = UIColor.white
			cell?.detailTextLabel?.textColor = UIColor.white
		} else {
			cell?.textLabel?.textColor = UIColor.black
			cell?.detailTextLabel?.textColor = UIColor.black
		}
		
		return cell!
	}
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		self.currentIndexPath = indexPath
		self.currentPokemon = gifts[indexPath.row]
		self.updateUI()
	}
	
	override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return 100
	}
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return gifts.count
	}
	
	func save() {
		self.showActivityView { (Bool) -> Void in
			
			self.currentPokemon.exp = self.currentPokemon.species.expRate.expForLevel(self.currentPokemon.level)
			
			self.currentPokemon.save()
			
			self.table.reloadRows(at: [self.currentIndexPath], with: .fade)
			self.table.selectRow(at: self.currentIndexPath, animated: false, scrollPosition: .none)
			
			
			self.hideActivityView()
		}
	}
	
	
}




















