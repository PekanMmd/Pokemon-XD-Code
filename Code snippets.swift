//
//  Code snippets.swift
//  XGCommandLineTools
//
//  Created by StarsMmd on 20/03/2017.
//  Copyright © 2017 StarsMmd. All rights reserved.
//

import Foundation


// infinite TMs
//infiniteUseTMs()
//
//
//loadAllStrings()
//let list = [(20,"Blizzard-"),(32,"Scald-"),(51,"Thunder-"),(54,"Rock Slide-")]
//var indices = [Int]()
//let rel = XGFiles.common_rel.data
//for (index,next) in list {
//	let move = XGMoves.move(index).data
//	let oldNameId = XGOriginalMoves.move(index).nameID
//	rel.replace2BytesAtOffset(move.startOffset + kMoveNameIDOffset, withBytes: oldNameId)
//	indices.append(oldNameId)
//}
//rel.save()
//for i in 0 ..< list.count {
//	getStringWithID(id: indices[i])!.duplicateWithString(list[i].1).replace()
//}


//let pelipper = pokemon("pelipper").stats
//pelipper.ability1 = ability("drizzle")
//pelipper.save()
//
//let torkoal = pokemon("torkoal").stats
//torkoal.ability1 = ability("drought")
//torkoal.save()

//let rage_powder = move("rage powder").data
//rage_powder.priority = 2
//rage_powder.save()
//
//let xg001 = pokemon("xg001").stats
//xg001.modelIndex = 0x1A1
//xg001.save()
//
//let typhlosion = pokemon("typhlosion").stats
//typhlosion.levelUpMoves[1].move = move("heat wave")
//typhlosion.save()
//let cyndaquil = pokemon("cyndaquil").stats
//cyndaquil.levelUpMoves[6].move = move("heat wave")
//cyndaquil.save()
//
//let blaziken = pokemon("blaziken").stats
//blaziken.learnableTMs[24] = true
//blaziken.save()
//
//
//for deck in TrainerDecksArray {
//	if deck != .DeckVirtual {
//		for poke in deck.allPokemon {
//			if poke.species.index == pokemon("wobbuffet").index {
//				poke.moves = [move("mirror coat"), move("counter"), move("safeguard"), move("destiny bond")]
//				poke.save()
//			}
//			if poke.isShadowPokemon {
//				if poke.species.stats.evolutions[0].evolutionMethod == .maxHappiness {
//					poke.happiness = 120
//					poke.save()
//				}
//			}
//		}
//	}
//}

//let scizor = pokemon("scizor").stats
//scizor.learnableTMs[30] = false
//scizor.save()
//
//XGTMs.tm(41).replaceWithMove(move("thunder"))
//
//let thunderLearners = [19,20,25,26,29,30,31,32,33,34,35,36,39,40,52,53,56,57,81,82,83,88,89,92,93,94,100,101,109,110,111,112,113,115,120,121,122,125,128,130,131,135,137,143,145,147,148,149,150,151,162,170,171,172,179,180,181,200,203,206,209,210,233,234,239,241,242,243,248,249,250,260,261,262,265,267,288,289,315,316,317,320,337,338,353,354,364,365,366,376,377,378,380,384,385,386,387,401,402,403,404,406,407,408,409,410]
//for i in 1..<kNumberOfPokemon {
//	let poke = XGPokemon.pokemon(i).stats
//	if thunderLearners.contains(i) {
//		poke.learnableTMs[40] = true
//	} else {
//		poke.learnableTMs[40] = false
//	}
//	poke.save()
//}
//
//let banette = pokemon("banette").stats
//for i in [8,27,36,42] {
//	banette.learnableTMs[i] = false
//}
//for i in [3,4,5,6] {
//	banette.tutorMoves[i] = false
//}
//banette.save()
//
//
//let normaliseMoves = [20,32,40,51,54,80]
//
//var normalised = [XGTrainerPokemon]()
//for deck in TrainerDecksArray {
//	if deck != .DeckVirtual {
//		for poke in deck.allPokemon {
//			for m in normaliseMoves {
//				if poke.moves.contains(where: { (m1) -> Bool in
//					return m1.index == m
//				}) {
//					normalised.append(poke)
//					break
//				}
//			}
//		}
//	}
//}
//
//normalised[0].moves[1] = XGMoves.move(0)
//normalised[1].moves[0] = move("tackle")
//normalised[2].moves[0] = move("absorb")
//normalised[3].moves[0] = move("rock throw")
//normalised[4].moves[2] = move("taunt")
//normalised[5].moves[1] = move("thunderwave")
//normalised[6].moves[3] = move("rock throw")
//normalised[7].moves[3] = move("poison jab")
//normalised[8].moves[3] = move("rock throw")
//normalised[9].moves[2] = move("tackle")
//normalised[10].moves[1] = move("megahorn")
//normalised[11].moves[2] = move("giga drain")
//normalised[12].moves[2] = move("spikes")
//normalised[13].moves[2] = move("giga drain")
//normalised[14].moves[2] = move("iron head")
//normalised[14].moves[3] = move("bulldoze")
//normalised[15].moves[2] = move("ice shard")
//normalised[16].moves[2] = move("poison fang")
//normalised[17].moves[3] = move("ice beam")
//normalised[18].moves[3] = move("ice beam")
//
//
//for pokemon in normalised {
//	pokemon.save()
//}


//loadAllStrings()
//let bigd = XGDecks.DeckColosseum
//var strs = [XGString]()
//for i in 41 ... 68 {
//	let trainer = XGTrainer(index: i, deck: bigd)
//	let name = trainer.name.string
//	let trclass = trainer.trainerClass.name.string
//	let pre = getStringSafelyWithID(id: trainer.preBattleTextID)
//	let vic = getStringSafelyWithID(id: trainer.victoryTextID)
//	let def = getStringSafelyWithID(id: trainer.defeatTextID)
//	strs += [pre, vic, def]
//}
//
//let replacementStrs = [
//	"[Speaker]: Cipher Green here!", "[Speaker]: You got weeded out![6d]", "[Speaker]: I got rooted.[6d]", // sage
//	"[Speaker]: I'll show you why they call[New Line]me the gatekeeper of Pyrite.", "[Speaker]: Don't come back, punk![6d]", "[Speaker]: Locked out...[6d]", // kane
//	"[Speaker]: Sylvia'll chew me out if[New Line]I lose again.", "[Speaker]: I did it![6d]", "[Speaker]: I'm in so much trouble.[6d]", // mark
//	"[Speaker]: Did you Mark lose again?[New Line]I'll have to #PunishHim later but[New Line]now it's #MyTurn!", "[Speaker]: #GetRekt![6d]", "[Speaker]: #NoFair![6d]", // sylvia
//	"[Speaker]: Do you know what they call[New Line]me?[New Line]They call me the storm bringer!", "[Speaker]: I stormed to victory![6d]", "[Speaker]: Darn![New Line]My feelings are stormy after this loss![6d]", // luthor
//	"[Speaker]: Let me show you what a[New Line]Gym Leader can do!", "[Speaker]: You need more training.[6d]", "[Speaker]: I need more training.[6d]", // derek
//	"[Speaker]: I'll crush you this time!", "[Speaker]: My muscles show my strength![6d]", "[Speaker]: I-I Lost?.[6d]", // ray
//	"[Speaker]: I've got some secret techs[New Line]to catch you off guard!", "[Speaker]: You're too predictable.[6d]", "[Speaker]: You saw through my tactics.[6d]", // blaine
//	"[Speaker]: Check out my seismic moves.", "[Speaker]: Hit the road.[6d]", "[Speaker]: You really ground me up.[6d]", // sandy
//	"[Speaker]: I'll stall you out of[New Line]all your pp.", "[Speaker]: Guess you got impatient![6d]", "[Speaker]: You broke our defenses!?.[6d]", // dexter
//	"[Speaker]: YOU AGAIN?!", "[Speaker]: I'm the greatest![6d]", "[Speaker]: You're crampin' my style.[6d]", // zeke
//	"[Speaker]: This time, I will crush you and pulverize you!", "[Speaker]: That's for wrecking my[New Line]factory![New Line]Don't you forget it![6d]", "[Speaker]: Why?[New Line]Why can't I ever beat you?![6d]", // bruce
//	"[Speaker]: Roar, my dragons!", "[Speaker]: Did my dragons scare you?[6d]", "[Speaker]: You weren't scared at all.[6d]", // drake
//	"[Speaker]: Run away while you can.", "[Speaker]: I told you to run.[6d]", "[Speaker]: I should have run away![6d]", // ryder
//	"[Speaker]: I held back last time.[New Line]You won't win this one.", "[Speaker]: This is how I play for real.[6d]", "[Speaker]: I can't catch a break![6d]", // nick
//	"[Speaker]: I won't let you keep ruining[New Line]Sangem Gang's reputation like this.", "[Speaker]: Don't cross Snagem Gang again.[6d]", "[Speaker]: I'll admit it. You're tough[New Line]kid. Snagem Gang could really[New Line]use someone competent like you.[6d]", // duncan
//	"[Speaker]: I'll sink you.", "[Speaker]: You're all washed up.[6d]", "[Speaker]: You rinsed me.[6d]", // azure
//	"[Speaker]: We meet again, buddy.[New Line]Yeeehah. We're burning up!", "[Speaker]: It's my win this time![6d]", "[Speaker]: whew, you smoked my team.[6d]", // will
//	"[Speaker]: Hohoho. It's you again.[New Line]Ready for my sweet, sweet moves[New Line]darling? Try and keep up!", "[Speaker]: I'm in the groove.[6d]", "[Speaker]: The tempo was too fast![6d]", // mirror b.
//	"[Speaker]: I'll flood the whole arena[New Line]to defeat you this time.", "[Speaker]: I'm unstoppable in the rain.[6d]", "[Speaker]: You made my deluge look[New Line]like a puddle. You're strong.[New Line]I concede to you.[6d]", // Troy
//	"[Speaker]: Time to get hot and sweaty.", "[Speaker]: Can't stand the heat?[6d]", "[Speaker]: I got burned.[6d]", // blaze
//	"[Speaker]: You won't get past me again.", "[Speaker]: I finally stopped you.[6d]", "[Speaker]: It's like I'm not even here![6d]", // nate
//	"[Speaker]: I may be old but I have[New Line]a lot of experience.[New Line]Don't hold back!", "[Speaker]: I told you not to go[New Line]easy on me.[6d]", "[Speaker]: You went all out.[New Line]We didn't stand a chance![6d]", // ash
//	"[Speaker]: I've been to Mt.Battle to hone[New Line]my skills since our last encounter.[New Line]I won't lose!", "[Speaker]: Your team lacks discipline.[6d]", "[Speaker]: I still need more training.[6d]", // des
//	"[Speaker]: Chobin fine tuned the machines.[New Line]They're oiled up and charged to 100%.", "[Speaker]: I collected some useful data.[6d]", "[Speaker]: There was still some input lag.[New Line]I must return to the lab![6d]", // zack
//	"[Speaker]: I have to hold back on Mt.Battle.[New Line]I come here to go all out!", "[Speaker]: Come to Mt.Battle some time.[New Line]You need more training.[6d]", "[Speaker]: Maybe I should train on[New Line]Mt.Battle myself![6d]", // mick
//	"[Speaker]: You took everything from me![New Line]Years of hard work down the drain![New Line]I'll make you pay for your[New Line]insolence.", "[Speaker]: Crushing your team is so[New Line]satisfying.[6d]", "[Speaker]: aarrghh![6d]", // tyrion
//	"[Speaker]: Welcome to Orre Colosseum's[New Line]final challenge.[New Line]Let me show you what a hacker[New Line]can do!", "[Speaker]: I made the game.[New Line]What did you really expect?[6d]", "[Speaker]: Thanks for playing XG![New Line]Don't forget to check out Mt.Battle.[New Line]There's a surprise at the top. ;)[6d]", // stars
//]
//for i in 0..<replacementStrs.count {
//	strs[i].duplicateWithString(replacementStrs[i]).replace()
//}

// convert ability list to add more abilities

//increaseNumberOfAbilities()

//var unused = [Int]()
//for string in XGFiles.common_rel.stringTable.allStrings() {
//	if string.string == "_" {
//		unused.append(string.id)
//	}
//}


//let dol = XGFiles.dol.data
//var nextUnused = 0
////
//let abNames = ["Hard Shell","Magic Bounce", "Pure Heart", "Adaptability","Multilayered","Solar Power","Regenerator","Snow Warning","Refrigerate","Slush Rush","Tough Claws","Prankster","Sand Force","Sand Rush","Amplifier", "No Guard"]
//let abDes = ["Blocks projectile moves.", "Reflects status moves.","Weakens evil moves.","Powers same type moves.", "Max HP halves Damage.","Sunlight powers moves.", "Heals when switching out.","Summons hail in battle.","Makes normal moves ice.","Hail doubles speed.","Powers up contact moves.","Status moves go first.","Sandstorm powers moves.","Raises speed in sandstorm.","Powers sound moves.", "Moves always hit."]
//
//
//var nextAb = 0
//var nextDe = 0
//for i in 78 ..< (0x3A8 / 8) {
//	
//	if !(nextUnused < unused.count) {
//		break
//	}
//	
//	if !(nextAb < abNames.count) {
//		break
//	}
//	
//	let start = 0x3FCC50 + (i * 8)
//	
//	if dol.get4BytesAtOffset(start) == 0 {
//		dol.replace4BytesAtOffset(start, withBytes: UInt32(unused[nextUnused]))
//		XGFiles.common_rel.stringTable.stringWithID(unused[nextUnused])!.duplicateWithString(abNames[nextAb]).replace()
//		nextAb += 1
//		nextUnused += 1
//	}
//	
//	if dol.get4BytesAtOffset(start + 4) == 0 {
//		dol.replace4BytesAtOffset(start + 4, withBytes: UInt32(unused[nextUnused]))
//		XGFiles.common_rel.stringTable.stringWithID(unused[nextUnused])!.duplicateWithString(abDes[nextDe]).replace()
//		nextDe += 1
//		nextUnused += 1
//	}
//	
//	
//}
//
//dol.save()

//let plus = ability("plus")
//plus.name.duplicateWithString("Battery").replace()
//plus.adescription.duplicateWithString("Powers ally special moves.").replace()
//let minus = XGAbilities.ability(58)
//minus.name.duplicateWithString("Shadow Aura").replace()
//minus.adescription.duplicateWithString("Powers ally shadow moves.").replace()



//let plus = ability("plus")
//plus.name.duplicateWithString("Battery").replace()
//plus.adescription.duplicateWithString("Powers ally special moves.").replace()
//let minus = XGAbilities.ability(58)
//minus.name.duplicateWithString("Shadow Aura").replace()
//minus.adescription.duplicateWithString("Powers ally shadow moves.").replace()
//
//let anonyItems = [42,43,46,47,48,49,50,51,81,80,83,84,85,148,149,150,151,152,153,154,155,156,157,158,159,160,161,162,163,164,165,166,167,254,255,256,257,258]
//for i in anonyItems {
//	let item = XGItems.item(i)
//	item.descriptionString.duplicateWithString("_").replace()
//	item.name.duplicateWithString("_").replace()
//	let data = item.data
//	data.nameID = 0
//	data.descriptionID = 0
//	data.save()
//}
//
//
//var nextUnused = 0
//var unused = [item("stick"), item("metal powder"), item("lucky punch"), item("up-grade"), item("dragon scale"), item("deepseascale"), item("deepseatooth"), item("repel"), item("blue flute"), item("yellow flute"), item("red flute")]
//
//let itNames = ["Choice Scarf","Choice Specs","Eviolite","Wise Glasses","Muscle Band","Pixie Plate","Aura Amplifier","Aura Booster","Aura Limiter","Aura Filter","Life Orb"]
//
//let itDes = ["Raises speed[New Line]but permits only[New Line]one move.","Raises sp.atk[New Line]but permits only[New Line]one move.","Raises defenses of[New Line]Pokemon that can[New Line]Evolve.","Slightly boosts special[New Line]moves' power.","Slightly boosts physical[New Line]moves' power.","A hold item that[New Line]raises the power of[New Line]Fairy-type moves.","Boosts the power[New Line]of a pokemon's[New Line]shadow moves.","Boosts the power[New Line]of a shadow pokemon's[New Line]moves.","The wearer takes[New Line]half the damage from[New Line]shadow pokemon.","The wearer takes[New Line]half the damage from[New Line]shadow moves.","Powers up moves but the[New Line]holder loses health."]
//
//item("choice band").descriptionString.duplicateWithString("Raises attack[New Line]but permits only[New Line]one move.").replace()
//item("focus band").descriptionString.duplicateWithString("Prevents fainting at[New Line]max HP.").replace()
//item("focus band").name.duplicateWithString("Focus Sash").replace()
//
//
//var itNext = 0
//for i in 0 ..< itNames.count {
//
//	let old = unused[i].data
//	let name = old.name
//	let desc = old.descriptionString
//
//	let item = XGItems.item(i + 52).data
//	item.nameID = name.id
//	name.duplicateWithString(itNames[itNext]).replace()
//
//	item.descriptionID = desc.id
//	desc.duplicateWithString(itDes[itNext]).replace()
//	nextUnused += 1
//	itNext += 1
//	item.save()
//
//	old.nameID = 0
//	old.descriptionID = 0
//	old.save()
//
//
//}

//for i in 1 ..< kNumberOfMoves {
//
//	let data = XGMove(index: i)
//
//	data.mirrorMoveFlag = false
//	data.HMFlag = data.isShadowMove ? true : false
//	data.snatchFlag = false
//
//	data.save()
//
//}
//
//
//let auramoves = [move("aura sphere"), move("water pulse"), move("dragon pulse"), move("dark pulse"),move("shadow pulse")]
//for move in auramoves {
//	let data = move.data
//	data.mirrorMoveFlag = true
//	data.save()
//}
//
//// shadow moves use HM flag
//let shadowMovesCheckStartAddress = 0x8013d03c - kDOLtoRAMOffsetDifference
//let shadowCheckInstructions : [UInt32] = [0x9421fff0,0x7c0802a6,0x90010014,0x480014cd,0x80010014,0x7c0803a6,0x38210010,0x4e800020]
//let adol = XGFiles.dol.data
//for i in 0 ..< shadowCheckInstructions.count {
//	
//	adol.replace4BytesAtOffset(shadowMovesCheckStartAddress + (i * 4), withBytes: shadowCheckInstructions[i])
//	
//}
//
////remove move flag depedencies
//let li_r3_0 : UInt32 = 0x38600000
//let dependentOffsets = [0x8021aafc,0x801bd9e0,0x80210628,0x802187b0]
//for offset in dependentOffsets {
//	adol.replace4BytesAtOffset(offset - kDOLtoRAMOffsetDifference, withBytes: li_r3_0)
//}
//
//adol.save()


//snow warning
//let snowWarningIndex = kNumberOfAbilities + 8
//let bdol = XGFiles.dol.data
//let nops = [0x80225d24 - kDOLtoRAMOffsetDifference, 0x80225d54 - kDOLtoRAMOffsetDifference]
//for offset in nops {
//	bdol.replace4BytesAtOffset(offset, withBytes: kNopInstruction)
//}
//bdol.replace4BytesAtOffset(0x80225d4c - kDOLtoRAMOffsetDifference, withBytes: UInt32(0x2c000000 + snowWarningIndex))
//
//let rainToSnow : UInt32 = 0x80225e90 - 0x80225d7c
//let weatherStarter : [UInt32] = [0x38600000, 0x38800053, 0x4BFCD1F9 - rainToSnow, 0x5460063E, 0x28000002, 0x40820188 - rainToSnow, 0x38600000, 0x38800053, 0x38A00000, 0x4BFCD189 - rainToSnow, 0x7FE4FB78, 0x38600000, 0x4BFD09D5 - rainToSnow, 0x3C608041, 0x3863783C, 0x4BFFD8F1 - rainToSnow, kNopInstruction]
//
//let snowstart = 0x80225e90 - kDOLtoRAMOffsetDifference
//for i in 0 ..< weatherStarter.count {
//	bdol.replace4BytesAtOffset(snowstart + (i * 4), withBytes: weatherStarter[i])
//}
//
//loadAllStrings()
//getStringWithID(id: 0x4eea)!.duplicateWithString("[1e]'s [1c][New Line]activated!").replace()
//


//let dugtrio = pokemon("dugtrio").stats
//dugtrio.attack = 100
//dugtrio.save()
//
//let dodrio = pokemon("dodrio").stats
//dodrio.speed = 110
//dodrio.save()
//
//let electrode = pokemon("electrode").stats
//electrode.speed = 150
//electrode.save()
//
//let pelipper = pokemon("pelipper").stats
//pelipper.specialAttack = 95
//pelipper.save()
//
//let mantine = pokemon("mantine").stats
//mantine.hp = 85
//mantine.save()
//
//let lunatone = pokemon("lunatone").stats
//lunatone.hp = 100
//lunatone.attack = 50
//lunatone.defense = 65
//lunatone.specialDefense = 85
//lunatone.specialAttack = 105
//lunatone.speed = 50
//lunatone.save()
//
//let solrock = pokemon("solrock").stats
//solrock.hp = 100
//solrock.attack = 50
//solrock.defense = 85
//solrock.specialDefense = 65
//solrock.specialAttack = 105
//solrock.speed = 50
//solrock.save()
//
//let masquerain = pokemon("masquerain").stats
//masquerain.specialAttack = 100
//masquerain.speed = 80
//masquerain.save()

//let cdol = XGFiles.dol.data
//
////crit multipliers
//let critOffsets = [0x8020dd7c,0x8020dd8c,0x8020dd9c,0x801f0968]
//let critValues : [UInt32] = [0x38800003,0x38800002,0x38800002,0x38800002]
//
//for i in 0 ..< critOffsets.count {
//	cdol.replace4BytesAtOffset(critOffsets[i] - kDOLtoRAMOffsetDifference, withBytes: critValues[i])
//}
//
//// reverse mode residual
//cdol.replace4BytesAtOffset(0x8022811c - kDOLtoRAMOffsetDifference, withBytes: 0x38800008)
//
//// paralysis to halve speed
//cdol.replace4BytesAtOffset(0x80203adc - kDOLtoRAMOffsetDifference, withBytes: 0x56f7f87e)
//
//// choice scarf
//let choicescarfindex : UInt32 = 52
//let choiceStart = 0x80203ab4 - kDOLtoRAMOffsetDifference
//let choiceInstructions : [UInt32] = [kNopInstruction,0x7f43d378,0x4bfffdb5,0x28030000 + choicescarfindex,0x4082000C,0x1EF70003,0x56f7f87e]
//for i in 0 ..< choiceInstructions.count {
//	cdol.replace4BytesAtOffset(choiceStart + (i * 4), withBytes: choiceInstructions[i])
//}
//
//// move maintenance
//
// new shadow moves
//for m in [197,330,346] {
//	let mov = XGMoves.move(m).data
//	mov.HMFlag = true
//	mov.save()
//	let rel = XGFiles.common_rel.data
//	rel.replace4BytesAtOffset(mov.startOffset + 0x14, withBytes: 0x00023101)
//	rel.save()
//	
//}
//
//var currentDescs = [Int]()
//var currentNames = [Int]()
//
//for m in 1 ..< kNumberOfMoves {
//	let move = XGMoves.move(m)
//	currentDescs.append(move.descriptionID)
//	currentNames.append(move.nameID)
//}
//
//loadAllStrings()
//let obsoleteMoves = [129,149,74,175,298,145,287,260,343,48,155,125,217,255,288,120,107,229,138,135,259,102,2,141,292,203,249,285,262,10,18,293,190,237,256,307,294,316,335,272,208,291,128,338,244,40,80,111,119,289]
//
//
//for obs in obsoleteMoves {
//	let oName = XGOriginalMoves.move(obs).nameID
//	let oDesc = XGOriginalMoves.move(obs).descriptionID
//	let m = XGMove(index: obs)
//	m.moveName = oName
//	m.moveDescription = oDesc
//	m.type = .normal
//	m.basePower = 0
//	m.target = .selectedTarget
//	m.category = .none
//	m.effect = 0
//	m.priority = 0
//	m.pp = 1
//	m.accuracy = 0
//	m.effectAccuracy = 0
//	m.contactFlag = false
//	m.mirrorMoveFlag = false
//	m.protectFlag = false
//	m.kingsRockFlag = false
//	m.magicCoatFlag = false
//	m.soundBasedFlag = false
//	m.snatchFlag = false
//	m.HMFlag = false
//	m.save()
//	if !currentNames.contains(oName) {
//		getStringWithID(id: oName)!.duplicateWithString("*").replace()
//	}
//	if !currentDescs.contains(oDesc) {
//		getStringWithID(id: oDesc)!.duplicateWithString("*").replace()
//	}
//}

//// hard shell flag
//let hardshells = ["aura sphere", "seed bomb","focus blast","pin missile","rock throw","energy ball","ice shard","icicle crash","explosion","sludge","sludgebomb","gunk shot","rock slide","zap cannon","shadow ball","leech seed","bullet seed","icicle spear","mud shot","rock blast","shadow pulse"]
//for name in hardshells {
//	let mo = move(name).data
//	mo.snatchFlag = true
//	mo.save()
//}
//
////magic bounce
//let magicBounceBranchAddress = 0x8021855c
//let magicBounceCompareAddress = 0x80218564
//let magicBounceIndex : UInt32 = UInt32(kNumberOfAbilities + 2)
//let magicBounceBranchInstruction : UInt32 = 0x4bf3033d
//let magicBounceCompareInstruction : UInt32 = 0x28000000 + magicBounceIndex
//
//cdol.replace4BytesAtOffset(magicBounceBranchAddress - kDOLtoRAMOffsetDifference, withBytes: magicBounceBranchInstruction)
//cdol.replace4BytesAtOffset(magicBounceCompareAddress - kDOLtoRAMOffsetDifference, withBytes: magicBounceCompareInstruction)
//
//cdol.save()



//let ddol = XGFiles.dol.data
//// sheer force
//let sheerForceStart = 0x80213d6c
//let sheerForceInstructions : [UInt32] = [0x7C7C1B78,0x7FA3EB78,0x4BFF1855,0x28030023,0x4082000C,0x3BA00000,0x48000024,0x7C7D1B78,0x7F83E378,0x4BF2A925,0x281D0020,0x7C7D1B78,0x4082000C,0x54600DFC,0x7C1D0378]
//
//for i in 0 ..< sheerForceInstructions.count {
//	let offset = sheerForceStart + (i * 4) - kDOLtoRAMOffsetDifference
//	ddol.replace4BytesAtOffset(offset, withBytes: sheerForceInstructions[i])
//}
//
//// -ate abilities types
//let ateStart = 0x802c8648 - kDOLtoRAMOffsetDifference
//let ateInstructions = [0x7F83E378,0x4BE76225,0x28030000,0x408200E0,0x7FA3EB78,0x4BF3CF6D,0x28030056,0x4082000C,0x3860000F,0x480000DC,0x28030044,0x4082000C,0x38600009,0x480000CC,0x28030001,0x4082000C,0x38600002,0x480000BC,0x480000A4]
//
//for i in 0 ..< ateInstructions.count {
//	let offset = ateStart + (i * 4)
//	ddol.replace4BytesAtOffset(offset, withBytes: UInt32(ateInstructions[i]))
//}
//
//let priorityAbilitiesStart = 0x8015224c - kDOLtoRAMOffsetDifference
//let priorityAbilitiesInstructions : [UInt32] = [0x9421fff0,0x7C0802A6,0x90010014,0x93E1000C,0x93C10008,0x7C7F1B78,0x48000074,0x4BFEC551,0x28030000,0x40820050,0x7FE3FB78,0x480B3351,0x28030059,0x41820024,0x28030043,0x40820034,0x7FC3F378,0x4BFEC5e1,0x28030002,0x40820024,0x38600001,0x48000020,0x7FC3F378,0x4bfec549,0x28030000,0x4082000C,0x38600001,0x48000008,0x38600000,0x80010014,0x83E1000C,0x83C10008,0x7C0803A6,0x38210010,0x4E800020,0x480B22DD,0x7C7E1B78,0x4BFFFF88]
//
//for i in 0 ..< priorityAbilitiesInstructions.count {
//	let offset = priorityAbilitiesStart + (i * 4)
//	ddol.replace4BytesAtOffset(offset, withBytes: priorityAbilitiesInstructions[i])
//}
//
//let determineOrderOffsets = [0x801f43e8,0x801f43ec,0x801f43f4,0x801f43f8]
//let determineOrderInstructions : [UInt32] = [0x7f23cb78,0x4bf5de61,0x7f43d378,0x4bf5de55]
//
//for i in 0 ..< determineOrderOffsets.count {
//	ddol.replace4BytesAtOffset(determineOrderOffsets[i] - kDOLtoRAMOffsetDifference, withBytes: determineOrderInstructions[i])
//}
//
//ddol.save()
//let dol2 = XGFiles.dol.data
//// hard shell ability
//let hardshellindex = 78
//let hardoffset1 = 0x8022580c - kDOLtoRAMOffsetDifference
//let hardcomparison : UInt32 = 0x2c00004e
//let hardoffset2 = 0x8022582c - kDOLtoRAMOffsetDifference
//let hardbranch : UInt32 = 0x4bf18db9
//
//dol2.replace4BytesAtOffset(hardoffset1, withBytes: hardcomparison)
//dol2.replace4BytesAtOffset(hardoffset2, withBytes: hardbranch)
//
//// regenerator
//let naturalcurechangestart = 0x8021c5cc - kDOLtoRAMOffsetDifference
//let naturalcurechanges : [UInt32] = [0x7C7E1B78,0x48002559,0x7fe3fb78]
//for i in 0 ... 2 {
//	dol2.replace4BytesAtOffset(naturalcurechangestart + (i * 4), withBytes: naturalcurechanges[i])
//}
//
//let regenStart = 0x8021eb28 - kDOLtoRAMOffsetDifference
//let regenCode : [UInt32] = [0x7fe3fb78,0xa063080c,0x28030054,0x41820008,0x4e800020,0x7fe3fb78,0x80630000,0x38630004,0xA0830090,0xa0630004,0x38000003, 0x7C0403D6,0x7C630214,0x7C032040,0x40810014,0x7fe3fb78,0x80630000,0x38630004,0xA0630090,0x7C641B78,0x7fe3fb78,0x80630000,0x38630004,0xb0830004,0x4e800020]
//for i in 0 ..< regenCode.count {
//	dol2.replace4BytesAtOffset(regenStart + (i * 4), withBytes: regenCode[i])
//}
//dol2.save()
//
//
//
//// effect accuracies
//for m in ["baby doll eyes","toxic","brave bird","head smash","short circuit","snore","outrage","swagger","knock off","overheat","psycho boost","shadow star"] {
//	let mov = move(m).data
//	mov.effectAccuracy = 0
//	mov.save()
//}


