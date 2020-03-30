//
//  GoDGiftPokemonView.swift
//  GoDToolOSX
//
//  Created by The Steez on 09/05/2018.
//

import Cocoa

class GoDGiftPokemonView: NSImageView {

	// copied from pokemon view so irrelevant views are just hidden
	var dpkm = GoDPopUpButton()
	var ddpk = GoDPopUpButton()
	var body = NSImageView()
	var name = GoDPokemonPopUpButton()
	var item = GoDItemPopUpButton()
	var level = GoDLevelPopUpButton()
	var moves = [GoDMovePopUpButton]()
	
	var ability = GoDPopUpButton()
	var nature = GoDNaturePopUpButton()
	var gender = GoDGenderPopUpButton()
	var happiness = NSTextField(frame: .zero)
	
	var ivs = NSTextField(frame: .zero)
	var evs  = [NSTextField]()
	
	var shadowMoves = [GoDMovePopUpButton]()
	var shadowCatchrate = NSTextField(frame: .zero)
	var shadowCounter = NSTextField(frame: .zero)
	var shadowAggression = NSTextField(frame: .zero)
	var shadowFlee = NSTextField(frame: .zero)
	var shadowBoost = GoDLevelPopUpButton()
	
	var views = [String : NSView]()
	var metrics = [String : NSNumber]()
	
	var delegate : GoDGiftViewController! {
		didSet {
			setUp()
		}
	}
	
	init() {
		super.init(frame: .zero)
		self.layoutViews()
	}
	
	required init?(coder: NSCoder) {
		super.init(coder: coder)
		self.layoutViews()
	}
	
