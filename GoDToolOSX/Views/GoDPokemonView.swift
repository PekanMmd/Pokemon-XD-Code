//
//  GoDPokemonView.swift
//  GoD Tool
//
//  Created by The Steez on 18/09/2017.
//
//

import Cocoa


class GoDPokemonView: NSImageView {
	
	var index = 0

	var dpkm = GoDDPKMPopUpButton()
	var ddpk = GoDDDPKPopUpButton()
	var body = NSImageView()
	var name = GoDPokemonPopUpButton()
	var item = GoDItemPopUpButton()
	var level = GoDLevelPopUpButton()
	var moves = [GoDMovePopUpButton]()
	
	var ability : GoDButton!
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
	
	var views = [String : NSView]()
	var metrics = [String : NSNumber]()
	
	var delegate : GoDTrainerViewController! {
		didSet {
			setUp()
		}
	}
	
	func setUp() {
		let trainer = self.delegate.currentTrainer
		
		if self.dpkm.deck != trainer.deck {
			self.dpkm.deck = self.delegate.currentTrainer.deck
		}
		
		let pokemon = self.delegate.pokemon[self.index]
		
		if !pokemon.isSet {
			self.setBackgroundColour(GoDDesign.colourGrey())
		} else if pokemon.isShadowPokemon {
			self.setBackgroundColour(GoDDesign.colourPurple())
		} else {
			self.setBackgroundColour(GoDDesign.colourLightGrey())
		}
		
		for key in views.keys {
			let view = views[key]!
			if key.contains("shadow") {
				view.isHidden = !pokemon.isShadowPokemon
			} else if (key != "dpkm") && (key != "ddpk") {
				view.isHidden = !pokemon.isSet
			} else {
				view.isHidden = false
			}
		}
		
		self.name.selectPokemon(pokemon: pokemon.species)
		self.dpkm.selectItem(at: pokemon.deckData.DPKMIndex)
		self.ddpk.selectItem(at: pokemon.isShadowPokemon ? pokemon.deckData.index : 0)
		self.body.image = pokemon.species.body
		self.level.selectLevel(level: pokemon.level)
		self.item.selectItem(item: pokemon.item)
		for move in self.moves {
			move.selectMove(move: pokemon.moves[move.tag])
		}
		for move in self.shadowMoves {
			move.selectMove(move: pokemon.moves[move.tag])
		}
		
		self.ivs.integerValue = pokemon.IVs
		for i in 0 ..< 6 {
			self.evs[i].integerValue = pokemon.EVs[i]
		}
		
		
		self.ability.title = pokemon.ability == 0 ? pokemon.species.stats.ability1.name.string : pokemon.species.stats.ability2.name.string
		self.nature.selectNature(nature: pokemon.nature)
		self.gender.selectGender(gender: pokemon.gender)
		self.happiness.integerValue = pokemon.happiness
		
		self.shadowCounter.integerValue = pokemon.shadowCounter
		self.shadowAggression.integerValue = pokemon.shadowAggression
		self.shadowFlee.integerValue = pokemon.shadowFleeValue
		self.shadowCatchrate.integerValue = pokemon.shadowCatchRate
		
		
	}
	
