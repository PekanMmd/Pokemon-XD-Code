//
//  GoDTrainerView.swift
//  GoD Tool
//
//  Created by The Steez on 18/09/2017.
//
//

import Cocoa

class GoDTrainerView: NSView {
	
	var modelimageview = NSImageView()
	var modelPopup = GoDTrainerModelPopUpButton()
	var modelIntro = NSTextField() // xd only camera for entrance
	var classPopup = GoDTrainerClassPopUpButton()
	var AI = NSTextField()
	var name = NSTextField()
	var stringIDs = NSTextView()
	var bgm = NSTextField()
	var battleType = GoDBattleTypePopUpButton()
	var battleStyle = GoDBattleStylePopUpButton()
	var battleID = NSTextField()
	
	var views = [String : NSView]()
	
	var battleDataUpdated = false
	var previousBGMID = 0
	
	init() {
		super.init(frame: .zero)
		self.translatesAutoresizingMaskIntoConstraints = false
		self.wantsLayer = true
		self.layer?.borderWidth = 1
		self.layer?.borderColor = NSColor.controlHighlightColor.cgColor
		
		self.addSubview(modelimageview)
		self.addSubview(modelPopup)
		self.addSubview(modelIntro)
		self.addSubview(classPopup)
		self.addSubview(AI)
		self.addSubview(name)
		self.addSubview(stringIDs)
		self.addSubview(bgm)
		self.addSubview(battleType)
		self.addSubview(battleStyle)
		self.addSubview(battleID)
		views["modeli"] = modelimageview
		views["modelp"] = modelPopup
		views["intro"] = modelIntro
		views["class"] = classPopup
		views["ai"] = AI
		views["name"] = name
		views["sids"] = stringIDs
		views["bgm"] = bgm
		views["bt"] = battleType
		views["bs"] = battleStyle
		views["bi"] = battleID
		
		for (_, view) in views {
			view.translatesAutoresizingMaskIntoConstraints = false
		}
		
		AI.placeholderString = "AI Index"
		bgm.placeholderString = "BGM ID"
		modelIntro.placeholderString = "Intro ID"
		battleID.placeholderString = "Battle ID"
		battleID.isEditable = false
		battleID.isSelectable = true
		
		self.addConstraints(visualFormat: "V:|-(10)-[modeli(60)]-(10)-|", layoutFormat: [.alignAllLeft, .alignAllRight], metrics: nil, views: views)
		self.addConstraints(visualFormat: "H:|-(20)-[modeli(60)]-(10)-[class(150)]-(10)-[name(150)]-(10)-[ai(100)]-(10)-[bs(150)]-(10)-[bi(100)]", layoutFormat: [.alignAllTop], metrics: nil, views: views)
		self.addConstraints(visualFormat: "V:[class(25)]-(10)-[modelp(25)]", layoutFormat: [.alignAllLeft, .alignAllRight], metrics: nil, views: views)
		self.addConstraints(visualFormat: "V:[name(25)]-(10)-[intro(25)]", layoutFormat: [.alignAllLeft, .alignAllRight], metrics: nil, views: views)
		self.addConstraints(visualFormat: "V:[ai(25)]-(10)-[bgm(25)]", layoutFormat: [.alignAllLeft, .alignAllRight], metrics: nil, views: views)
		self.addConstraints(visualFormat: "V:[bs(25)]-(10)-[bt(25)]", layoutFormat: [.alignAllLeft, .alignAllRight], metrics: nil, views: views)
		
		self.addConstraintAlignCenterY(view1: self, view2: self.modelimageview)
		
		battleStyle.target = self
		battleStyle.action = #selector(battleDataUpdate)
		battleType.target = self
		battleType.action = #selector(battleDataUpdate)

		if game == .Colosseum {
			battleStyle.isHidden = true
			battleType.isHidden = true
			bgm.isHidden = true
			modelIntro.isHidden = true
			battleID.isHidden = true
		}
		
	}
	
	required init?(coder: NSCoder) {
		super.init(coder: coder)
	}

	var delegate : GoDTrainerViewController!
	
	func setUp(loadBattleData: Bool) {
		
		if loadBattleData {
			battleDataUpdated = false
		}
		
		let trainer = self.delegate.currentTrainer
		self.setBackgroundColour(trainer.hasShadow ? GoDDesign.colourPurple() : GoDDesign.colourRed())
		
		self.modelimageview.image = trainer.trainerModel.image
		self.classPopup.select(trainer.trainerClass)
		self.modelPopup.select(trainer.trainerModel)
		self.AI.stringValue = trainer.AI.string
		self.name.stringValue = trainer.nameID.stringIDToString().string
		
		if game == .XD {
			
			self.modelIntro.stringValue = trainer.cameraEffects.string
			
			if loadBattleData {
				if let battle = trainer.battleData {
					battleType.select(battle.battleType!)
					battleStyle.select(battle.battleStyle!)
					battleStyle.isHidden = false
					battleType.isHidden = false
					bgm.isHidden = false
					bgm.stringValue = battle.BGMusicID.hexString()
					modelIntro.stringValue = trainer.cameraEffects.string
					previousBGMID = battle.BGMusicID
					battleID.stringValue = battle.index.string
				} else {
					battleStyle.isHidden = true
					battleType.isHidden = true
					bgm.isHidden = true
					previousBGMID = 0
					battleID.stringValue = "0"
				}
			}
			
		}
		
	}
	
	@objc func battleDataUpdate() {
		self.battleDataUpdated = true
	}
	
	func save() {
		
        if let c = XGTrainerClasses(rawValue: classPopup.selectedValue.data.index) {
			self.delegate.currentTrainer.trainerClass = c
		}
		
		self.delegate.currentTrainer.trainerModel = modelPopup.selectedValue
		if let val = AI.stringValue.integerValue {
			self.delegate.currentTrainer.AI = val
		}
		
		if game == .Colosseum {
			self.delegate.currentTrainer.save()
		}
		
		if name.stringValue.length > 0 {
			if name.stringValue != self.delegate.currentTrainer.name.string {
				if let s = getStringWithID(id: self.delegate.currentTrainer.nameID) {
					if !s.duplicateWithString(name.stringValue).replace() {
						printg("failed to replace trainer name:", s)
					}
				}
			}
		}
		
		
		if game == .XD {
			
			if let m = self.modelIntro.stringValue.integerValue {
				self.delegate.currentTrainer.cameraEffects = m
			}
			self.delegate.currentTrainer.save()
			
			if let b = self.bgm.stringValue.integerValue {
				if previousBGMID != b {
					battleDataUpdated = true
				}
			}
			
			if battleDataUpdated {
				if let battle = self.delegate.currentTrainer.battleData {
					
					battle.battleType = self.battleType.selectedValue
					battle.battleStyle = self.battleStyle.selectedValue
					if let b = self.bgm.stringValue.integerValue {
						battle.BGMusicID = b
					} else {
						self.bgm.stringValue = previousBGMID.string
					}
					
					
					battle.save()
				}
			}
			battleDataUpdated = false
			
		}
		
		setUp(loadBattleData: false)
		
	}
	
	
}