//let newPokespotStart = 0x73300
//relocatePokespots(startOffset: UInt32(newPokespotStart), numberOfEntries: 25)
//
//let spotmons : [ [(name: String, minLevel: Int, maxLevel: Int, encounterPercentage: Int, stepsPerSnack: Int)] ] = [
//	// rock
//	[
//		("entei"		, 25, 25, 2,  75),
//		("jirachi"		, 10, 10, 1,  25),
//		("aerodactyl"	, 24, 27, 9, 150),
//		("ponyta"		, 15, 22, 5, 300),
//		("larvitar"		, 19, 23, 9, 100),
//		("miltank"		, 27, 32, 2, 400),
//		("sandshrew"	, 18, 23, 7, 300),
//		("sandslash"	, 28, 31, 2, 100),
//		("cacnea"		, 26, 29, 8, 400),
//		("trapinch"		, 21, 25, 6, 300),
//		("vibrava"		, 35, 35, 2,  80),
//		("onix"			, 21, 26, 2, 400),
//		("numel"		, 23, 26, 5, 400),
//		("camerupt"		, 33, 34, 1, 100),
//		("dugtrio"		, 28, 29, 2, 100),
//		("hitmontop"	, 22, 26, 8, 200),
//		("gligar"		, 23, 26, 3, 400),
//		("graveler"		, 25, 27, 2, 200),
//		("kecleon"		, 23, 25, 3, 250),
//		("electrode"	, 30, 32, 2, 150),
//		("cubone"		, 18, 23, 4, 400),
//		("marowak"		, 28, 29, 3, 100),
//		("kangaskhan"	, 22, 26, 2, 300),
//		("tauros"		, 23, 26, 4, 200),
//		("seviper"		, 24, 27, 6, 400)
//	],
//	
//	// oasis
//	[
//		("suicune"		, 25, 26, 3,  50),
//		("celebi"		, 15, 15, 1,  25),
//		("chansey"		, 17, 22, 9, 100),
//		("roselia"		, 26, 29, 2, 300),
//		("eevee"		,  5, 13, 7, 400),
//		("lanturn"		, 27, 28, 6, 200),
//		("gloom"		, 21, 24, 2, 300),
//		("persian"		, 28, 29, 2, 300),
//		("bellsprout"	, 21, 26, 6, 250),
//		("weepinbell"	, 22, 23, 2, 150),
//		("kingler"		, 28, 29, 2, 250),
//		("scyther"		, 23, 27, 7, 150),
//		("ninjask"		, 22, 28, 2, 250),
//		("exeggcute"	, 21, 26, 8, 200),
//		("feebas"		,  1,  1, 3, 100),
//		("magikarp"		,  1,  1, 8, 400),
//		("tangela"		, 24, 28, 2, 300),
//		("tentacool"	, 22, 25, 3, 400),
//		("tentacruel"	, 30, 32, 2, 150),
//		("octillery"	, 25, 27, 3, 250),
//		("vulpix"		, 18, 22, 5, 350),
//		("ninetales"	, 23, 26, 2, 150),
//		("jumpluff"		, 27, 29, 2, 200),
//		("tropius"		, 26, 29, 4, 250),
//		("swablu"		, 21, 26, 7, 350)
//	],
//	
//	// cave
//	[
//		("raikou"		, 25, 25, 2, 100),
//		("mew"			,  5,  5, 1,  25),
//		("dratini"		, 11, 22, 9, 150),
//		("absol"		, 24, 26, 7, 250),
//		("golbat"		, 22, 25, 6, 400),
//		("porygon2"		, 24, 26, 7, 300),
//		("mantine"		, 23, 25, 2, 300),
//		("wailmer"		, 22, 24, 2, 400),
//		("omanyte"		, 23, 26, 7, 150),
//		("kabuto"		, 22, 27, 7, 150),
//		("psyduck"		, 19, 24, 5, 300),
//		("golduck"		, 33, 34, 1, 100),
//		("poliwhirl"	, 25, 26, 2, 250),
//		("abra"			, 17, 21, 6, 350),
//		("kadabra"		, 19, 24, 2, 150),
//		("horsea"		, 21, 24, 3, 400),
//		("seadra"		, 32, 33, 2,  50),
//		("shellder"		, 21, 23, 5, 400),
//		("cloyster"		, 22, 25, 2, 150),
//		("crawdaunt"	, 30, 30, 7, 100),
//		("ditto"		, 20, 23, 5, 300),
//		("wooper"		, 18, 22, 3, 400),
//		("quagsire"		, 21, 24, 2, 200),
//		("mr. mime"		, 24, 26, 2, 250),
//		("qwilfish"		, 25, 27, 3, 300)
//	],
//	
//	// all
//	[
//		("bonsly"		, 10, 10, 35, 100),
//		("munchlax"		, 10, 10,  5,  50),
//		],
//]
//
//for i in 0 ... 3 {
//	let spot = XGPokeSpots(rawValue: i)!
//	let monList = spotmons[i]
//	
//	var percentageTotal = 0
//	
//	for j in 0 ..< monList.count {
//		let (name, minLevel, maxLevel, encounterPercentage, stepsPerSnack) = monList[j]
//		let mon = XGPokeSpotPokemon(index: j, pokespot: spot)
//		mon.pokemon = pokemon(name)
//		mon.minLevel = minLevel
//		mon.maxLevel = maxLevel
//		mon.encounterPercentage = encounterPercentage
//		mon.stepsPerSnack = stepsPerSnack
//		mon.save()
//		
//		percentageTotal += encounterPercentage
//	}
//	
//	if percentageTotal != 100 && spot != .all {
//		print("wrong percentage total for spot: " + spot.string, percentageTotal)
//	}
//}



//let kFirstFieldEffectEntry = 0x03fc3e0
//let kSizeOfFieldEffectEntry = 0x14
//let kNumberOfFieldEffects = 0x57
//
//let kFieldEffectDurationOffset = 0x4
//let kFieldEffectStringIDOffset = 0x12
//
//let rel = XGFiles.nameAndFolder("xg ram.raw", .Documents).data
//for i in 0 ..< kNumberOfFieldEffects {
//	let effect = kFirstFieldEffectEntry + (i * kSizeOfFieldEffectEntry)
//	let stringID = rel.get2BytesAtOffset(effect + kFieldEffectStringIDOffset)
//	let duration = rel.getByteAtOffset(effect + kFieldEffectDurationOffset)
//	print(i,getStringSafelyWithID(id: stringID),"duration: ", duration)
//}


//let iso = XGISO()
//
//for file in ["kyogre","ootachi","hanecco","groudon","kongpang","kyukon","garagara","sleeper"].map({ (str) -> String in
//	return "pkx_" + str + ".fsys"
//	}).sorted(by: { (s1, s2) -> Bool in
//	return iso.sizeForFile(s1)! < iso.sizeForFile(s2)!
//	}) {
//		print(file, iso.sizeForFile(file)!)
//}
//
//let replacements = [("robo_groudon","hanecco"),("robo_kyogre","sleeper"),("alolan_marowak","kongpang"),("alolan_ninetales","ootachi")]
//for (new,old) in replacements {
//	let oldFile = "pkx_" + old + ".fsys"
//	let oldFsys = iso.dataForFile(filename: oldFile)!
//	let fsys = XGFiles.fsys(oldFile)
//	oldFsys.file = fsys
//	oldFsys.save()
//	fsys.fsysData.shiftAndReplaceFileWithIndex(0, withFile: XGFiles.nameAndFolder(new + ".fdat", .TextureImporter).compress())
//	iso.importFiles([fsys])
//}



//let ldol = XGFiles.dol.data
//
//// stat booster (r3 index of stat to boost, r4 battle pokemon)
//let statBoosterStart = 0x8015258c - kDOLtoRAMOffsetDifference
//let statBoosterCode : [UInt32] = [0x9421ffe0,0x7c0802a6,0x90010024,0x93e1001c,0x93c10018,0x93a10014,0x93810010,
//0x7C9F2378,0x480cfed9,0x7c601b78,0x7fe3fb78,0x7c1d0378,0x38800000,0x7fa5eb78,0x38c00000,0x4bff08b5,
//0x7c7c0774,0x2c1c000c,0x4080006c,//------
//0x7fe3fb78,0x4bff64bd,0x5460043e,0x28000002,0x41820058, // ------
//0x7fe4fb78,0x38600000,0x480a418d,0x381c0001,0x7fe3fb78,0x7c070774,0x7fa5eb78,0x38800000,0x38c00000,
//0x4bfef705,0x808dbb04,0x3c608041,0x38a00011,0x38000000,0x3c840001,0x38637957,
//0x98a460a4,0x808dbb04,0x3c840001,0x980460a5,0x480d106d,
//0x80010024,0x83e1001c,0x83c10018,0x83a10014,0x83810010,0x7c0803a6,0x38210020,0x4e800020
//]
//
//for i in 0 ..< statBoosterCode.count {
//	ldol.replace4BytesAtOffset(statBoosterStart + (i * 4), withBytes: statBoosterCode[i])
//}
//
//// tailwind and trick room
//let safeguards = [0x80214040,0x8021bd6c,0x8022cd90,0x8022d538,0x8022d94c,0x8022e0fc,0x8022e244,0x8022ee48,0x80230154,0x802302f4,0x802306b8,0x80230bd0,0x802314e8,0x802ccf60,0x802de1b4]
//let mists = [0x8022c910,0x802cc790,0x802ccab4,0x802cccf8,0x802ccf40,0x802220a4,0x80210990]
//for offset in safeguards + mists {
//	ldol.replace4BytesAtOffset(offset - kDOLtoRAMOffsetDifference, withBytes: 0x38600000)
//}
//
//let tailBranchOffset = 0x801f4430 - kDOLtoRAMOffsetDifference
//let tailBranchInstruction = 0x4bf5e04d
//ldol.replace4BytesAtOffset(tailBranchOffset, withBytes: UInt32(tailBranchInstruction))
//
//let tailStart = 0x8015247c - kDOLtoRAMOffsetDifference
//let tailCode : [UInt32] = [0x9421ffe0,0x7c0802a6,0x90010024,0x93e1001c,0x93c10018,0x93a10014,0x93810010,
//0x7f23cb78,0x3880004b,0x480a6041,0x28030001,0x40820008,0x57BD083C,
//0x7f43d378,0x3880004b,0x480a6029,0x28030001,0x40820008,0x57DE083C,
//0x7f23cb78,0x3880004c,0x480a6011,0x28030001,0x40820008,0x48000018,
//0x7f43d378,0x3880004c,0x480a5ff9,0x28030001,0x4082000c,0x7C1EE840,0x48000008,0x7c1df040,
//0x80010024,0x83e1001c,0x83c10018,0x83a10014,0x83810010,0x7c0803a6,0x38210020,0x4e800020
//]
//
//for i in 0 ..< tailCode.count {
//	ldol.replace4BytesAtOffset(tailStart + (i * 4), withBytes: tailCode[i])
//}
//
//// immune to moves abilities r31 current move r3 defending ability
//let originOffset = 0x80225804 - kDOLtoRAMOffsetDifference
//let originInstructions : [UInt32] = [0x3bc00000,0x4bf2cb55,0x28030001]
//let originNopOffset = 0x80225838 - kDOLtoRAMOffsetDifference
//
//for i in 0 ..< originInstructions.count {
//	ldol.replace4BytesAtOffset(originOffset + (i * 4), withBytes: originInstructions[i])
//}
//ldol.replace4BytesAtOffset(originNopOffset, withBytes: kNopInstruction)
//
//// immunities
//let immunitiesStart = 0x8015235c - kDOLtoRAMOffsetDifference
//let immunitiesCode : [UInt32] = [0x9421ffe0,0x7c0802a6,0x90010024,0x93e1001c,0x93c10018,0x93a10014,0x93810010,
//0x7c7c1b78, // mr r28,r3
//0x7fe3fb78,0x4bfec265,0x7c7e1b78, // snatch flag in r30
//0x7fe3fb78,0x4bfec1bd,0x7C7D1B78, // sound flag in r29
//0x7fe3fb78,0x4bfec4d9,0x7C7F1B78, // move type in r31
//0x7f83e378, //mr r3,r28
//0x2803004e,0x4082000c,0x281e0001,0x41820098, // cmpwi r3,bulletproof
//0x2803002b,0x40820010,0x281d0001,0x40820008,0x48000084, // cmpwi r3, soundproof
//0x2803001f,0x40820014,0x281f000d,0x4082000c,0x38600004,0x48000064, // cmpwi r3, lightning rod
//0x2803005f,0x40820014,0x281f000d,0x4082000c,0x38600003,0x4800004c, // cmpwi r3, motor drive
//0x28030060,0x40820014,0x281f000b,0x4082000c,0x38600004,0x48000034, // cmpwi r3, storm drain
//0x28030061,0x40820014,0x281f000c,0x4082000c,0x38600001,0x4800001c, // cmpwi r3, sap sipper
//0x28030062,0x4082002c,0x281f0011,0x40820024,0x38600001,0x48000014, // cmpwi r3, justified
//0x80810014,0x48000149,	//power up
//0x38600001,0x48000010,	// immune
//0x80810014,0x48000139,	//power up
//0x38600000,				// not immune
//0x80010024,0x83e1001c,0x83c10018,0x83a10014,0x83810010,0x7c0803a6,0x38210020,0x4e800020
//]
//
//for i in 0 ..< immunitiesCode.count {
//	ldol.replace4BytesAtOffset(immunitiesStart + (i * 4), withBytes: immunitiesCode[i])
//}
//
// assault vest status moves

//
//let avBranchOffset = 0x802014ac - kDOLtoRAMOffsetDifference
//let avBranchInstruction : UInt32 = 0x4bf16619
//
//ldol.replace4BytesAtOffset(avBranchOffset, withBytes: avBranchInstruction)
//
//let assaultVestStart = 0x80117ac4 - kDOLtoRAMOffsetDifference
//let assaultVestCode : [UInt32] = [0x28030001,0x40820008,0x4e800020,0x281f004c,0x4082000c,0x38600001,0x4e800020,0x38600000,0x4e800020]
//
//for i in 0 ..< assaultVestCode.count {
//	ldol.replace4BytesAtOffset(assaultVestStart + (i * 4), withBytes: assaultVestCode[i])
//}

//ldol.replace4BytesAtOffset(0x802014b0 - kDOLtoRAMOffsetDifference, withBytes: 0x28030001)

//
//
//// allow shadow moves to use hm flag
//let shadowBranchOffsetsR0 = [0x8001c60c,0x8001c7ec,0x8001e314,0x80036c60]
//for offset in shadowBranchOffsetsR0 {
//	ldol.replace4BytesAtOffset(offset - kDOLtoRAMOffsetDifference, withBytes: createBranchAndLinkFrom(offset: offset - 0x80000000, toOffset: 0x21eb8c))
//}
//
//let shadowStart = 0x8021eb8c - kDOLtoRAMOffsetDifference
//let shadowCode : [UInt32] = [0x7C030378,0x9421fff0,0x7c0802a6,0x90010014,
//0x4bf1e4a1,0x28030001,
//0x80010014,0x7c0803a6,0x38210010,0x38000165,0x4e800020,
//0x7C641B78,
//0x1c030038,0x806d89d4,0x7c630214,//pointer to move
//0x88630012,0x28030001,0x7C832378,
//0x4d800020,0x38600000,0x4e800020
//]
//
//for i in 0 ..< shadowCode.count {
//	ldol.replace4BytesAtOffset(shadowStart + (i * 4), withBytes: shadowCode[i])
//}
//
//let shadowR3Offsets = [0x8007e6dc,0x80034e98]
//for offset in shadowR3Offsets {
//	ldol.replace4BytesAtOffset(offset - kDOLtoRAMOffsetDifference, withBytes: createBranchFrom(offset: offset - 0x80000000, toOffset: 0x21ebb8))
//}
//
//ldol.save()
//


//let origin = XGStringTable.common_relOriginal()
//var newIDs = [Int]()
//
//loadAllStrings()
//for str in allStrings {
//	if str.table == XGFiles.common_rel {
//		if str.string == "*" || str.string == "_" {
//			if str.id > 0x1000 {
//				if origin.stringSafelyWithID(str.id).string.characters.count > 3 {
//					newIDs.append(str.id)
//				}
//			}
//		}
//	}
//}
//
//let newAbs = ["Motor Drive", "Storm Drain", "Sap Sipper", "Justified","Reckless","Download","Scrappy","Skill Link","Defiant","Competitive","Snow Cloak","Magic Guard"]
//let newDescs = ["Electricity raises speed.","Water raises sp.atk.","Grass raises attack.","Dark raises attack.","Powers recoil moves.","Raises sp.atk in battle.", "Can hit ghosts.","Always 5 hits.","Drops raise attack.", "Drops raise sp.atk.","Hail boosts evasion.","Prevents side damage."]
//
//
//for i in 0 ..< newAbs.count {
//	let ab = XGAbilities.ability(95 + i)
//	ab.replaceNameID(newID: newIDs[i * 2])
//	ab.replaceDescriptionID(newID: newIDs[(i * 2) + 1])
//	getStringSafelyWithID(id: newIDs[i * 2]).duplicateWithString(newAbs[i]).replace()
//	getStringSafelyWithID(id: newIDs[(i * 2) + 1]).duplicateWithString(newDescs[i]).replace()
//}

//// trick room tailwind part 2
//let kdol = XGFiles.dol.data
//
//let tr2BranchOffset = 0x80152498 - kDOLtoRAMOffsetDifference
//let tr2BranchInstr  = createBranchFrom(offset: 0x152498, toOffset: 0x152520)
//kdol.replace4BytesAtOffset(tr2BranchOffset, withBytes: tr2BranchInstr)
//
//let tr2Start = 0x80152520 - kDOLtoRAMOffsetDifference
//let tr2Instructions : [UInt32] = [
//	0x7F24CB78,0x38600002,createBranchAndLinkFrom(offset: 0x152528, toOffset: 0x1efcac),0x7C7C1B78,
//	0x7F44D378,0x38600002,createBranchAndLinkFrom(offset: 0x152538, toOffset: 0x1efcac),0x7c7f1b78,
//	0x7F83E378,createBranchFrom(offset: 0x152544, toOffset: 0x15249c) // mr r3, r28 to continue original tr code
//]
//
//
//for i in 0 ..< tr2Instructions.count {
//	kdol.replace4BytesAtOffset(tr2Start + (i * 4), withBytes: tr2Instructions[i])
//}
//
//kdol.replace4BytesAtOffset(0x801524c8 - kDOLtoRAMOffsetDifference, withBytes: 0x7F83E378)
//for offset in [0x801524b0,0x801524e0] {
//	kdol.replace4BytesAtOffset(offset - kDOLtoRAMOffsetDifference, withBytes: 0x7FE3FB78)
//}

//// No guard
//let noguardindex = 93
//let noguardstart = 0x802178d4 - kDOLtoRAMOffsetDifference
//let noguardinstructions : [UInt32] = [kNopInstruction,0x2819005D,
//                                      0x4182000C,
//                                      0x281A005D,
//                                      0x4082000C,
//                                      0x3AC00064,
//                                      0x480000CC
//]
//
//for i in 0 ..< noguardinstructions.count {
//	kdol.replace4BytesAtOffset(noguardstart + (i * 4), withBytes: noguardinstructions[i])
//}
//
//kdol.save()
//
//switchNextPokemonAtEndOfTurn()
//paralysisHalvesSpped()


//for mon in XGDecks.DeckDarkPokemon.allPokemon.sorted(by: { (p1, p2) -> Bool in
//	return p1.shadowFleeValue < p2.shadowFleeValue
//}).filter({ (p) -> Bool in
//	return p.species.index > 0
//}) {
//	let tabs = 11 - (mon.species.name.string.characters.count)
//	var nameTab = "    "
//	for t in 0 ..< tabs {
//		nameTab += " "
//	}
//
//	print(mon.species.name, nameTab, mon.shadowFleeValue.hex(), "\t", mon.shadowAggression, "\t", mon.shadowUnknown2,"\t")
//}

//for mon in XGDecks.DeckStory.allPokemon.filter({ (p1) -> Bool in
//	return p1.unknown1 > 0
//}) {
//		let tabs = 11 - (mon.species.name.string.characters.count)
//		var nameTab = "    "
//		for t in 0 ..< tabs {
//			nameTab += " "
//		}
//	let tab = "\t"
//
//	var binary = String(mon.unknown1, radix: 2)
//	for i in 0 ..< (8 - binary.characters.count) {
//		binary = "0" + binary
//	}
//
//	print(mon.species.name,nameTab,String(format:"%2d",mon.level),tab,String(format:"%2x",mon.unknown1),binary)
//}

// skill link part 2
//let dol = XGFiles.dol.data
//
//dol.replace4BytesAtOffset(0x80221d70 - kDOLtoRAMOffsetDifference, withBytes: createBranchAndLinkFrom(offset: 0x221d70, toOffset: 0x152548))
//
//dol.save()

//let skillLinkStart = 0x80152548 - kDOLtoRAMOffsetDifference
//let skillLinkBranchOffset = 0x80221d98 - kDOLtoRAMOffsetDifference
//let skillLinkBranchInstruction = createBranchAndLinkFrom(offset: skillLinkBranchOffset, toOffset: skillLinkStart)
//let skillLinkCode : [UInt32] = [
//0x5404063e, // rlwinm	r4, r0, 0, 24, 31 (000000ff) like original code
//0x387F0648, // addi	r3, r31, 1608 turns r31 back to battle pokemon pointer
//0xa063080c, // lhz	r3, 0x080C (r3) get the pokemon's ability
//0x28030066, // compare with skill link
//0x41820008, // beq 0x8 if skill link then continue
//0x4e800020, // else return
//0x38800005, // li r4,5 load 5 turns
//0x4e800020, // return
//]
//
//let bdol = XGFiles.dol.data
//bdol.replace4BytesAtOffset(skillLinkBranchOffset, withBytes: skillLinkBranchInstruction)
//for i in 0 ..< skillLinkCode.count {
//	bdol.replace4BytesAtOffset(skillLinkStart + (i * 4), withBytes: skillLinkCode[i])
//}
//
//// foes can enter reverse mode
//let reverseOffset = 0x80226754 - kDOLtoRAMOffsetDifference
//bdol.replace4BytesAtOffset(reverseOffset, withBytes: kNopInstruction)
//
//
////// no infinite weather
//let infiniteOffsets = [0x80225dc4, 0x80225ddc,0x80225d80,0x80225d98,0x80225e20,0x80225e08]
//let infiniteReplacements : [UInt32] = [0x38800056,0x38800055,0x38800054]
//for i in 0 ..< infiniteReplacements.count {
//	let index = i * 2
//	bdol.replace4BytesAtOffset(infiniteOffsets[index] - kDOLtoRAMOffsetDifference, withBytes: infiniteReplacements[i])
//	bdol.replace4BytesAtOffset(infiniteOffsets[index + 1] - kDOLtoRAMOffsetDifference, withBytes: infiniteReplacements[i])
//}
//bdol.save()
//
//let sm = move("shadow massacre").data
//sm.priority = 0x100 - 7
//sm.save()

//var unused = [Int]()
//
//for m in 1 ..< XGDecks.DeckStory.DPKMEntries {
//	if unused.count < 8 {
//		let mon = XGTrainerPokemon(DeckData: XGDeckPokemon.dpkm(m, .DeckStory))
//		if mon.species.index == 0 {
//			unused.append(m)
//			print(m)
//		}
//	}
//}

//let newSpecs = ["marowak","nosepass"]
//let newCatch = [45,160]
//let newCount = [2500,1500]
//let newLevs = [54,29]
//let newItems = ["thick club",""]
//
//for i in 0 ..< 2 {
//	let index = 107 + i
//	
//	let ddpk = XGDeckPokemon.ddpk(index)
//	let poke = ddpk.data
//	poke.shadowCatchRate = newCatch[i]
//	let spec = pokemon(newSpecs[i])
//	poke.species = spec
//	poke.shadowCounter = newCount[i]
//	let lev = newLevs[i]
//	poke.level = lev
//	poke.moves = spec.movesForLevel(lev)
//	if newItems[i] != "" {
//		poke.item = item(newItems[i])
//	}
//	poke.shadowFleeValue = 0x80
//	poke.shadowAggression = 3
//	poke.ShadowDataInUse = true
//	
//	poke.save()
//}


