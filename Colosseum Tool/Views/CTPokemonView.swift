//
//  CTPokemonView.swift
//  Colosseum Tool
//
//  Created by The Steez on 07/06/2018.
//

import Cocoa

class GoDPokemonView: NSImageView {
	
	var index = 0
	
	var dpkm = GoDPokemonPopUpButton()
	var ddpk = CMShadowIDPopUpButton() // pokemon's shadow id
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
	var shadowAggression = NSTextField(frame: .zero) // repurposed to be shadow pokemon's alternate first TID
	var shadowID = NSTextField(frame: .zero) // repurposed to be shadow pokemon's first TID
	var pokeball = GoDPokeballPopUpButton()
	
	var views = [String : NSView]()
	var metrics = [String : NSNumber]()

	// This class is copy and pasted from the XD one and tweaked slightly so there are some inconsistent variable names and such
	
	var delegate : GoDTrainerViewController! {
		didSet {
			setUp()
		}
	}
	
	func setUp() {
		let pokemon = self.delegate.pokemon[self.index]
		
		if !pokemon.isSet {
			self.setBackgroundColour(GoDDesign.colourGrey())
			self.alphaValue = 0.5
		} else if pokemon.isShadowPokemon {
			self.setBackgroundColour(GoDDesign.colourPurple())
			self.alphaValue = 1.0
		} else {
			self.setBackgroundColour(NSColor.controlBackgroundColor)
			self.alphaValue = 1.0
		}
		
		for key in views.keys {
			let view = views[key]!
			if key.contains("shadow") {
				view.isHidden = !pokemon.isShadowPokemon
			} else if (key != "dpkm") && (key != "ddpk") {
				view.isHidden = pokemon.index == 0
			} else {
				view.isHidden = false
			}
		}
		
		self.name.select(pokemon.species)
		self.dpkm.isHidden = true
		self.ddpk.selectItem(at: pokemon.shadowID)
		self.body.image = pokemon.species.body
		self.level.selectLevel(level: pokemon.level)
		self.item.select(pokemon.item)
		for move in self.moves {
			move.select(pokemon.moves[move.tag])
		}
		for move in self.shadowMoves {
			move.isHidden = true
		}
		
		self.ivs.integerValue = pokemon.IVs
		for i in 0 ..< 6 {
			self.evs[i].integerValue = pokemon.EVs[i]
		}
		
		
		let abtitles = [pokemon.species.stats.ability1.name.string , pokemon.species.stats.ability2.name.string] + (game == .XD ? [] : ["Random"])
		self.ability.setTitles(values: abtitles)
		if pokemon.ability == 0 || pokemon.ability == 1 {
			self.ability.selectItem(at: pokemon.ability)
		} else {
			self.ability.selectItem(at: 2)
		}
		self.nature.select(pokemon.nature)
		self.gender.select(pokemon.gender)
		self.happiness.integerValue = pokemon.happiness
		
		self.shadowCounter.integerValue = pokemon.shadowCounter
		self.shadowAggression.integerValue = pokemon.shadowAlternateFirstTID
		self.shadowID.integerValue = pokemon.shadowFirstTID
		self.shadowCatchrate.integerValue = pokemon.shadowCatchRate
		self.pokeball.select(pokemon.pokeball)
		
	}
	
	init() {
		super.init(frame: .zero)
		
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
			shadow.isHidden = true
//			shadow.target = self
//			shadow.action = shadowSelectors[i]
			
			self.addConstraintEqualSizes(view1: moves[0], view2: shadow)
		}
		