	func layoutViews() {
		
		self.translatesAutoresizingMaskIntoConstraints = false
		self.wantsLayer = true
		self.layer?.cornerRadius = 12
		self.layer?.borderColor = NSColor.controlHighlightColor.cgColor
		self.layer?.borderWidth = 1
		
		let moveSelectors = [#selector(setMove1(sender:)),#selector(setMove2(sender:)),#selector(setMove3(sender:)),#selector(setMove4(sender:)),]
		
		for i in 0 ..< 4 {
			let move = GoDMovePopUpButton()
			move.tag = i
			self.moves.append(move)
			self.addSubview(move)
			self.views["move\(i)"] = move
			move.font = GoDDesign.fontOfSize(8)
			move.target = self
			move.action = moveSelectors[i]
			
			if i != 0 {
				self.addConstraintEqualSizes(view1: moves[0], view2: move)
			}
			
			let shadow = GoDMovePopUpButton()
			shadow.tag = i
			self.shadowMoves.append(shadow)
			self.addSubview(shadow)
			self.views["shadow\(i)"] = shadow
			shadow.font = GoDDesign.fontOfSize(8)
			shadow.target = self
			
			self.addConstraintEqualSizes(view1: moves[0], view2: shadow)
		}
		
		let texts = [shadowCounter, shadowFlee, shadowAggression, shadowCatchrate, ivs, happiness]
		for i in 0 ..< texts.count {
			texts[i].target = self
		}
		
		let popups : [GoDPopUpButton] = [name,level]
		let popselectors = [#selector(setSpecies(sender:)),#selector(setLevel(sender:))]
		
		for i in 0 ..< popups.count {
			popups[i].target = self
			popups[i].action = popselectors[i]
		}
		
		for i in 0 ..< 6 {
			let ev = NSTextField(frame: .zero)
			ev.tag = i
			self.evs.append(ev)
			self.addSubview(ev)
			self.views["ev\(i)"] = ev
			ev.target = self
		}
		
		self.dpkm.font = GoDDesign.fontOfSize(8)
		
		let byteFormat = NumberFormatter.byteFormatter()
		let shortFormat = NumberFormatter.shortFormatter()
		
		let ivFormat = NumberFormatter()
		ivFormat.minimum = 0
		ivFormat.maximum = 31
		
		for view in evs + [shadowCatchrate,shadowAggression,shadowFlee,happiness] {
			view.formatter = byteFormat
		}
		shadowCounter.formatter = shortFormat
		ivs.formatter = ivFormat
		
		self.addSubview(dpkm)
		self.views["dpkm"] = dpkm
		self.addSubview(ddpk)
		self.views["ddpk"] = ddpk
		self.addSubview(name)
		self.views["name"] = name
		self.addSubview(body)
		self.views["body"] = body
		self.addSubview(item)
		self.views["item"] = item
		self.addSubview(level)
		self.views["level"] = level
		self.addSubview(ability)
		
		self.views["ability"] = ability
		self.addSubview(nature)
		self.views["nature"] = nature
		self.addSubview(gender)
		self.views["gender"] = gender
		self.addSubview(happiness)
		self.views["happ"] = happiness
		self.addSubview(ivs)
		self.views["iv"] = ivs
		
		self.addSubview(shadowCatchrate)
		self.views["shadowcr"] = shadowCatchrate
		self.addSubview(shadowCounter)
		self.views["shadowct"] = shadowCounter
		self.addSubview(shadowAggression)
		self.views["shadowag"] = shadowAggression
		self.addSubview(shadowFlee)
		self.views["shadowfl"] = shadowFlee
		self.addSubview(shadowBoost)
		self.views["shadowbo"] = shadowBoost
		
		
		let titles = ["IVs","HP","Atk","Def","Sp.A","Sp.D","Speed","Happiness","Counter","Flee","Aggression","Catch rate"]
		let visuals = ["IVs","hpEV","atkEV","defEV","spaEV","spdEV","speEV","happiness","shadowctT","shadowflT","shadowagT","shadowcrT"]
		for i in 0 ..< titles.count {
			let title = titles[i]
			let name = visuals[i]
			
			let view = NSTextField(frame: .zero)
			view.stringValue = title
			view.setBackgroundColour(.clear)
			views[name] = view
			self.addSubview(view)
			view.alignment = .center
			self.addConstraintHeight(view: view, height: 15)
			view.font = GoDDesign.fontOfSize(10)
			view.drawsBackground = false
			view.isBezeled = false
			view.isEditable = false
		}
		
		for i in 0 ... 5 {
			let view1 = views[["hpEV","atkEV","defEV","spaEV","spdEV","speEV",][i]]!
			let view2 = evs[i]
			self.addConstraintAlignLeftAndRightEdges(view1: view1, view2: view2)
			view2.alignment = .right
			view2.font = GoDDesign.fontOfSize(8)
		}
		
		for i in 0 ... 5 {
			let view1 = views[["IVs","happiness","shadowctT","shadowflT","shadowagT","shadowcrT"][i]]!
			let view2 = [ivs,happiness,shadowCounter,shadowFlee,shadowAggression,shadowCatchrate][i]
			self.addConstraintAlignLeftAndRightEdges(view1: view1, view2: view2)
			view2.alignment = .right
			view2.font = GoDDesign.fontOfSize(8)
		}
		
		for i in 1 ... 3 {
			self.addConstraintEqualWidths(view1: moves[0], view2: moves[i])
			self.addConstraintEqualWidths(view1: shadowMoves[0], view2: shadowMoves[i])
		}
		
		for view in ["hpEV","atkEV","defEV","spaEV","spdEV","speEV",] {
			self.addConstraintEqualWidths(view1: evs[0], view2: views[view]!)
		}
		for i in 1 ... 5 {
			self.addConstraintEqualSizes(view1: evs[i], view2: evs[0])
		}
		
		for key in views.keys {
			let view = views[key]!
			view.translatesAutoresizingMaskIntoConstraints = false
		}
		
		self.metrics["g"] = 5
		
		for view in [shadowCatchrate,shadowFlee,shadowAggression] {
			self.addConstraintEqualWidths(view1: view, view2: shadowCounter)
		}
		
		self.addConstraintWidth(view: self.body, width: 80)
		self.addConstraintEqualSizes(view1: ivs, view2: happiness)
		self.addConstraintHeight(view: ivs, height: 15)
		self.addConstraintHeight(view: moves[0], height: 20)
		self.addConstraintHeight(view: evs[0], height: 15)
		self.addConstraintEqualWidths(view1: self.dpkm, view2: self.ddpk)
		self.addConstraintAlignLeftAndRightEdges(view1: self.body, view2: self.shadowBoost)
		self.addConstraintAlignBottomEdges(view1: self.shadowBoost, view2: self.ivs)
		
		for (view1, view2) in [(level,name),(ability,item),(nature,gender)] as! [(NSView, NSView)] {
			self.addConstraintEqualSizes(view1: view1, view2: view2)
		}
		
		self.addConstraints(visualFormat: "H:|-(g)-[dpkm]-(g)-[ddpk]-(g)-|", layoutFormat: [.alignAllTop,.alignAllBottom], metrics: metrics, views: views)
		self.addConstraints(visualFormat: "V:|-(g)-[dpkm(20)]-(g)-[body(80)]", layoutFormat: [.alignAllLeft], metrics: metrics, views: views)
		self.addConstraints(visualFormat: "H:|-(g)-[body]-(g)-[level]-(g)-[name]-(g)-|", layoutFormat: [.alignAllTop], metrics: metrics, views: views)
		self.addConstraints(visualFormat: "H:[body]-(g)-[ability]-(g)-[item]-(g)-|", layoutFormat: [.alignAllCenterY], metrics: metrics, views: views)
		self.addConstraints(visualFormat: "H:[body]-(g)-[nature]-(g)-[gender]-(g)-|", layoutFormat: [.alignAllBottom], metrics: metrics, views: views)
		self.addConstraints(visualFormat: "V:[name(20)]-(10)-[ability(20)]-(10)-[nature(20)]", layoutFormat: [], metrics: metrics, views: views)
		self.addConstraintEqualSizes(view1: name, view2: level)
		self.addConstraintEqualSizes(view1: name, view2: item)
		self.addConstraintEqualSizes(view1: ability, view2: nature)
		self.addConstraintEqualSizes(view1: ability, view2: gender)
		self.addConstraintHeight(view: ability, height: 20)
		self.addConstraints(visualFormat: "V:[iv]-(g)-[hpEV][ev0]-(g)-[move0]-(g)-[shadow0]-(g)-[shadowctT][shadowct]", layoutFormat: [], metrics: metrics, views: views)
		self.addConstraints(visualFormat: "V:[nature]-(g)-[IVs][iv]", layoutFormat: [.alignAllLeft, .alignAllRight], metrics: metrics, views: views)
		self.addConstraints(visualFormat: "V:[gender]-(g)-[happiness][happ]", layoutFormat: [.alignAllLeft, .alignAllRight], metrics: metrics, views: views)
		self.addConstraints(visualFormat: "H:|-(g)-[hpEV]-(g)-[atkEV]-(g)-[defEV]-(g)-[spaEV]-(g)-[spdEV]-(g)-[speEV]-(g)-|", layoutFormat: [.alignAllTop, .alignAllBottom], metrics: metrics, views: views)
		self.addConstraints(visualFormat: "H:|-(g)-[ev0]-(g)-[ev1]-(g)-[ev2]-(g)-[ev3]-(g)-[ev4]-(g)-[ev5]-(g)-|", layoutFormat: [.alignAllTop, .alignAllBottom], metrics: metrics, views: views)
		self.addConstraints(visualFormat: "H:|-(g)-[move0]-(g)-[move1]-(g)-[move2]-(g)-[move3]-(g)-|", layoutFormat: [.alignAllTop, .alignAllBottom], metrics: metrics, views: views)
		self.addConstraints(visualFormat: "H:|-(g)-[shadow0]-(g)-[shadow1]-(g)-[shadow2]-(g)-[shadow3]-(g)-|", layoutFormat: [.alignAllTop, .alignAllBottom], metrics: metrics, views: views)
		self.addConstraints(visualFormat: "H:|-(g)-[shadowctT]-(g)-[shadowflT]-(g)-[shadowagT]-(g)-[shadowcrT]-(g)-|", layoutFormat: [.alignAllTop, .alignAllBottom], metrics: metrics, views: views)
		self.addConstraints(visualFormat: "H:|-(g)-[shadowct]-(g)-[shadowfl]-(g)-[shadowag]-(g)-[shadowcr]-(g)-|", layoutFormat: [.alignAllTop, .alignAllBottom], metrics: metrics, views: views)
	}
	
	
	func setUp() {
		
		let pokemon = self.delegate.currentGift
		
		self.setBackgroundColour(NSColor.controlBackgroundColor)
		
		self.ddpk.isHidden = true
		self.dpkm.isHidden = true
		self.ivs.isHidden  = true
		self.ability.isHidden  = true
		self.nature.isHidden  = true
		self.item.isHidden  = true
		self.gender.isHidden  = true
		self.happiness.isHidden = true
		
		for key in views.keys {
			let view = views[key]!
			if key.contains("shadow") || key.contains("ev") || key.contains("appiness") || key.contains("EV") || key.contains("IV") {
				view.isHidden = true
			}
		}
		self.level.isHidden = false
		
		self.name.select(pokemon.species)
		self.body.image = pokemon.species.body
		self.level.selectLevel(level: pokemon.level)
		
		let giftmoves = [pokemon.move1, pokemon.move2, pokemon.move3, pokemon.move4]
		for move in self.moves {
			move.select(giftmoves[move.tag])
		}
		
		
	}
	
	@objc func setMove1(sender: GoDMovePopUpButton) {
		self.delegate.currentGift.move1 = sender.selectedValue
		self.setUp()
	}
	
	@objc func setMove2(sender: GoDMovePopUpButton) {
		self.delegate.currentGift.move2 = sender.selectedValue
		self.setUp()
	}
	
	@objc func setMove3(sender: GoDMovePopUpButton) {
		self.delegate.currentGift.move3 = sender.selectedValue
		self.setUp()
	}
	
	@objc func setMove4(sender: GoDMovePopUpButton) {
		self.delegate.currentGift.move4 = sender.selectedValue
		self.setUp()
	}
	
	@objc func setSpecies(sender: GoDPokemonPopUpButton) {
		
		var mon = self.delegate.currentGift
		mon.species = sender.selectedValue
		
		let defaultMoves = mon.species.movesForLevel(mon.level)
		mon.move1 = defaultMoves[0]
		mon.move2 = defaultMoves[1]
		mon.move3 = defaultMoves[2]
		mon.move4 = defaultMoves[3]
		
		self.setUp()
	}
	
	@objc func setLevel(sender: GoDLevelPopUpButton) {
		self.delegate.currentGift.level = sender.selectedValue
		self.setUp()
	}
    
}