//let kdol = XGFiles.dol.data
//// trick room part 3
//
//let get_pointer_index_func = 0x801f3f3c - kDOLtoRAMOffsetDifference
//let get_pointer_general_func = 0x801efcac - kDOLtoRAMOffsetDifference
//let check_status_func = 0x801f848c - kDOLtoRAMOffsetDifference
//let set_status_function = 0x801f8438 - kDOLtoRAMOffsetDifference
//let end_status_function = 0x801f8534 - kDOLtoRAMOffsetDifference
//
//let mist_start = 0x80220f94 - kDOLtoRAMOffsetDifference
//let mist_continue = 0x80220ff4 - kDOLtoRAMOffsetDifference
//let tr_start = 0x8021c268 - kDOLtoRAMOffsetDifference
//
//let label_set_status = tr_start + 0x28
//let label_end_status = tr_start + 0x5c
//let label_end		 = tr_start + 0x84
//
//kdol.replace4BytesAtOffset(mist_start, withBytes: createBranchFrom(offset: mist_start, toOffset: tr_start))
//
//let mistCode : [UInt32] = [
//	
//	0x38600000,	//0x00 li r3, 0
//	//0x04 bl get_pointer_index
//	createBranchAndLinkFrom(offset: tr_start + 0x04, toOffset: get_pointer_index_func),
//	0x7C641B78,	//0x08 mr r4, r3
//	0x38600002,	//0x0c li r3, 2
//	//0x10 bl get_pointer_general
//	createBranchAndLinkFrom(offset: tr_start + 0x10, toOffset: get_pointer_general_func),
//	0x7C7F1B78,	//0x14 mr r31, r3
//	0x3880004C,	//0x18 li r4, 76
//	//0x1c bl check_status
//	createBranchAndLinkFrom(offset: tr_start + 0x1C, toOffset: check_status_func),
//	0x28030002,	//0x20 cmpwi r3, 2
//	powerPCBranchNotEqualFromOffset(from: tr_start + 0x24, to: label_end_status),
//	// set_status: ---------------- 0x28
//	0x7fe3fb78,	//0x28 mr r3, r31
//	0x3880004C,	//0x2c li r4, 76
//	0x38a00000,	//0x30 li r5, 0
//	createBranchAndLinkFrom(offset: tr_start + 0x34, toOffset: set_status_function),
//	//0x34 bl set_status
//	0x38600001,	//0x38 li r3, 1
//	createBranchAndLinkFrom(offset: tr_start + 0x3c, toOffset: get_pointer_index_func),
//	//0x3c bl get_pointer_index
//	0x7C641B78,	//0x40 mr r4, r3
//	0x38600002,	//0x44 li r3, 2
//	createBranchAndLinkFrom(offset: tr_start + 0x48, toOffset: get_pointer_general_func),
//	//0x48 bl get_pointer_general
//	0x3880004C,	//0x4c li r4, 76
//	0x38a00000,	//0x50 li r5, 0
//	createBranchAndLinkFrom(offset: tr_start + 0x54, toOffset: set_status_function),
//	//0x54 bl set_status
//	createBranchFrom(offset: tr_start + 0x58, toOffset: label_end),
//	//0x58 b end:
//	// end_status: ---------------- 0x5c
//	0x7fe3fb78,	//0x5c mr r3, r31
//	0x3880004C,	//0x60 li r4, 76
//	createBranchAndLinkFrom(offset: tr_start + 0x64, toOffset: end_status_function),
//	//0x64 bl end_status
//	0x38600001,	//0x68 li r3, 1
//	createBranchAndLinkFrom(offset: tr_start + 0x6c, toOffset: get_pointer_index_func),
//	//0x6c bl get_pointer_index
//	0x7C641B78,	//0x70 mr r4, r3
//	0x38600002,	//0x74 li r3, 2
//	createBranchAndLinkFrom(offset: tr_start + 0x78, toOffset: get_pointer_general_func),
//	//0x78 bl get_pointer_general
//	0x3880004C,	//0x7c li r4, 76
//	createBranchAndLinkFrom(offset: tr_start + 0x80, toOffset: end_status_function),
//	//0x80 bl end_status
//	// end: ------------------------ 0x84
//	createBranchFrom(offset: tr_start + 0x84, toOffset: mist_continue)
//	//0x84 b mist_continue
//]
//
//for i in 0 ..< mistCode.count {
//	let offset = i * 4
//	let instruction = mistCode[i]
//	kdol.replace4BytesAtOffset(tr_start + offset, withBytes: instruction)
//}
//
//
//// tailwind part 3
//// removes some code to do with safeguard
//let tw_start = 0x8021342c - kDOLtoRAMOffsetDifference
//let tw_end = 0x80213450 - kDOLtoRAMOffsetDifference
//let tw_code : [UInt32] = [
//	0xa09f0002,
//	0x2804004b,
//	powerPCBranchEqualFromOffset(from: tw_start + 8, to: tw_end),
//	0x4BFE50A9,
//	0x28030001,
//	0x40820010,
//	0x807F0004
//]
//
//for i in 0 ..< tw_code.count {
//	let offset = i * 4
//	let inst = tw_code[i]
//	kdol.replace4BytesAtOffset(tw_start + offset, withBytes: inst)
//}
//
// kdol.save()
//
//
//// magic coat mirror match check
//let magicBranch = 0x80218568 - kDOLtoRAMOffsetDifference
//let magicCheckStart  = 0x80152568 - kDOLtoRAMOffsetDifference
//let magicTrueOffset  = 0x8021856c - kDOLtoRAMOffsetDifference
//let magicFalseOffset = 0x802185dc - kDOLtoRAMOffsetDifference
//let get_ability_func = 0x80148898 - kDOLtoRAMOffsetDifference
//
//replaceASM(startOffset: magicBranch, newASM: [createBranchFrom(offset: magicBranch, toOffset: magicCheckStart)])
//
//let magicCode : ASM = [
//	powerPCBranchNotEqualFromOffset(from: 0x0, to: 0x18), // bne magic false
//	0x7fa3eb78,	// mr r3, r29
//	createBranchAndLinkFrom(offset: magicCheckStart + 0x8, toOffset: get_ability_func), // bl battle_pokemon_get_ability
//	0x2803004f,	// cmpwi r3, 79
//	powerPCBranchEqualFromOffset(from: 0x10, to: 0x18), // beq magic flase
//	createBranchFrom(offset: magicCheckStart + 0x14, toOffset: magicTrueOffset), // b magic true
//	createBranchFrom(offset: magicCheckStart + 0x18, toOffset: magicFalseOffset) // b magic false
//]
//replaceASM(startOffset: magicCheckStart, newASM: magicCode)
//
//// ability activate function
//let abilityActivateStart = 0x80220708 - kDOLtoRAMOffsetDifference
//let messageParams = 0x801f6780 - kDOLtoRAMOffsetDifference
//let animSoundCallBack = 0x802236a8 - kDOLtoRAMOffsetDifference
//replaceASM(startOffset: abilityActivateStart, newASM: [
//	// code extract of animation from speed boost activation code
//	0x9421fff0,
//	0x7c0802a6,
//	0x90010014,
//	0x7C641B78,																	// mr r4, r3
//	0x38600000,																	// li r3, 0
//	createBranchAndLinkFrom(offset: abilityActivateStart + 0x14, toOffset: messageParams),
//	0x808dbb04,
//	0x3c608041,
//	0x38a00011,
//	0x38000000,
//	0x3c840001,
//	0x38637957,
//	0x98a460a4,
//	0x808dbb04,
//	0x3c840001,
//	0x980460a5,
//	createBranchAndLinkFrom(offset: abilityActivateStart + 0x40, toOffset: animSoundCallBack),
//	0x80010014,
//	0x7c0803a6,
//	0x38210010,
//	0x4e800020																	// blr
//	])
//
//// trace, download, trickster
//let entryBranch = 0x80225d18 - kDOLtoRAMOffsetDifference
//let entryStart = 0x80222554 - kDOLtoRAMOffsetDifference
//let entryEnd = 0x80225d1c - kDOLtoRAMOffsetDifference
//let traceStart = entryStart + 0x20
//let downloadStart = traceStart + 0x44
//let tricksterStart = downloadStart + 0x14
//let traceIndex : UInt32 = 36
//let downloadIndex : UInt32 = 100
//let tricksterIndex : UInt32 = 57
//let checkSetStatus = 0x8020254c - kDOLtoRAMOffsetDifference
//let setStatus = 0x802024a4 - kDOLtoRAMOffsetDifference
//let activate = 0x8015258c - kDOLtoRAMOffsetDifference
//replaceASM(startOffset: entryBranch, newASM: [createBranchFrom(offset: entryBranch, toOffset: entryStart)])
//replaceASM(startOffset: entryStart, newASM: [
//	0x5460043e,																	// rlwinm r0, r3
//	0x28000000 + traceIndex,													// cmpwi r0, trace
//	powerPCBranchEqualFromOffset(from: entryStart + 0x8, to: traceStart),		// beq traceStart:
//	0x28000000 + downloadIndex,													// cmpwi r0, download
//	powerPCBranchEqualFromOffset(from: entryStart + 0x10, to: downloadStart),	// beq downloadStart:
//	0x28000000 + tricksterIndex,												// cmpwi r0, trickster
//	powerPCBranchEqualFromOffset(from: entryStart + 0x18, to: tricksterStart),	// beq tricksterStart:
//	createBranchFrom(offset: entryStart + 0x1c, toOffset: entryEnd),			// b entryEnd
//	//traceStart: 0x20 -------->
//	0x7fe3fb78,																	// mr r3, r31
//	0x8863084d,																	// lbz r3, 0x084d(r3)
//	0x5460063f,																	// rlwinm r0, r3
//	powerPCBranchNotEqualFromOffset(from: traceStart + 0xc, to: entryEnd),		// bne entryEnd
//	0x7fe3fb78,																	// mr r3, r31
//	0x3880003c,																	// li r4, 60
//	createBranchAndLinkFrom(offset:traceStart + 0x18, toOffset: checkSetStatus),// bl checkIfCanSetStatus
//	0x28030002,																	// cmpwi r3, 2
//	powerPCBranchNotEqualFromOffset(from: 0, to: 0x14),							// bne don't set
//	0x7fe3fb78,																	// mr r3, r31
//	0x3880003c,																	// li r4, 60
//	0x38a00000,																	// li r5, 0
//	createBranchAndLinkFrom(offset: traceStart + 0x30, toOffset: setStatus),	// bl set status
//	0x7fe3fb78,																	// mr r3, r31
//	0x38800001,																	// li r4, 1
//	0x9883084d,																	// stb r4, 0x084d(r3)
//	createBranchFrom(offset: traceStart + 0x40, toOffset: entryEnd),			// b entryEnd
//	//downloadStart: 0x64 -------->
//	0x7fe3fb78,																	// mr r3, r31
//	0x7C641B78,																	// mr r4, r3
//	0x38600004,																	// li r3, 4
//	createBranchAndLinkFrom(offset: downloadStart + 0xc, toOffset: activate),	// bl activate ability (stat boost)
//	createBranchFrom(offset: downloadStart + 0x10, toOffset: entryEnd),			// b entry end
//	//tricksterStart: 0x78 -------->
//	0x7fe3fb78,																	// mr r3, r31
//	createBranchAndLinkFrom(offset: tricksterStart + 0x4, toOffset: abilityActivateStart),
//	0x38600000,	// li r3, 0
//	createBranchAndLinkFrom(offset: tricksterStart + 0x0c, toOffset: get_pointer_index_func),	// bl get_pointer_index
//	0x7C641B78,	// mr r4, r3
//	0x38600002,	// li r3, 2
//	createBranchAndLinkFrom(offset: tricksterStart + 0x18, toOffset: get_pointer_general_func), // bl get_pointer_general
//	0x7C7F1B78,	// mr r31, r3
//	0x3880004C,	// li r4, 76
//	createBranchAndLinkFrom(offset: tricksterStart + 0x24, toOffset: check_status_func), // bl check_status
//	0x28030002,	// cmpwi r3, 2
//	powerPCBranchNotEqualFromOffset(from: tricksterStart + 0x2c, to: entryEnd),
//	0x7fe3fb78,	//0x28 mr r3, r31
//	0x3880004C,	//0x2c li r4, 76
//	0x38a00000,	//0x30 li r5, 0
//	createBranchAndLinkFrom(offset: tricksterStart + 0x3c, toOffset: set_status_function), //0x34 bl set_status
//	0x38600001,	//0x38 li r3, 1
//	createBranchAndLinkFrom(offset: tricksterStart + 0x44, toOffset: get_pointer_index_func), //0x3c bl get_pointer_index
//	0x7C641B78,	//0x40 mr r4, r3
//	0x38600002,	//0x44 li r3, 2
//	createBranchAndLinkFrom(offset: tricksterStart + 0x50, toOffset: get_pointer_general_func), //0x48 bl get_pointer_general
//	0x3880004C,	//0x4c li r4, 76
//	0x38a00000,	//0x50 li r5, 0
//	createBranchAndLinkFrom(offset: tricksterStart + 0x5c, toOffset: set_status_function), //0x54 bl set_status
//	createBranchFrom(offset: tricksterStart + 0x60, toOffset: entryEnd), //0x58 b entry end:
//	])
//
//
//
//// rough skin residual
//replaceASM(startOffset: 0x80225234 - kDOLtoRAMOffsetDifference, newASM: [0x38800008])
//
//
//
//// natural cure activation message
//let naturalBranch = 0x8021c5fc - kDOLtoRAMOffsetDifference
//let naturalStart = 0x802226e4 - kDOLtoRAMOffsetDifference
//let naturalEnd = naturalBranch + 0x4
//replaceASM(startOffset: naturalBranch, newASM: [createBranchFrom(offset: naturalBranch, toOffset: naturalStart)])
//replaceASM(startOffset: naturalStart, newASM: [
//	0x7fe3fb78, // mr r3, r31
//	createBranchAndLinkFrom(offset: naturalStart + 0x4, toOffset: abilityActivateStart),
//	0x7fe3fb78, // mr r3, r31
//	createBranchFrom(offset: naturalStart + 0xc, toOffset: naturalEnd)
//	])
//
//// shadow flare belly drum effect
//let bellyBranch = 0x8021e724 - kDOLtoRAMOffsetDifference
//let bellyStart = 0x802226f4 - kDOLtoRAMOffsetDifference
//let checkShadowPokemon = 0x80149014 - kDOLtoRAMOffsetDifference
//replaceASM(startOffset: bellyBranch, newASM: [createBranchFrom(offset: bellyBranch, toOffset: bellyStart)])
//replaceASM(startOffset: bellyStart, newASM: [
//	0x80630000, // lw r3, 0 (r3)
//	0x38630004, // addi r3, 4
//	createBranchAndLinkFrom(offset: bellyStart + 0x8, toOffset: checkShadowPokemon),
//	0x28030000, // cmpwi r3, 0 check not shadow
//	powerPCBranchNotEqualFromOffset(from: 0x0, to: 0xc),
//	0x38800002, // li r4, 2
//	createBranchFrom(offset: 0x0, toOffset: 0x8),
//	0x38800003, // li r4, 3
//	0x7f83e378, // mr r3, r28
//	createBranchFrom(offset: bellyStart + 0x24, toOffset: bellyBranch + 0x4)
//	])
//
//// freeze dry
//let freezeBranches = [0x80216828,0x80216858]
//let freezeStart = 0x8022271c - kDOLtoRAMOffsetDifference
//let effectCheck = 0x80117a2c - kDOLtoRAMOffsetDifference
//for i in 0 ..< freezeBranches.count {
//	let branch = freezeBranches[i] - kDOLtoRAMOffsetDifference
//	replaceASM(startOffset: branch, newASM: [createBranchAndLinkFrom(offset: branch, toOffset: freezeStart)])
//}
//replaceASM(startOffset: freezeStart, newASM: [
//	0x281500c6, // cmpwi r21, freeze dry
//	powerPCBranchNotEqualFromOffset(from: 0x0, to: 0x14), //bne 0x14
//	0x2804000b, // cmpwi r4, water type
//	powerPCBranchNotEqualFromOffset(from: 0x0, to: 0xc), //bne 0xc
//	0x38600041, // li r3, super effective
//	0x4e800020, // blr
//	// get type matchup
//	0x1ca30030,
//	0x5480083c,
//	0x80cd89ac,
//	0x7ca50214,
//	0x3805000c,
//	0x7c66022e,
//	0x4e800020, // blr
//	])
//
//
//// shadow hunter shadow seeker
//let hunterBranch = 0x80216da0 - kDOLtoRAMOffsetDifference
//let hunterStart = 0x80222750 - kDOLtoRAMOffsetDifference
//replaceASM(startOffset: hunterBranch, newASM: [createBranchAndLinkFrom(offset: hunterBranch, toOffset: hunterStart)])
//replaceASM(startOffset: hunterStart, newASM: [
//	0x28030000, // cmpwi r3, 0
//	powerPCBranchNotEqualFromOffset(from: 0x0, to: 0xc), //bne 0xc
//	0x38000000, // li r0, 0
//	0x4e800020, // blr
//	0x7f43d378, // mr r3, r26
//	// get move data pointer
//	0x1c030038,
//	0x806d89d4,
//	0x7c630214,
//	0xa063001c, // lhz 0x001c(r3)     (get move effect)
//	0x28030015, // cmpwi r3, move effect 21 (shadow seeker/hunter)
//	powerPCBranchNotEqualFromOffset(from: 0x0, to: 0xc),
//	0x38000000, // li r0, 0
//	0x4e800020, // blr
//	0x38000001, // li r0, 1
//	0x4e800020, // blr
//	])
//
//// feint
//let feintBranch = 0x80216708 - kDOLtoRAMOffsetDifference
//let feintStart = 0x8022075c - kDOLtoRAMOffsetDifference
//let feintEnd = 0x80216728 - kDOLtoRAMOffsetDifference
//let endStatus = 0x802026a0 - kDOLtoRAMOffsetDifference
//replaceASM(startOffset: feintBranch, newASM: [createBranchFrom(offset: feintBranch, toOffset: feintStart)])
//replaceASM(startOffset: feintStart, newASM: [
//	0x7ea3ab78, // mr r3, r21
//	// get move data pointer
//	0x1c030038,
//	0x806d89d4,
//	0x7c630214,
//	0xa063001c, // lhz 0x001c(r3)     (get move effect)
//	0x28030016, // cmpwi r3, move effect 22 (feint)
//	powerPCBranchNotEqualFromOffset(from: feintStart + 0x18, to: feintStart + 0x28),
//	0x7ec3b378,	// mr r3, r22
//	0x3880002b, // li r4, protect status
//	createBranchAndLinkFrom(offset: feintStart + 0x24, toOffset: endStatus),
//	createBranchFrom(offset: feintStart + 0x28, toOffset: feintEnd),
//	])
//
//
//// foul play
//let foulBranch = 0x8022a188 - kDOLtoRAMOffsetDifference
//let foulStart = 0x8022278c - kDOLtoRAMOffsetDifference
//let foulEnd = foulBranch + 0x8
//replaceASM(startOffset: foulBranch, newASM: [createBranchFrom(offset: foulBranch, toOffset: foulStart)])
//replaceASM(startOffset: foulStart, newASM: [
//	0x7c140378, // mr r20, r0
//	0x7e238b78, // mr r3, r17
//	// get move data pointer
//	0x1c030038,
//	0x806d89d4,
//	0x7c630214,
//	0xa063001c, // lhz 0x001c(r3)     (get move effect)
//	0x2803000f, // cmpwi r3, move effect 15 (foul play)
//	powerPCBranchNotEqualFromOffset(from: 0x0, to: 0x14),
//	0x7e439378, // mr r3, r18
//	0xa0630092, // lhz r3, 0x0092(r3) (get attack)
//	0x7c601b78, // mr r0, r3
//	0x7c150378, // mr r21, r0
//	0x7e439378, // mr r3, r18
//	createBranchFrom(offset: foulStart + 0x34, toOffset: foulEnd)
//	])
//
//// facade with burn
//let facadeBranch = 0x8022a5c4 - kDOLtoRAMOffsetDifference
//let facadeStart = 0x8021e998 - kDOLtoRAMOffsetDifference
//let checkStatus = 0x802025f0 - kDOLtoRAMOffsetDifference
//replaceASM(startOffset: facadeBranch, newASM: [createBranchFrom(offset: facadeBranch, toOffset: facadeStart)])
//replaceASM(startOffset: facadeStart, newASM: [
//	0x7de37b78, // mr r3, r15
//	0x38800006, // mr r4, burn
//	createBranchAndLinkFrom(offset: facadeStart + 0x8, toOffset: checkStatus),
//	0x28030001, // cmpwi r3, 1
//	powerPCBranchNotEqualFromOffset(from: 0x10, to: 0x18),
//	0x56b50c3c, // r21 *= 2 double attack
//	0x56a3043e, // rlwinm r3, r21 (overwritted code)
//	createBranchFrom(offset: facadeStart + 0x1c, toOffset: facadeBranch + 0x4)
//	])
//
//// acrobatics
//let acroBranch = 0x8022a110 - kDOLtoRAMOffsetDifference
//let acroStart = 0x8021e9b8 - kDOLtoRAMOffsetDifference
//let acroEnd = acroBranch + 0x4
//replaceASM(startOffset: acroBranch, newASM: [createBranchFrom(offset: acroBranch, toOffset: acroStart)])
//replaceASM(startOffset: acroStart, newASM: [
//	0x7de37b78, // mr r3, r15
//	0x80630000, // lw r3, 0 (r3)
//	0x38630004, // addi r3, 4
//	0xa0630002, // lhz r3, 0x0002(r3) get item
//	0x28030000, // cmpwi r3, 0
//	powerPCBranchEqualFromOffset(from: 0x0, to: 0x8),
//	createBranchFrom(offset: 0x18, toOffset: 0x2c),
//	0x7e238b78, // mr r3, r17
//	0x280300b2, // cmpwi r3, acrobatics
//	powerPCBranchNotEqualFromOffset(from: 0x0, to: 0x8),
//	0x56b50c3c, // r21 *= 2 double attack
//	0x7de47b78,	// mr r4, r15 overwritten code
//	createBranchFrom(offset: acroStart + 0x30, toOffset: acroEnd)
//	])
//
//// thick club alolan marowak
//replaceASM(startOffset: 0x8022a4c8 - kDOLtoRAMOffsetDifference, newASM: [0x28000109])
//
//// shadow sky residual damage
//replaceASM(startOffset:0x80221320 - kDOLtoRAMOffsetDifference, newASM: [0x38800008])
//
//// remove explosion defense halving
//replaceASM(startOffset: 0x8022a780 - kDOLtoRAMOffsetDifference, newASM: [kNopInstruction])
//
//// psyshock psystrike
//let psyBranch = 0x8022a97c - kDOLtoRAMOffsetDifference
//let psyStart = 0x8021e9fc - kDOLtoRAMOffsetDifference
//let psyTrue = 0x8022a7fc - kDOLtoRAMOffsetDifference
//let psyfalse = 0x8022a980 - kDOLtoRAMOffsetDifference
//let psy2Start = 0x8021ea2c - kDOLtoRAMOffsetDifference
//let psy2Branch = 0x8022a85c - kDOLtoRAMOffsetDifference
//let psy2End = psy2Branch + 0x4
//replaceASM(startOffset: psyBranch, newASM: [createBranchFrom(offset: psyBranch, toOffset: psyStart)])
//replaceASM(startOffset: psyStart, newASM: [
//	0x7c6303d6, // divw r3, r3, r0 (overwritten by branch)
//	0x7C641B78,	// mr r4, r3
//	0x7e238b78, // mr r3, r17
//	// get move data pointer
//	0x1c030038,
//	0x806d89d4,
//	0x7c630214,
//	0xa063001c, // lhz 0x001c(r3)     (get move effect)
//	0x2803000e, // cmpwi r3, move effect 14 (psyshock)
//	0x7c832378, // mr r3, r4 (overwritten by branch)
//	powerPCBranchEqualFromOffset(from: 0x0, to: 0x8),
//	createBranchFrom(offset: psyStart + 0x20, toOffset: psyfalse),
//	createBranchFrom(offset: psyStart + 0x24, toOffset: psyTrue),
//	])
//replaceASM(startOffset: psy2Branch, newASM: [createBranchFrom(offset: psy2Branch, toOffset: psy2Start)])
//replaceASM(startOffset: psy2Start, newASM: [
//	0x28030000, // cmpwi r3, 0
//	powerPCBranchNotEqualFromOffset(from: 0x0, to: 0xc),
//	0x38000000, // li r0,0
//	createBranchFrom(offset: psy2Start + 0xc, toOffset: psy2End),
//	0x7e238b78, // mr r3, r17
//	// get move data pointer
//	0x1c030038,
//	0x806d89d4,
//	0x7c630214,
//	0xa063001c, // lhz 0x001c(r3)     (get move effect)
//	0x2803000e, // cmpwi r3, move effect 14 (psyshock)
//	powerPCBranchEqualFromOffset(from: 0x0, to: 0xc),
//	0x38000001, // li r0, 1
//	createBranchFrom(offset: psy2Start + 0x30, toOffset: psy2End),
//	0x38000000, // li r0, 0
//	createBranchFrom(offset: psy2Start + 0x38, toOffset: psy2End),
//	])
//
//// lightball attack boost
//replaceASM(startOffset: 0x8022a48c - kDOLtoRAMOffsetDifference, newASM: [
//	0x281d0019, // cmpwi r29, pikachu
//	0x4082000c, // bne 0xc
//	0x56b50c3c, // r21 *= 2 (double attack)
//	])
//
//
//// sand spdef boost for rock types
//let sandBranch = 0x8022a1c4 - kDOLtoRAMOffsetDifference
//let sandEnd = sandBranch + 0x4
//let sandStart = 0x8021db34 - kDOLtoRAMOffsetDifference
//let checkHasType = 0x802054fc - kDOLtoRAMOffsetDifference
////replaceASM(startOffset: sandBranch, newASM: [createBranchFrom(offset: sandBranch, toOffset: sandStart)])
//replaceASM(startOffset: sandStart, newASM: [
//	// sandstorm spdef boost for rock types
//	0x80010010, // lwz r0, 0x0010(sp) (load weather)
//	0x28000003, // cmpwi r0, sandstorm
//	powerPCBranchNotEqualFromOffset(from: 0x8, to: 0x34),
//	0x7e038378, // mr r3, r16
//	0x38800005, // li r4, rock type
//	createBranchAndLinkFrom(offset: sandStart + 0x14, toOffset: checkHasType),
//	0x28030001, // cmpwi r0, 1
//	powerPCBranchNotEqualFromOffset(from: 0x1c, to: 0x34),
//	// spdef x 1.5
//	0x5643043e, // rlwinm r3, r18
//	0x38000064, // li r0, 100
//	0x1c630096, // mulli r3, r3, 150
//	0x7c0303d6, // divw r0, r3, r0
//	0x5412043e, // rlwinm r18, r0
//	0x7e058378, // mr r5, r16 (overwritten by branch)
//	createBranchFrom(offset: sandStart + 0x38, toOffset: sandEnd)
//	])
//
// sheer force sand force amplifier tough claws adaptability
//let abilityBranch = 0x8022a66c - kDOLtoRAMOffsetDifference
//let abilityStart = 0x80220cec - kDOLtoRAMOffsetDifference
//let abilityEnd = abilityBranch + 0x4
//let checkHasType = 0x802054fc - kDOLtoRAMOffsetDifference
//let noBoost = 0xa8
//let boost33 = 0x94
//let noBoost50 = 0x120
//let boost50 = 0x10c
//let sandCheck = 0x80220ec0 - kDOLtoRAMOffsetDifference
//replaceASM(startOffset: abilityBranch, newASM: [createBranchFrom(offset: abilityBranch, toOffset: abilityStart)]
//	+ ASM(repeating: kNopInstruction, count: 63))
//replaceASM(startOffset: abilityStart, newASM: [
//	0x7e238b78, // mr r3, r17
//	// get move data pointer
//	0x1c030038,
//	0x806d89d4,
//	0x7c630214,
//	0x7C641B78,	// mr r4, r3
//	0x7f63db78, // mr r3, r27
//	0x28030023, // cmpwi r3, sheer force
//	powerPCBranchNotEqualFromOffset(from: 0x1c, to: 0x34),
//	0x7c832378, // mr r3, r4
//	0x88630005, // lbz r3, 0x0005 (r3) (get effect accuracy)
//	0x28030000, // cmpwi r3, 0
//	powerPCBranchEqualFromOffset(from: 0x2c, to: noBoost),
//	createBranchFrom(offset: 0x30, toOffset: boost33),
//	0x2803005c, // cmpwi r3, amplifier
//	powerPCBranchNotEqualFromOffset(from: 0x38, to: 0x50),
//	0x7c832378, // mr r3, r4
//	0x8863000b, // lbz r3, 0x000b (r3) (get sound flag)
//	0x28030000, // cmpwi r3, 0
//	powerPCBranchEqualFromOffset(from: 0x48, to: noBoost),
//	createBranchFrom(offset: 0x4c, toOffset: boost33),
//	0x28030058, // cmpwi r3, tough claws
//	powerPCBranchNotEqualFromOffset(from: 0x54, to: 0x6c),
//	0x7c832378, // mr r3, r4
//	0x88630006, // lbz r3, 0x0006 (r3) (get contact flag)
//	0x28030000, // cmpwi r3, 0
//	powerPCBranchEqualFromOffset(from: 0x64, to: noBoost),
//	createBranchFrom(offset: 0x68, toOffset: boost33),
//	0x2803005a, // cmpwi r3, sand force
//	powerPCBranchEqualFromOffset(from: abilityStart + 0x70, to: sandCheck),
//	0x28030051, // cmpwi r3, adaptability
//	powerPCBranchNotEqualFromOffset(from: 0x78, to: noBoost),
//	0x7f23cb78, // mr r3, r25
//	0x7C641B78,	// mr r4, r3
//	0x7de37b78, // mr r3, r15
//	createBranchAndLinkFrom(offset: abilityStart + 0x88, toOffset: checkHasType),
//	0x28030001, // cmpwi r3, 1
//	powerPCBranchNotEqualFromOffset(from: 0x90, to: noBoost),
//	// boost power 33%
//	0x56c3043e, // rlwinm r3, r22
//	0x38000064, // li r0, 100
//	0x1c630085, // mulli r3, 133
//	0x7c0303d6, // div r0, r3, r0
//	0x5416043e, // rlwinm r22, r0
//	// no boost
//	// 50% boosts
//	0x7f63db78, // mr r3, r27
//	0x28030042, // cmpwi r3, technician
//	powerPCBranchNotEqualFromOffset(from: 0xb0, to: 0xc4),
//	0x56c3043e, // rlwinm r3, r22
//	0x2803003c, // cmpwi r3, 60
//	powerPCBranchLessThanOrEqualFromOffset(from: 0xbc, to: boost50),
//	createBranchFrom(offset: 0xc0, toOffset: noBoost50),
//	0x28030041, // cmpwi r3, mega launcher
//	powerPCBranchNotEqualFromOffset(from: 0xc8, to: 0xe0),
//	0x7c832378, // mr r3, r4
//	0x8863000a, // lbz r3, 0x000a (r3) (get mirror move flag)
//	0x28030000, // cmpwi r3, 0
//	powerPCBranchEqualFromOffset(from: 0xd8, to: noBoost50),
//	createBranchFrom(offset: 0xdc, toOffset: boost50),
//	0x28030053, // cmpwi r3, solar power
//	powerPCBranchNotEqualFromOffset(from: 0xe4, to: noBoost50),
//	0x80010010, // lwz r0, 0x0010(sp) (load weather)
//	0x28000001, // cmpwi r0, sun
//	powerPCBranchNotEqualFromOffset(from: 0xf0, to: noBoost50),
//	// sp.atk boost 50%
//	0x5663043e, // rlwinm r3, r19
//	0x38000064, // li r0, 100
//	0x1c630096, // mulli r3, 150
//	0x7c0303d6, // div r0, r3, r0
//	0x5413043e, // rlwinm r19, r0
//	createBranchFrom(offset: 0x108, toOffset: noBoost50),
//	// boost power 50%
//	0x56c3043e, // rlwinm r3, r22
//	0x38000064, // li r0, 100
//	0x1c630096, // mulli r3, 150
//	0x7c0303d6, // div r0, r3, r0
//	0x5416043e, // rlwinm r22, r0
//	// no boost 50 - 0x120
//	createBranchFrom(offset: abilityStart + 0x120, toOffset: abilityEnd)
//	])
//// forgot to check for sand with sand force
//replaceASM(startOffset: sandCheck, newASM: [
//	0x80010010, // lwz r0, 0x0010(sp) (load weather)
//	0x28000003, // cmpwi r0, sandstorm
//	powerPCBranchNotEqualFromOffset(from: sandCheck + 0x8, to: abilityStart + noBoost),
//	createBranchFrom(offset: sandCheck + 0xc, toOffset: abilityStart + boost33)
//	])
//
//// technician mega launcher solar power
//let ability2Branch = 0x8022a670 - kDOLtoRAMOffsetDifference
//let ability2Start = 0x8022190c - kDOLtoRAMOffsetDifference
//let ability2End = ability2Branch + 0x4
//let noBoost20 = 0x88
//let boost20 = 0x74
//let reckless = 0x48
//replaceASM(startOffset: ability2Branch, newASM: [createBranchFrom(offset: ability2Branch, toOffset: ability2Start)])
//replaceASM(startOffset: ability2Start, newASM: [
//	0x7e238b78, // mr r3, r17
//	// get move data pointer
//	0x1c030038,
//	0x806d89d4,
//	0x7c630214,
//	0x7C641B78,	// mr r4, r3
//	0x88630002, // lbz r3, 0x0002 (r3) (get move type)
//	0x28030000, // cmpwi r3, normal type
//	powerPCBranchNotEqualFromOffset(from: 0x1c, to: reckless),
//	0x7c832378, // mr r3, r4
//	0x88630012, // lbz r3, 0x0012 (r3) (check if shadow move)
//	powerPCBranchEqualFromOffset(from: 0x28, to: reckless),
//	0x7f63db78, // mr r3, r27
//	0x28030001, // cmpwi r3, aerilate
//	powerPCBranchEqualFromOffset(from: 0x34, to: boost20),
//	0x28030044, // cmpwi r3, pixilate
//	powerPCBranchEqualFromOffset(from: 0x3c, to: boost20),
//	0x28030056, // cmpwi r3, refrigerate
//	powerPCBranchEqualFromOffset(from: 0x44, to: boost20),
//	// reckless - 0x48
//	0x7f63db78, // mr r3, r27
//	0x28030063, // cmpwi r3, reckless
//	powerPCBranchNotEqualFromOffset(from: 0x50, to: noBoost20),
//	0x7c832378, // mr r3, r4
//	0xa063001c, // lhz 0x001c(r3)     (get move effect)
//	// recoil move effects
//	0x2803002d, // cmpwi r3, 45
//	powerPCBranchEqualFromOffset(from: 0x60, to: boost20),
//	0x28030030, // cmpwi r3, 48
//	powerPCBranchEqualFromOffset(from: 0x68, to: boost20),
//	0x280300c6, // cmpwi r3, 198
//	powerPCBranchNotEqualFromOffset(from: 0x70, to: noBoost20),
//	// boost power 20%
//	0x56c3043e, // rlwinm r3, r22
//	0x38000064, // li r0, 100
//	0x1c630078, // mulli r3, 120
//	0x7c0303d6, // div r0, r3, r0
//	0x5416043e, // rlwinm r22, r0
//	// no boost 20
//	createBranchFrom(offset: ability2Start + 0x88, toOffset: ability2End)
//	])
//
//// multiscale fur coat pure heart
//let ability3Branch = 0x8022a674 - kDOLtoRAMOffsetDifference
//let ability3Start = 0x802227f4 - kDOLtoRAMOffsetDifference
//let ability3End = ability3Branch + 0x4
//let halfDamage = 0x7c
//let noHalfDamage = 0x90
//let checkFullHP = 0x80201d20 - kDOLtoRAMOffsetDifference
//replaceASM(startOffset: ability3Branch, newASM: [createBranchFrom(offset: ability3Branch, toOffset: ability3Start)])
//replaceASM(startOffset: ability3Start, newASM: [
//	0x7e238b78, // mr r3, r17
//	// get move data pointer
//	0x1c030038,
//	0x806d89d4,
//	0x7c630214,
//	0x7C641B78,	// mr r4, r3
//	0x80010030, // lwz r0, 0x0030 (sp) (load defending ability)
//	0x28000050, // cmpwi r0, pure heart ability
//	powerPCBranchNotEqualFromOffset(from: 0x1c, to: 0x48),
//	0x7c832378, // mr r3, r4
//	0x88630002, // lbz r3, 0x0002 (r3) (get move type)
//	0x28030011, // cmpwi r3, dark type
//	powerPCBranchEqualFromOffset(from: 0x2c, to: halfDamage),
//	0x28030007, // cmpwi r3, ghost type
//	powerPCBranchEqualFromOffset(from: 0x34, to: halfDamage),
//	0x7c832378, // mr r3, r4
//	0x88630012, // lbz r3, 0x0012 (r3) (check if shadow move)
//	powerPCBranchEqualFromOffset(from: 0x40, to: halfDamage),
//	createBranchFrom(offset: 0x44, toOffset: noHalfDamage),
//	0x2800005e, // cmpwi r0, fur coat
//	powerPCBranchNotEqualFromOffset(from: 0x4c, to: 0x64),
//	0x7c832378, // mr r3, r4
//	0x88630006, // lbz r3, 0x0006 (r3) (get contact flag)
//	0x28030001, // cmpwi r3, 1
//	powerPCBranchEqualFromOffset(from: 0x5c, to: halfDamage),
//	createBranchFrom(offset: 0x60, toOffset: noHalfDamage),
//	0x28000052, // cmpwi r0, multiscale
//	powerPCBranchNotEqualFromOffset(from: 0x68, to: noHalfDamage),
//	0x7e038378, // mr r3, r16
//	createBranchAndLinkFrom(offset: ability3Start + 0x70, toOffset: checkFullHP),
//	0x28030000, // cmpwi r3, 0
//	powerPCBranchEqualFromOffset(from: 0x78, to: noHalfDamage),
//	// half damage - 0x7c
//	0x56c3043e, // rlwinm r3, r22
//	0x38000064, // li r0, 100
//	0x1c630032, // mulli r3, 50
//	0x7c0303d6, // div r0, r3, r0
//	0x5416043e, // rlwinm r22, r0
//	// no half damage - 0x90
//	createBranchFrom(offset: ability3Start + 0x90, toOffset: ability3End)
//	])
//
//// storm drain
//let stormBranch = 0x80218a70 - kDOLtoRAMOffsetDifference
//let stormStart = 0x8022288c - kDOLtoRAMOffsetDifference
//let rodFalseOffset = 0x80218b54 - kDOLtoRAMOffsetDifference
//let rodCheckOffset = 0x80218a84 - kDOLtoRAMOffsetDifference
//let rodFalse = 0x48
//let rodCheck = 0x4c
//let getFoeWithAbility = 0x801f38d8 - kDOLtoRAMOffsetDifference
//let changeTarget = 0x80218aa4 - kDOLtoRAMOffsetDifference
//replaceASM(startOffset: stormBranch, newASM: [createBranchFrom(offset: stormBranch, toOffset: stormStart)])
//replaceASM(startOffset: stormStart, newASM: [
//	0x281b000d, // cmpwi r27, electric type
//	powerPCBranchNotEqualFromOffset(from: 0x4, to: 0x14),
//	0x281d001f, // cmpwi r29, lightning rod
//	powerPCBranchEqualFromOffset(from: 0xc, to: rodFalse),
//	createBranchFrom(offset: 0x10, toOffset: rodCheck),
//	0x281b000b, // cmpwi r27, water type
//	powerPCBranchNotEqualFromOffset(from: 0x18, to: rodFalse),
//	0x281d0060, // cmpwi r29, storm drain
//	powerPCBranchEqualFromOffset(from: 0x20, to: rodFalse),
//	// check if either foe has storm drain
//	0x7fc7f378, // mr r7, r30
//	0x38600000, // li r3, 0
//	0x38800060, // li r4, storm drain
//	0x38a00001, // li r5, 1
//	0x38c00002, // li r6, 2
//	createBranchAndLinkFrom(offset: stormStart + 0x38, toOffset: getFoeWithAbility),
//	0x28030000, // cmpwi r3, 0
//	powerPCBranchEqualFromOffset(from: 0x40, to: rodFalse),
//	// change target - 0x44
//	createBranchFrom(offset: stormStart + 0x44, toOffset: changeTarget),
//	// rod false - 0x48
//	createBranchFrom(offset: stormStart + 0x48, toOffset: rodFalseOffset),
//	// rod check - 0x4c
//	createBranchFrom(offset: stormStart + 0x4c, toOffset: rodCheckOffset),
//	])
//
//// remove old choice band
//replaceASM(startOffset: 0x8022a3a0 - kDOLtoRAMOffsetDifference, newASM: ASM(repeating: kNopInstruction, count: 8))
//
//
//
//// ddpk fix up
//let noFlee = [3,4,5,6,7,14,22,73,74,75,76,77,78,79,80]
//let aggro = [15,28,30,37,40,44,62,89,]
//let rage = [11,18,31,32,46,38,43,55,82,100,106,107,]
//let happy = [1,29,27,46,81,83,103]
//for mon in XGDecks.DeckDarkPokemon.allPokemon.filter({ (p) -> Bool in
//	return p.deckData.index != 0
//}) {
//	
//	let data = mon.deckData
//	mon.shadowFleeValue = noFlee.contains(mon.deckData.index) ? 0 : 0x80
//	
//	let index = mon.deckData.index
//	if index == 12 {
//		mon.shadowFleeValue = 80
//	}
//	
//	if index == 27 || index == 15 {
//		mon.shadowFleeValue = 70
//	}
//	
//	if index == 49 || index == 94 || index == 85 {
//		mon.shadowFleeValue = 60
//	}
//	
//	if index == 48 || index == 91 {
//		mon.shadowFleeValue = 50
//	}
//	
//	if index == 105 || index == 67 || index == 86 {
//		mon.shadowFleeValue = 40
//	}
//	
//	if index == 62 || index == 87 || index == 66 {
//		mon.shadowFleeValue = 30
//	}
//	
//	if index == 63 || index == 64 || index == 65 || index == 98 {
//		mon.shadowFleeValue = 20
//	}
//	
//	if index == 69 || index == 70 || index == 71 || index == 72 {
//		mon.shadowFleeValue = 10
//	}
//	
//	if aggro.contains(mon.deckData.index) {
//		mon.shadowAggression = 1
//	} else if rage.contains(mon.deckData.index) {
//		mon.shadowAggression = 2
//	} else if happy.contains(mon.deckData.index) {
//		mon.shadowAggression = 5
//	} else {
//		mon.shadowAggression = mon.shadowCounter <= 2000 ? 5 : (mon.shadowCounter <= 4000 ? 4 : (mon.shadowCounter <= 6000 ? 3 : (mon.shadowCounter <= 10000 ? 2 : 1)))
//	}
//	
//	mon.save()
//	
//	print(mon.deckData.index,mon.deckData.pokemon.name,mon.shadowAggression,mon.shadowFleeValue)
//}