		let texts = [shadowCounter, shadowID, shadowAggression, shadowCatchrate, ivs, happiness]
		let textSelectors = [#selector(setCounter(sender:)), #selector(setFlee(sender:)), #selector(setAggression(sender:)), #selector(setCatch(sender:)),#selector(setIVs(sender:)),#selector(setHappiness(sender:)),]
		for i in 0 ..< texts.count {
			texts[i].target = self
			texts[i].action = textSelectors[i]
			texts[i].cell?.sendsActionOnEndEditing = true
		}
		
		
		let popups = [ability,gender,nature,name,item,level,pokeball,ddpk]
		let popselectors = [#selector(setAbility(sender:)),#selector(setGender(sender:)),#selector(setNature(sender:)),#selector(setSpecies(sender:)),#selector(setItem(sender:)),#selector(setLevel(sender:)),#selector(setPokeball(sender:)), #selector(setShadowID(sender:))]
		
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
			ev.action = #selector(setEV(sender:))
			ev.cell?.sendsActionOnEndEditing = true
		}
		
		self.dpkm.font = GoDDesign.fontOfSize(8)
		self.ddpk.font = GoDDesign.fontOfSize(8)
		self.pokeball.font = GoDDesign.fontOfSize(8)
		self.item.font = GoDDesign.fontOfSize(8)
		
		let byteFormat = NumberFormatter.byteFormatter()
		
		let ivFormat = NumberFormatter()
		ivFormat.minimum = 0
		ivFormat.maximum = 255
		
		for view in evs + [shadowCatchrate,shadowAggression,happiness] {
			view.formatter = byteFormat
		}
		shadowCounter.formatter = byteFormat
		shadowCatchrate.formatter = byteFormat
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
		self.addSubview(pokeball)
		self.views["pokeball"] = pokeball
		
		self.addSubview(shadowCatchrate)
		self.views["shadowcr"] = shadowCatchrate
		self.addSubview(shadowCounter)
		self.views["shadowct"] = shadowCounter
		self.addSubview(shadowAggression)
		self.views["shadowag"] = shadowAggression
		self.addSubview(shadowID)
		self.views["shadowfl"] = shadowID
		
		
		let titles = ["IVs","HP","Atk","Def","Sp.A","Sp.D","Speed","Happiness","Heart Guage","First TID","Alternate TID","Catch rate"]
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
			let view2 = [ivs,happiness,shadowCounter,shadowID,shadowAggression,shadowCatchrate][i]
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
			
			view.isHidden = true
		}
		
		self.metrics["g"] = 5
		
		for view in [shadowCatchrate,shadowID,shadowAggression] {
			self.addConstraintEqualWidths(view1: view, view2: shadowCounter)
		}
		
		self.addConstraintWidth(view: self.body, width: 80)
		self.addConstraintEqualSizes(view1: ivs, view2: happiness)
		self.addConstraintHeight(view: ivs, height: 15)
		self.addConstraintHeight(view: moves[0], height: 20)
		self.addConstraintHeight(view: evs[0], height: 15)
		self.addConstraintEqualWidths(view1: self.dpkm, view2: self.ddpk)
		self.addConstraintAlignLeftAndRightEdges(view1: self.body, view2: self.pokeball)
		self.addConstraintAlignBottomEdges(view1: self.pokeball, view2: self.ivs)
		
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
	
	required init?(coder: NSCoder) {
		super.init(coder: coder)
	}
	
	@objc func setAbility(sender: GoDPopUpButton) {
		if sender.indexOfSelectedItem == 2 {
			// random
			self.delegate.pokemon[self.index].ability = 0xFF
		} else {
			self.delegate.pokemon[self.index].ability = sender.indexOfSelectedItem
		}
		
	}
	
	@objc func setMove1(sender: GoDMovePopUpButton) {
		self.delegate.pokemon[self.index].moves[0] = sender.selectedValue
		
	}
	
	@objc func setMove2(sender: GoDMovePopUpButton) {
		self.delegate.pokemon[self.index].moves[1] = sender.selectedValue
		
	}
	
	@objc func setMove3(sender: GoDMovePopUpButton) {
		self.delegate.pokemon[self.index].moves[2] = sender.selectedValue
		
	}
	
	@objc func setMove4(sender: GoDMovePopUpButton) {
		self.delegate.pokemon[self.index].moves[3] = sender.selectedValue
		
	}
	
	func setShadowMove1(sender: GoDMovePopUpButton) { }
	
	func setShadowMove2(sender: GoDMovePopUpButton) { }
	
	func setShadowMove3(sender: GoDMovePopUpButton) { }
	
	func setShadowMove4(sender: GoDMovePopUpButton) { }
	
	@objc func setPokeball(sender: GoDPokeballPopUpButton) {
		self.delegate.pokemon[self.index].pokeball = sender.selectedValue
	}
	
