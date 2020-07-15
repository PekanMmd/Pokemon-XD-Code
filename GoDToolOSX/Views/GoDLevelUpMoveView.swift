//
//  GoDLevelUpMoveView.swift
//  GoD Tool
//
//  Created by The Steez on 15/09/2017.
//
//

import Cocoa

class GoDLevelUpMoveView: NSView {

	var index = 0
	
	var movePopUp = GoDMovePopUpButton()
	var levelPopUp = GoDLevelPopUpButton()
	
	weak var delegate : GoDStatsViewController! {
		didSet {
			self.reloadData()
		}
	}
	
	init() {
		super.init(frame: .zero)
		
		self.setUp()
	}
	
	required init?(coder: NSCoder) {
		super.init(coder: coder)
		
		self.setUp()
	}
	
	func setUp() {
		self.movePopUp.target = self
		self.movePopUp.action = #selector(setMove)
		self.levelPopUp.target = self
		self.levelPopUp.action = #selector(setLevel)
		
		let viewsArray : [GoDPopUpButton] = [movePopUp,levelPopUp]
		let viewsDict : [String : NSView] = ["m" : movePopUp, "l" : levelPopUp]
		for view in viewsArray  {
			view.font = GoDDesign.fontOfSize(8)
			view.translatesAutoresizingMaskIntoConstraints = false
			self.addSubview(view)
			self.addConstraintEqualHeights(view1: self, view2: view)
			self.addConstraintAlignCenterY(view1: self, view2: view)
		}
		self.addConstraints(visualFormat: "|[m]-(10)-[l]|", layoutFormat: [], metrics: nil, views: viewsDict)
		self.addConstraint(NSLayoutConstraint(item: movePopUp, attribute: .width, relatedBy: .equal, toItem: levelPopUp, attribute: .width, multiplier: 2, constant: 0))
	}
	
	@objc func setMove() {
		if delegate != nil {
			delegate.pokemon.levelUpMoves[self.index].move = self.movePopUp.selectedValue
			self.reloadData()
		}
	}
	
	@objc func setLevel() {
		if delegate != nil {
			delegate.pokemon.levelUpMoves[self.index].level = self.levelPopUp.selectedValue
			self.reloadData()
		}
	}
	
	
	func reloadData() {
		if delegate != nil {
			let move = self.delegate.pokemon.levelUpMoves[self.index].move
			let level = self.delegate.pokemon.levelUpMoves[self.index].level
			
			self.movePopUp.select(move)
			self.levelPopUp.selectLevel(level: level)
			
		}
		
	}
}