//getStringSafelyWithID(id: 41308).duplicateWithString("[07]{01}Sun Stone").replace()
//item("moon shard").name.duplicateWithString("Moon Stone").replace()
//item("sun shard").name.duplicateWithString("Sun Stone").replace()


// allow shadow moves to use hm flag
//let shadow355Start = 0x8021e380 - kDOLtoRAMOffsetDifference
//let shadowBranchOffset355 = 0x80146eb4 - kDOLtoRAMOffsetDifference
//let shadow355End = 0x80146ebc - kDOLtoRAMOffsetDifference
//let shadowSkip = 0x80146ecc - kDOLtoRAMOffsetDifference
//
//replaceASM(startOffset: shadowBranchOffset355, newASM: [createBranchFrom(offset: shadowBranchOffset355, toOffset: shadow355Start)])
//
//replaceASM(startOffset: shadow355Start, newASM: [
//0x28030163, // cmpwi r3, 0x163
//powerPCBranchEqualFromOffset(from: 0x4, to: 0x24),
//// get move data pointer
//0x1c030038,
//0x806d89d4,
//0x7c630214,
//0x88630012, // lbz r3, 0x0012 (r3) (check if shadow move)
//0x28030001, // cmpwi r3, 1
//powerPCBranchEqualFromOffset(from: 0, to: 8),
//createBranchFrom(offset: shadow355Start + 0x20, toOffset: shadow355End),
//createBranchFrom(offset: shadow355Start + 0x24, toOffset: shadowSkip),
//])
//
//let shadow355Start2 = 0x8021db70 - kDOLtoRAMOffsetDifference
//let shadowBranchOffset3552 = 0x80146f28 - kDOLtoRAMOffsetDifference
//let shadow355End2 = 0x80146f30 - kDOLtoRAMOffsetDifference
//let shadowSkip2 = 0x80146f50 - kDOLtoRAMOffsetDifference
//replaceASM(startOffset: shadowBranchOffset3552, newASM: [createBranchFrom(offset: shadowBranchOffset3552, toOffset: shadow355Start2)])
//
//replaceASM(startOffset: shadow355Start2, newASM: [
//0x7C641B78,	// mr r4, r3
//0x28030163, // cmpwi r3, 0x163
//powerPCBranchEqualFromOffset(from: 0x8, to: 0x2c),
//// get move data pointer
//0x1c030038,
//0x806d89d4,
//0x7c630214,
//0x88630012, // lbz r3, 0x0012 (r3) (check if shadow move)
//0x28030000, // cmpwi r3, 0
//0x7c832378, // mr r3, r4
//powerPCBranchEqualFromOffset(from: 0, to: 8),
//createBranchFrom(offset: shadow355Start2 + 0x28, toOffset: shadow355End2),
//createBranchFrom(offset: shadow355Start2 + 0x2c, toOffset: shadowSkip2),
//])
//
//replaceASM(startOffset: 0x80146f38 - kDOLtoRAMOffsetDifference, newASM: [
//0x7c601b78, // mr r0, r3
//0x3c6080b9, // lis r3, 0x80b9
//0x5404103a, // rlwinm r4, r0 (x4)
//0x3803c500, // subi r0, r3, 0x3b00
//])

// calc damage 2
//let calc_boosts = 0x80229fe4 - kDOLtoRAMOffsetDifference
//let boostOffsets = [0x802dcc14,0x8020daec]
//for offset in boostOffsets {
//	replaceASM(startOffset: offset - kDOLtoRAMOffsetDifference, newASM: [createBranchAndLinkFrom(offset: offset - kDOLtoRAMOffsetDifference, toOffset: calc_boosts)])
//}

//// pixilate aerilate refrigerate
//let ateBranch  = 0x802183dc - kDOLtoRAMOffsetDifference
//let ateStart   = 0x8021dba0 - kDOLtoRAMOffsetDifference
//let ateEnd     = 0x802183e0 - kDOLtoRAMOffsetDifference
//let storeType  = 0x8013e064 - kDOLtoRAMOffsetDifference
//let getRoutine = 0x80148da8 - kDOLtoRAMOffsetDifference
//replaceASM(startOffset: ateBranch, newASM: [createBranchFrom(offset: ateBranch, toOffset: ateStart),])
//replaceASM(startOffset: ateStart, newASM: [
//0x7c791b78, // mr r3, r25
//// get move data pointer
//0x1c030038,
//0x806d89d4,
//0x7c630214,
//0x88630002, // lbz r3, 0x0002 (r3) (get move type)
//0x28030000,	// cmpwi r3, 0
//powerPCBranchEqualFromOffset(from: 0x0, to: 0x8),
//createBranchFrom(offset: 0x1c, toOffset: 0x68),
//0x7fa3eb78,	// mr r3, r29 (battle pokemon)
//createBranchAndLinkFrom(offset: ateStart + 0x24, toOffset: getRoutine),
//0x7c601b78, // mr r0, r3
//0x7fa3eb78,	// mr r3, r29 (battle pokemon)
//0xa063080c,	// lhz r3, 0x80c(r3) (get ability)
//0x28030056, // cmpwi r3, refrigerate
//powerPCBranchNotEqualFromOffset(from: 0x0, to: 0xc),
//0x3880000f, // li r4, 15
//createBranchFrom(offset: 0x40, toOffset: 0x60),
//0x28030044, // cmpwi r3, pixilate
//powerPCBranchNotEqualFromOffset(from: 0x0, to: 0xc),
//0x38800009, // li r4, 9
//createBranchFrom(offset: 0x50, toOffset: 0x60),
//0x28030001, // cmpwi r3, aerilate
//powerPCBranchNotEqualFromOffset(from: 0x0, to: 0x10),
//0x38800002, // li r4, 2
//0x7C030378, // mr r3, r0
//createBranchAndLinkFrom(offset: ateStart + 0x64, toOffset: storeType),
//0x7f23cb78, // mr r3, r25
//createBranchFrom(offset: ateStart + 0x6c, toOffset: ateEnd)
//])


// type 9 dependencies
//let type9Offsets : [(offset: Int, lenght: Int)] = [(0x802c6ecc,3),(0x802c6f7c,2),(0x802c8a9c,2),(0x802c8e28,2),(0x802cb90c,2),(0x802cb9f8,2),(0x802d9228,2),(0x802d9324,2),]
//for (offset, length) in type9Offsets {
//	removeASM(startOffset: offset - kDOLtoRAMOffsetDifference, length: length)
//}



//// calc damage boosts
//let calcOffsets = [0x802dcc14,0x8020daec,0x8021e224,0x802db020,0x8022713c,0x80216d0c]
//let calcDamageBoosts = 0x80229fe4 - kDOLtoRAMOffsetDifference
//let calcStart = 0x80220e10 - kDOLtoRAMOffsetDifference
//replaceASM(startOffset: calcStart, newASM: [
//0x9421fef0, // stwu	sp, -0x0110 (sp)
//0x7c0802a6, // mflr	r0
//0x90010114, // stw	r0, 0x0114 (sp)
//0xbdc1004c, // stmw	r14, 0x004c (sp)
//0xBDE10008, // 15
//0xBE01000c, // 16
//0xBE210010, // 17
//0xBE410014, // 18
//0xBE610018, // 19
//0xBE81001c, // 20
//0xBEA10020, // 21
//0xBEC10024, // 22
//0xBEE10028, // 23
//0xBF01002c, // 24
//0xBF210030, // 25
//0xBF410034, // 26
//0xBF610038, // 27
//0xBF81003c, // 28
//0xBFA10040, // 29
//0xBFC10044, // 30
//0xBFE10048, // 31
//createBranchAndLinkFrom(offset: calcStart + 0x54, toOffset: calcDamageBoosts),
//0xb9c1004c, // lmw	r14, 0x004c (sp)
//0xB9E10008, // 15
//0xBa01000c, // 16
//0xBa210010, // 17
//0xBa410014, // 18
//0xBa610018, // 19
//0xBa81001c, // 20
//0xBaA10020, // 21
//0xBaC10024, // 22
//0xBaE10028, // 23
//0xBb01002c, // 24
//0xBb210030, // 25
//0xBb410034, // 26
//0xBb610038, // 27
//0xBb81003c, // 28
//0xBbA10040, // 29
//0xBbC10044, // 30
//0xBbE10048, // 31
//0x80010114, // lwz	r0, 0x0114 (sp)
//0x7c0803a6, // mtlr	r0
//0x38210110, // addi	sp, sp, 272
//0x4e800020, // blr
//])
//
//
//for offset in calcOffsets {
//	let o = offset - kDOLtoRAMOffsetDifference
//	replaceASM(startOffset: o, newASM: [createBranchAndLinkFrom(offset: o, toOffset: calcStart)])
//}
////sturdy and focus sash
//let sashstart = 0x80216010 - kDOLtoRAMOffsetDifference
//replaceASM(startOffset: sashstart, newASM: [0x28170027,0x41820014,0x7fa3eb78,0x4bf3287d,0x28030005,0x40820024,0x7fa3eb78,0x4bfebcf5,0x5460063f,0x41820014,0x7fa3eb78,0x38800001,kNopInstruction])
//replaceASM(startOffset: 0x80216140 - kDOLtoRAMOffsetDifference, newASM: [0x388000c4]) // pretend pokemon is holding focus sash
//
//// sash/sturdy shedinja check
////
//let shedinjaBranch = 0x80216010 - kDOLtoRAMOffsetDifference
//let shedinjaTrueBranch = 0x80216048 - kDOLtoRAMOffsetDifference
//let shedinjaFalseBranch = 0x80216014 - kDOLtoRAMOffsetDifference
//let shedinjaCheckStart = 0x80152660 - kDOLtoRAMOffsetDifference
//
//let shedinjaCode : ASM = [
//	0x281f0001,	// cmpwi r31, 1
//	powerPCBranchEqualFromOffset(from: 0x4, to: 0x10),
//	0x28170027,	// cmpwi r23,39 (code that we overwrote with the branch)
//	createBranchFrom(offset: shedinjaCheckStart + 0xC, toOffset: shedinjaFalseBranch),
//	createBranchFrom(offset: shedinjaCheckStart + 0x10, toOffset: shedinjaTrueBranch)
//]
//
//replaceASM(startOffset: shedinjaCheckStart, newASM: shedinjaCode)
//replaceASM(startOffset: shedinjaBranch, newASM: [createBranchFrom(offset: shedinjaBranch, toOffset: shedinjaCheckStart)])
//
//
//
//
//let tmList : [[Int]] = [
//	[6,17,18,22,42,142,144,145,146,149,164,169,176,178,189,193,198,207,226,227,212,12,123,245,249,250,252,304,305,310,333,334,359,369,397,406,407,408,151,302], // tailwind
//	[406,405,397,396,395,379,376,372,371,366,359,340,339,334,333,321,317,282,281,280,265,252,250,248,244,242,240,229,228,224,199,176,157,156,146,143,142,136,130,128,126,115,113,110,89,80,78,77,59,53,38,37,36,35,34,31,6,151,241,],	// fire blast
//	[9,18,25,26,35,36,38,65,73,81,82,101,113,120,121,122,124,125,128,134,135,136,137,147,148,149,150,151,154,171,175,176,180,181,196,233,242,243,249,250,251,264,317,319,337,338,347,358,359,372,392,393,394,400,406,407,408,409,410,53],	// light pulse
//	[408,407,406,397,369,359,334,310,305,302,300,252,250,249,227,226,176,169,151,149,146,145,144,142,42,18,12,6,302],	// hurricane
//	[3,9,15,31,33,34,42,44,45,53,61,62,69,70,71,72,73,89,94,110,117,151,154,157,169,193,195,207,211,213,221,224,229,230,233,248,252,265,279,285,287,300,299,306,307,317,321,334,340,344,345,362,363,366,372,376,378,405,410,339,340,301,302,303],	// sludgewave
//	[409,392,393,394,363,359,358,355,264,251,242,210,200,196,189,182,175,176,151,124,122,121,120,113,94,171,344,354,302,73,72,65,64,63,36,35,18],	// dazzling gleam
//	[15,37,38,53,151,157,169,185,413,197,198,200,215,228,229,252,264,286,287,299,300,317,322,345,355,376,378,18],	// foul play
//	[409,403,400,399,384,355,320,227,208,181,151,82,81,9,],	// flash cannon
//	[25,26,31,33,34,35,36,53,54,55,63,64,65,80,81,82,94,101,113,115,120,121,122,125,128,130,135,137,145,147,148,149,150,151,171,175,176,180,181,182,189,193,196,197,198,199,200,205,210,224,233,241,243,242,248,249,252,264,265,279,278,287,286,296,297,317,319,320,322,337,338,345,355,358,359,362,366,372,376,378,384,392,393,394,401,402,403,404,406,407,408,409,410,302,303],	// thunder wave
//	[9,31,33,34,35,36,53,54,55,61,62,72,73,79,80,90,91,99,104,105,112,113,115,116,117,120,121,122,124,128,130,131,134,138,139,140,141,143,144,147,148,149,150,151,159,160,171,175,176,183,184,186,194,195,199,211,215,217,221,224,226,230,233,241,242,245,248,249,252,264,265,283,284,285,297,310,314,317,327,329,330,331,343,347,359,355,358,362,366,372,376,378,380,384,319,402,404,406,407,408,410,362],	// ice beam
//	[410,405,392,393,394,378,376,362,340,339,322,321,280,281,282,265,250,244,228,229,200,157,156,155,151,150,146,136,126,110,94,78,77,65,64,63,59,38,37,6,122,303,],	// will-o-wisp
//	[25,26,53,57,59,76,77,78,81,82,101,105,115,125,128,135,143,145,150,151,156,157,171,180,181,210,217,241,243,252,265,287,286,304,305,317,337,338,355,366,372,376,380,384,400,403,406,409,],	// wild charge
//	[410,409,408,407,400,399,394,393,392,378,376,362,357,356,319,252,251,249,233,200,199,196,317,151,150,124,121,103,102,94,80,65,64,63,122,303],	// trick room
//	[9,54,55,61,62,72,73,80,99,116,117,120,121,130,134,138,139,140,141,151,159,160,171,183,184,186,194,195,199,211,224,226,230,245,252,283,284,285,297,310,314,327,329,330,331,404,],	// scald
//	[408,407,406,405,397,396,395,379,378,376,372,366,359,358,340,339,338,337,334,333,321,317,282,281,280,265,252,250,244,242,241,233,229,298,224,199,176,175,157,156,151,150,149,148,147,146,143,142,136,128,126,115,113,112,110,89,80,78,77,76,59,53,38,37,36,35,34,31,6],	// flamethrower
//	[3,6,9,25,26,27,28,31,33,34,51,53,54,55,57,59,61,62,68,76,77,78,75,81,82,104,105,106,107,110,112,113,115,125,126,127,128,130,142,141,143,149,150,151,153,154,157,156,159,160,181,183,184,185,205,208,210,212,214,217,221,224,227,231,232,237,241,242,244,246,247,248,251,252,265,283,284,285,286,287,299,300,306,307,314,317,319,320,321,322,330,331,332,333,334,336,337,338,339,340,343,345,347,355,356,357,359,366,369,372,376,378,379,380,384,391,395,396,397,398,399,400,401,402,403,404,405,406,409,410],	// iron head
//	[410,409,408,407,406,404,403,402,401,400,394,393,392,384,380,379,378,376,373,366,362,359,358,357,355,338,337,320,319,317,287,286,265,252,248,243,242,241,233,217,210,200,181,180,176,175,171,151,150,149,148,147,145,143,135,131,130,128,125,121,120,115,113,112,105,101,94,82,81,53,36,35,34,31,25,26,],	// thunderbolt
//	[90,91,124,131,144,151,221,264,343,347,402,],	// freeze dry
//	[410,405,401,400,391,379,378,376,372,366,363,362,345,340,339,334,331,330,321,319,317,307,306,300,299,287,286,285,284,283,279,278,277,265,252,249,241,232,231,230,229,228,224,221,217,215,214,213,211,207,200,195,193,185,169,157,154,153,151,143,141,140,139,138,136,128,127,117,115,114,112,110,105,94,91,89,76,73,72,71,70,69,62,61,53,51,45,44,42,38,34,31,28,27,15,3,9,301,302,303],	// sludgebomb
//	[3,38,44,45,53,65,64,63,78,89,102,103,114,151,150,153,154,156,157,182,189,193,196,228,229,233,241,251,252,277,278,279,297,299,300,306,307,317,321,334,344,345,363,369,376,392,393,394,405,407,408,410,],	// energy ball
//	[410,409,408,407,406,405,404,403,402,401,400,399,398,397,396,395,394,393,392,380,376,372,366,356,357,355,347,331,330,319,317,252,249,251,241,233,200,199,196,176,175,151,150,149,148,143,142,128,124,122,115,113,80,65,64,63,53,36,35,],	// zen headbutt
//	[15,123,127,151,193,205,212,333,334,301,302,303],	// bug buzz
//	[6,9,115,130,131,142,147,148,149,151,154,160,193,230,248,252,278,277,279,333,334,359,369,372,379,384,395,396,397,406,407,408,224],	// dragon pulse
//	[31,34,57,62,68,76,107,112,115,127,128,136,142,143,150,151,157,160,185,184,208,210,212,214,217,221,232,237,241,242,248,252,282,285,307,319,336,340,355,357,366,380,384,400,401,402,403,405,410],	// super power
//	[408,407,406,405,403,402,401,400,399,397,391,384,372,369,366,359,347,343,340,339,336,334,333,332,321,320,319,314,285,284,252,248,247,246,241,232,231,221,217,214,210,208,207,195,185,413,160,159,157,154,153,151,150,149,143,142,128,115,112,105,104,103,76,75,68,62,51,34,31,28,27,9,6,3],	// earthquake
//	[31,34,128,139,141,142,151,157,208,251,252,285,195,319,320,321,334,333,339,340,401,402,403,405,],	// earth power
//	[405,372,339,340,338,334,321,305,304,282,281,280,252,250,244,229,228,198,176,157,156,151,146,142,136,126,77,78,59,38,37,18,9,],	// heat wave
//	[9,31,33,34,35,36,53,54,55,61,62,72,73,80,90,91,99,113,115,116,117,120,121,124,128,130,131,134,138,139,140,141,143,144,151,159,160,171,175,176,183,184,186,194,195,199,211,215,221,224,226,230,233,241,242,245,248,249,252,264,283,284,285,287,297,310,314,317,327,329,330,331,343,347,366,372,376,380,402,404,407,408,410],	// blizzard
//	[25,26,31,33,34,50,51,53,57,71,94,107,115,151,185,413,198,210,215,228,229,237,252,286,287,299,300,317,322,344,345,355,362,363,366,376,378,379,380,301,302],	// sucker punch
//	[3,28,31,33,34,45,53,73,89,110,151,241,252,285,287,317,366,379,],	// gunk shot
//	[410,409,408,407,400,399,394,393,392,376,362,357,356,319,264,252,251,249,242,233,200,198,196,193,199,176,151,150,124,121,103,102,94,65,64,63,36,35,],	// psyshock
//	[37,38,42,53,63,64,65,89,91,94,115,124,128,143,150,151,169,193,196,197,198,199,200,210,215,217,224,228,229,233,241,243,248,252,265,264,287,286,300,299,317,319,322,327,330,331,345,347,357,362,366,372,376,378,379,380,392,393,394,400,410,303],	// shadow ball
//	[405,403,402,401,400,397,391,384,366,355,347,340,339,336,334,321,320,319,285,284,252,248,247,246,241,237,232,231,221,217,210,208,205,195,185,413,160,159,157,154,151,143,142,141,140,139,138,128,127,115,112,105,104,99,76,75,68,57,51,34,31,28,27,279],	// rock slide
//	[3,6,31,33,34,35,36,37,38,44,45,53,59,69,70,71,77,78,89,102,103,114,128,136,146,148,149,151,153,154,156,157,176,175,181,182,189,193,217,228,229,233,241,244,250,251,252,277,278,279,280,281,282,297,299,300,306,307,317,321,333,334,338,339,340,344,345,359,363,366,369,372,376,379,405,407,408,409,],	// solar beam
//	[410,409,405,403,402,401,394,393,384,380,378,372,366,357,356,336,319,317,307,282,281,252,251,242,241,237,232,224,217,215,214,210,200,181,176,160,157,154,151,150,143,136,128,127,126,125,124,122,115,112,107,106,94,89,68,65,64,63,62,18,279],	// focus blast
//	[15,27,28,53,99,123,127,141,151,169,212,277,278,279,300,327,380,391,301,302,303],	// x-scissor
//	[410,409,408,407,406,404,403,402,401,400,384,380,376,372,366,359,355,338,337,319,317,287,286,265,252,248,243,242,241,233,217,210,200,181,176,171,151,150,149,148,147,145,143,135,128,125,121,122,113,115,112,105,104,101,82,81,53,34,31,26,25,],	// thunder
//	[6,15,18,42,53,127,142,144,145,146,151,169,176,189,193,198,207,227,249,250,252,282,279,300,304,305,310,359,302,303],	// acrobatics
//	[408,407,404,406,343,331,330,329,327,314,310,297,285,284,283,252,249,245,230,226,224,211,199,195,194,186,183,184,171,160,159,151,149,148,147,139,138,134,131,130,121,120,117,116,80,73,72,62,61,54,55,9],	// waterfall
//	[6,31,34,28,53,112,115,142,149,151,157,159,160,248,252,277,278,279,317,334,359,369,376,380,384,395,396,397,405,406,407,408,],	// dragon claw
//	[],	// toxic all except ditto
//	[6,31,33,34,37,38,53,59,77,78,126,128,136,146,151,156,157,228,229,244,250,252,265,280,281,282,287,286,304,305,317,321,339,340,376,405,406,],	// wild flare
//	[410,400,391,380,379,378,376,366,363,357,356,355,336,327,317,307,300,299,297,287,285,284,279,278,277,252,241,237,229,217,215,214,212,211,210,207,185,184,182,181,169,159,160,157,151,150,143,141,139,128,127,126,125,123,115,114,112,107,105,99,94,89,76,78,73,72,75,71,70,69,68,65,62,61,59,57,55,53,51,45,44,42,31,33,34,28,15,3,301,302,303],	// poison jab
//	[391,380,376,366,355,345,331,330,327,317,300,299,287,286,279,278,252,229,228,217,215,212,198,169,42,160,159,156,157,151,150,143,142,141,127,123,115,94,53,51,28,27,15,6,301,302,303],	// night slash
//	[9,18,25,26,35,36,37,38,53,55,63,64,65,73,82,94,101,102,103,121,124,122,150,151,153,154,171,175,176,180,181,182,196,197,198,199,200,233,242,249,252,251,264,317,319,320,322,347,376,378,392,393,394,399,400,401,402,403,407,408,409,410,303,245,],	// reflect
//	[9,18,25,26,35,36,37,38,53,55,63,64,65,73,82,94,101,102,103,121,124,122,150,151,153,154,171,175,176,180,181,182,196,197,198,199,200,233,242,249,252,251,264,317,319,320,322,347,376,378,392,393,394,399,400,401,402,403,407,408,409,410,303,245,],	// light screen
//	[408,407,406,404,343,330,331,329,327,317,314,310,297,285,284,283,252,249,245,242,241,230,226,224,211,199,195,194,186,184,183,176,175,171,160,159,151,149,148,147,139,138,134,131,130,128,121,120,117,116,115,112,99,90,91,80,72,73,61,62,54,55,53,31,34,9],	// surf
//	[3,6,9,27,28,31,34,51,53,57,59,62,68,75,76,91,99,104,105,106,107,112,115,125,126,127,128,138,139,140,141,142,143,149,151,150,154,157,159,160,181,184,185,413,194,195,205,207,208,210,211,212,213,214,215,217,221,224,227,232,231,237,241,242,244,246,247,248,252,265,282,283,284,285,287,307,314,319,320,331,332,333,334,336,339,340,347,355,357,366,369,372,376,378,380,384,391,397,400,401,402,403,405,406,409,410],	// stone edge
//	[410,409,408,407,404,403,402,401,400,399,394,393,392,378,376,372,362,357,356,347,345,329,322,319,317,300,264,252,251,249,245,242,233,224,200,198,199,196,193,186,176,175,151,150,124,122,121,120,113,103,102,94,80,65,64,63,55,36,35,303],	// psychic
//	[9,31,33,34,37,38,42,53,63,64,65,59,91,94,110,115,124,126,128,150,151,169,176,193,197,198,200,215,224,228,229,233,243,248,252,265,264,286,287,299,300,317,319,322,327,330,331,345,347,357,362,366,372,376,378,379,380,394,410,303],	// dark pulse
//
//]
//
//let tutList : [[Int]] = [
//	[], // draco meteor
//	[],	// protect ------------------------------
//	[],	// substitute --------------------------
//	[410,409,394,378,376,372,366,363,362,355,347,336,297,287,279,264,251,242,241,237,217,215,213,200,198,197,196,193,189,186,413,185,182,176,175,154,151,136,135,134,133,124,122,121,120,115,113,107,101,94,78,65,55,53,38,37,51,36,35,25,26,18,301,302,303],	// encore
//	[6,31,34,57,65,68,76,89,94,105,107,112,115,126,149,150,151,157,35,36,125,185,210,217,237,241,248,265,281,282,334,336,355,356,357,362,366,372,378,380,401,405,409,410,],	// fire punch
//	[31,34,57,65,68,76,89,94,105,107,112,115,125,149,150,151,25,26,35,36,126,6,157,181,185,210,217,237,241,248,265,279,297,336,355,356,357,362,366,372,378,380,384,400,403,409,410,],// thunder punch
//	[31,34,55,57,62,65,68,76,89,94,105,107,112,115,124,149,150,151,159,160,35,36,184,183,185,210,215,217,237,241,248,284,285,297,336,355,356,357,362,366,372,378,380,384,400,402,409,410,],	// ice punch
//	[410,409,404,402,362,347,343,331,330,329,327,317,314,310,297,287,286,283,284,285,264,252,249,248,245,242,241,230,226,224,221,215,211,200,199,195,194,186,184,183,176,175,171,160,159,151,144,139,138,140,141,134,131,130,128,124,121,120,117,116,115,113,112,99,94,91,90,80,73,72,62,61,55,54,53,36,35,31,33,34,9],	// icy wind
//	[6,18,31,33,34,37,38,53,59,105,104,110,112,115,128,130,142,151,157,159,160,154,197,215,217,228,229,198,89,210,243,244,245,248,252,264,265,278,279,284,285,286,287,299,300,322,330,331,337,338,347,355,359,366,372,376,380,384,397,405,406,],	// snarl
//	[410,394,380,379,378,376,366,363,362,355,347,345,344,336,331,330,327,322,317,372,384,320,393,392,300,299,297,287,286,285,279,278,277,265,264,252,251,250,249,248,247,246,244,243,241,237,232,231,229,228,227,217,215,212,211,210,207,200,198,197,189,413,185,184,183,176,169,160,159,157,156,151,150,142,141,136,130,128,127,126,125,124,123,122,115,110,107,105,104,101,99,94,89,78,76,73,72,71,70,69,68,62,59,57,55,53,51,42,38,37,36,35,28,27,25,26,18,15,9,6,3,301,302,303],	// taunt
//	[9,15,18,25,26,31,33,34,35,36,53,54,55,61,62,72,73,80,81,82,90,91,99,101,113,114,115,116,117,120,121,125,128,130,131,134,135,138,139,140,141,145,147,148,149,151,159,160,171,175,176,181,180,183,184,186,189,194,195,198,199,200,210,217,224,226,227,230,233,241,242,243,245,249,252,251,277,278,279,283,284,285,286,287,297,304,305,310,314,317,322,327,329,330,331,337,338,355,358,359,362,366,372,376,378,380,384,391,392,393,394,403,404,406,407,408,409,410,303],			// rain dance
//	[3,6,15,18,31,33,34,35,36,37,38,44,45,53,59,69,70,71,77,78,102,103,110,113,114,115,126,128,136,142,146,147,148,149,151,153,154,156,157,175,176,182,189,183,196,198,200,210,213,217,228,229,233,241,242,244,250,251,265,277,278,279,280,281,282,286,287,299,300,304,305,306,307,317,321,322,339,340,355,358,359,362,363,366,369,372,376,378,379,380,384,392,393,394,403,405,406,407,408,409,410,303],					// sunny day
//
//]
//
//for i in tmList {
//	for t in i {
//		if t > 415 {
//			print("tm typo: ", i, t)
//		}
//	}
//}
//
//for i in tutList {
//	for t in i {
//		if t > 415 {
//			print("tutor typo: ", i, t)
//		}
//	}
//}
//
//for tut in 0 ..< tutList.count {
//	for i in 1 ..< kNumberOfPokemon {
//		let mon = XGPokemonStats(index: i)
//
//		if mon.index == 151 {
//			mon.tutorMoves[tut] = true
//		} else if (tut == 2) || (tut == 1) {
//			mon.tutorMoves[tut] = (mon.index != 132) && (mon.index != 398)
//		} else if tut == 0 {
//			mon.tutorMoves[tut] = (mon.type1 == .dragon) || (mon.type2 == .dragon) || (mon.index == 151)
//		} else {
//			mon.tutorMoves[tut] = tutList[tut].contains(i)
//		}
//
//		mon.save()
//	}
//}
//
//for tm in 0 ..< tmList.count {
//	for i in 1 ..< kNumberOfPokemon {
//		let mon = XGPokemonStats(index: i)
//
//		if mon.index == 151 {
//			mon.learnableTMs[tm] = true
//		} else if tm == 40 {
//			mon.learnableTMs[tm] = (mon.index != 132) && (mon.index != 398)
//		} else {
//			mon.learnableTMs[tm] = tmList[tm].contains(i)
//		}
//
//		mon.save()
//	}
//}