	init() {
		super.init(frame: .zero)
		
		self.translatesAutoresizingMaskIntoConstraints = false
		self.wantsLayer = true
		self.layer?.cornerRadius = 12
		self.layer?.borderColor = GoDDesign.colourBlack().cgColor
		self.layer?.borderWidth = 1
		
		for i in 0 ..< 4 {
			let move = GoDMovePopUpButton()
			move.tag = i
			self.moves.append(move)
			self.addSubview(move)
			self.views["move\(i)"] = move
			
			if i != 0 {
				self.addConstraintEqualSizes(view1: moves[0], view2: move)
			}
			
			let shadow = GoDMovePopUpButton()
			shadow.tag = i
			self.shadowMoves.append(shadow)
			self.addSubview(shadow)
			self.views["shadow\(i)"] = shadow
			
			self.addConstraintEqualSizes(view1: moves[0], view2: shadow)
		}
		
		for i in 0 ..< 6 {
			let ev = NSTextField(frame: .zero)
			ev.tag = i
			self.evs.append(ev)
			self.addSubview(ev)
			self.views["ev\(i)"] = ev
		}
		
		self.ability = GoDButton(title: "-", colour: GoDDesign.colourGrey(), textColour: GoDDesign.colourBlack(), buttonType: NSButtonType.momentaryPushIn, target: self, action: #selector(swapAbility))
		self.ability.font = GoDDesign.fontOfSize(10)
		self.ability.wantsLayer = true
		self.ability.layer?.cornerRadius = 8
		
		self.nature.font = GoDDesign.fontOfSize(10)
		
		let byteFormat = NumberFormatter()
		let ivFormat = NumberFormatter()
		let shortFormat = NumberFormatter()
		
		byteFormat.minimum = 0x00
		byteFormat.maximum = 0xFF
		ivFormat.minimum = 0
		ivFormat.maximum = 31
		shortFormat.minimum = 0x00
		shortFormat.maximum = 0xFFFF
		
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
		self.views["catch"] = shadowCatchrate
		self.addSubview(shadowCounter)
		self.views["counter"] = shadowCounter
		self.addSubview(shadowAggression)
		self.views["agg"] = shadowAggression
		self.addSubview(shadowFlee)
		self.views["flee"] = shadowFlee
		
		
		let titles = ["IVs","hpEV","atkEV","defEV","spaEV","spdEV","speEV","happiness","shadow counter","shadow flee","shadow aggression","shadow catch rate"]
		for title in titles {
			let view = NSTextField(frame: .zero)
			view.stringValue = title
			view.setBackgroundColour(.clear)
			views[title] = view
			self.addSubview(view)
		}
		
		for i in 0 ... 5 {
			let view1 = views[["hpEV","atkEV","defEV","spaEV","spdEV","speEV",][i]]!
			let view2 = evs[i]
			self.addConstraintAlignLeftAndRightEdges(view1: view1, view2: view2)
		}
		
		for i in 0 ... 5 {
			let view1 = views[["IVs","happiness","shadow counter","shadow flee","shadow aggression","shadow catch rate"][i]]!
			let view2 = [ivs,happiness,shadowCounter,shadowFlee,shadowAggression,shadowCatchrate][i]
			self.addConstraintAlignLeftAndRightEdges(view1: view1, view2: view2)
		}
		
		
		for view in ["hpEV","atkEV","defEV","spaEV","spdEV","speEV",] {
			self.addConstraintEqualSizes(view1: evs[0], view2: views[view]!)
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
		
		self.addConstraintEqualSizes(view1: ivs, view2: happiness)
		self.addConstraintSize(view: ivs, height: 30, width: 60)
		self.addConstraintHeight(view: moves[0], height: 30)
		self.addConstraintHeight(view: evs[0], height: 20)
		self.addConstraintEqualWidths(view1: self.dpkm, view2: self.ddpk)
		self.addConstraints(visualFormat: "H:|-(g)-[dpkm]-(g)-[ddpk]-(g)-|", layoutFormat: [.alignAllTop,.alignAllBottom], metrics: metrics, views: views)
		self.addConstraints(visualFormat: "V:|-(g)-[dpkm(20)]-(g)-[body(80)]", layoutFormat: [.alignAllLeft], metrics: metrics, views: views)
		self.addConstraints(visualFormat: "H:|-(g)-[body]-(g)-[name]-(g)-|", layoutFormat: [.alignAllTop], metrics: metrics, views: views)
		self.addConstraints(visualFormat: "V:[name(20)]-(g)-[level(20)]-(g)-[item(20)]", layoutFormat: [.alignAllLeft,.alignAllRight], metrics: metrics, views: views)
		self.addConstraintEqualSizes(view1: name, view2: level)
		self.addConstraintEqualSizes(view1: name, view2: item)
		self.addConstraintEqualSizes(view1: ability, view2: nature)
		self.addConstraintEqualSizes(view1: ability, view2: gender)
		self.addConstraintHeight(view: ability, height: 30)
		self.addConstraints(visualFormat: "H:|-(g)-[ability]-(g)-[nature]-(g)-[gender]-(g)-|", layoutFormat: [.alignAllTop, .alignAllBottom], metrics: metrics, views: views)
		self.addConstraints(visualFormat: "V:[body]-(g)-[ability]-(g)-[IVs][iv]", layoutFormat: [], metrics: metrics, views: views)
		self.addConstraints(visualFormat: "H:|-(g)-[iv]-(g)-[happ]", layoutFormat: [.alignAllTop, .alignAllBottom], metrics: metrics, views: views)
		self.addConstraints(visualFormat: "H:|-(g)-[IVs]-(g)-[happiness]", layoutFormat: [.alignAllTop, .alignAllBottom], metrics: metrics, views: views)
		
		
		
	}
	
	required init?(coder: NSCoder) {
		super.init(coder: coder)
	}
	
	func swapAbility() {
		self.delegate.pokemon[self.index].ability = 1 - self.delegate.pokemon[self.index].ability
		self.setUp()
	}
	
}