	@objc func setItem(sender: GoDItemPopUpButton) {
		self.delegate.pokemon[self.index].item = sender.selectedValue
		
	}
	
	@objc func setSpecies(sender: GoDPokemonPopUpButton) {
		
		self.delegate.pokemon[self.index].species = sender.selectedValue
		self.delegate.pokemon[self.index].moves = sender.selectedValue.movesForLevel(self.delegate.pokemon[self.index].level)
		
		let gr = sender.selectedValue.stats.genderRatio
		
			 if gr == .maleOnly   { self.delegate.pokemon[self.index].gender = .male }
		else if gr == .femaleOnly { self.delegate.pokemon[self.index].gender = .female }
		else if gr == .genderless { self.delegate.pokemon[self.index].gender = .genderless }
		
		if self.delegate.pokemon[self.index].isShadowPokemon {
			self.delegate.pokemon[self.index].shadowCatchRate = sender.selectedValue.catchRate
		}
		
		self.setUp()
	}
	
	@objc func setLevel(sender: GoDLevelPopUpButton) {
		self.delegate.pokemon[self.index].level = sender.selectedValue
		
	}
	
	@objc func setGender(sender: GoDGenderPopUpButton) {
		self.delegate.pokemon[self.index].gender = sender.selectedValue
		
	}
	
	@objc func setNature(sender: GoDNaturePopUpButton) {
		self.delegate.pokemon[self.index].nature = sender.selectedValue
		
	}
	
	@objc func setCounter(sender: NSTextField) {
		self.delegate.pokemon[self.index].shadowCounter = sender.integerValue
		
	}
	
	@objc func setFlee(sender: NSTextField) {
		self.delegate.pokemon[self.index].shadowFirstTID = sender.integerValue
	}
	
	@objc func setAggression(sender: NSTextField) {
		self.delegate.pokemon[self.index].shadowAlternateFirstTID = sender.integerValue
	}
	
	@objc func setCatch(sender: NSTextField) {
		self.delegate.pokemon[self.index].shadowCatchRate = sender.integerValue
		
	}
	
	@objc func setIVs(sender: NSTextField) {
		let val = sender.integerValue > 31 ? 255 : sender.integerValue
		self.delegate.pokemon[self.index].IVs = val
		
	}
	
	@objc func setHappiness(sender: NSTextField) {
		self.delegate.pokemon[self.index].happiness = sender.integerValue
		
	}
	
	@objc func setEV(sender: NSTextField) {
		self.delegate.pokemon[self.index].EVs[sender.tag] = sender.integerValue
		
	}

	@objc func setShadowID(sender: CMShadowIDPopUpButton) {
		self.delegate.pokemon[self.index].shadowID = sender.selectedValue
		setUp()
		let data = CMShadowData(index: sender.selectedValue)
		shadowCounter.integerValue = data.purificationCounter
		shadowID.integerValue = data.firstTID
		shadowAggression.integerValue = data.alternateTID
		shadowCatchrate.integerValue = data.catchRate
	}
	
	func prepareForSave() {
		for view in self.evs + [shadowCatchrate, happiness] {
			if let val = view.stringValue.integerValue {
				if val > 0xFF {
					view.stringValue = "255"
				}
				if val < 0 {
					view.stringValue = "0"
				}
			} else {
				view.stringValue = "0"
			}
		}
		for view in [ivs] {
			if let val = view.stringValue.integerValue {
				if val > 31 {
					view.stringValue = "31"
				}
				if val < 0 {
					view.stringValue = "0"
				}
			} else {
				view.stringValue = "0"
			}
		}
		
		for ev in self.evs {
			self.setEV(sender: ev)
		}
		self.setHappiness(sender: happiness)
		self.setIVs(sender: ivs)
		self.setCatch(sender: shadowCatchrate)
		self.setCounter(sender: shadowCounter)
		self.setFlee(sender: shadowID)
		self.setAggression(sender: shadowAggression)
	}
	
	func didSave() {
		ddpk.setUpItems()
		ddpk.selectItem(at: self.delegate.pokemon[self.index].shadowID)
	}
	
}