//// aurora veil shadow veil
//let veilStart = 0x8021c7e0 - kDOLtoRAMOffsetDifference
//
//let moveRoutineSetPosition = 0x802236d4 - kDOLtoRAMOffsetDifference
//let moveRoutineUpdatePosition = 0x802236dc - kDOLtoRAMOffsetDifference
//
//let getPokemonPointer = 0x801efcac - kDOLtoRAMOffsetDifference
//let setFieldStatus = 0x801f8438 - kDOLtoRAMOffsetDifference
//let getCurrentMove = 0x80148d64 - kDOLtoRAMOffsetDifference
//let getWeather = 0x801f45d0 - kDOLtoRAMOffsetDifference
//
//replaceASM(startOffset: veilStart, newASM: [
//	0x7C7E1B78, // mr r30, r3
//	createBranchAndLinkFrom(offset: veilStart + 0x4, toOffset: getCurrentMove),
//	// get move data pointer
//	0x1c030038,
//	0x806d89d4,
//	0x7c630214,
//	0x88630012, // lbz r3, 0x0012 (r3) (check if shadow move)
//	0x28030001, // cmpwi r3, 1
//	powerPCBranchEqualFromOffset(from: 0x1c, to: 0x40),
//	0x38600000, // li r3, 0
//	0x38800001, // li r4, 1
//	createBranchAndLinkFrom(offset: veilStart + 0x28, toOffset: getWeather),
//	0x28030004, // cmpwi r3, hail
//	powerPCBranchEqualFromOffset(from: 0x30, to: 0x40),
//	0x807f0001, // lwz	r3, 0x0001 (r31)
//	createBranchAndLinkFrom(offset: veilStart + 0x38, toOffset: moveRoutineSetPosition),
//	createBranchFrom(offset: 0x3c, toOffset: 0x70),
//	0x7FC4F378, // mr r4, r30
//	0x38600002,	// li r3, 2
//	createBranchAndLinkFrom(offset: veilStart + 0x48, toOffset: getPokemonPointer),
//	0x7C7E1B78, // mr r30, r3
//	0x38800049, // li r4, light screen
//	0x38a00000, // li r5, 0
//	createBranchAndLinkFrom(offset: veilStart + 0x58, toOffset: setFieldStatus),
//	0x7fc3f378, // mr r3, r30
//	0x38800048, // li r4, reflect
//	createBranchAndLinkFrom(offset: veilStart + 0x64, toOffset: setFieldStatus),
//	0x38600005, // li r3, 5
//	createBranchAndLinkFrom(offset: veilStart + 0x6c, toOffset: moveRoutineUpdatePosition),
//])
//
//// new dpkm structure
//replaceASM(startOffset: 0x8028bac0 - kDOLtoRAMOffsetDifference, newASM: [0x8863001f, kNopInstruction])
//
//
//let mtbattleprizes : [XGItems] = [
//	item("expert belt"),
//	item("life orb"),
//	item("focus sash"),
//	item("leftovers"),
//	item("king's rock"),
//	item("scope lens"),
//	item("choice band"),
//	item("choice specs"),
//	item("choice scarf"),
//	item("assault vest"),
//	item("eviolite"),
//	item("bright powder"),
//	item("quick claw"),
//	XGTMs.tm(1).item,
//	XGTMs.tm(27).item,
//	XGTMs.tm(28).item,
//	XGTMs.tm(37).item,
//	XGTMs.tm(47).item
//]
//
//for i in 0 ..< mtbattleprizes.count {
//	let offset = 1098 + (i * 2)
//	let item = mtbattleprizes[i]
//	replaceMartItemAtOffset(offset, withItem: item)
//}
//
//// 100% accuracy in weather
//
//let weatherBranch = 0x802180e0 - kDOLtoRAMOffsetDifference
//let weatherStart  = 0x802296E4 - kDOLtoRAMOffsetDifference
//
//let accurate   = 0x802180f8 - kDOLtoRAMOffsetDifference
//let inaccurate = 0x80218100 - kDOLtoRAMOffsetDifference
//
//let rainCheck = 0x1c
//let hailCheck = 0x30
//let skyCheck  = 0x3c
//
//let aBranch = 0x48
//let iBranch = 0x44
//
//replaceASM(startOffset: weatherBranch, newASM: [createBranchFrom(offset: weatherBranch, toOffset: weatherStart)])
//replaceASM(startOffset: weatherStart, newASM: [
//	0x28030002, // cmpwi r3, rain
//	powerPCBranchEqualFromOffset(from: 0x4, to: rainCheck),
//	0x28030004, // cmpwi r3, hail
//	powerPCBranchEqualFromOffset(from: 0xc, to: hailCheck),
//	0x28030005, // cmpwi r3, shadow sky
//	powerPCBranchEqualFromOffset(from: 0x14, to: skyCheck),
//	createBranchFrom(offset: weatherStart + 0x18, toOffset: inaccurate),
//	// rain check 0x1c
//	0x281f0057, // cmpwi r31, thunder
//	powerPCBranchEqualFromOffset(from: 0x20, to: aBranch),
//	0x281f00ef, // cmpwi r31, hurricane
//	powerPCBranchEqualFromOffset(from: 0x28, to: aBranch),
//	createBranchFrom(offset: 0x2c, toOffset: iBranch),
//	// hail check 0x30
//	0x281f003b, // cmpwi r31, blizzard
//	powerPCBranchEqualFromOffset(from: 0x34, to: aBranch),
//	createBranchFrom(offset: 0x38, toOffset: iBranch),
//	// shadow sky check 0x3c
//	0x281f016a, // cmpwi r31, shadow storm
//	powerPCBranchEqualFromOffset(from: 0x40, to: aBranch),
//	//inaccurate branch 0x44
//	createBranchFrom(offset: weatherStart + iBranch, toOffset: inaccurate),
//	// accurate branch 0x48
//	createBranchFrom(offset: weatherStart + aBranch, toOffset: accurate)
//])
//replaceASM(startOffset: 0x21502c, newASM: [kNopInstruction]) // start offset is from dol not ram
//
//
//getStringSafelyWithID(id: 36811).duplicateWithString("[Speaker]: I'd like you to have these as[New Line]mementos of our battle.[Dialogue End]").replace()
//getStringSafelyWithID(id: 36816).duplicateWithString("[Player F] received Rare Candies and TM32.[Dialogue End]").replace()
//
//
//let null = XGDeckPokemon.dpkm(0, .DeckStory).data
//null.level = 0
//null.save()
//
//switchNextPokemonAtEndOfTurn()
//
//// burn residual damage to 1/16
//replaceASM(startOffset: 0x80227e64 - kDOLtoRAMOffsetDifference, newASM: [0x38800010])
//
//
//// filter tinted lens expert belt
//
//// tinted lens
//let oldLensBranch = 0x80216ac4 - kDOLtoRAMOffsetDifference
//
//let lens2Start = 0x8021c2f0 - kDOLtoRAMOffsetDifference
//replaceASM(startOffset: lens2Start, newASM: [
//
//	0x9421ffe0, // stwu	sp, -0x0020 (sp)
//	0x7c0802a6, // mflr	r0
//	0x90010024, // stw	r0, 0x0024 (sp)
//	0xbfa10014, // stmw	r29, 0x0014 (sp)
//	0x83B2009C, // lwz	r29, 0x009C (r18)
//
//	0x38600011, // li r3, 17 (attacking pokemon)
//	0x38800000, // li r4, 0
//	createBranchAndLinkFrom(offset: lens2Start + 0x1c, toOffset: 0x801efcac - kDOLtoRAMOffsetDifference), // get pokemon pointer
//	0xa063080c,	// lhz r3, 0x80c(r3)
//	0x2803006a,	// cmpwi r3, tinted lens
//	powerPCBranchNotEqualFromOffset(from: 0x28, to: 0x38), // bne lens end
//
//	0x1C7D0014,	// mullw r3, r29, 20
//	0x3800000a,	// li r0, 10
//	0x7FA303D7,	// divw r29, r3, r0
//
//	0x93B2009C, // stw	r29, 0x009C (r18)
//	0xbba10014, // lmw	r29, 0x0014 (sp)
//	0x80010024, // lwz	r0, 0x0024 (sp)
//	0x7c0803a6, // mtlr	r0
//	0x38210020, // addi	sp, sp, 32
//	0x4e800020, // blr
//])
//
//// old filter
//let oldFilterBranch = 0x80216ad4 - kDOLtoRAMOffsetDifference
//revertDolInstructionAtOffsets(offsets: [oldFilterBranch, oldLensBranch])
//
//// filter + expert belt
//let filter2Start = 0x802295F8 - kDOLtoRAMOffsetDifference
//
//let getItem = 0x8020384c - kDOLtoRAMOffsetDifference
//
//replaceASM(startOffset: filter2Start, newASM: [
//
//	0x9421ffe0, // stwu	sp, -0x0020 (sp)
//	0x7c0802a6, // mflr	r0
//	0x90010024, // stw	r0, 0x0024 (sp)
//	0xbfa10014, // stmw	r29, 0x0014 (sp)
//	0x83B2009C, // lwz	r29, 0x009C (r18)
//
//	0x38600012, // li r3, 18 (defending pokemon)
//	0x38800000, // li r4, 0
//	createBranchAndLinkFrom(offset: filter2Start + 0x1c, toOffset: 0x801efcac - kDOLtoRAMOffsetDifference), // get pokemon pointer
//	0xa063080c,	// lhz r3, 0x80c(r3) (get ability)
//	0x28030065,	// cmpwi r3, filter
//	powerPCBranchNotEqualFromOffset(from: 0x28, to: 0x5c),
//
//	0x1C7D004B,	// mullw r3, r29, 75
//	0x38000064,	// li r0, 100
//	0x7FA303D7,	// divw r29, r3, r0
//
//	0x38600011, //li r3, 17 (attacking pokemon)
//	0x38800000, // li r4, 0
//	createBranchAndLinkFrom(offset: filter2Start + 0x40, toOffset: 0x801efcac - kDOLtoRAMOffsetDifference), // get pokemon pointer
//	createBranchAndLinkFrom(offset: filter2Start + 0x44, toOffset: getItem), // get item's hold item id
//	0x28030047, // cmpwi r3, 71 (compare with expert belt)
//	powerPCBranchNotEqualFromOffset(from: 0x4c, to: 0x5c),
//
//	0x1C7D0078,	// mullw r3, r29, 120
//	0x38000064,	// li r0, 100
//	0x7FA303D7,	// divw r29, r3, r0
//
//	0x93B2009C, // stw	r29, 0x009C (r18)
//	0xbba10014, // lmw	r29, 0x0014 (sp)
//	0x80010024, // lwz	r0, 0x0024 (sp)
//	0x7c0803a6, // mtlr	r0
//	0x38210020, // addi	sp, sp, 32
//	0x4e800020, // blr
//])
//
//
//let getEffectiveness = 0x8022271c - kDOLtoRAMOffsetDifference
//
//let effectiveEnd = 0x78
//let filterCheckStart = 0x58
//let tintedCheckStart = 0x44
//let filterStart = 0x6c
//let tintedStart = 0x74
//
//let effectiveStart = 0x80229578 - kDOLtoRAMOffsetDifference
//let effectiveBranch = 0x80216840 - kDOLtoRAMOffsetDifference
//let effectiveReturn = effectiveBranch + 0x4
//
//replaceASM(startOffset: effectiveBranch, newASM: [createBranchFrom(offset: effectiveBranch, toOffset: effectiveStart)])
//replaceASM(startOffset: effectiveStart, newASM: [
//	0x7e83a378, // mr r3, r20 (move type)
//	0x7f24cb78, // mr r4, r25 (target type 1)
//	createBranchAndLinkFrom(offset: effectiveStart + 0x8, toOffset: getEffectiveness),
//	0x28030043, // cmpwi r3, no effect
//	powerPCBranchEqualFromOffset(from: 0x10, to: effectiveEnd),
//	0x28030041, // cmpwi r3, super effective
//	powerPCBranchEqualFromOffset(from: 0x18, to: filterCheckStart),
//	0x28030042, // cmpwi r3, not very effective
//	powerPCBranchEqualFromOffset(from: 0x20, to: tintedCheckStart),
//	// neutral 0x24
//	0x7e83a378, // mr r3, r20 (move type)
//	0x7f04c378, // mr r4, r24 (target type 2)
//	createBranchAndLinkFrom(offset: effectiveStart + 0x2c, toOffset: getEffectiveness),
//	0x28030041, // cmpwi r3, super effective
//	powerPCBranchEqualFromOffset(from: 0x34, to: filterStart),
//	0x28030042, // cmpwi r3, not very effective
//	powerPCBranchEqualFromOffset(from: 0x3c, to: tintedStart),
//	createBranchFrom(offset: 0x40, toOffset: effectiveEnd),
//	// tinted check start 0x44
//	0x7e83a378, // mr r3, r20 (move type)
//	0x7f04c378, // mr r4, r24 (target type 2)
//	createBranchAndLinkFrom(offset: effectiveStart + 0x4c, toOffset: getEffectiveness),
//	0x28030041, // cmpwi r3, super effective
//	powerPCBranchNotEqualFromOffset(from: 0x54, to: tintedStart),
//	// filter check start 0x58
//	0x7e83a378, // mr r3, r20 (move type)
//	0x7f04c378, // mr r4, r24 (target type 2)
//	createBranchAndLinkFrom(offset: effectiveStart + 0x60, toOffset: getEffectiveness),
//	0x28030042, // cmpwi r3, not very effective
//	powerPCBranchEqualFromOffset(from: 0x68, to: effectiveEnd),
//	// filter expert belt start 0x6c
//	createBranchAndLinkFrom(offset: effectiveStart + 0x6c, toOffset: filter2Start),
//	createBranchFrom(offset: 0x70, toOffset: effectiveEnd),
//	// tinted lens start 0x74
//	createBranchAndLinkFrom(offset: effectiveStart + 0x74, toOffset: lens2Start),
//	// effectiveEnd 0x78
//	0x5723043e, // rlwinm r3, r25 overwritten code
//	createBranchFrom(offset: effectiveStart + 0x7c, toOffset: effectiveReturn),
//])
//
//
//// life orb
//let lifeBranch = 0x802250f4 - kDOLtoRAMOffsetDifference
//let lifeStart = 0x80222630 - kDOLtoRAMOffsetDifference
//let lifeEnd = lifeBranch + 0x4 // oh wow, what a grim variable name XD
//let lifeCodeEnd = 0x64
//
//let getMovePower = 0x8013e71c - kDOLtoRAMOffsetDifference
//let getItem = 0x8020384c - kDOLtoRAMOffsetDifference
//let animSoundCallBack = 0x802236a8 - kDOLtoRAMOffsetDifference
//
//replaceASM(startOffset: lifeBranch, newASM: [createBranchFrom(offset: lifeBranch, toOffset: lifeStart)])
//replaceASM(startOffset: lifeStart, newASM: [
//	0x7fc3f378, // mr r3, r30 (pokemon pointer)
//	createBranchAndLinkFrom(offset: lifeStart + 0x4, toOffset: getItem), // get item's hold item id
//	0x2803004b, // cmpwi r3, 75 (compare with life orb)
//	powerPCBranchNotEqualFromOffset(from: 0xc, to: lifeCodeEnd),
//	0x7fc3f378, // mr r3, r30 (pokemon pointer)
//	0xa063080c,	// lhz r3, 0x80c(r3) (get ability)
//	0x28030023, // cmpwi r3, sheer force
//	powerPCBranchEqualFromOffset(from: 0x1c, to: lifeCodeEnd),
//	0x281a0000, // cmpwi r26, 0 (check if move failed),
//	powerPCBranchEqualFromOffset(from: 0x24, to: lifeCodeEnd),
//	0x7ea3ab78, // mr r3, r21
//	createBranchAndLinkFrom(offset: lifeStart + 0x2c, toOffset: getMovePower),
//	0x28030001, // cmpwi r3, 1
//	powerPCBranchLessThanOrEqualFromOffset(from: 0x34, to: lifeCodeEnd),
//	0x7fc3f378, // mr r3, r30 (pokemon pointer)
//	0x80630000, // lw r3, 0 (r3)
//	0x38630004, // addi r3, 4
//	0xa0830090, // lhz r4, 0x0090 (r3) (get max hp)
//	0x3800000a, // li r0, 10
//	0x7C8403D6, // divw r4, r4, r0 (max hp / 10)
//	0x7e439378, // mr r3, r18 (move routine pointer)
//	0x9083009c, // store hp to lose
//	0x3c608041, // lis r3, 8041
//	0x386374df, // addi r3, r3, 29919 (reverse mode residual damage animation
//	createBranchAndLinkFrom(offset: lifeStart + 0x60, toOffset: animSoundCallBack),
//	0x38600000, // rlwinm r3, 0 (code that was overwritten by branch)
//	createBranchFrom(offset: lifeStart + 0x68, toOffset: lifeEnd)
//])
//
//renameZaprong(newName: "BonBon")
//
//// shadow terrain
//let terrainBranch = 0x8022a60c - kDOLtoRAMOffsetDifference
//let terrainStart = 0x8021e9ec - kDOLtoRAMOffsetDifference
//let terrainTrue = 0x8022a618 - kDOLtoRAMOffsetDifference
//let terrainFalse = 0x8022a63c - kDOLtoRAMOffsetDifference
//let checkShadowMove = 0x8013d03c - kDOLtoRAMOffsetDifference
//replaceASM(startOffset: terrainBranch, newASM: [
//	0x7e238b78, // mr r3, r17
//	createBranchAndLinkFrom(offset: terrainBranch + 0x4, toOffset: checkShadowMove),
//	createBranchFrom(offset: terrainBranch + 0x8, toOffset: terrainStart),
//	])
//replaceASM(startOffset: terrainStart, newASM: [
//	0x28030001, // cmpwi r3, 1 check shadow move
//	powerPCBranchEqualFromOffset(from: 0x0, to: 0x8),
//	createBranchFrom(offset: terrainStart + 0x8, toOffset: terrainTrue),
//	createBranchFrom(offset: terrainStart + 0xc, toOffset: terrainFalse)
//	])
//
//
//let lastShadow = XGDeckPokemon.ddpk(108).data
//lastShadow.ShadowDataInUse = false
//lastShadow.shadowAggression = 0
//lastShadow.shadowFleeValue = 0
//lastShadow.save()
//
//let nosepass = XGDeckPokemon.ddpk(89).data
//nosepass.shadowAggression = 5
//nosepass.save()


//let gen4Evos = ["murkrow","electabuzz","magmar","gligar","sneasel","piloswine","yanma","rhydon","roselia","dusclops","aipom","magneton",
//                "misdreavus","nosepass","porygon2","tangela","togetic","lickitung"]
//
//for mon in gen4Evos {
//	let stats = pokemon(mon).stats
////	stats.evolutions[0] = XGEvolution(evolutionMethod: XGEvolutionMethods.Gen4.rawValue, condition: 0, evolvedForm: 0)
//	print(stats.evolutions[0].toInts())
////	stats.save()
//}


//// items
//let checkShadowPokemon = 0x80149014 - kDOLtoRAMOffsetDifference
//let itemBranch = 0x8022a678 - kDOLtoRAMOffsetDifference
//let itemStart = 0x802219e0 - kDOLtoRAMOffsetDifference
//let itemEnd = itemBranch + 0x4
//let itemBuff = 0x68
//let itemNerf = 0x104
//let defenderStart = 0x80
//let defenderEnd = 0x118
//let getStats = 0x80146078 - kDOLtoRAMOffsetDifference
//let getEvolutionMethod = 0x80145c18 - kDOLtoRAMOffsetDifference
//let getItemParameter = 0x80203828 - kDOLtoRAMOffsetDifference
//replaceASM(startOffset: itemBranch, newASM: [createBranchFrom(offset: itemBranch, toOffset: itemStart)])
//replaceASM(startOffset: itemStart, newASM: [
//	// attacker items
//	0x281c0046, // cmpwi r28, pixie plate
//	powerPCBranchNotEqualFromOffset(from: 0x4, to: 0x10),
//	0x28190009, // cmpwi r25, fairy type
//	powerPCBranchEqualFromOffset(from: 0xc, to: itemBuff),
//	0x281c004b, // cmpwi r28, life orb
//	powerPCBranchEqualFromOffset(from: 0x14, to: itemBuff),
//	0x281c0048, // cmpwi r28, aura booster
//	powerPCBranchNotEqualFromOffset(from: 0x1c, to: 0x38),
//	0x7de37b78, // mr r3, r15
//	0x80630000, // lw r3, 0 (r3)
//	0x38630004, // addi r3, 4
//	createBranchAndLinkFrom(offset: itemStart + 0x2c, toOffset: checkShadowPokemon),
//	0x28030001, // cmpwi r3, 1
//	powerPCBranchEqualFromOffset(from: 0x34, to: itemBuff),
//	// get raw item index
//	0x7de37b78, // mr r3, r15
//	0x80630000, // lw r3, 0 (r3)
//	0x38630004, // addi r3, 4
//	0xa0630002, // lhz r3, 0x0002 (r3) // get item index
//	0x280300ba, // cmpwi r3, choice band
//	powerPCBranchNotEqualFromOffset(from: 0x4c, to: 0x58),
//	0x28180001, // cmpwi r24, physical
//	powerPCBranchEqualFromOffset(from: 0x54, to: itemBuff),
//	0x28030035, // cmpwi r3, choice specs
//	powerPCBranchNotEqualFromOffset(from: 0x5c, to: defenderStart),
//	0x28180002, // cmpwi r24, special
//	powerPCBranchNotEqualFromOffset(from: 0x64, to: defenderStart),
//	// item buff - 0x68
//	0x80810020, // lwz r4, 0x0020 (sp)
//	0x56c6043e, // rlwinm r6, r22
//	0x7cc621d6, // mullw r6, r6, r4
//	0x38800064, // li r4, 100
//	0x7c8623d6, // divw r4, r6, r4
//	0x5496043E, // rlwinm r22, r4
//	// defender start - 0x80
//	0x281e004c, // cmpwi r30, assault vest
//	powerPCBranchNotEqualFromOffset(from: 0x84, to: 0x94),
//	0x1E520096, // mulli r18, r18, 150
//	0x38000064, // li r0, 100
//	0x7E5203D6, // divw	r18, r18, r0
//	0x281e0049, // cmpwi r30, aura filter
//	powerPCBranchNotEqualFromOffset(from: 0x98, to: 0xb4),
//	0x7de37b78, // mr r3, r15
//	// 0xa0
//	0x80630000, // lw r3, 0 (r3)
//	0x38630004, // addi r3, 4
//	createBranchAndLinkFrom(offset: itemStart + 0xa8, toOffset: checkShadowPokemon),
//	0x28030001, // cmpwi r3, 1
//	powerPCBranchEqualFromOffset(from: 0xb0, to: itemNerf),
//	0x281e004a, // cmpwi r30, aura armour
//	powerPCBranchNotEqualFromOffset(from: 0xb8, to: 0xdc),
//	0x28180001, // cmpwi r24, physical
//	powerPCBranchNotEqualFromOffset(from: 0xc0, to: 0xdc),
//	0x7e038378, // mr r3, r16
//	0x80630000, // lw r3, 0 (r3)
//	0x38630004, // addi r3, 4
//	createBranchAndLinkFrom(offset: itemStart + 0xd0, toOffset: checkShadowPokemon),
//	0x28030001, // cmpwi r3, 1
//	powerPCBranchEqualFromOffset(from: 0xd8, to: itemNerf),
//	0x281e0043, // cmpwi r30, eviolite
//	powerPCBranchNotEqualFromOffset(from: 0xe0, to: defenderEnd),
//	0x7e038378, // mr r3, r16
//	0x80630000, // lw r3, 0 (r3)
//	0xa0630004, // lhz r3, 0x0004 (r3) // get species
//	createBranchAndLinkFrom(offset: itemStart + 0xf0, toOffset: getStats),
//	0x38800000, // li r4, 0
//	createBranchAndLinkFrom(offset: itemStart + 0xf8, toOffset: getEvolutionMethod),
//	0x28030000, // cmpwi r3, 0
//	powerPCBranchEqualFromOffset(from: 0x100, to: defenderEnd),
//	// item nerf - 0x104
//	0x7e038378, // mr r3, r16
//	createBranchAndLinkFrom(offset: itemStart + 0x108, toOffset: getItemParameter),
//	0x7ED619D6, // mullw r22, r22, r3
//	0x38800064, // li r4, 100
//	0x7ED623D6, // divw r22, r22, r4
//	// defender end - 0x118
//	createBranchFrom(offset: itemStart + 0x118, toOffset: itemEnd)
//])

//// aura animation
//let auraAnimation = 0x80205c9c - kDOLtoRAMOffsetDifference
//
//let auraStart   = 0x80229734 - kDOLtoRAMOffsetDifference
//
//let auraBranch = 0x80215e08 - kDOLtoRAMOffsetDifference
//
//let checkStatus = 0x802025f0 - kDOLtoRAMOffsetDifference
//let getCurrentMove = 0x80148d64 - kDOLtoRAMOffsetDifference
//
//replaceASM(startOffset: auraBranch, newASM: [createBranchAndLinkFrom(offset: auraBranch, toOffset: auraStart)])
//replaceASM(startOffset: auraStart, newASM: [
//
//	0x9421ffe0, // stwu	sp, -0x0020 (sp)
//	0x7c0802a6, // mflr	r0
//	0x90010024, // stw	r0, 0x0024 (sp)
//	0xbfa10014, // stmw	r29, 0x0014 (sp)
//
//	0x38600011, // li r3, 17 (attacking pokemon)
//	0x38800000, // li r4, 0
//	createBranchAndLinkFrom(offset: auraStart + 0x18, toOffset: 0x801efcac - kDOLtoRAMOffsetDifference), // get pokemon pointer
//	0x7C7D1B78,	// mr r29, r3
//
//	0x3880003e, // li r4, reverse mode
//	createBranchAndLinkFrom(offset: auraStart + 0x24, toOffset: checkStatus),
//	0x28030001, // cmpwi r3, 1
//	powerPCBranchNotEqualFromOffset(from: 0x2c, to: 0x5c),
//
//	0x7fa3eb78,	// mr r3, r29
//	0x38800001,
//	0x38a00001,
//	0x38c00000,
//	createBranchAndLinkFrom(offset: auraStart + 0x40, toOffset: auraAnimation),
//
//	0x7fa3eb78,	// mr r3, r29
//	0x38800001,
//	0x38a00001,
//	0x38c00001,
//	createBranchAndLinkFrom(offset: auraStart + 0x54, toOffset: auraAnimation),
//	createBranchFrom(offset: 0x58, toOffset: 0xa4),
//
//	0x7fa3eb78,	// mr r3, r29
//	createBranchAndLinkFrom(offset: auraStart + 0x60, toOffset: getCurrentMove),
//	// get move data pointer
//	0x1c030038,
//	0x806d89d4,
//	0x7c630214,
//	0x88630012, // lbz r3, 0x0012 (r3) (check if shadow move)
//	0x28030001, // cmpwi r3, 1
//	powerPCBranchNotEqualFromOffset(from: 0x78, to: 0xa4),
//
//	0x7fa3eb78,	// mr r3, r29
//	0x38800000,
//	0x38a00000,
//	0x38c00000,
//	createBranchAndLinkFrom(offset: auraStart + 0x8c, toOffset: auraAnimation),
//
//	0x7fa3eb78,	// mr r3, r29
//	0x38800000,
//	0x38a00000,
//	0x38c00001,
//	createBranchAndLinkFrom(offset: auraStart + 0xa0, toOffset: auraAnimation),
//
//	0xbba10014, // lmw	r29, 0x0014 (sp)
//	0x80010024, // lwz	r0, 0x0024 (sp)
//	0x7c0803a6, // mtlr	r0
//	0x38210020, // addi	sp, sp, 32
//
//	0x800dbb18, // lwz	r0, -0x44E8 (r13) overwritten code
//
//	0x4e800020, // blr
//])


//let suicune = XGISO().dataForFile(filename: "pkx_suikun.fsys")!
//let entei = XGISO().dataForFile(filename: "pkx_entei.fsys")!
//let raikou = XGISO().dataForFile(filename: "pkx_raikou.fsys")!
//
//let shedinja = XGISO().dataForFile(filename: "pkx_nukenin.fsys")!
//
//let models = [suicune,entei,raikou, shedinja]
//
//for model in models {
//	model.save()
//	let fsys = model.file.fsysData
//	let pkx = fsys.decompressedDataForFileWithIndex(index: 0)!
//	pkx.save()
//	let file = pkx.file.data
//	let ow = XGUtility.convertFromPKXToOverWorldModel(pkx: file)
//	ow.file = .nameAndFolder(pkx.file.fileName + " OW", .Documents)
//	ow.save()
//
//}

//let shade = XGFiles.nameAndFolder("diveball_open.fdat", .TextureImporter).compress()
//XGFiles.fsys("wzx_diveball_open.fsys").fsysData.replaceFile(file: shade)
//XGUtility.compileForRelease(XG: true)

//let faces = XGFiles.fsys("poke_face.fsys").fsysData
//let marowak = XGFiles.nameAndFolder("face048.fdat", .Output).compress()
//let ninetails = XGFiles.nameAndFolder("face162.fdat", .Output).compress()
//faces.replaceFile(file: marowak)
//faces.replaceFile(file: ninetails)
//
//
//let wak = XGPokemon.pokemon(265).stats
//let tails = XGPokemon.pokemon(264).stats
//wak.faceIndex = 48
//tails.faceIndex = 162
//wak.save()
//tails.save()
//

//		XGFiles.fsys("field_common.fsys").fsysData.shiftAndReplaceFileWithIndex(8, withFile: .lzss("uv_icn_type_big_00.fdat.lzss"))
//		XGFiles.fsys("field_common.fsys").fsysData.shiftAndReplaceFileWithIndex(9, withFile: .lzss("uv_icn_type_small_00.fdat.lzss"))

//		XGFiles.fsys("fight_common.fsys").fsysData.shiftAndReplaceFileWithIndex(15, withFile: .lzss("uv_icn_type_big_00.fdat.lzss"))
//		XGFiles.fsys("fight_common.fsys").fsysData.shiftAndReplaceFileWithIndex(16, withFile: .lzss("uv_icn_type_small_00.fdat.lzss"))

//		XGFiles.nameAndFolder("title.fsys",.MenuFSYS).fsysData.shiftAndReplaceFileWithIndex(4, withFile: .lzss("title_start_bg.fdat.lzss"))
//		XGFiles.nameAndFolder("title.fsys",.MenuFSYS).fsysData.shiftAndReplaceFileWithIndex(12, withFile: .lzss("title_start_00.fdat.lzss"))

// turn pokedance textures into regular textures
//for tex in ["garagara","kyukon","kongpang","ootachi"] {
//	for name in [tex + ".fdat", tex + "_c.fdat"] {
//		let file = XGFiles.texture(name).data
//		file.deleteBytes(start: 0, count: 0xa0)
//		file.save()
//	}
//}

//let diveballfsys = ["wzx_snatch_attack_dive.fsys","wzx_snatch_ball_land_dive.fsys","wzx_snatch_miss_dive.fsys","wzx_snatch_shake_dive.fsys","wzx_throw_dive.fsys","wzx_yasei_ball_land_dive.fsys","wzx_yasei_get_dive.fsys","wzx_yasei_poke_out_dive.fsys","wzx_yasei_shake_dive.fsys"]
//let diveballfdat = ["snatch_attack_dive.fdat","snatch_ball_land_dive.fdat","snatch_miss_dive.fdat","snatch_shake_dive.fdat","throw_dive.fdat","yasei_ball_land_dive.fdat","yasei_get_dive.fdat","yasei_poke_out_dive.fdat","yasei_shake_dive.fdat"]
//for i in 0 ..< diveballfsys.count {
//	let fsys = XGFiles.fsys(diveballfsys[i]).fsysData
//	let fdat = XGFiles.nameAndFolder(diveballfdat[i], .TextureImporter).compress()
//	fsys.replaceFile(file: fdat)
//}

//let a = XGFiles.nameAndFolder("esaba_A.fsys", .AutoFSYS).fsysData
//let b = XGFiles.nameAndFolder("esaba_B.fsys", .AutoFSYS).fsysData
//let c = XGFiles.nameAndFolder("esaba_C.fsys", .AutoFSYS).fsysData
//let shedinja = XGFiles.nameAndFolder("nukenin_ow.fdat", .TextureImporter).compress()
//for i in [5,6,10] {
//	a.replaceFileWithIndex(i, withFile: shedinja)
//	c.replaceFileWithIndex(i, withFile: shedinja)
//}
//for i in [5,6,8] {
//	b.replaceFileWithIndex(i, withFile: shedinja)
//}
//
//for file in [a,b,c] {
//	file.shiftUpFileWithIndex(index: 2)
//}
//for i in 5 ... 10 {
//	a.shiftUpFileWithIndex(index: i)
//	c.shiftUpFileWithIndex(index: i)
//	if i < 9 {
//		b.shiftUpFileWithIndex(index: i)
//	}
//}
//let suicune = XGFiles.nameAndFolder("suikun_ow.fdat", .TextureImporter).compress()
//let entei   = XGFiles.nameAndFolder("entei_ow.fdat", .TextureImporter).compress()
//let raikou  = XGFiles.nameAndFolder("raikou_ow.fdat", .TextureImporter).compress()
//a.replaceFileWithIndex(10, withFile: entei)
//b.replaceFileWithIndex(8, withFile: suicune)
//c.replaceFileWithIndex(10, withFile: raikou)

//let photo = item("bonsly photo")
//photo.name.duplicateWithString("XG000 Photo").replace()
//photo.descriptionString.duplicateWithString("An ominous photo...").replace()

//let deck = XGDecks.DeckStory
//let new = deck.unusedPokemonCount(14)
//
//let species = [12,20,24,40,47,83,108,178,203,206,219,226,289,292,308,312,316,348,349,389]
//
//for i in 0 ... 13 {
//	let dd = XGDeckPokemon.ddpk(108 + i)
//	dd.setDPKMIndexForDDPK(newIndex: new[i].DPKMIndex)
//	let d = dd.data
//	d.shadowAggression = 1
//	d.shadowCounter = 5000
//	d.shadowFleeValue = 0
//	d.level = 60
//	d.shadowCatchRate = 30
//	d.ShadowDataInUse = true
//	d.shadowUnknown2 = XGDeckPokemon.ddpk(80).data.shadowUnknown2
//	d.shadowMoves[0] = move("shadow rush")
//	d.species = .pokemon(species[i])
//	d.moves[0] = move("latent power")
//	d.save()
//}

//let tmList : [[Int]] = [
//	[12,83,178,226,292,312,], // tailwind
//	[20,24,40,108,203,219,289,308,316,349,],	// fire blast
//	[12,20,108,178,203,206,289,292,308,316,348,349,],	// light pulse
//	[12,178,226,292,312,],	// hurricane
//	[12,20,24,47,219,289,389,],	// sludgewave
//	[12,40,108,203,206,292,316,348,349,],	// dazzling gleam
//	[20,24,40,83,108,203,206,289,308,316,],	// foul play
//	[108,203,292,348,349,],	// flash cannon
//	[12,20,24,40,83,108,178,203,206,219,226,289,292,308,312,316,348,349,389,],	// thunder wave
//	[20,40,108,203,206,226,289,308,316,348,],	// ice beam
//	[178,203,219,348,349,],	// will-o-wisp
//	[20,108,203,289,308,316,],	// wild charge
//	[12,178,203,348,349,],	// trick room
//	[226,312,],	// scald
//	[20,24,40,108,203,206,219,289,308,316,349,],	// flamethrower
//	[12,20,24,40,47,83,108,178,203,206,219,289,308,312,316,348,349,389,],	// iron head
//	[20,40,108,203,206,289,308,316,348,349,],	// thunderbolt
//	[316,],	// freeze dry
//	[12,20,24,47,108,206,219,289,292,308,312,316,389,],	// sludgebomb
//	[12,47,108,178,203,206,219,292,312,316,348,349,389,],	// energy ball
//	[12,47,206,292,312,],	// bug buzz
//	[24,206,],	// dragon pulse
//	[20,24,108,289,308,],	// super power
//	[108,203,219,308,348,349,389,],	// earthquake
//	[206,219,348,349,389,],	// earth power
//	[83,178,206,219,349,],	// heat wave
//	[20,40,108,203,206,226,289,308,316,348,],	// blizzard
//	[12,20,24,83,108,203,289,308,316,],	// sucker punch
//	[20,24,47,108,219,289,316,389,],	// gunk shot
//	[12,40,178,203,206,292,312,316,348,349,],	// psyshock
//	[12,20,24,40,108,178,203,206,219,289,308,312,316,348,349,],	// shadow ball
//	[20,108,206,219,289,308,316,348,349,389,],	// rock slide
//	[12,20,40,47,108,203,206,219,289,292,308,316,349,389,],	// solar beam
//	[12,20,40,108,178,203,289,308,316,],	// focus blast
//	[47,83,312,],	// x-scissor
//	[20,40,108,203,206,289,308,316,],	// thunder
//	[12,24,83,178,206,226,289,292,308,312,316,],	// acrobatics
//	[108,226,289,312,316,],	// waterfall
//	[289,],	// dragon claw
//	[],	// toxic all except ditto
//	[20,108,203,219,289,308,316,349,],	// wild flare
//	[12,20,24,47,83,108,206,289,292,308,316,389,],	// poison jab
//	[20,47,83,289,316,],	// night slash
//	[12,40,108,178,203,206,219,226,292,308,312,316,348,349,389,],	// reflect
//	[12,40,108,178,203,206,219,226,292,308,312,316,348,349,389,],	// light screen
//	[40,108,203,226,289,308,312,316,],	// surf
//	[20,219,289,308,348,349,389,],	// stone edge
//	[12,40,108,178,203,206,292,312,316,348,349,],	// psychic
//	[24,108,178,203,289,316,348,349,],	// dark pulse
//
//]
//
//let tutList : [[Int]] = [
//	[], // draco meteor
//	[],	// protect ------------------------------
//	[],	// substitute --------------------------
//	[40,108,308,],	// fire punch
//	[40,108,308,],// thunder punch
//	[40,108,308,],	// ice punch
//	[40,108,203,206,226,289,308,312,348,],	// icy wind
//	[108,203,289,],	// snarl
//	[12,24,40,47,83,108,178,203,219,226,289,292,308,312,348,349,389,],	// taunt
//	[12,24,40,47,83,108,178,203,206,226,289,292,308,312,348,389,], // rain dance
//	[12,24,40,47,83,108,178,203,206,219,289,292,308,312,348,349,389,], // sunny day
//
//]
//
//for i in tmList {
//	for t in i {
//		if t > 415 {
//			print("tm typo: ", i, t)
//		}
//	}
//}
//
//for i in tutList {
//	for t in i {
//		if t > 415 {
//			print("tutor typo: ", i, t)
//		}
//	}
//}
//
//let tmMons = [12,20,24,40,47,83,108,178,203,206,219,226,289,292,308,312,316,348,349,389,]
//
//for tut in 0 ..< tutList.count {
//	for i in tmMons {
//		let mon = XGPokemonStats(index: i)
//
//		if (tut == 2) || (tut == 1) {
//			mon.tutorMoves[tut] = (mon.index != 132) && (mon.index != 398)
//		} else if tut == 0 {
//			mon.tutorMoves[tut] = (mon.type1 == .dragon) || (mon.type2 == .dragon)
//		} else {
//			mon.tutorMoves[tut] = tutList[tut].contains(i)
//		}
//
//		mon.save()
//	}
//}
//
//for tm in 0 ..< tmList.count {
//	for i in tmMons {
//		let mon = XGPokemonStats(index: i)
//
//		if tm == 40 {
//			mon.learnableTMs[tm] = (mon.index != 132) && (mon.index != 398)
//		} else {
//			mon.learnableTMs[tm] = tmList[tm].contains(i)
//		}
//
//		mon.save()
//	}
//}

//// copy level up moves
//for (to, from) in [(1,3),(2,3),(7,9),(8,9),(16,18),(17,18),(19,20),(23,24),(30,31),(33,34),(39,40),(41,42),(43,44),(46,47),(50,51),(52,53),(56,57),(58,59),(60,61),(66,67),(74,75),(98,99),(100,101),(109,110),(111,112),(137,233),(152,153),(155,156),(158,159),(163,164),(170,171),(177,178),(179,180),(188,189),(204,205),(209,210),(216,217),(218,219),(288,289),(295,297),(296,297),(309,310),(313,314),(315,316),(318,319),(335,336),(341,343),(342,343),(364,366),(365,366),(370,372),(371,372),(382,384),(383,384),(388,389),(390,391),] {
//	let f = XGPokemonStats(index: from)
//	let t = XGPokemonStats(index: to)
//	t.levelUpMoves = f.levelUpMoves
//	t.learnableTMs = f.learnableTMs
//	t.tutorMoves = f.tutorMoves
//	t.save()
//}

//// shadow pokemon can't be battled after being captured
//let checkCaught = 0x14b024 - kDOLtoRAMOffsetDifference
//
//let shadowBattleBranch1 = 0x1fabf0 - kDOLtoRAMOffsetDifference
//let shadowBattleStart1  = 0x220ed0 - kDOLtoRAMOffsetDifference
//// r20 stored shadow data start
////
//replaceASM(startOffset: shadowBattleBranch1, newASM: [
//	XGUtility.createBranchFrom(offset: shadowBattleBranch1, toOffset: shadowBattleStart1),
//])
//replaceASM(startOffset: shadowBattleStart1, newASM: [
//	0x7e83a378, // mr r3, r20
//	XGUtility.createBranchAndLinkFrom(offset: shadowBattleStart1 + 0x4, toOffset: checkCaught),
//	0x5460063f, //rlwinm.	r0, r3, 0, 24, 31 (000000ff)
//	XGUtility.powerPCBranchEqualFromOffset(from: 0x0, to: 0x8),
//	0x3B200000, // li r25, 0
//	0x7f03c378, // mr r3, r24 (overwritten code)
//	XGUtility.createBranchFrom(offset: shadowBattleStart1 + 0x18, toOffset: shadowBattleBranch1 + 0x4)// branch back
//])

//// shadow shake
//let shakeBranch = 0x216d94 - kDOLtoRAMOffsetDifference
//let shakeStart = 0x21fe38 - kDOLtoRAMOffsetDifference
//let groundTrue = 0x216e10 - kDOLtoRAMOffsetDifference
//let groundFalse = shakeBranch + 0x4
//let setEffect = 0x1f057c - kDOLtoRAMOffsetDifference
//let checkForType = 0x2054fc - kDOLtoRAMOffsetDifference
//replaceASM(startOffset: shakeBranch, newASM: [XGUtility.createBranchFrom(offset: shakeBranch, toOffset: shakeStart)])
//replaceASM(startOffset: shakeStart, newASM: [
//	0x7f43d378, // mr	r3, r26 (move)
//	0x28030084, // cmpwi r3, shadow shake
//	0x7f63db78, // mr	r3, r27 (defending pokemon)
//	XGUtility.powerPCBranchEqualFromOffset(from: 0x0, to: 0x8),
//	XGUtility.createBranchFrom(offset: shakeStart + 0x10, toOffset: groundFalse),
//	0xa063080c, // lhz	r3, 0x080C (r3) get ability
//	0x2803001a, // cmpwi r3, levitate
//	XGUtility.powerPCBranchEqualFromOffset(from: 0x0, to: 0x18),
//	0x7f63db78, // mr	r3, r27 (defending pokemon)
//	0x38800002, // li r4, flying type
//	XGUtility.createBranchAndLinkFrom(offset: shakeStart + 0x28, toOffset: checkForType),
//	0x28030001, // cmpwi r3, 1
//	XGUtility.powerPCBranchNotEqualFromOffset(from: 0x0, to: 0x18),
//	0x7fe3fb78, // mr	r3, r31
//	0x38800043, // li	r4, 67 (doesn't affect the target)
//	0x38a00000, // li r5, 0
//	XGUtility.createBranchAndLinkFrom(offset: shakeStart + 0x40, toOffset: setEffect),
//	XGUtility.createBranchFrom(offset: shakeStart + 0x44, toOffset: groundTrue),
//	0x7f63db78, // mr	r3, r27 (overwritten code)
//	XGUtility.createBranchFrom(offset: shakeStart + 0x4c, toOffset: groundFalse),
//])

//// sucker punch
//let suckerBranch = 0x216e10 - kDOLtoRAMOffsetDifference
//let suckerStart = 0x21fe88 - kDOLtoRAMOffsetDifference
//let suckerEnd = suckerBranch + 0x4
////let setEffect = 0x1f057c - kDOLtoRAMOffsetDifference
//let getCurrentMove = 0x148d64 - kDOLtoRAMOffsetDifference
//let getMovePower = 0x13e71c - kDOLtoRAMOffsetDifference
//let getMoveOrder = 0x1f4300 - kDOLtoRAMOffsetDifference
//replaceASM(startOffset: suckerBranch, newASM: [XGUtility.createBranchFrom(offset: suckerBranch, toOffset: suckerStart)])
//replaceASM(startOffset: suckerStart, newASM: [
//	0x7f43d378, // mr	r3, r26 (move)
//	0x28030015, // cmpwi r3, sucker punch
//	XGUtility.powerPCBranchEqualFromOffset(from: 0x0, to: 0xc),
//	0x7fe3fb78, // mr	r3, r31 (overwritten code)
//	XGUtility.createBranchFrom(offset: suckerStart + 0x10, toOffset: suckerEnd),
//	0x7f63db78, // mr	r3, r27 (defending pokemon)
//	XGUtility.createBranchAndLinkFrom(offset: suckerStart + 0x18, toOffset: getCurrentMove),
//	XGUtility.createBranchAndLinkFrom(offset: suckerStart + 0x1c, toOffset: getMovePower),
//	0x28030000, // cmpwi r3, 0
//	XGUtility.powerPCBranchEqualFromOffset(from: 0x0, to: 0x28),
//	0x38600000, // li r3, 0
//	0x38c00000, // li r6, 0
//	0x7f64dB78, // mr r4, r27 (defending pokemon)
//	0x7f85e378, // mr r5, r28 (attacking pokemon)
//	XGUtility.createBranchAndLinkFrom(offset: suckerStart + 0x38, toOffset: getMoveOrder),
//	0x28030001, // cmpwi r3, 1
//	XGUtility.powerPCBranchEqualFromOffset(from: 0x0, to: 0xc),
//	0x7fe3fb78, // mr	r3, r31 (overwritten code)
//	XGUtility.createBranchFrom(offset: suckerStart + 0x48, toOffset: suckerEnd),
//	0x7fe3fb78, // mr	r3, r31 (overwritten code)
//	0x38800045, // li	r4, 69 (the move failed)
//	0x38a00000, // li r5, 0
//	XGUtility.createBranchAndLinkFrom(offset: suckerStart + 0x58, toOffset: setEffect),
//	0x7fe3fb78, // mr	r3, r31 (overwritten code)
//	XGUtility.createBranchFrom(offset: suckerStart + 0x60, toOffset: suckerEnd)
//])

//// skill link
//let skillBranch1 = 0x221d70 - kDOLtoRAMOffsetDifference
//let skillBranch2 = 0x221d98 - kDOLtoRAMOffsetDifference
//let skillStart = 0x152548 - kDOLtoRAMOffsetDifference
//replaceASM(startOffset: skillBranch1, newASM: [XGUtility.createBranchAndLinkFrom(offset: skillBranch1, toOffset: skillStart)])
//replaceASM(startOffset: skillBranch2, newASM: [XGUtility.createBranchAndLinkFrom(offset: skillBranch2, toOffset: skillStart)])
//replaceASM(startOffset: skillStart, newASM: [
//0x5404063e, // rlwinm	r4, r0, 0, 24, 31 (replaced code)
//0x387FF9B8, // subi	r3, r31, 1608 (turns move routine pointer back to battle pokemon pointer)
//0xa063080c, // lhz	r3, 0x080C (r3) get ability
//0x28030066, // cmpwi r3, 102 (skill link)
//0x41820008, // beq 0x8
//0x4e800020, // blr
//0x38800005, // li r4, 5
//0x4e800020, // blr
//])


//// shade ball
//let shadeStart = 0x219380 - kDOLtoRAMOffsetDifference
//let checkShadow = 0x13efec - kDOLtoRAMOffsetDifference
//replaceASM(startOffset: shadeStart, newASM: [
//	0x7f43d378, // mr r3, r26 defending pokemon stats
//	XGUtility.createBranchAndLinkFrom(offset: shadeStart + 0x4, toOffset: checkShadow),
//	0x28030001, // cmpwi r3, 1
//	XGUtility.powerPCBranchNotEqualFromOffset(from: 0x0, to: 0x14),
//	kNopInstruction,
//	kNopInstruction,
//	0x3b800032, // li r28, 50
//])
//
//// net ball buff
//replaceASM(startOffset: 0x219370 - kDOLtoRAMOffsetDifference, newASM: [0x3b800023])
//
//// magic bounce 2
//let setStatus = 0x2024a4 - kDOLtoRAMOffsetDifference
//let getMove = 0x148d64 - kDOLtoRAMOffsetDifference
//let coatBranch = 0x218590 - kDOLtoRAMOffsetDifference
//let coatReturn = coatBranch + 0x4
//let coatStart = 0x21ea68 - kDOLtoRAMOffsetDifference
//replaceASM(startOffset: coatBranch, newASM: [XGUtility.createBranchFrom(offset: coatBranch, toOffset: coatStart)])
//replaceASM(startOffset: coatStart, newASM: [
//	0x38a00000, // li r5, 0
//	XGUtility.createBranchAndLinkFrom(offset: coatStart + 0x4, toOffset: setStatus),
//	0x7f83e378, // mr r3, r28 (defending pokemon)
//	XGUtility.createBranchAndLinkFrom(offset: coatStart + 0xc, toOffset: getMove),
//	0x7C641B78,	// mr r4, r3
//	0x7f83e378, // mr r3, r28 (defending pokemon)
//	0xb0830008, // sth	r4, 0x0008 (r3)
//	XGUtility.createBranchFrom(offset: coatStart + 0x1c, toOffset: coatReturn)
//])
//let coatCheckBranch = 0x20e3c4 - kDOLtoRAMOffsetDifference
//let coatCheckReturn = coatCheckBranch + 0x4
//let coatCheckStart = 0x21dc10 - kDOLtoRAMOffsetDifference
//let checkStatus = 0x2025f0 - kDOLtoRAMOffsetDifference
//let getPokemon = 0x1efcac - kDOLtoRAMOffsetDifference
//let setMove = 0x14774c - kDOLtoRAMOffsetDifference
//replaceASM(startOffset: coatCheckBranch, newASM: [XGUtility.createBranchFrom(offset: coatCheckBranch, toOffset: coatCheckStart)])
//replaceASM(startOffset: coatCheckStart, newASM: [
//	0x38600011, // li r3, 17
//	0x38800000, // li r4, 0
//	XGUtility.createBranchAndLinkFrom(offset: coatCheckStart + 0x8, toOffset: getPokemon),
//	0x38800037, // li r4, magic coat (set after magic bounce activates)
//	XGUtility.createBranchAndLinkFrom(offset: coatCheckStart + 0x10, toOffset: checkStatus),
//	0x28030001, // cmpwi r3, 1
//	XGUtility.powerPCBranchNotEqualFromOffset(from: 0x18, to: 0x30),
//	0x38600011, // li r3, 17
//	0x38800000, // li r4, 0
//	XGUtility.createBranchAndLinkFrom(offset: coatCheckStart + 0x24, toOffset: getPokemon),
//	0xa0830008, // lhz	r4, 0x0008 (r3)
//	XGUtility.createBranchAndLinkFrom(offset: coatCheckStart + 0x2c, toOffset: setMove),
//	0xbb410008, // lmw	r26, 0x0008 (sp)
//	XGUtility.createBranchFrom(offset: coatCheckStart + 0x34, toOffset: coatCheckReturn),
//
//])
//let coatChangeBranch = 0x209bac - kDOLtoRAMOffsetDifference
//let coatChangeReturn = coatChangeBranch + 0x4
//let coatNopOffset = 0x209bb4 - kDOLtoRAMOffsetDifference
//let coatChangeStart = 0x21bc80 - kDOLtoRAMOffsetDifference
//replaceASM(startOffset: coatNopOffset, newASM: [kNopInstruction])
//replaceASM(startOffset: coatChangeBranch, newASM: [XGUtility.createBranchFrom(offset: coatChangeBranch, toOffset: coatChangeStart)])
//replaceASM(startOffset: coatChangeStart, newASM: [
//	0x7C7A1B78, // mr r26, r3
//	0x7f83e378, // mr r3, r28 (attacking pokemon)
//	0x38800037, // li r4, magic coat (set after magic bounce activates)
//	XGUtility.createBranchAndLinkFrom(offset: coatChangeStart + 0xc, toOffset: checkStatus),
//	0x28030001, // cmpwi r3, 1
//	XGUtility.powerPCBranchNotEqualFromOffset(from: 0x0, to: 0x10),
//	0x7f83e378, // mr r3, r28 (attacking pokemon)
//	0xa0630008, // lhz	r3, 0x0008 (r3)
//	0x7C7A1B78, // mr r26, r3
//	XGUtility.createBranchFrom(offset: coatChangeStart + 0x24, toOffset: coatChangeReturn)
//])
//
//// sand rush/force immune to sandstorm
//let sarfissBranch = 0x221238 - kDOLtoRAMOffsetDifference
//let sarfissStart = 0x221998 - kDOLtoRAMOffsetDifference
//let sarfissReturn = sarfissBranch + 0x8
//let sarfissNoDamage = 0x22127c - kDOLtoRAMOffsetDifference
//replaceASM(startOffset: sarfissBranch, newASM: [XGUtility.createBranchFrom(offset: sarfissBranch, toOffset: sarfissStart)])
//replaceASM(startOffset: sarfissStart, newASM: [
//	0x28000008, // cmpwi r0, sand veil
//	XGUtility.powerPCBranchEqualFromOffset(from: 0x4, to: 0x18),
//	0x2800005a, // cmpwi r0, sand force
//	XGUtility.powerPCBranchEqualFromOffset(from: 0xc, to: 0x18),
//	0x2800005b, // cmpwi r0, sand rush
//	XGUtility.powerPCBranchNotEqualFromOffset(from: 0x14, to: 0x1c),
//	XGUtility.createBranchFrom(offset: sarfissStart + 0x18, toOffset: sarfissNoDamage),
//	XGUtility.createBranchFrom(offset: sarfissStart + 0x1c, toOffset: sarfissReturn)
//])
//
//// aura filter immune to shadow sky
//let afissBranch = 0x2212e4 - kDOLtoRAMOffsetDifference
//let afissReturn = afissBranch + 0x4
//let afissNoDamage = 0x221330 - kDOLtoRAMOffsetDifference
//let afissStart = 0x2219b8 - kDOLtoRAMOffsetDifference
//replaceASM(startOffset: afissBranch, newASM: [XGUtility.createBranchFrom(offset: afissBranch, toOffset: afissStart)])
//replaceASM(startOffset: afissStart, newASM: [
//	0x7f43d378, // defending pokemon stats pointer
//	0xa0630002, // lhz r3, 0x0002(r3) get item
//	0x2803003c, // cmpwi r3, aura filter
//	XGUtility.powerPCBranchEqualFromOffset(from: 0x0, to: 0xc),
//	0x7f43d378, // overwritten by branch
//	XGUtility.createBranchFrom(offset: afissStart + 0x14, toOffset: afissReturn),
//	XGUtility.createBranchFrom(offset: afissStart + 0x18, toOffset: afissNoDamage),
//])
//
//
//// rage mode boost
////let checkStatus = 0x2025f0 - kDOLtoRAMOffsetDifference
//let rageStart = 0x22a67c - kDOLtoRAMOffsetDifference
//replaceASM(startOffset: rageStart, newASM: [
//	0x7de37b78, // mr r3, r15
//	0x3880003e, // li r4, reverse mode
//	XGUtility.createBranchAndLinkFrom(offset: rageStart + 0x8, toOffset: checkStatus),
//	0x28030001, // cmpwi r3, 1
//	XGUtility.powerPCBranchNotEqualFromOffset(from: 0x0, to: 0x18),
//	0x7ec3b378,	// mr r3, r22
//	0x38000064, // li r0, 100
//	0x1c630082, // mulli r3, 130
//	0x7c0303d6, // div r0, r3, r0
//	0x5416043e, // rlwinm r22, r0
//	])
//


//for offset in stride(from: 770, through: 800, by: 2) {
//	XGUtility.replaceMartItemAtOffset(offset, withItem: XGUtility.getMartItemAtOffset(offset + 2))
//}
//XGUtility.replaceMartItemAtOffset(800, withItem: .item(333))



//let aurora = move("aurora veil").data
//aurora.pp = 10
//aurora.save()
//
//let omanyte = pokemon("omanyte").stats
//omanyte.levelUpMoves[0].move = move("rock throw")
//omanyte.save()
//
//let rest = move("rest").data
//rest.effect = 37
//rest.save()
//
//let veil = move("shadow veil").data
//veil.pp = 5
//veil.save()
//
//let feebas = pokemon("feebas").stats
//feebas.evolutions[0].evolutionMethod = .levelUp
//feebas.evolutions[0].condition = 20
//feebas.save()

//let tmList : [[Int]] = [
//	[], // tailwind
//	[],	// fire blast
//	[],	// light pulse
//	[],	// hurricane
//	[],	// sludgewave
//	[],	// dazzling gleam
//	[],	// foul play
//	[],	// flash cannon
//	[286],	// thunder wave
//	[],	// ice beam
//	[],	// will-o-wisp
//	[],	// wild charge
//	[],	// trick room
//	[],	// scald
//	[],	// flamethrower
//	[],	// iron head
//	[],	// thunderbolt
//	[],	// freeze dry
//	[],	// sludgebomb
//	[],	// energy ball
//	[],	// zen headbutt
//	[],	// bug buzz
//	[],	// dragon pulse
//	[142],	// super power
//	[279],	// earthquake
//	[],	// earth power
//	[],	// heat wave
//	[],	// blizzard
//	[],	// sucker punch
//	[],	// gunk shot
//	[],	// psyshock
//	[],	// shadow ball
//	[279],	// rock slide
//	[],	// solar beam
//	[279],	// focus blast
//	[],	// x-scissor
//	[],	// thunder
//	[],	// acrobatics
//	[],	// waterfall
//	[],	// dragon claw
//	[],	// toxic all except ditto
//	[],	// wild flare
//	[],	// poison jab
//	[],	// night slash
//	[245],	// reflect
//	[245],	// light screen
//	[],	// surf
//	[],	// stone edge
//	[],	// psychic
//	[],	// dark pulse
//
//]
//
//for i in tmList {
//	for t in i {
//		if t > 415 {
//			print("tm typo: ", i, t)
//		}
//	}
//}
//
//for tm in 0 ..< tmList.count {
//	if tmList[tm].count > 0 {
//		let mon = XGPokemon.pokemon(tmList[tm][0]).stats
//		mon.learnableTMs[tm] = true
//		mon.save()
//	}
//}
//
//
//let gyarados  = XGTrainer(index: 199, deck:     .DeckStory).pokemon[1].data
//let gyarados2 = XGTrainer(index:  67, deck: .DeckColosseum).pokemon[3].data
//for mon in [gyarados, gyarados2] {
//	mon.shinyness = .always
//	mon.save()
//}

//// make taunt last 4 turns
//let dol = XGFiles.dol.data
//dol.replaceByteAtOffset(0x3f93e0 + (48 * 0x14) + 4, withByte: 4)
//
//// make tail wind last 4 turns
////let dol = XGFiles.dol.data
//dol.replaceByteAtOffset(0x3f93e0 + (75 * 0x14) + 4, withByte: 4)
//
//for tm in XGTMs.allTMs() {
//
//	tm.updateItemDescription()
//
//}


//var bingoMons = [XGBattleBingoPokemon]()
//for i in 0 ..< kNumberOfBingoCards {
//	let card = XGBattleBingoCard(index: i)
//
//	bingoMons.append(card.startingPokemon)
//	for p in card.panels {
//		switch p {
//		case .pokemon(let poke):
//			bingoMons.append(poke)
//		default:
//			break
//		}
//	}
//}
//
//
//
//let bingo : [ (XGPokemon,XGMoves,XGNatures,XGMoveTypes,Int) ] = [
//	//card 1
//		(pokemon("bagon"),move("dragonbreath"),.modest,.dragon,0),
//		(pokemon("bulbasaur"),move("absorb"),.hardy,.grass,0),
//		(pokemon("mudkip"),move("water gun"),.hardy,.water,0),
//		(pokemon("chikorita"),move("absorb"),.hardy,.grass,0),
//		(pokemon("cyndaquil"),move("ember"),.hardy,.fire,0),
//		(pokemon("sunkern"),move("leech seed"),.hardy,.grass,0),
//		(pokemon("totodile"),move("water gun"),.hardy,.water,0),
//		(pokemon("charmander"),move("ember"),.adamant,.fire,0),
//		(pokemon("marill"),move("play fair"),.hardy,.water,0),
//		(pokemon("magby"),move("will-o-wisp"),.hardy,.fire,0),
//		(pokemon("squirtle"),move("water gun"),.hardy,.water,0),
//		(pokemon("treecko"),move("absorb"),.hardy,.grass,0),
//		(pokemon("goldeen"),move("baby doll eyes"),.hardy,.water,0),
//		(pokemon("torchic"),move("ember"),.hardy,.fire,0),
//	//card 2
//		(pokemon("magnemite"),move("shockwave"),.modest,.electric,0),
//		(pokemon("machop"),move("bullet punch"),.hardy,.fighting,0),
//		(pokemon("pidgey"),move("air slash"),.hardy,.flying,0),
//		(pokemon("gligar"),move("bulldoze"),.hardy,.flying,0),
//		(pokemon("nosepass"),move("rock tomb"),.hardy,.rock,0),
//		(pokemon("makuhita"),move("ice punch"),.hardy,.fighting,0),
//		(pokemon("swablu"),move("dragonbreath"),.hardy,.flying,0),
//		(pokemon("anorith"),move("aerial ace"),.hardy,.rock,0),
//		(pokemon("meditite"),move("zen headbutt"),.hardy,.fighting,0),
//		(pokemon("lunatone"),move("psybeam"),.hardy,.rock,0),
//		(pokemon("larvitar"),move("rock slide"),.hardy,.rock,0),
//		(pokemon("zubat"),move("aerial ace"),.hardy,.flying,0),
//		(pokemon("mankey"),move("power-up punch"),.hardy,.fighting,0),
//		(pokemon("rhyhorn"),move("bulldoze"),.hardy,.rock,0),
//	//card 3
//		(pokemon("nuzleaf"),move("mega drain"),.modest,.grass,0),
//		(pokemon("lanturn"),move("scald"),.hardy,.water,0), // ability 0 for volt absorb
//		(pokemon("steelix"),move("iron head"),.hardy,.ground,0),
//		(pokemon("magneton"),move("flash cannon"),.hardy,.electric,0),
//		(pokemon("graveler"),move("bulldoze"),.hardy,.ground,0),
//		(pokemon("spheal"),move("ice beam"),.hardy,.water,0),
//		(pokemon("flaaffy"),move("thunderbolt"),.hardy,.electric,0),
//		(pokemon("marshtomp"),move("earth power"),.hardy,.water,0),
//		(pokemon("pupitar"),move("rock slide"),.hardy,.ground,0),
//		(pokemon("pikachu"),move("volt tackle"),.hardy,.electric,0),
//		(pokemon("manectric"),move("overheat"),.hardy,.electric,0),
//		(pokemon("gyarados"),move("bounce"),.hardy,.water,0),
//		(pokemon("piloswine"),move("icicle crash"),.hardy,.ground,0),
//		(pokemon("lombre"),move("giga drain"),.hardy,.water,0),
//	//card 4
//		(pokemon("alakazam"),move("psychic"),.modest,.psychic,0),
//		(pokemon("claydol"),move("psychic"),.hardy,.psychic,0),
//		(pokemon("grumpig"),move("psychic"),.modest,.psychic,0),
//		(pokemon("muk"),move("gunk shot"),.hardy,.poison,0),
//		(pokemon("shiftry"),move("sucker punch"),.hardy,.dark,0),
//		(pokemon("sharpedo"),move("crunch"),.hardy,.dark,0),
//		(pokemon("medicham"),move("drain punch"),.hardy,.psychic,0),
//		(pokemon("victreebel"),move("leaf storm"),.hardy,.poison,0),
//		(pokemon("metang"),move("meteor mash"),.hardy,.psychic,0),
//		(pokemon("seviper"),move("sucker punch"),.adamant,.poison,0),
//		(pokemon("gardevoir"),move("moonblast"),.hardy,.psychic,0),
//		(pokemon("crobat"),move("brave bird"),.adamant,.poison,0),
//		(pokemon("absol"),move("dark pulse"),.hardy,.dark,0),
//		(pokemon("sneasel"),move("ice punch"),.hardy,.dark,0),
//	//card 5
//		(pokemon("sableye"),move("will-o-wisp"),.brave,.ghost,0),
//		(pokemon("wigglytuff"),move("play rough"),.adamant,.normal,0),
//		(pokemon("gengar"),move("sludge bomb"),.adamant,.ghost,0),
//		(pokemon("misdreavus"),move("shadow ball"),.modest,.ghost,0),
//		(pokemon("blaziken"),move("blaze kick"),.hardy,.fighting,0),
//		(pokemon("pidgeot"),move("hurricane"),.hardy,.normal,0),
//		(pokemon("machamp"),move("cross chop"),.hardy,.fighting,0),
//		(pokemon("banette"),move("sucker punch"),.adamant,.ghost,0),
//		(pokemon("slaking"),move("giga impact"),.brave,.normal,0),
//		(pokemon("exploud"),move("boomburst"),.hardy,.normal,0),
//		(pokemon("breloom"),move("sky uppercut"),.jolly,.fighting,0),
//		(pokemon("dusclops"),move("destiny bond"),.hardy,.ghost,0),
//		(pokemon("hariyama"),move("knock off"),.adamant,.fighting,0),
//		(pokemon("zangoose"),move("night slash"),.jolly,.normal,0),
//	//card 6
//		(pokemon("butterfree"),move("bug buzz"),.modest,.bug,0),
//		(pokemon("armaldo"),move("stone edge"),.hardy,.bug,0),
//		(pokemon("beedrill"),move("poison jab"),.hardy,.bug,0),
//		(pokemon("scizor"),move("bullet punch"),.timid,.bug,0),
//		(pokemon("scyther"),move("air slash"),.hardy,.bug,0),
//		(pokemon("heracross"),move("rock blast"),.jolly,.bug,0),
//		(pokemon("parasect"),move("seed bomb"),.hardy,.bug,0),
//		(pokemon("ninjask"),move("aerial ace"),.hardy,.bug,0),
//		(pokemon("shedinja"),move("shadow claw"),.hardy,.bug,0),
//		(pokemon("ariados"),move("sucker punch"),.adamant,.bug,0),
//		(pokemon("beautifly"),move("hurricane"),.hardy,.bug,0),
//		(pokemon("masquerain"),move("scald"),.hardy,.bug,0),
//		(pokemon("pinsir"),move("seismic toss"),.bold,.bug,0),
//		(pokemon("shuckle"),move("toxic"),.hardy,.bug,0),
//	//card 7
//		(pokemon("pidgeot"),move("hurricane"),.modest,.flying,0),
//		(pokemon("aggron"),move("iron tail"),.hardy,.steel,0),
//		(pokemon("tyranitar"),move("stone edge"),.hardy,.rock,0),
//		(pokemon("steelix"),move("earthquake"),.adamant,.steel,0),
//		(pokemon("sneasel"),move("brick break"),.adamant,.ice,0),
//		(pokemon("regirock"),move("stone edge"),.hardy,.rock,0),
//		(pokemon("golem"),move("earthquake"),.relaxed,.rock,0),
//		(pokemon("skarmory"),move("iron head"),.hardy,.steel,0),
//		(pokemon("glalie"),move("ice beam"),.hardy,.ice,0),
//		(pokemon("rhydon"),move("drill run"),.hardy,.rock,0),
//		(pokemon("regice"),move("blizzard"),.hardy,.ice,0),
//		(pokemon("registeel"),move("super power"),.hardy,.steel,0),
//		(pokemon("omastar"),move("scald"),.hardy,.rock,0),
//		(pokemon("lapras"),move("hydro pump"),.hardy,.ice,0),
//	//card 8
//		(pokemon("dragonite"),move("dragon claw"),.jolly,.dragon,0),
//		(pokemon("ampharos"),move("thunderbolt"),.modest,.dragon,0),
//		(pokemon("dragonite"),move("iron tail"),.adamant,.flying,0),
//		(pokemon("tyranitar"),move("stone edge"),.adamant,.rock,0),
//		(pokemon("altaria"),move("play fair"),.hardy,.dragon,0),
//		(pokemon("flygon"),move("iron tail"),.jolly,.dragon,0),
//		(pokemon("sceptile"),move("dragon pulse"),.adamant,.dragon,0),
//		(pokemon("latias"),move("ice beam"),.adamant,.dragon,0),
//		(pokemon("feraligatr"),move("ice punch"),.adamant,.water,0),
//		(pokemon("salamence"),move("aerial ace"),.adamant,.flying,0),
//		(pokemon("kingdra"),move("hydro pump"),.timid,.water,0),
//		(pokemon("aerodactyl"),move("stone edge"),.timid,.rock,0),
//		(pokemon("latios"),move("thunderbolt"),.brave,.dragon,0),
//		(pokemon("charizard"),move("dragon claw"),.adamant,.flying,0),
//	//card 9
//		(pokemon("slaking"),move("body slam"),.brave,.normal,0),
//		(pokemon("suicune"),move("hydro pump"),.bold,.water,0),
//		(pokemon("regice"),move("blizzard"),.modest,.ice,0),
//		(pokemon("zapdos"),move("thunder"),.relaxed,.electric,0),
//		(pokemon("entei"),move("flare blitz"),.adamant,.fire,0),
//		(pokemon("metagross"),move("meteor mash"),.adamant,.steel,0),
//		(pokemon("regirock"),move("stone edge"),.adamant,.rock,0),
//		(pokemon("registeel"),move("iron head"),.adamant,.steel,0),
//		(pokemon("moltres"),move("fire blast"),.timid,.fire,0),
//		(pokemon("raikou"),move("thunder"),.jolly,.normal,0),
//		(pokemon("salamence"),move("outrage"),.brave,.dragon,0),
//		(pokemon("tyranitar"),move("stone edge"),.impish,.rock,0),
//		(pokemon("dragonite"),move("dragon claw"),.jolly,.dragon,0),
//		(pokemon("articuno"),move("blizzard"),.timid,.ice,0),
//	//card 10
//		(pokemon("mew"),move("psychic"),.modest,.psychic,0),
//		(pokemon("kyogre"),move("surf"),.modest,.water,0),
//		(pokemon("mew"),move("sucker punch"),.adamant,.psychic,0),
//		(pokemon("latias"),move("draco meteor"),.modest,.dragon,0),
//		(pokemon("lugia"),move("aeroblast"),.hasty,.flying,0),
//		(pokemon("groudon"),move("stone edge"),.adamant,.ground,0),
//		(pokemon("mew"),move("ice beam"),.modest,.psychic,0),
//		(pokemon("celebi"),move("leaf storm"),.modest,.psychic,0),
//		(pokemon("latios"),move("dracometeor"),.modest,.dragon,0),
//		(pokemon("jirachi"),move("iron head"),.adamant,.psychic,0),
//		(pokemon("ho-oh"),move("sacred fire"),.hasty,.flying,0),
//		(pokemon("rayquaza"),move("outrage"),.adamant,.dragon,0),
//		(pokemon("mewtwo"),move("psystrike"),.modest,.psychic,0),
//		(pokemon("deoxys"),move("psychoboost"),.modest,.psychic,0),
//	//card 11
//		(pokemon("bonsly"),move("stone edge"),.adamant,.rock,0),
//		(pokemon("vulpix"),move("fire blast"),.modest,.fire,0),
//		(pokemon("shroomish"),move("wood hammer"),.adamant,.grass,0),
//		(pokemon("poliwag"),move("hydro pump"),.modest,.water,0),
//		(pokemon("dratini"),move("draco meteor"),.modest,.dragon,0),
//		(pokemon("mareep"),move("thunder"),.modest,.electric,0),
//		(pokemon("snorunt"),move("blizzard"),.modest,.ice,0),
//		(pokemon("phanpy"),move("earthquake"),.adamant,.ground,0),
//		(pokemon("poochyena"),move("sucker punch"),.adamant,.dark,0),
//		(pokemon("taillow"),move("brave bird"),.adamant,.flying,0),
//		(pokemon("whismur"),move("boomburst"),.modest,.normal,0),
//		(pokemon("tyrogue"),move("superpower"),.adamant,.fighting,0),
//		(pokemon("grimer"),move("gunk shot"),.adamant,.poison,0),
//		(pokemon("abra"),move("psychic"),.modest,.psychic,0)
//
//]
//
//for j in 0 ..< bingo.count {
//	let mon = bingoMons[j]
//	let nw = bingo[j]
//
//	mon.species = nw.0
//	mon.move = nw.1
//	mon.nature = nw.2
//	mon.typeOnCard = nw.3 == mon.species.type1 ? 0 : 1
//	mon.ability = nw.4
//
//	mon.save()
//}

//let dive = XGFiles.nameAndFolder("ball_dive.fdat", .TextureImporter).compress()
//XGFiles.fsys("people_archive.fsys").fsysData.replaceFile(file: dive)


//// sash/sturdy 2 (multihit moves work)
//let sash2Branch   = 0x216038
//let sash2Start    = 0xb99350
//let getMoveEffect = 0x13e6e8
//XGAssembly.replaceASM(startOffset: sash2Branch - kDOLtoRAMOffsetDifference, newASM: [
//	XGAssembly.createBranchFrom(offset: sash2Branch, toOffset: sash2Start),
//	// overwritten code
//	0x7fa3eb78, // mr	r3, r29
//	0x38800001, // li	r4, 1
//])
//XGAssembly.replaceRELASM(startOffset: sash2Start - kRELtoRAMOffsetDifference, newASM: [
//	0x7f83e378, // mr r3, r28
//	XGAssembly.createBranchAndLinkFrom(offset: sash2Start + 0x4, toOffset: getMoveEffect),
//	0x2803001d, // cmpwi r3, 29 (2-5 hits)
//	XGAssembly.powerPCBranchEqualFromOffset(from: 0x0, to: 0x28), // beq 0x28
//	0x2803002c, // cmpwi r3, 44 (2 hits)
//	XGAssembly.powerPCBranchEqualFromOffset(from: 0x0, to: 0x20), // beq 0x20
//	0x2803004d, // cmpwi r3, 77 (2 hits + poison)
//	XGAssembly.powerPCBranchEqualFromOffset(from: 0x0, to: 0x18), // beq 0x18
//	0x28030068, // cmpwi r3, 104 (3 hits)
//	XGAssembly.powerPCBranchEqualFromOffset(from: 0x0, to: 0x10), // beq 0x10
//	0x2803009a, // cmpwi r3, 154 (beat up)
//	XGAssembly.powerPCBranchEqualFromOffset(from: 0x0, to: 0x08), // beq 0x8
//	XGAssembly.createBranchFrom(offset: sash2Start + 0x30, toOffset: sash2Branch + 0x4), // b branch + 0x4
//	XGAssembly.createBranchFrom(offset: sash2Start + 0x34, toOffset: sash2Branch + 0x10), // b branch + 0x10
//])
//
//
//// shadow hunter/slayer
//let hunterStart = 0x22a6a4 - kDOLtoRAMOffsetDifference
//let checkShadowPokemon = 0x149014 - kDOLtoRAMOffsetDifference
//XGAssembly.replaceASM(startOffset: hunterStart, newASM: [
//	0x7e038378, // mr r3, r16 (defending mon)
//	0x80630000, // lw r3, 0 (r3)
//	0x38630004, // addi r3, 4
//	XGAssembly.createBranchAndLinkFrom(offset: hunterStart + 0xc, toOffset: checkShadowPokemon),
//	0x28030001, // cmpwi r3, 1
//	XGAssembly.powerPCBranchNotEqualFromOffset(from: 0x0, to: 0x34),
//	0x7e238b78, // mr r3, r17
//	// get move data pointer
//	0x1c030038,
//	0x806d89d4,
//	0x7c630214,
//	0xa063001c, // lhz 0x001c(r3)     (get move effect)
//	0x28030015, // cmpwi r3, shadow hunter/slayer
//	XGAssembly.powerPCBranchNotEqualFromOffset(from: 0x0, to: 0x18),
//	// boost 50%
//	0x56c3043e, // rlwinm r3, r22
//	0x38000064, // li r0, 100
//	0x1c630096, // mulli r3, 150
//	0x7c0303d6, // div r0, r3, r0
//	0x5416043e, // rlwinm r22, r0
//])
//
//
//// hex
//let hexStart = 0x22a6ec - kDOLtoRAMOffsetDifference
//let checkNoStatus = 0x203744 - kDOLtoRAMOffsetDifference
//XGAssembly.replaceASM(startOffset: hexStart, newASM: [
//	0x7e038378, // mr r3, r16 (defending pokemon)
//	XGAssembly.createBranchAndLinkFrom(offset: hexStart + 0x4, toOffset: checkNoStatus),
//	0x28030001, // if has no status effect
//	XGAssembly.powerPCBranchEqualFromOffset(from: 0x0, to: 0x28),
//	0x7e238b78, // mr r3, r17
//	// get move data pointer
//	0x1c030038,
//	0x806d89d4,
//	0x7c630214,
//	0xa063001c, // lhz 0x001c(r3)     (get move effect)
//	0x2803000c, // cmpwi r3, move effect 12 (hex)
//	XGAssembly.powerPCBranchNotEqualFromOffset(from: 0x0, to: 0xc),
//	0x38600002, // li r3, 2
//	0x7ED619D6, // mullw r22, r22, r3
//])

//// aoe moves (e.g. bulldoze discharge)
// need to test how moves being absorbed affects aoe moves before investing time
// into making this work.
// it seems some abilities completely end the move after absorbing it.
//let activateSecondary = 0x213d20
//let getRoutinePos = 0x806dbb10 // lwz	r3, -0x44F0 (r13)
//let setRoutinePos = 0x906dbb10 // stw	r3, -0x44F0 (r13)
//
//// change effect to eq in use move
//let effectBranch = 0x20f068
//let effectStart = 0x0
//
//let getTargets = 0x13e784
//
//let effectCode : ASM = [
//
//	0x7c791b78, // mr	r25, r3
//	0x7f03c378, // mr	r3, r24
//	XGAssembly.createBranchAndLinkFrom(offset: effectStart + 0x8, toOffset: getTargets),
//	0x28030006, // cmpwi r3, both foes and ally
//	XGAssembly.powerPCBranchNotEqualFromOffset(from: 0x0, to: 0xc),
//	0x38600093, // li r3, earthquake effect
//	0x7c791b78, // mr	r25, r3
//	// overwritten code
//	0x38000000, // li	r0, 0
//
//]

//// disable/encore lasts 4 turns
//XGStatusEffects.disabled.setDuration(turns: 4)
//XGStatusEffects.encored.setDuration(turns: 4)
//
//// remove follow me redirection so can be used for wide guard
//XGAssembly.replaceASM(startOffset: 0x218bb4 - kDOLtoRAMOffsetDifference, newASM: [0x4800003c])


////Sand rush
//let sandstart = 0x2009c0
//let sinstructions : ASM = [
//	0x5464043e, // rlwinm	r4, r3, 0, 16, 31 (0000ffff)
//	0x28170021, // cmpwi r23, swift swim
//	0x41820020, // beq 0x20
//	0x28170022, // cmpwi r23, chlorophyll
//	0x41820024, // beq 0x24
//	0x2817005b, // cmpwi r23, sand rush
//	0x40820028, // bne 0x28
//	0x281C0003, // cmpwi r28, sandstorm
//	0x4182001C, // beq 0x1c
//	0x4800001C, // b 0x1c
//	0x281C0002, // cmpwi r28, rain
//	0x41820010, // beq 0x10
//	0x48000010, // b 0x10
//	0x281C0001, // cmpwi r28, sun
//	0x40820008  // bne 0x8
//]
//XGAssembly.replaceASM(startOffset: sandstart, newASM: sinstructions)

//// shadow terrain residual hp healing for shadow pokemon
//let terrainBranch = 0x227ac8 //(ram)
//let terrainStart = 0xb99388
//
//let healTrue = 0x227ad4
//let healFalse = 0x227b0c
//
//let checkField = 0x1f3824
//let checkShadow = 0x149014
//
//let terrainCode : ASM = [
//
//	0x28030001, // cmpwi r3, 1 (overwritten check for ingrain)
//	XGAssembly.powerPCBranchNotEqualFromOffset(from: 0x0, to: 0x8),
//	XGAssembly.createBranchFrom(offset: terrainStart + 0x8, toOffset: healTrue),
//
//	0x38600000, // li r3, 0
//	0x38800038, // li r4, 56
//	XGAssembly.createBranchAndLinkFrom(offset: terrainStart + 0x14, toOffset: checkField),
//	0x5460043f, // rlwinm.	r0, r3, 0, 16, 31 (0000ffff)
//	XGAssembly.powerPCBranchNotEqualFromOffset(from: 0x0, to: 0x8),
//	XGAssembly.createBranchFrom(offset: terrainStart + 0x20, toOffset: healFalse),
//
//	0x7fe3fb78, // mr r3, r31 (battle pokemon)
//	// get stats pointer
//	0x80630000, // lwz	r3, 0 (r3)
//	0x38630004, // addi	r3, r3, 4
//
//	XGAssembly.createBranchAndLinkFrom(offset: terrainStart + 0x30, toOffset: checkShadow),
//	0x28030001, // cmpwi r3, 1
//	XGAssembly.powerPCBranchNotEqualFromOffset(from: 0x0, to: 0x8),
//	XGAssembly.createBranchFrom(offset: terrainStart + 0x3c, toOffset: healTrue),
//	XGAssembly.createBranchFrom(offset: terrainStart + 0x40, toOffset: healFalse),
//
//]
//
//XGAssembly.replaceASM(startOffset: terrainBranch - kDOLtoRAMOffsetDifference, newASM: [XGAssembly.createBranchFrom(offset: terrainBranch, toOffset: terrainStart),kNopInstruction])
//XGAssembly.replaceRELASM(startOffset: terrainStart - kRELtoRAMOffsetDifference, newASM: terrainCode)

//// shadow terrain residual healing to 1/10
//XGAssembly.replaceASM(startOffset: 0x227ae8 - kDOLtoRAMOffsetDifference, newASM: [0x3880000A])
//
//// regular moves doe 75% damage in shadow terrain
//XGAssembly.replaceASM(startOffset: 0x22a62c - kDOLtoRAMOffsetDifference, newASM: [
//	0x1C160003, // mulli	r0, r22, 3
//	0x7C001670, // srawi	r0, r0,2
//])

//// allow endured the hit message to be set elsewhere (effectiveness 70) (interferes with focus sash message)
//for offset in [0x2160f8, 0x2160e0] {
//	XGAssembly.replaceASM(startOffset: offset - kDOLtoRAMOffsetDifference, newASM: [0x38800047])
//}
//
//// spiky shield 1 (replaces endure effect)
//XGAssembly.replaceASM(startOffset: 0x223514 - kDOLtoRAMOffsetDifference, newASM: [0x28000113])
//XGAssembly.replaceASM(startOffset: 0x223570 - kDOLtoRAMOffsetDifference, newASM: [kNopInstruction])
//XGAssembly.replaceASM(startOffset: 0x2235dc - kDOLtoRAMOffsetDifference, newASM: [kNopInstruction,kNopInstruction])
//let endureRemove = 0x21607c - kDOLtoRAMOffsetDifference
//XGAssembly.replaceASM(startOffset: endureRemove, newASM: [kNopInstruction,kNopInstruction,kNopInstruction,kNopInstruction,kNopInstruction])
//XGAssembly.replaceASM(startOffset: 0x2160d8 - kDOLtoRAMOffsetDifference, newASM: [0x48000030])
//
////rocky helmet & spiky shield 2
//let rockyBranch = 0x2250bc
//let rockyStart = 0xb993cc
//
//let checkStatus = 0x2025f0
//let getMoveEffectiveness = 0x1f0684
//let getItem = 0x20384c
//
//let getHPFraction = 0x203688
//let storeHP = 0x13e094
//let animSoundCallBack = 0x2236a8
//let clearEffectiveness = 0x1f06d8
//
//let rockyCode : ASM = [
//
//	// check contact
//	0x28190001, // cmpwi r25, 1
//	XGAssembly.powerPCBranchEqualFromOffset(from: 0x0, to: 0x8), // beq 8
//	XGAssembly.createBranchFrom(offset: 0x8, toOffset: 0x88),
//
//	// check spiky shield (status 44)
//	0x7fe3fb78, // mr	r3, r31 (defending mon)
//	0x3880002c, // li   r4, spiky shield (originally endure flag)
//	XGAssembly.createBranchAndLinkFrom(offset: rockyStart + 0x14, toOffset: checkStatus),
//	0x28030001, // cmpwi r3, 1
//	XGAssembly.powerPCBranchNotEqualFromOffset(from: 0x1c, to: 0x48),
//
//	// check protected
//	0x7e439378, // mr	r3, r18 move routine pointer
//	0x38800040, // li	r4, 64 (protected)
//	XGAssembly.createBranchAndLinkFrom(offset: rockyStart + 0x28, toOffset: getMoveEffectiveness),
//	0x28030001, // cmpwi r3, 1
//	XGAssembly.powerPCBranchEqualFromOffset(from: 0x0, to: 0x8),
//	XGAssembly.createBranchFrom(offset: 0x0, toOffset: 0x14),
//	0x7e439378, // mr	r3, r18 move routine pointer
//	0x38800040, // li r4, failed (rough skin won't work if the move failed)
//	XGAssembly.createBranchAndLinkFrom(offset: rockyStart + 0x40, toOffset: clearEffectiveness),
//	XGAssembly.createBranchFrom(offset: 0x44, toOffset: 0x64),
//
//	// check failed
//	0x281a0001, // cmpwi r26, 1
//	XGAssembly.powerPCBranchEqualFromOffset(from: 0x0, to: 0x8),
//	XGAssembly.createBranchFrom(offset: 0x50, toOffset: 0x88),
//
//	// check item rocky helmet (hold item id 77)
//	0x7fe3fb78, // mr	r3, r31 (defending mon)
//	XGAssembly.createBranchAndLinkFrom(offset: rockyStart + 0x58, toOffset: getItem),
//	0x2803004d, // cmplwi	r3, rocky helmet
//	XGAssembly.powerPCBranchNotEqualFromOffset(from: 0x60, to: 0x88),
//
//	// rough skin code
//	0x7fc3f378, // mr	r3, r30 (attacking mon)
//	0x38800006, // li r4, 6
//	XGAssembly.createBranchAndLinkFrom(offset: rockyStart + 0x6c, toOffset: getHPFraction),
//	0x5464043e, // rlwinm	r4, r3, 0, 16, 31 (0000ffff)
//	0x7e439378, // mr	r3, r18
//	XGAssembly.createBranchAndLinkFrom(offset: rockyStart + 0x78, toOffset: storeHP),
//	0x3c608041, // lis	r3, 0x8041
//	0x38637be1, // addi	r3, r3, 31713
//	XGAssembly.createBranchAndLinkFrom(offset: rockyStart + 0x84, toOffset: animSoundCallBack),
//
//	0x7fc3f378, // mr	r3, r30 (overwritten code)
//	XGAssembly.createBranchFrom(offset: rockyStart + 0x8c, toOffset: rockyBranch + 0x4),
//]
//XGAssembly.replaceASM(startOffset: rockyBranch - kDOLtoRAMOffsetDifference, newASM: [XGAssembly.createBranchFrom(offset: rockyBranch, toOffset: rockyStart)])
//XGAssembly.replaceRELASM(startOffset: rockyStart - kRELtoRAMOffsetDifference, newASM: rockyCode)


//// wide guard
//let wideGuardBranchLinks = [0x218204, 0x218184]
//let wideGuardStart = 0xb9945c
//
//for offset in wideGuardBranchLinks {
//	XGAssembly.replaceASM(startOffset: offset - kDOLtoRAMOffsetDifference, newASM: [XGAssembly.createBranchAndLinkFrom(offset: offset, toOffset: wideGuardStart), 0x28030001])
//}
//
//let getPokemonPointer = 0x1efcac
//let getFieldEffect = 0x1f84e0
//let getCurrentMove = 0x148d64
//let getMoveTargets = 0x13e784
//
//let wideEndOffset = 0x78
//
//XGAssembly.replaceRELASM(startOffset: wideGuardStart - kRELtoRAMOffsetDifference, newASM: [
//	// allow blr
//	0x9421ffe0, // stwu	sp, -0x0020 (sp)
//	0x7c0802a6, // mflr	r0
//	0x90010024, // stw	r0, 0x0024 (sp)
//	0xbfa10014, // stmw	r29, 0x0014 (sp) (just in case I wanted to use r29 for something)
//
//	// check regular protect
//	0x28030001, // cmpwi r3, 1
//	XGAssembly.powerPCBranchNotEqualFromOffset(from: 0x0, to: 0xc),
//
//	// regular protect so go to end
//	0x38600001, // li r3, 1
//	XGAssembly.createBranchFrom(offset: 0x1c, toOffset: wideEndOffset),
//
//	// no regular protect so check wide guard
//
//	// get field pointer
//	0x7fc3f378, // mr	r3, r30
//	0x7c641b78, // mr	r4, r3
//	0x38600002, // li r3, 2
//	XGAssembly.createBranchAndLinkFrom(offset: wideGuardStart + 0x2c, toOffset: getPokemonPointer),
//
//	// check wide guard
//	0x3880004d, // li r4, 77
//	XGAssembly.createBranchAndLinkFrom(offset: wideGuardStart + 0x34, toOffset: getFieldEffect),
//	0x28030001, // cmpwi r3, 1
//	XGAssembly.powerPCBranchEqualFromOffset(from: 0x0, to: 0xc),
//	0x38600000, // li r3, 0
//	XGAssembly.createBranchFrom(offset: 0x44, toOffset: wideEndOffset),
//
//	// check current move target
//	0x38600011, // li r3, 17
//	0x38800000, // li r4, 0
//	XGAssembly.createBranchAndLinkFrom(offset: wideGuardStart + 0x50, toOffset: getPokemonPointer),
//	XGAssembly.createBranchAndLinkFrom(offset: wideGuardStart + 0x54, toOffset: getCurrentMove),
//	XGAssembly.createBranchAndLinkFrom(offset: wideGuardStart + 0x58, toOffset: getMoveTargets),
//	0x28030006, // cmpwi r3, both foes and ally
//	XGAssembly.powerPCBranchEqualFromOffset(from: 0x0, to: 0xc),
//	0x28030004, // cmpwi r3, both foes
//	XGAssembly.powerPCBranchNotEqualFromOffset(from: 0x0, to: 0xc),
//	0x38600001, // li r3, 1
//	XGAssembly.createBranchFrom(offset: 0x0, toOffset: 0x8),
//	0x38600000, // li r3, 0
//
//	// wide end 0x78
//	0xbba10014, // lmw	r29, 0x0014 (sp)
//	0x80010024, // lwz	r0, 0x0024 (sp)
//	0x7c0803a6, // mtlr	r0
//	0x38210020, // addi	sp, sp, 32
//	XGAssembly.powerPCBranchLinkReturn()
//
//])

//// checks if defending pokemon has hp before allowing attack
//// helps with chaining move routines where an effect is applied after attacking
//// but need to check that the pokemon hasn't fainted
//let hpCheckBranch = 0x218370
//let hpCheckStart = 0x22244c
//let checkHP = 0x204a70
//let hpFail = 0x218380
//let hpCode : ASM = [
//	0x7f83e378, // mr	r3, r28
//	XGAssembly.createBranchAndLinkFrom(offset: hpCheckStart + 0x4, toOffset: checkHP),
//	0x28030001, // cmpwi r3, 1
//	XGAssembly.powerPCBranchEqualFromOffset(from: 0x0, to: 0x8),
//	XGAssembly.createBranchFrom(offset: hpCheckStart + 0x10, toOffset: hpFail),
//	0x7fa3eb78, // mr	r3, r29
//	XGAssembly.createBranchFrom(offset: hpCheckStart + 0x18, toOffset: hpCheckBranch + 0x4)
//]
//XGAssembly.replaceASM(startOffset: hpCheckBranch - kDOLtoRAMOffsetDifference, newASM: [XGAssembly.createBranchFrom(offset: hpCheckBranch, toOffset: hpCheckStart)])
//XGAssembly.replaceASM(startOffset: hpCheckStart - kDOLtoRAMOffsetDifference, newASM: hpCode)

//// foul play 2, include stat boosts on foe
//let fpBranch = 0x22a120 - kDOLtoRAMOffsetDifference
//let fpStart = 0x2209cc - kDOLtoRAMOffsetDifference
//
//XGAssembly.replaceASM(startOffset: fpBranch, newASM: [
//	0x9001000c, // overwritten code
//	XGAssembly.createBranchFrom(offset: fpBranch + 0x4, toOffset: fpStart)
//	])
//XGAssembly.replaceASM(startOffset: fpStart, newASM: [
//		0x7e238b78, // mr r3, r17
//		// get move data pointer
//		0x1c030038,
//		0x806d89d4,
//		0x7c630214,
//		0xa063001c, // lhz 0x001c(r3)     (get move effect)
//		0x2803000f, // cmpwi r3, move effect 15 (foul play)
//		XGAssembly.powerPCBranchNotEqualFromOffset(from: 0x0, to: 0xc),
//		0x7e038378, // mr	r3, r16
//		XGAssembly.createBranchFrom(offset: 0x0, toOffset: 0x8),
//		0x7de37b78, // mr	r3, r15
//		XGAssembly.createBranchFrom(offset: fpStart + 0x28, toOffset: fpBranch + 0x8)
//])

//// roar move effect doesn't require higher level
//let roarStart = 0x221c54 - kDOLtoRAMOffsetDifference
//XGAssembly.replaceASM(startOffset: roarStart, newASM: [0x7c7f1b78,kNopInstruction,kNopInstruction])
//
//// roar move routine doesn't show animation etc.
//let roarRoutineStart = 0x413f45
//let dol = XGFiles.dol.data
//dol.replaceBytesFromOffset(roarRoutineStart, withByteStream: [0x3b,0x3b,0x3b])
//dol.save()


//// learnable SMs
//let lsms = [
//	[0], // shadow rush
//	[0], // shadow pulse
//	[0], // shadow bully
//	[20,31,34,57,62,68,76,83,94,99,101,108,115,125,126,127,143,184,185,210,214,217,289,287,320,321,324,336,340,345,343,347,366,378,391,410,413], // shadow max
//	[413,410,406,380,376,378,347,345,338,337,330,331,322,316,315,312,307,304,305,303,302,301,299,300,289,287,286,283,284,285,282,281,280,279,278,277,264,250,249,241,237,234,232,231,228,229,215,212,207,203,200,198,197,193,190,189,184,183,176,169,168,166,164,150,149,142,141,133,134,135,136,128,127,126,125,124,123,121,120,119,106,107,101,94,93,92,89,88,85,83,77,78,59,57,56,53,51,42,37,38,28,27,26,25,22,20,18,15,12,], // shadow stealth
//	[0], // shadow sky
//	[410,409,408,407,394,386,387,379,378,376,363,362,349,348,347,345,329,322,319,317,312,303,302,292,265,264,249,233,206,203,201,202,200,198,197,196,178,176,175,169,166,164,150,144,137,196,124,122,121,103,94,80,73,65,64,55,49,38,12,], // shadow madness
//	[0], // shadow guard
//]
//
//for i in 1 ..< kNumberOfPokemon {
//	let mon = XGPokemon.pokemon(i).stats
//
//	for j in [3,4,6]{
//
//		mon.learnableTMs[50 + j] = lsms[j].contains(i) || (i == 151)
//
//	}
//
//	for j in [0,1,2,5,7] {
//		mon.learnableTMs[50 + j] = mon.index != 251
//	}
//
//	mon.save()
//}
//
//
//let sms = ["Shadow Rush","Shadow Pulse","Shadow Bully","Shadow Max","Shadow Stealth","Shadow Sky","Shadow Madness","Shadow Guard"]
//for i in 0 ... 7 {
//	let sm = XGTMs.tm(51 + i)
//	sm.replaceWithMove(move(sms[i]))
//}
//
//for i in 0 ..< 8 {
//	let cd = XGItem(index: i + 0x164)
//	let sm = XGItem(index: i + 0x153)
//	sm.nameID = cd.nameID
//	sm.friendshipEffects = [129,129,129]
//	sm.save()
//}
//
//for i in 0x1b4 ... 0x1bb {
//	let item = XGItem(index: i)
//	item.nameID = 0
//	item.save()
//}
//let key = XGItem(index: 0x15e)
//for i in 0x153 ... 0x15a {
//	let sm = XGItem(index: i)
//	sm.descriptionID = key.descriptionID
//	sm.save()
//}
//key.descriptionID = 0
//key.save()

//// allow stats to increase/decrease by up to 6
//let statBranch = 0x222428
//let statStart = 0x8069c + kRELtoRAMOffsetDifference
//
//XGAssembly.replaceASM(startOffset: statBranch - kDOLtoRAMOffsetDifference, newASM: [
//	0x9421ffe0, // stwu	sp, -0x0020 (sp)
//	0x7c0802a6, // mflr	r0
//	0x90010024, // stw	r0, 0x0024 (sp)
//	XGAssembly.createBranchAndLinkFrom(offset: statBranch + 0xc, toOffset: statStart),
//	0x80010024, // lwz	r0, 0x0024 (sp)
//	0x7c0803a6, // mtlr	r0
//	0x38210020, // addi	sp, sp, 32
//	XGAssembly.powerPCBranchLinkReturn(),kNopInstruction,
//])
//
//XGAssembly.replaceRELASM(startOffset: statStart - kRELtoRAMOffsetDifference, newASM: [
//
//	0x28030010, // cmpwi r3, +1
//	XGAssembly.powerPCBranchNotEqualFromOffset(from: 0x0, to: 0xc),
//	0x38600001, // li r3, 1
//	XGAssembly.powerPCBranchLinkReturn(),
//
//	0x28030020, // cmpwi r3, +2
//	XGAssembly.powerPCBranchNotEqualFromOffset(from: 0x0, to: 0xc),
//	0x38600002, // li r3, 2
//	XGAssembly.powerPCBranchLinkReturn(),
//
//	0x28030030, // cmpwi r3, +3
//	XGAssembly.powerPCBranchNotEqualFromOffset(from: 0x0, to: 0xc),
//	0x38600003, // li r3, 3
//	XGAssembly.powerPCBranchLinkReturn(),
//
//	0x28030040, // cmpwi r3, +4
//	XGAssembly.powerPCBranchNotEqualFromOffset(from: 0x0, to: 0xc),
//	0x38600004, // li r3, 4
//	XGAssembly.powerPCBranchLinkReturn(),
//
//	0x28030050, // cmpwi r3, +5
//	XGAssembly.powerPCBranchNotEqualFromOffset(from: 0x0, to: 0xc),
//	0x38600005, // li r3, 5
//	XGAssembly.powerPCBranchLinkReturn(),
//
//	0x28030060, // cmpwi r3, +6
//	XGAssembly.powerPCBranchNotEqualFromOffset(from: 0x0, to: 0xc),
//	0x38600006, // li r3, 6
//	XGAssembly.powerPCBranchLinkReturn(),
//
//	0x28030090, // cmpwi r3, -1
//	XGAssembly.powerPCBranchNotEqualFromOffset(from: 0x0, to: 0xc),
//	0x3860ffff, // li r3, -1
//	XGAssembly.powerPCBranchLinkReturn(),
//
//	0x280300a0, // cmpwi r3, -2
//	XGAssembly.powerPCBranchNotEqualFromOffset(from: 0x0, to: 0xc),
//	0x3860fffe, // li r3, -2
//	XGAssembly.powerPCBranchLinkReturn(),
//
//	0x280300b0, // cmpwi r3, -3
//	XGAssembly.powerPCBranchNotEqualFromOffset(from: 0x0, to: 0xc),
//	0x3860fffd, // li r3, -3
//	XGAssembly.powerPCBranchLinkReturn(),
//
//	0x280300c0, // cmpwi r3, -4
//	XGAssembly.powerPCBranchNotEqualFromOffset(from: 0x0, to: 0xc),
//	0x3860fffc, // li r3, -4
//	XGAssembly.powerPCBranchLinkReturn(),
//
//	0x280300d0, // cmpwi r3, -5
//	XGAssembly.powerPCBranchNotEqualFromOffset(from: 0x0, to: 0xc),
//	0x3860fffb, // li r3, -5
//	XGAssembly.powerPCBranchLinkReturn(),
//
//	0x280300e0, // cmpwi r3, -6
//	XGAssembly.powerPCBranchNotEqualFromOffset(from: 0x0, to: 0xc),
//	0x3860fffa, // li r3, -6
//	XGAssembly.powerPCBranchLinkReturn(),
//
//	0x38600000, // li r3, 0
//	XGAssembly.powerPCBranchLinkReturn(),
//
//])

////let bingoLevels = [5,15,25,30,45,50,60,75,80,100,10]
//var bingoMons = [XGBattleBingoPokemon]()
//for i in 0 ..< kNumberOfBingoCards {
//	let card = XGBattleBingoCard(index: i)
//
//	card.pokemonLevel = bingoLevels[i]
//
//	for r in 0 ..< card.rewards.count {
//		card.rewards[r] *= 2
//	}
//	card.save()
//
//	bingoMons.append(card.startingPokemon)
//	for p in card.panels {
//		switch p {
//		case .pokemon(let poke):
//			bingoMons.append(poke)
//		default:
//			break
//		}
//	}
//}
//
//
//
//let bingo : [ (XGPokemon,XGMoves,XGNatures,XGMoveTypes,Int) ] = [
//	//card 1
//		(pokemon("bagon"),move("dragonbreath"),.modest,.dragon,0),
//		(pokemon("bulbasaur"),move("absorb"),.hardy,.grass,0),
//		(pokemon("mudkip"),move("water gun"),.hardy,.water,0),
//		(pokemon("chikorita"),move("absorb"),.hardy,.grass,0),
//		(pokemon("cyndaquil"),move("ember"),.hardy,.fire,0),
//		(pokemon("sunkern"),move("leech seed"),.hardy,.grass,0),
//		(pokemon("totodile"),move("water gun"),.hardy,.water,0),
//		(pokemon("charmander"),move("ember"),.adamant,.fire,0),
//		(pokemon("marill"),move("play rough"),.hardy,.water,0),
//		(pokemon("magby"),move("will-o-wisp"),.hardy,.fire,0),
//		(pokemon("squirtle"),move("water gun"),.hardy,.water,0),
//		(pokemon("treecko"),move("absorb"),.hardy,.grass,0),
//		(pokemon("goldeen"),move("splash"),.hardy,.water,0),
//		(pokemon("torchic"),move("ember"),.hardy,.fire,0),
//	//card 2
//		(pokemon("magnemite"),move("charge beam"),.modest,.electric,0),
//		(pokemon("machop"),move("bullet punch"),.hardy,.fighting,0),
//		(pokemon("pidgey"),move("air slash"),.hardy,.flying,0),
//		(pokemon("gligar"),move("bulldoze"),.hardy,.flying,0),
//		(pokemon("nosepass"),move("rock tomb"),.hardy,.rock,0),
//		(pokemon("makuhita"),move("ice punch"),.hardy,.fighting,0),
//		(pokemon("swablu"),move("dragonbreath"),.hardy,.flying,0),
//		(pokemon("anorith"),move("aerial ace"),.hardy,.rock,0),
//		(pokemon("meditite"),move("zen headbutt"),.hardy,.fighting,0),
//		(pokemon("lunatone"),move("psybeam"),.hardy,.rock,0),
//		(pokemon("larvitar"),move("rock slide"),.hardy,.rock,0),
//		(pokemon("zubat"),move("aerial ace"),.hardy,.flying,0),
//		(pokemon("mankey"),move("power up punch"),.hardy,.fighting,0),
//		(pokemon("rhyhorn"),move("bulldoze"),.hardy,.rock,0),
//	//card 3
//		(pokemon("nuzleaf"),move("mega drain"),.modest,.grass,0),
//		(pokemon("lanturn"),move("scald"),.hardy,.water,0), // ability 0 for volt absorb
//		(pokemon("steelix"),move("iron head"),.hardy,.ground,0),
//		(pokemon("magneton"),move("flash cannon"),.hardy,.electric,0),
//		(pokemon("graveler"),move("bulldoze"),.hardy,.ground,0),
//		(pokemon("spheal"),move("ice beam"),.hardy,.water,0),
//		(pokemon("flaaffy"),move("thunderbolt"),.hardy,.electric,0),
//		(pokemon("marshtomp"),move("earth power"),.hardy,.water,0),
//		(pokemon("pupitar"),move("rock slide"),.hardy,.ground,0),
//		(pokemon("pikachu"),move("volt tackle"),.hardy,.electric,0),
//		(pokemon("manectric"),move("overheat"),.hardy,.electric,0),
//		(pokemon("gyarados"),move("bounce"),.hardy,.water,0),
//		(pokemon("piloswine"),move("icicle crash"),.hardy,.ground,0),
//		(pokemon("lombre"),move("giga drain"),.hardy,.water,0),
//	//card 4
//		(pokemon("alakazam"),move("psychic"),.mild,.psychic,0),
//		(pokemon("claydol"),move("psychic"),.hardy,.psychic,0),
//		(pokemon("grumpig"),move("psychic"),.modest,.psychic,0),
//		(pokemon("muk"),move("gunk shot"),.hardy,.poison,0),
//		(pokemon("shiftry"),move("sucker punch"),.hardy,.dark,0),
//		(pokemon("sharpedo"),move("crunch"),.hardy,.dark,0),
//		(pokemon("medicham"),move("drain punch"),.hardy,.psychic,0),
//		(pokemon("victreebel"),move("leaf storm"),.hardy,.poison,0),
//		(pokemon("metang"),move("meteor mash"),.hardy,.psychic,0),
//		(pokemon("seviper"),move("sucker punch"),.adamant,.poison,0),
//		(pokemon("gardevoir"),move("moonblast"),.hardy,.psychic,0),
//		(pokemon("crobat"),move("brave bird"),.adamant,.poison,0),
//		(pokemon("absol"),move("dark pulse"),.hardy,.dark,0),
//		(pokemon("sneasel"),move("ice punch"),.hardy,.dark,0),
//	//card 5
//		(pokemon("sableye"),move("will-o-wisp"),.brave,.ghost,0),
//		(pokemon("wigglytuff"),move("play rough"),.adamant,.normal,0),
//		(pokemon("gengar"),move("sludge bomb"),.adamant,.ghost,0),
//		(pokemon("misdreavus"),move("shadow ball"),.modest,.ghost,0),
//		(pokemon("blaziken"),move("blaze kick"),.hardy,.fighting,0),
//		(pokemon("pidgeot"),move("hurricane"),.hardy,.normal,0),
//		(pokemon("machamp"),move("cross chop"),.hardy,.fighting,0),
//		(pokemon("banette"),move("sucker punch"),.adamant,.ghost,0),
//		(pokemon("slaking"),move("giga impact"),.brave,.normal,0),
//		(pokemon("exploud"),move("boomburst"),.hardy,.normal,0),
//		(pokemon("breloom"),move("sky uppercut"),.jolly,.fighting,0),
//		(pokemon("dusclops"),move("destiny bond"),.hardy,.ghost,0),
//		(pokemon("hariyama"),move("knock off"),.adamant,.fighting,0),
//		(pokemon("zangoose"),move("night slash"),.jolly,.normal,0),
//	//card 6
//		(pokemon("butterfree"),move("bug buzz"),.modest,.bug,0),
//		(pokemon("armaldo"),move("stone edge"),.hardy,.bug,0),
//		(pokemon("beedrill"),move("poison jab"),.hardy,.bug,0),
//		(pokemon("scizor"),move("bullet punch"),.timid,.bug,0),
//		(pokemon("scyther"),move("air slash"),.hardy,.bug,0),
//		(pokemon("heracross"),move("rock blast"),.jolly,.bug,0),
//		(pokemon("parasect"),move("seed bomb"),.hardy,.bug,0),
//		(pokemon("ninjask"),move("aerial ace"),.hardy,.bug,0),
//		(pokemon("shedinja"),move("shadow claw"),.hardy,.bug,0),
//		(pokemon("ariados"),move("sucker punch"),.adamant,.bug,0),
//		(pokemon("beautifly"),move("hurricane"),.hardy,.bug,0),
//		(pokemon("masquerain"),move("scald"),.hardy,.bug,0),
//		(pokemon("pinsir"),move("seismic toss"),.bold,.bug,0),
//		(pokemon("shuckle"),move("toxic"),.hardy,.bug,0),
//	//card 7
//		(pokemon("pidgeot"),move("hurricane"),.modest,.flying,0),
//		(pokemon("aggron"),move("iron tail"),.hardy,.steel,0),
//		(pokemon("tyranitar"),move("stone edge"),.hardy,.rock,0),
//		(pokemon("steelix"),move("earthquake"),.adamant,.steel,0),
//		(pokemon("sneasel"),move("brick break"),.adamant,.ice,0),
//		(pokemon("regirock"),move("stone edge"),.hardy,.rock,0),
//		(pokemon("golem"),move("earthquake"),.relaxed,.rock,0),
//		(pokemon("skarmory"),move("iron head"),.hardy,.steel,0),
//		(pokemon("glalie"),move("ice beam"),.hardy,.ice,0),
//		(pokemon("rhydon"),move("drill run"),.hardy,.rock,0),
//		(pokemon("regice"),move("blizzard"),.hardy,.ice,0),
//		(pokemon("registeel"),move("super power"),.hardy,.steel,0),
//		(pokemon("omastar"),move("scald"),.hardy,.rock,0),
//		(pokemon("lapras"),move("hydro pump"),.hardy,.ice,0),
//	//card 8
//		(pokemon("dragonite"),move("dragon claw"),.jolly,.dragon,0),
//		(pokemon("ampharos"),move("thunderbolt"),.modest,.dragon,0),
//		(pokemon("dragonite"),move("iron tail"),.adamant,.flying,0),
//		(pokemon("tyranitar"),move("stone edge"),.adamant,.rock,0),
//		(pokemon("altaria"),move("tackle"),.hardy,.dragon,0),
//		(pokemon("flygon"),move("iron tail"),.jolly,.dragon,0),
//		(pokemon("sceptile"),move("dragon pulse"),.adamant,.dragon,0),
//		(pokemon("latias"),move("ice beam"),.adamant,.dragon,0),
//		(pokemon("feraligatr"),move("ice punch"),.adamant,.water,0),
//		(pokemon("salamence"),move("aerial ace"),.adamant,.flying,0),
//		(pokemon("kingdra"),move("hydro pump"),.timid,.water,0),
//		(pokemon("aerodactyl"),move("stone edge"),.timid,.rock,0),
//		(pokemon("latios"),move("thunderbolt"),.brave,.dragon,0),
//		(pokemon("charizard"),move("dragon claw"),.adamant,.flying,0),
//	//card 9
//		(pokemon("slaking"),move("body slam"),.brave,.normal,0),
//		(pokemon("suicune"),move("hydro pump"),.bold,.water,0),
//		(pokemon("regice"),move("blizzard"),.modest,.ice,0),
//		(pokemon("zapdos"),move("thunder"),.relaxed,.electric,0),
//		(pokemon("entei"),move("flare blitz"),.adamant,.fire,0),
//		(pokemon("metagross"),move("meteor mash"),.adamant,.steel,0),
//		(pokemon("regirock"),move("stone edge"),.adamant,.rock,0),
//		(pokemon("registeel"),move("iron head"),.adamant,.steel,0),
//		(pokemon("moltres"),move("fire blast"),.timid,.fire,0),
//		(pokemon("raikou"),move("thunder"),.jolly,.normal,0),
//		(pokemon("salamence"),move("outrage"),.brave,.dragon,0),
//		(pokemon("tyranitar"),move("stone edge"),.impish,.rock,0),
//		(pokemon("dragonite"),move("dragon claw"),.jolly,.dragon,0),
//		(pokemon("articuno"),move("blizzard"),.timid,.ice,0),
//	//card 10
//		(pokemon("mew"),move("psychic"),.modest,.psychic,0),
//		(pokemon("kyogre"),move("surf"),.modest,.water,0),
//		(pokemon("mew"),move("sucker punch"),.adamant,.psychic,0),
//		(pokemon("latias"),move("draco meteor"),.modest,.dragon,0),
//		(pokemon("lugia"),move("aeroblast"),.hasty,.flying,0),
//		(pokemon("groudon"),move("stone edge"),.adamant,.ground,0),
//		(pokemon("mew"),move("ice beam"),.modest,.psychic,0),
//		(pokemon("celebi"),move("leaf storm"),.modest,.psychic,0),
//		(pokemon("latios"),move("dracometeor"),.modest,.dragon,0),
//		(pokemon("jirachi"),move("iron head"),.adamant,.psychic,0),
//		(pokemon("ho-oh"),move("sacred fire"),.hasty,.flying,0),
//		(pokemon("rayquaza"),move("outrage"),.adamant,.dragon,0),
//		(pokemon("mewtwo"),move("psystrike"),.modest,.psychic,0),
//		(pokemon("deoxys"),move("psychoboost"),.modest,.psychic,0),
//	//card 11
//		(pokemon("bonsly"),move("stone edge"),.adamant,.rock,0),
//		(pokemon("vulpix"),move("fire blast"),.modest,.fire,0),
//		(pokemon("shroomish"),move("wood hammer"),.adamant,.grass,0),
//		(pokemon("poliwag"),move("hydro pump"),.modest,.water,0),
//		(pokemon("dratini"),move("draco meteor"),.modest,.dragon,0),
//		(pokemon("mareep"),move("thunder"),.modest,.electric,0),
//		(pokemon("snorunt"),move("blizzard"),.modest,.ice,0),
//		(pokemon("phanpy"),move("earthquake"),.adamant,.ground,0),
//		(pokemon("poochyena"),move("sucker punch"),.adamant,.dark,0),
//		(pokemon("taillow"),move("brave bird"),.adamant,.flying,0),
//		(pokemon("whismur"),move("boomburst"),.modest,.normal,0),
//		(pokemon("tyrogue"),move("superpower"),.adamant,.fighting,0),
//		(pokemon("grimer"),move("gunk shot"),.adamant,.poison,0),
//		(pokemon("abra"),move("psychic"),.modest,.psychic,0)
//
//]
//
//for j in 0 ..< bingo.count {
//	let mon = bingoMons[j]
//	let nw = bingo[j]
//
//	mon.species = nw.0
//	mon.move = nw.1
//	mon.nature = nw.2
//	mon.typeOnCard = nw.3 == mon.species.type1 ? 0 : 1
//	mon.ability = nw.4
//
//	mon.save()
//}



//let dol = XGFiles.dol.data

//let spreadAbsorbedStart = 0x2209f8  - kDOLtoRAMOffsetDifference
//let spreadA : UInt32 = 0x8022
//let spreadB : UInt32 = 0x09f8
//let spreadC : UInt32 = 0x0000
//let spreadMoveAbsorbedRoutine = [0x3A, 0x00, 0x20, 0x46, 0x12, 0x17, 0x00, 0x00, 0x00, 0x00, 0x0B, 0x00, 0x11, 0x00, 0x00, 0x4E, 0xFC, 0x78, 0x12, 0x13, 0x00, 0x50, 0x0B, 0x04, 0x29, 0x80, 0x41, 0x59, 0xa8, 0x00, 0x00, 0x00, 0x60, 0x00, 0x00, 0x00]
//
//dol.replaceBytesFromOffset(spreadAbsorbedStart, withByteStream: spreadMoveAbsorbedRoutine)
//dol.save()

//let spreadCheckStart = 0x2209a4 - kDOLtoRAMOffsetDifference
//let spreadCheckBranch = 0x22586c - kDOLtoRAMOffsetDifference
//let getTargets = 0x13e784 - kDOLtoRAMOffsetDifference
//
//let spreadCode : ASM = [
//	0x7fe3fb78, // mr r3, r31 (move)
//	XGAssembly.createBranchAndLinkFrom(offset: spreadCheckStart + 0x4, toOffset: getTargets),
//	0x28030006, // cmpwi r3, both foes and ally
//	XGAssembly.powerPCBranchNotEqualFromOffset(from: 0x0, to: 0x14),
//	0x3c600000 + spreadA, // lis	r3, spread a
//	0x38630000 + spreadB, // addi	r3, r3, spread b
//	0x38630000 + spreadC, // addi	r3, r3, spread c
//	0x906dbb10, // move routine set position
//	0x3bc00001, // li	r30, 1 (over written code)
//	XGAssembly.createBranchFrom(offset: spreadCheckStart + 0x24, toOffset: spreadCheckBranch + 0x4)
//]
//XGAssembly.replaceASM(startOffset: spreadCheckBranch, newASM: [XGAssembly.createBranchFrom(offset: spreadCheckBranch, toOffset: spreadCheckStart)])
//XGAssembly.replaceASM(startOffset: spreadCheckStart, newASM: spreadCode)


//let dol = XGFiles.dol.data
//let earthquakeStart = 0x4158fb - kDOLtoRAMOffsetDifference + 0xa0
//let earthquakeRoutine = [
//
//	// intro 0x4158fb
//	0x32, 0x80, 0x22, 0x0a, 0x17, 0x80, 0x4e, 0x85, 0xc3, 0x1, 0x02, 0x04,
//
//	// next target 0x415907
//	0xc2,
//
//	// reset 0x415908
//	0x26,
//	0x32, 0x80, 0x4e, 0x85, 0xc3, 0x80, 0x22, 0x0a, 0x17, 0x1,
//
//	// check if should work and check accuracy 0x415913
//	0x00, 0x01, 0x80, 0x41, 0x59, 0x8d, 0x00, 0x00,
//	0x29, 0x80, 0x41, 0x59, 0x33,
//
//	// filler 0x415921
//	0x00, 0x00, 0x00, 0x00, 0x00,
//	0x00, 0x00, 0x00, 0x00, 0x00,
//	0x00, 0x00, 0x00, 0x00, 0x00,
//	0x00, 0x00, 0x00, 0x00,
//
//	// set damage multiplier to 1 0x415933
//	0x39, 0x80, 0x4e, 0xb9, 0x38, 0x00, 0x02, 0x00, 0x00,
//	0x2f, 0x80, 0x4e, 0xb9, 0x5e, 0x01,
//
//	// start move 0x415942
//	0xfc, 0x07, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x39, 0x00, 0x00, 0x00, 0x00, 0x80, 0x4e, 0xb9, 0x5e,
//
//	// start damage routine 0x415956
//	0x3b, 0x3b, 0x3b, 0x3b, 0x3b, 0x3b, // check accuracy
//	0x05, 0x06, 0x07, 0x08, // calcs
//	0x0a, 0x0b, 0x00, // animations
//	0x0f, 0x5d, 0x12, 0x3b, 0x0c, 0x12, 0x0e, 0x13, 0x00, 0x40, 0x10, 0x13, 0x00, 0x50, // messages
//	0x0d, 0x12, 0x0b, 0x04, 0x1a, 0x12, 0x00, 0x00, 0x00, 0x00, 0x00, // animations 2
//	0x2f, 0x80, 0x4e, 0xb9, 0x47, 0x00, 0x16, 0x4a, 0x02, 0x10, // after move
//	0x7c, 0x80, 0x41, 0x59, 0x08, 0x01, // jump while valid target
//	0x3e, // end move
//
//	// attack missed 0x41598d
//	0x3a, 0x00, 0x20, 0x07, 0x46, 0x12, 0x17, 0x00, 0x00, 0x00, 0x00, 0x0f, 0x10, 0x13, 0x00, 0x50, 0x0b, 0x04, 0x2f, 0x80, 0x4e, 0xb9, 0x47, 0x00, 0x4a, 0x02, 0x10, 0x7c, 0x80, 0x41, 0x59, 0x08, 0x01, 0x3e,]
//
//dol.replaceBytesFromOffset(earthquakeStart, withByteStream: earthquakeRoutine)
//dol.save()
//
//
//let dragonTailRoutine = XGAssembly.routineRegularHitOpenEnded() + [
//	// roar
//	0x00, 0x1f, 0x12, 0x15, 0x80, 0x41, 0x7a, 0x7f, 0x90, 0x80, 0x41, 0x5c, 0xb4,
//]
//
//let uturnRoutine = XGAssembly.routineRegularHitOpenEnded() + [
//	// baton pass
//	0x77, 0x11, 0x07, 0x51, 0x11, 0x80, 0x41, 0x5c, 0xb4, 0xe1, 0x11, 0x3b, 0x52, 0x11, 0x02, 0x59, 0x11, 0x4d, 0x11, 0x4e, 0x11, 0x02, 0x74, 0x11, 0x14, 0x80, 0x2f, 0x90, 0xe0, 0x4f, 0x11, 0x01, 0x13, 0x00, 0x00, 0x3b, 0x53, 0x11, 0x29, 0x80, 0x41, 0x41, 0x0f,
//]
//
//let shadowGiftRoutine = [0x00, 0x02, 0x04, 0x50, 0x11, 0x80, 0x41, 0x5c, 0x93, 0x00, 0x0a, 0x0b, 0x04, 0x77, 0x11, 0x07, 0x51, 0x11, 0x80, 0x41, 0x5c, 0x93, 0xe1, 0x11, 0x3b, 0x52, 0x11, 0x02, 0x59, 0x11, 0x4d, 0x11, 0x4e, 0x11, 0x01, 0x74, 0x11, 0x14, 0x80, 0x2f, 0x90, 0xe0, 0x4f, 0x11, 0x01, 0x13, 0x00, 0x00, 0x3b, 0x53, 0x11,
//// branch cosmic power boosts
//0x29, 0x80, 0x41, 0x66, 0x8d,]
//
//let skillSwap = [0x00, 0x02, 0x04, 0x01, 0x80, 0x41, 0x5c, 0x93, 0xff, 0xff, 0xd9, 0x80, 0x41, 0x5c, 0x93, 0x0a, 0x0b, 0x04, 0x0a, 0x0b, 0x00, 0x11, 0x00, 0x00, 0x4e, 0xd2, 0x13, 0x00, 0x60, 0x0b, 0x04, 0x53, 0x11, 0x53, 0x12, 0x29, 0x80, 0x41, 0x41, 0x0f,]
//
//let shadowAnalysisRoutine = XGAssembly.routineRegularHitOpenEnded() + [0x00, 0xa4, 0x80, 0x41, 0x5c, 0xb4, 0x11, 0x00, 0x00, 0x4e, 0xa0, 0x13, 0x00, 0x60, 0x0b, 0x04, 0x29, 0x80, 0x41, 0x41, 0x0f,]
//
//
//let shadowFreezeRoutine =  [0x00, 0x02, 0x04, 0x1e, 0x12, 0x00, 0x00, 0x00, 0x14, 0x80, 0x41, 0x5c, 0x93, 0x1d, 0x12, 0x00, 0x00, 0x00, 0x07, 0x80, 0x41, 0x5e, 0xb9, 0x23, 0x12, 0x0f, 0x80, 0x41, 0x5c, 0xc6, 0x1f, 0x12, 0x28, 0x80, 0x41, 0x5e, 0x81, 0x1f, 0x12, 0x2f, 0x80, 0x41, 0x5e, 0x81, 0x1f, 0x12, 0x31, 0x80, 0x41, 0x5e, 0x81, 0x1d, 0x12, 0x00, 0x00, 0x00, 0x01, 0x80, 0x41, 0x5c, 0x93, 0x01, 0x80, 0x41, 0x5c, 0x93, 0x00, 0x00, 0x20, 0x12, 0x00, 0x4b, 0x80, 0x41, 0x6d, 0xb2, 0x0a, 0x0b, 0x04, 0x2f, 0x80, 0x4e, 0x85, 0xc3, 0x04, 0x17, 0x0b, 0x04, 0x29, 0x80, 0x41, 0x41, 0x0f,]
//
//let routines : [(effect: Int, routine: [Int], offset: Int)] = [
//
//	(28,dragonTailRoutine, 0xb99524),
//	(57, uturnRoutine, 0xb99564),
//	(213, shadowGiftRoutine, 0xb995c2),
//	(191, skillSwap, 0xb995fa),
//	(122, shadowAnalysisRoutine, 0xb99622),
//
//	(55, XGAssembly.routineForMultipleStatBoosts(RAMOffset: 0x80b9966a, boosts: [(stat: XGStats.accuracy, stages: XGStatStages.plus_1), (stat: XGStats.attack, stages: XGStatStages.plus_1)], animate: true), 0xb9966a), // hone claws
//
//	(56, XGAssembly.routineForMultipleStatBoosts(RAMOffset: 0x80b996d4, boosts: [(stat: XGStats.special_attack, stages: XGStatStages.plus_1), (stat: XGStats.special_defense, stages: XGStatStages.plus_1), (stat: XGStats.speed, stages: XGStatStages.plus_1)], animate: true), 0xb996d4), // quiver dance
//
//	(61, XGAssembly.routineForMultipleStatBoosts(RAMOffset: 0x80b99766, boosts: [(stat: XGStats.attack, stages: XGStatStages.plus_1), (stat: XGStats.defense, stages: XGStatStages.plus_1), (stat: XGStats.accuracy, stages: XGStatStages.plus_1)], animate: true), 0xb99766), // coil
//
//	(135, XGAssembly.routineForMultipleStatBoosts(RAMOffset: 0x80b997f8, boosts: [(stat: XGStats.speed, stages: XGStatStages.plus_1), (stat: XGStats.evasion, stages: XGStatStages.plus_1),], animate: true), 0xb997f8), // shadow haste
//
//	(203, XGAssembly.routineForMultipleStatBoosts(RAMOffset: 0x80b99862, boosts: [(stat: XGStats.attack, stages: XGStatStages.plus_1), (stat: XGStats.speed, stages: XGStatStages.plus_2),], animate: true), 0xb99862), // shift gear
//
//	(154, XGAssembly.routineForMultipleStatBoosts(RAMOffset: 0x80b998cc, boosts: [(stat: XGStats.attack, stages: XGStatStages.plus_1), (stat: XGStats.accuracy, stages: XGStatStages.plus_2),], animate: true), 0xb998cc), // shadow focus
//
//	(74, XGAssembly.routineForMultipleStatBoosts(RAMOffset: 0x80b99936, boosts: [(stat: XGStats.attack, stages: XGStatStages.plus_2), (stat: XGStats.special_attack, stages: XGStatStages.plus_2), (stat: XGStats.speed, stages: XGStatStages.plus_2), (stat: XGStats.defense, stages: XGStatStages.minus_1), (stat: XGStats.special_defense, stages: XGStatStages.minus_1)], animate: true), 0xb99936), // shell smash
//
//	(163, XGAssembly.routineForMultipleStatBoosts(RAMOffset: 0x80b99a06, boosts: [(stat: XGStats.attack, stages: XGStatStages.plus_1), (stat: XGStats.defense, stages: XGStatStages.plus_1), (stat: XGStats.speed, stages: XGStatStages.plus_1), (stat: XGStats.special_attack, stages: XGStatStages.plus_1), (stat: XGStats.special_defense, stages: XGStatStages.plus_1)], animate: true), 0xb99a06), // latent power
//
//	(145, XGAssembly.routineForMultipleStatBoosts(RAMOffset: 0x80b99ae8, boosts: [(stat: XGStats.evasion, stages: XGStatStages.minus_1), (stat: XGStats.special_defense, stages: XGStatStages.plus_3)], animate: true), 0xb99ae8), // shadow barrier
//
//	(63, XGAssembly.routineForSingleStatBoost(stat: .defense, stages: .plus_3), 0xb99b49), // cotton guard
//
//	(64, XGAssembly.routineForSingleStatBoost(stat: .special_attack, stages: .plus_3), 0xb99b54), // tail glow
//
//	(96, XGAssembly.routineHitWithSecondaryEffect(effect: 0x51), 0xb99b5f), // flame charge
//
//	(110, XGAssembly.routineHitWithSecondaryEffect(effect: 0xd8), 0xb99b70), // hammer arm
//
//	(131, XGAssembly.routineHitAndStatChange(routineOffsetRAM: 0x80b99b7b, boosts: [(stat: XGStats.defense, stages: XGStatStages.minus_1), (stat: XGStats.special_defense, stages: XGStatStages.minus_1)]), 0xb99b7b), // close combat
//
//	(184, XGAssembly.routineHitAndStatChange(routineOffsetRAM: 0x80b99c01, boosts: [(stat: XGStats.defense, stages: XGStatStages.minus_1), (stat: XGStats.special_defense, stages: XGStatStages.minus_1), (stat: XGStats.speed, stages: XGStatStages.minus_1)]), 0xb99c01), // v-create
//
//	(141, XGAssembly.routineHitWithSecondaryEffect(effect: 0x52), 0xb99ca6), // charge beam
//
//	(93, XGAssembly.routineHitAllWithSecondaryEffect(effect: 0x18), 0xb99cb7), // bulldoze
//
//	(34, XGAssembly.routineHitAllWithSecondaryEffect(effect: 0x03), 0xb99cc8), // lava plume
//
//	(81, XGAssembly.routineHitAllWithSecondaryEffect(effect: 0x05), 0xb99cd3), // discharge
//
//	(88, XGAssembly.routineHitAllWithSecondaryEffect(effect: 0x02), 0xb99cde), // sludge wave
//
//	(162, shadowFreezeRoutine, 0xb99ce9), // shadow freeze
//
//]
//
//
//
//var currentOffset = XGAssembly.ASMfreeSpacePointer()
//for routine in routines {
//
////	// run first to generate offsets
////	print("effect \(routine.effect) - \(currentOffset.hexString())")
////	currentOffset += routine.routine.count
//
//	// fill in offsets then run this to actually add them
//	XGAssembly.setMoveEffectRoutine(effect: routine.effect, fileOffset: routine.offset - kRELtoRAMOffsetDifference, moveToREL: true, newRoutine: routine.routine)
//
//
//}




























//for m in XGMoves.allMoves().filter({ (m) -> Bool in
//	return (m.index < kNumberOfMoves - 1) && (m.data.effect != move("THIEF").data.effect) && (m.data.effect != move("FACADE").data.effect)
//}).sorted(by: { (m1, m2) -> Bool in
//	return XGAssembly.getRoutineStartForMoveEffect(index: m1.data.effect) < XGAssembly.getRoutineStartForMoveEffect(index: m2.data.effect)
//}) {
//	let start = XGAssembly.getRoutineStartForMoveEffect(index: m.data.effect)
//	
//	let routine = XGAssembly.routineDataForMove(move: m)
//	
//	print(m.name.string + " " + start.hexString() + " - " + (start + routine.count).hexString() + ":")
//	
//	for i in 0 ..< routine.count {
//		print(String(format: "0x%02x,", routine[i]), terminator: " ")
//	}
//	print("\n")
//}

//let fileName = "B1_1.fsys"
////let fileName = "D3_ship_B2_2.fsys"
//let new = iso.dataForFile(filename: fileName)!
//let fsys = iso.fsysForFile(filename: fileName)!
//new.file = .fsys("S1_out.fsys")
//new.save()
//
//iso.importFiles([new.file])
//
//for i in 0 ..< fsys.numberOfEntries {
//	let data = fsys.decompressedDataForFileWithIndex(index: i)!
//	data.file = .nameAndFolder(fsys.fileNames[i], .Documents)
//	data.save()
//}


//
//let fileName = "B1_1.fsys"
////let fileName = "D3_ship_B2_2.fsys"
//let new = iso.dataForFile(filename: fileName)!
//let fsys = iso.fsysForFile(filename: fileName)!
//new.file = .fsys("S1_out.fsys")
//new.save()
//
//iso.importFiles([new.file])
//
//for i in 0 ..< fsys.numberOfEntries {
//	let data = fsys.decompressedDataForFileWithIndex(index: i)!
//	data.file = .nameAndFolder(fsys.fileNames[i], .Documents)
//	data.save()
//}




//compileForRelease()


// copy nintendon't save to dolphin gci to import into mem card
//let from = XGFiles.nameAndFolder("GXXE.raw", .Reference).data
//let to = XGFiles.nameAndFolder("GXXE_PokemonXD.gci", .Reference).data
//let fromStart = 0xB2000
//let toStart = 0x40
//let save = from.getByteStreamFromOffset(fromStart, length: 0x56000)
//to.replaceBytesFromOffset(toStart, withByteStream: save)
//to.save()


//printRoutineForMove(move: move("nature power"))
//getFunctionPointerWithIndex(index: 96).hex().println()















