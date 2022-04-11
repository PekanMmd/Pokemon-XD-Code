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


//let dol = XGFiles.dol.data!
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
//	if dol.getWordAtOffset(start) == 0 {
//		dol.replaceWordAtOffset(start, withBytes: UInt32(unused[nextUnused]))
//		XGFiles.common_rel.stringTable.stringWithID(unused[nextUnused])!.duplicateWithString(abNames[nextAb]).replace()
//		nextAb += 1
//		nextUnused += 1
//	}
//	
//	if dol.getWordAtOffset(start + 4) == 0 {
//		dol.replaceWordAtOffset(start + 4, withBytes: UInt32(unused[nextUnused]))
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
//let shadowMovesCheckStartAddress = 0x8013d03c - kDolToRAMOffsetDifference
//let shadowCheckInstructions : [UInt32] = [0x9421fff0,0x7c0802a6,0x90010014,0x480014cd,0x80010014,0x7c0803a6,0x38210010,0x4e800020]
//let adol = XGFiles.dol.data!
//for i in 0 ..< shadowCheckInstructions.count {
//	
//	adol.replaceWordAtOffset(shadowMovesCheckStartAddress + (i * 4), withBytes: shadowCheckInstructions[i])
//	
//}
//
////remove move flag depedencies
//let li_r3_0 : UInt32 = 0x38600000
//let dependentOffsets = [0x8021aafc,0x801bd9e0,0x80210628,0x802187b0]
//for offset in dependentOffsets {
//	adol.replaceWordAtOffset(offset - kDolToRAMOffsetDifference, withBytes: li_r3_0)
//}
//
//adol.save()

////snow warning
//let snowWarningIndex = kNumberOfAbilities + 8
//let bdol = XGFiles.dol.data!
//let nops = [0x80225d24 - kDolToRAMOffsetDifference, 0x80225d54 - kDolToRAMOffsetDifference]
//for offset in nops {
//	bdol.replaceWordAtOffset(offset, withBytes: kNopInstruction)
//}
//bdol.replaceWordAtOffset(0x80225d4c - kDolToRAMOffsetDifference, withBytes: UInt32(0x2c000000 + snowWarningIndex))
//
//let rainToSnow : UInt32 = 0x80225e90 - 0x80225d7c
//let weatherStarter : [UInt32] = [0x38600000, 0x38800053, 0x4BFCD1F9 - rainToSnow, 0x5460063E, 0x28000002, 0x40820188 - rainToSnow, 0x38600000, 0x38800053, 0x38A00000, 0x4BFCD189 - rainToSnow, 0x7FE4FB78, 0x38600000, 0x4BFD09D5 - rainToSnow, 0x3C608041, 0x3863783C, 0x4BFFD8F1 - rainToSnow, kNopInstruction]
//
//let snowstart = 0x80225e90 - kDolToRAMOffsetDifference
//for i in 0 ..< weatherStarter.count {
//	bdol.replaceWordAtOffset(snowstart + (i * 4), withBytes: weatherStarter[i])
//}
//
//loadAllStrings()
//getStringWithID(id: 0x4eea)!.duplicateWithString("[1e]'s [1c][New Line]activated!").replace()

//// snow warning uses hail animation
//let snowRoutineStart = 0xB9AC60
//let snowWarningRoutine = [0x46, 0x19, 0x1e, 0x00, 0x00, 0x00, 0x00, 0x29, 0x80, 0x41, 0x78, 0x43]
//let rel = XGFiles.common_rel.data!
//rel.replaceBytesFromOffset(snowRoutineStart - kRELtoRAMOffsetDifference, withByteStream: snowWarningRoutine)
//rel.save()
//
//let snowRoutineBranch = 0x225ec4
//XGAssembly.replaceASM(startOffset: snowRoutineBranch - kDolToRAMOffsetDifference, newASM: [
//	.lis(.r3, 0x80ba),
//	.subi(.r3, .r3, 0x10000 - 0xac60),
//])



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

//let cdol = XGFiles.dol.data!
//
////crit multipliers
//let critOffsets = [0x8020dd7c,0x8020dd8c,0x8020dd9c,0x801f0968]
//let critValues : [UInt32] = [0x38800003,0x38800002,0x38800002,0x38800002]
//
//for i in 0 ..< critOffsets.count {
//	cdol.replaceWordAtOffset(critOffsets[i] - kDolToRAMOffsetDifference, withBytes: critValues[i])
//}
//
//// reverse mode residual
//cdol.replaceWordAtOffset(0x8022811c - kDolToRAMOffsetDifference, withBytes: 0x38800008)
//
//// paralysis to halve speed
//cdol.replaceWordAtOffset(0x80203adc - kDolToRAMOffsetDifference, withBytes: 0x56f7f87e)
//
//// choice scarf
//let choicescarfindex : UInt32 = 52
//let choiceStart = 0x80203ab4 - kDolToRAMOffsetDifference
//let choiceInstructions : [UInt32] = [kNopInstruction,0x7f43d378,0x4bfffdb5,0x28030000 + choicescarfindex,0x4082000C,0x1EF70003,0x56f7f87e]
//for i in 0 ..< choiceInstructions.count {
//	cdol.replaceWordAtOffset(choiceStart + (i * 4), withBytes: choiceInstructions[i])
//}
//
//// move maintenance
//
// new shadow moves
//for m in [197,330,346] {
//	let mov = XGMoves.move(m).data
//	mov.HMFlag = true
//	mov.save()
//	let rel = XGFiles.common_rel.data!
//	rel.replaceWordAtOffset(mov.startOffset + 0x14, withBytes: 0x00023101)
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
//cdol.replaceWordAtOffset(magicBounceBranchAddress - kDolToRAMOffsetDifference, withBytes: magicBounceBranchInstruction)
//cdol.replaceWordAtOffset(magicBounceCompareAddress - kDolToRAMOffsetDifference, withBytes: magicBounceCompareInstruction)
//
//cdol.save()



//let ddol = XGFiles.dol.data!
//// sheer force
//let sheerForceStart = 0x80213d6c
//let sheerForceInstructions : [UInt32] = [0x7C7C1B78,0x7FA3EB78,0x4BFF1855,0x28030023,0x4082000C,0x3BA00000,0x48000024,0x7C7D1B78,0x7F83E378,0x4BF2A925,0x281D0020,0x7C7D1B78,0x4082000C,0x54600DFC,0x7C1D0378]
//
//for i in 0 ..< sheerForceInstructions.count {
//	let offset = sheerForceStart + (i * 4) - kDolToRAMOffsetDifference
//	ddol.replaceWordAtOffset(offset, withBytes: sheerForceInstructions[i])
//}
//
//// -ate abilities types
//let ateStart = 0x802c8648 - kDolToRAMOffsetDifference
//let ateInstructions = [0x7F83E378,0x4BE76225,0x28030000,0x408200E0,0x7FA3EB78,0x4BF3CF6D,0x28030056,0x4082000C,0x3860000F,0x480000DC,0x28030044,0x4082000C,0x38600009,0x480000CC,0x28030001,0x4082000C,0x38600002,0x480000BC,0x480000A4]
//
//for i in 0 ..< ateInstructions.count {
//	let offset = ateStart + (i * 4)
//	ddol.replaceWordAtOffset(offset, withBytes: UInt32(ateInstructions[i]))
//}
//
//let priorityAbilitiesStart = 0x8015224c - kDolToRAMOffsetDifference
//let priorityAbilitiesInstructions : [UInt32] = [0x9421fff0,0x7C0802A6,0x90010014,0x93E1000C,0x93C10008,0x7C7F1B78,0x48000074,0x4BFEC551,0x28030000,0x40820050,0x7FE3FB78,0x480B3351,0x28030059,0x41820024,0x28030043,0x40820034,0x7FC3F378,0x4BFEC5e1,0x28030002,0x40820024,0x38600001,0x48000020,0x7FC3F378,0x4bfec549,0x28030000,0x4082000C,0x38600001,0x48000008,0x38600000,0x80010014,0x83E1000C,0x83C10008,0x7C0803A6,0x38210010,0x4E800020,0x480B22DD,0x7C7E1B78,0x4BFFFF88]
//
//for i in 0 ..< priorityAbilitiesInstructions.count {
//	let offset = priorityAbilitiesStart + (i * 4)
//	ddol.replaceWordAtOffset(offset, withBytes: priorityAbilitiesInstructions[i])
//}
//
//let determineOrderOffsets = [0x801f43e8,0x801f43ec,0x801f43f4,0x801f43f8]
//let determineOrderInstructions : [UInt32] = [0x7f23cb78,0x4bf5de61,0x7f43d378,0x4bf5de55]
//
//for i in 0 ..< determineOrderOffsets.count {
//	ddol.replaceWordAtOffset(determineOrderOffsets[i] - kDolToRAMOffsetDifference, withBytes: determineOrderInstructions[i])
//}
//
//ddol.save()
//let dol2 = XGFiles.dol.data!
//// hard shell ability
//let hardshellindex = 78
//let hardoffset1 = 0x8022580c - kDolToRAMOffsetDifference
//let hardcomparison : UInt32 = 0x2c00004e
//let hardoffset2 = 0x8022582c - kDolToRAMOffsetDifference
//let hardbranch : UInt32 = 0x4bf18db9
//
//dol2.replaceWordAtOffset(hardoffset1, withBytes: hardcomparison)
//dol2.replaceWordAtOffset(hardoffset2, withBytes: hardbranch)
//
//// regenerator
//let naturalcurechangestart = 0x8021c5cc - kDolToRAMOffsetDifference
//let naturalcurechanges : [UInt32] = [0x7C7E1B78,0x48002559,0x7fe3fb78]
//for i in 0 ... 2 {
//	dol2.replaceWordAtOffset(naturalcurechangestart + (i * 4), withBytes: naturalcurechanges[i])
//}
//
//let regenStart = 0x8021eb28 - kDolToRAMOffsetDifference
//let regenCode : [UInt32] = [0x7fe3fb78,0xa063080c,0x28030054,0x41820008,0x4e800020,0x7fe3fb78,0x80630000,0x38630004,0xA0830090,0xa0630004,0x38000003, 0x7C0403D6,0x7C630214,0x7C032040,0x40810014,0x7fe3fb78,0x80630000,0x38630004,0xA0630090,0x7C641B78,0x7fe3fb78,0x80630000,0x38630004,0xb0830004,0x4e800020]
//for i in 0 ..< regenCode.count {
//	dol2.replaceWordAtOffset(regenStart + (i * 4), withBytes: regenCode[i])
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
//		printg("wrong percentage total for spot: " + spot.string, percentageTotal)
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



//let ldol = XGFiles.dol.data!
//
//// old stat booster (r3 index of stat to boost, r4 battle pokemon)
//let statBoosterStart = 0x8015258c - kDolToRAMOffsetDifference
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
//	ldol.replaceWordAtOffset(statBoosterStart + (i * 4), withBytes: statBoosterCode[i])
//}
//
//// tailwind and trick room
//let safeguards = [0x80214040,0x8021bd6c,0x8022cd90,0x8022d538,0x8022d94c,0x8022e0fc,0x8022e244,0x8022ee48,0x80230154,0x802302f4,0x802306b8,0x80230bd0,0x802314e8,0x802ccf60,0x802de1b4]
//let mists = [0x8022c910,0x802cc790,0x802ccab4,0x802cccf8,0x802ccf40,0x802220a4,0x80210990]
//for offset in safeguards + mists {
//	ldol.replaceWordAtOffset(offset - kDolToRAMOffsetDifference, withBytes: 0x38600000)
//}
//
//let tailBranchOffset = 0x801f4430 - kDolToRAMOffsetDifference
//let tailBranchInstruction = 0x4bf5e04d
//ldol.replaceWordAtOffset(tailBranchOffset, withBytes: UInt32(tailBranchInstruction))
//
//let tailStart = 0x8015247c - kDolToRAMOffsetDifference
//let tailCode : [UInt32] = [0x9421ffe0,0x7c0802a6,0x90010024,0x93e1001c,0x93c10018,0x93a10014,0x93810010,
//0x7f23cb78,0x3880004b,0x480a6041,0x28030001,0x40820008,0x57BD083C,
//0x7f43d378,0x3880004b,0x480a6029,0x28030001,0x40820008,0x57DE083C,
//0x7f23cb78,0x3880004c,0x480a6011,0x28030001,0x40820008,0x48000018,
//0x7f43d378,0x3880004c,0x480a5ff9,0x28030001,0x4082000c,0x7C1EE840,0x48000008,0x7c1df040,
//0x80010024,0x83e1001c,0x83c10018,0x83a10014,0x83810010,0x7c0803a6,0x38210020,0x4e800020
//]
//
//for i in 0 ..< tailCode.count {
//	ldol.replaceWordAtOffset(tailStart + (i * 4), withBytes: tailCode[i])
//}
//
//
// assault vest status moves

//
//let avBranchOffset = 0x802014ac - kDolToRAMOffsetDifference
//let avBranchInstruction : UInt32 = 0x4bf16619
//
//ldol.replaceWordAtOffset(avBranchOffset, withBytes: avBranchInstruction)
//
//let assaultVestStart = 0x80117ac4 - kDolToRAMOffsetDifference
//let assaultVestCode : [UInt32] = [0x28030001,0x40820008,0x4e800020,0x281f004c,0x4082000c,0x38600001,0x4e800020,0x38600000,0x4e800020]
//
//for i in 0 ..< assaultVestCode.count {
//	ldol.replaceWordAtOffset(assaultVestStart + (i * 4), withBytes: assaultVestCode[i])
//}

//ldol.replaceWordAtOffset(0x802014b0 - kDolToRAMOffsetDifference, withBytes: 0x28030001)

//
//
//// allow shadow moves to use hm flag
//let shadowBranchOffsetsR0 = [0x8001c60c,0x8001c7ec,0x8001e314,0x80036c60]
//for offset in shadowBranchOffsetsR0 {
//	ldol.replaceWordAtOffset(offset - kDolToRAMOffsetDifference, withBytes: createBranchAndLinkFrom(offset: offset - 0x80000000, toOffset: 0x21eb8c))
//}
//
//let shadowStart = 0x8021eb8c - kDolToRAMOffsetDifference
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
//	ldol.replaceWordAtOffset(shadowStart + (i * 4), withBytes: shadowCode[i])
//}
//
//let shadowR3Offsets = [0x8007e6dc,0x80034e98]
//for offset in shadowR3Offsets {
//	ldol.replaceWordAtOffset(offset - kDolToRAMOffsetDifference, withBytes: createBranchFrom(offset: offset - 0x80000000, toOffset: 0x21ebb8))
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
//let kdol = XGFiles.dol.data!
//
//let tr2BranchOffset = 0x80152498 - kDolToRAMOffsetDifference
//let tr2BranchInstr  = createBranchFrom(offset: 0x152498, toOffset: 0x152520)
//kdol.replaceWordAtOffset(tr2BranchOffset, withBytes: tr2BranchInstr)
//
//let tr2Start = 0x80152520 - kDolToRAMOffsetDifference
//let tr2Instructions : [UInt32] = [
//	0x7F24CB78,0x38600002,createBranchAndLinkFrom(offset: 0x152528, toOffset: 0x1efcac),0x7C7C1B78,
//	0x7F44D378,0x38600002,createBranchAndLinkFrom(offset: 0x152538, toOffset: 0x1efcac),0x7c7f1b78,
//	0x7F83E378,createBranchFrom(offset: 0x152544, toOffset: 0x15249c) // mr r3, r28 to continue original tr code
//]
//
//
//for i in 0 ..< tr2Instructions.count {
//	kdol.replaceWordAtOffset(tr2Start + (i * 4), withBytes: tr2Instructions[i])
//}
//
//kdol.replaceWordAtOffset(0x801524c8 - kDolToRAMOffsetDifference, withBytes: 0x7F83E378)
//for offset in [0x801524b0,0x801524e0] {
//	kdol.replaceWordAtOffset(offset - kDolToRAMOffsetDifference, withBytes: 0x7FE3FB78)
//}

//// No guard
//let noguardindex = 93
//let noguardstart = 0x802178d4 - kDolToRAMOffsetDifference
//let noguardinstructions : [UInt32] = [kNopInstruction,0x2819005D,
//                                      0x4182000C,
//                                      0x281A005D,
//                                      0x4082000C,
//                                      0x3AC00064,
//                                      0x480000CC
//]
//
//for i in 0 ..< noguardinstructions.count {
//	kdol.replaceWordAtOffset(noguardstart + (i * 4), withBytes: noguardinstructions[i])
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
//let dol = XGFiles.dol.data!
//
//dol.replaceWordAtOffset(0x80221d70 - kDolToRAMOffsetDifference, withBytes: createBranchAndLinkFrom(offset: 0x221d70, toOffset: 0x152548))
//
//dol.save()

//let skillLinkStart = 0x80152548 - kDolToRAMOffsetDifference
//let skillLinkBranchOffset = 0x80221d98 - kDolToRAMOffsetDifference
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
//let bdol = XGFiles.dol.data!
//bdol.replaceWordAtOffset(skillLinkBranchOffset, withBytes: skillLinkBranchInstruction)
//for i in 0 ..< skillLinkCode.count {
//	bdol.replaceWordAtOffset(skillLinkStart + (i * 4), withBytes: skillLinkCode[i])
//}
//
//// foes can enter reverse mode
//let reverseOffset = 0x80226754 - kDolToRAMOffsetDifference
//bdol.replaceWordAtOffset(reverseOffset, withBytes: kNopInstruction)
//
//
////// no infinite weather
//let infiniteOffsets = [0x80225dc4, 0x80225ddc,0x80225d80,0x80225d98,0x80225e20,0x80225e08]
//let infiniteReplacements : [UInt32] = [0x38800056,0x38800055,0x38800054]
//for i in 0 ..< infiniteReplacements.count {
//	let index = i * 2
//	bdol.replaceWordAtOffset(infiniteOffsets[index] - kDolToRAMOffsetDifference, withBytes: infiniteReplacements[i])
//	bdol.replaceWordAtOffset(infiniteOffsets[index + 1] - kDolToRAMOffsetDifference, withBytes: infiniteReplacements[i])
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


//let kdol = XGFiles.dol.data!
//// trick room part 3
//
//let get_pointer_index_func = 0x801f3f3c - kDolToRAMOffsetDifference
//let get_pointer_general_func = 0x801efcac - kDolToRAMOffsetDifference
//let check_status_func = 0x801f848c - kDolToRAMOffsetDifference
//let set_status_function = 0x801f8438 - kDolToRAMOffsetDifference
//let end_status_function = 0x801f8534 - kDolToRAMOffsetDifference
//
//let mist_start = 0x80220f94 - kDolToRAMOffsetDifference
//let mist_continue = 0x80220ff4 - kDolToRAMOffsetDifference
//let tr_start = 0x8021c268 - kDolToRAMOffsetDifference
//
//let label_set_status = tr_start + 0x28
//let label_end_status = tr_start + 0x5c
//let label_end		 = tr_start + 0x84
//
//kdol.replaceWordAtOffset(mist_start, withBytes: createBranchFrom(offset: mist_start, toOffset: tr_start))
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
//	kdol.replaceWordAtOffset(tr_start + offset, withBytes: instruction)
//}
//
//
//// tailwind part 3
//// removes some code to do with safeguard
//let tw_start = 0x8021342c - kDolToRAMOffsetDifference
//let tw_end = 0x80213450 - kDolToRAMOffsetDifference
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
//	kdol.replaceWordAtOffset(tw_start + offset, withBytes: inst)
//}
//
// kdol.save()
//
//
//// magic coat mirror match check
//let magicBranch = 0x80218568 - kDolToRAMOffsetDifference
//let magicCheckStart  = 0x80152568 - kDolToRAMOffsetDifference
//let magicTrueOffset  = 0x8021856c - kDolToRAMOffsetDifference
//let magicFalseOffset = 0x802185dc - kDolToRAMOffsetDifference
//let get_ability_func = 0x80148898 - kDolToRAMOffsetDifference
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
//// old ability activate function
//let abilityActivateStart = 0x80220708 - kDolToRAMOffsetDifference
//let messageParams = 0x801f6780 - kDolToRAMOffsetDifference
//let animSoundCallBack = 0x802236a8 - kDolToRAMOffsetDifference
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
//
//
//
//// rough skin residual
//replaceASM(startOffset: 0x80225234 - kDolToRAMOffsetDifference, newASM: [0x38800008])
//
//
//
//// shadow max belly drum effect
//let bellyBranch = 0x8021e724 - kDolToRAMOffsetDifference
//let bellyStart = 0x802226f4 - kDolToRAMOffsetDifference
//let checkShadowPokemon = 0x80149014 - kDolToRAMOffsetDifference
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
//let freezeStart = 0x8022271c - kDolToRAMOffsetDifference
//let effectCheck = 0x80117a2c - kDolToRAMOffsetDifference
//for i in 0 ..< freezeBranches.count {
//	let branch = freezeBranches[i] - kDolToRAMOffsetDifference
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
//let hunterBranch = 0x80216da0 - kDolToRAMOffsetDifference
//let hunterStart = 0x80222750 - kDolToRAMOffsetDifference
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
//let feintBranch = 0x80216708 - kDolToRAMOffsetDifference
//let feintStart = 0x8022075c - kDolToRAMOffsetDifference
//let feintEnd = 0x80216728 - kDolToRAMOffsetDifference
//let endStatus = 0x802026a0 - kDolToRAMOffsetDifference
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
//let foulBranch = 0x8022a188 - kDolToRAMOffsetDifference
//let foulStart = 0x8022278c - kDolToRAMOffsetDifference
//let foulEnd = foulBranch + 0x8
//replaceASM(startOffset: foulBranch, newASM: [createBranchFrom(offset: foulBranch, toOffset: foulStart), kNopInstruction])
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
//let facadeBranch = 0x8022a5c4 - kDolToRAMOffsetDifference
//let facadeStart = 0x8021e998 - kDolToRAMOffsetDifference
//let checkStatus = 0x802025f0 - kDolToRAMOffsetDifference
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
//let acroBranch = 0x8022a110 - kDolToRAMOffsetDifference
//let acroStart = 0x8021e9b8 - kDolToRAMOffsetDifference
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
//replaceASM(startOffset: 0x8022a4c8 - kDolToRAMOffsetDifference, newASM: [0x28000109])
//
//// shadow sky residual damage
//replaceASM(startOffset:0x80221320 - kDolToRAMOffsetDifference, newASM: [0x38800008])
//
//// remove explosion defense halving
//replaceASM(startOffset: 0x8022a780 - kDolToRAMOffsetDifference, newASM: [kNopInstruction])
//
//// psyshock psystrike
//let psyBranch = 0x8022a97c - kDolToRAMOffsetDifference
//let psyStart = 0x8021e9fc - kDolToRAMOffsetDifference
//let psyTrue = 0x8022a7fc - kDolToRAMOffsetDifference
//let psyfalse = 0x8022a980 - kDolToRAMOffsetDifference
//let psy2Start = 0x8021ea2c - kDolToRAMOffsetDifference
//let psy2Branch = 0x8022a85c - kDolToRAMOffsetDifference
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
//replaceASM(startOffset: 0x8022a48c - kDolToRAMOffsetDifference, newASM: [
//	0x281d0019, // cmpwi r29, pikachu
//	0x4082000c, // bne 0xc
//	0x56b50c3c, // r21 *= 2 (double attack)
//	])
//
//
//// sand spdef boost for rock types
//let sandBranch = 0x8022a1c4 - kDolToRAMOffsetDifference
//let sandEnd = sandBranch + 0x4
//let sandStart = 0x8021db34 - kDolToRAMOffsetDifference
//let checkHasType = 0x802054fc - kDolToRAMOffsetDifference
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
// sheer force sand force amplifier tough claws adaptability technician solar power mega launcher
//let abilityBranch = 0x8022a66c - kDolToRAMOffsetDifference
//let abilityStart = 0x80220cec - kDolToRAMOffsetDifference
//let abilityEnd = abilityBranch + 0x4
//let checkHasType = 0x802054fc - kDolToRAMOffsetDifference
//let noBoost = 0xa8
//let boost33 = 0x94
//let noBoost50 = 0x120
//let boost50 = 0x10c
//let sandCheck = 0x80220ec0 - kDolToRAMOffsetDifference
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
//	kNopInstruction, //0x2803005c, // cmpwi r3, amplifier
//	kNopInstruction, //	powerPCBranchNotEqualFromOffset(from: 0x38, to: 0x50),
//	kNopInstruction, //	0x7c832378, // mr r3, r4
//	kNopInstruction, //	0x8863000b, // lbz r3, 0x000b (r3) (get sound flag)
//	kNopInstruction, //	0x28030000, // cmpwi r3, 0
//	kNopInstruction, //	powerPCBranchEqualFromOffset(from: 0x48, to: noBoost),
//	kNopInstruction, //	createBranchFrom(offset: 0x4c, toOffset: boost33),
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
//// aerilate, pixilate, refrigerate, reckless
//let ability2Branch = 0x8022a670 - kDolToRAMOffsetDifference
//let ability2Start = 0x8022190c - kDolToRAMOffsetDifference
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
//let ability3Branch = 0x8022a674 - kDolToRAMOffsetDifference
//let ability3Start = 0x802227f4 - kDolToRAMOffsetDifference
//let ability3End = ability3Branch + 0x4
//let halfDamage = 0x7c
//let noHalfDamage = 0x90
//let checkFullHP = 0x80201d20 - kDolToRAMOffsetDifference
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
//let stormBranch = 0x80218a70 - kDolToRAMOffsetDifference
//let stormStart = 0x8022288c - kDolToRAMOffsetDifference
//let rodFalseOffset = 0x80218b54 - kDolToRAMOffsetDifference
//let rodCheckOffset = 0x80218a84 - kDolToRAMOffsetDifference
//let rodFalse = 0x48
//let rodCheck = 0x4c
//let getFoeWithAbility = 0x801f38d8 - kDolToRAMOffsetDifference
//let changeTarget = 0x80218aa4 - kDolToRAMOffsetDifference
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
//replaceASM(startOffset: 0x8022a3a0 - kDolToRAMOffsetDifference, newASM: ASM(repeating: kNopInstruction, count: 8))
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
//let shadow355Start = 0x8021e380 - kDolToRAMOffsetDifference
//let shadowBranchOffset355 = 0x80146eb4 - kDolToRAMOffsetDifference
//let shadow355End = 0x80146ebc - kDolToRAMOffsetDifference
//let shadowSkip = 0x80146ecc - kDolToRAMOffsetDifference
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
//let shadow355Start2 = 0x8021db70 - kDolToRAMOffsetDifference
//let shadowBranchOffset3552 = 0x80146f28 - kDolToRAMOffsetDifference
//let shadow355End2 = 0x80146f30 - kDolToRAMOffsetDifference
//let shadowSkip2 = 0x80146f50 - kDolToRAMOffsetDifference
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
//replaceASM(startOffset: 0x80146f38 - kDolToRAMOffsetDifference, newASM: [
//0x7c601b78, // mr r0, r3
//0x3c6080b9, // lis r3, 0x80b9
//0x5404103a, // rlwinm r4, r0 (x4)
//0x3803c500, // subi r0, r3, 0x3b00
//])

// calc damage 2
//let calc_boosts = 0x80229fe4 - kDolToRAMOffsetDifference
//let boostOffsets = [0x802dcc14,0x8020daec]
//for offset in boostOffsets {
//	replaceASM(startOffset: offset - kDolToRAMOffsetDifference, newASM: [createBranchAndLinkFrom(offset: offset - kDolToRAMOffsetDifference, toOffset: calc_boosts)])
//}

//// pixilate aerilate refrigerate
//let ateBranch  = 0x802183dc - kDolToRAMOffsetDifference
//let ateStart   = 0x8021dba0 - kDolToRAMOffsetDifference
//let ateEnd     = 0x802183e0 - kDolToRAMOffsetDifference
//let storeType  = 0x8013e064 - kDolToRAMOffsetDifference
//let getRoutine = 0x80148da8 - kDolToRAMOffsetDifference
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
//	removeASM(startOffset: offset - kDolToRAMOffsetDifference, length: length)
//}



//// calc damage boosts
//let calcOffsets = [0x802dcc14,0x8020daec,0x8021e224,0x802db020,0x8022713c,0x80216d0c]
//let calcDamageBoosts = 0x80229fe4 - kDolToRAMOffsetDifference
//let calcStart = 0x80220e10 - kDolToRAMOffsetDifference
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
//	let o = offset - kDolToRAMOffsetDifference
//	replaceASM(startOffset: o, newASM: [createBranchAndLinkFrom(offset: o, toOffset: calcStart)])
//}
////sturdy and focus sash
//let sashstart = 0x80216010 - kDolToRAMOffsetDifference
//replaceASM(startOffset: sashstart, newASM: [0x28170027,0x41820014,0x7fa3eb78,0x4bf3287d,0x28030005,0x40820024,0x7fa3eb78,0x4bfebcf5,0x5460063f,0x41820014,0x7fa3eb78,0x38800001,kNopInstruction])
//replaceASM(startOffset: 0x80216140 - kDolToRAMOffsetDifference, newASM: [0x388000c4]) // pretend pokemon is holding focus sash
//
//// sash/sturdy shedinja check
////
//let shedinjaBranch = 0x80216010 - kDolToRAMOffsetDifference
//let shedinjaTrueBranch = 0x80216048 - kDolToRAMOffsetDifference
//let shedinjaFalseBranch = 0x80216014 - kDolToRAMOffsetDifference
//let shedinjaCheckStart = 0x80152660 - kDolToRAMOffsetDifference
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
//let veilStart = 0x8021c7e0 - kDolToRAMOffsetDifference
//
//let moveRoutineSetPosition = 0x802236d4 - kDolToRAMOffsetDifference
//let moveRoutineUpdatePosition = 0x802236dc - kDolToRAMOffsetDifference
//
//let getPokemonPointer = 0x801efcac - kDolToRAMOffsetDifference
//let setFieldStatus = 0x801f8438 - kDolToRAMOffsetDifference
//let getCurrentMove = 0x80148d64 - kDolToRAMOffsetDifference
//let getWeather = 0x801f45d0 - kDolToRAMOffsetDifference
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
//replaceASM(startOffset: 0x8028bac0 - kDolToRAMOffsetDifference, newASM: [0x8863001f, kNopInstruction])
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
//let weatherBranch = 0x802180e0 - kDolToRAMOffsetDifference
//let weatherStart  = 0x802296E4 - kDolToRAMOffsetDifference
//
//let accurate   = 0x802180f8 - kDolToRAMOffsetDifference
//let inaccurate = 0x80218100 - kDolToRAMOffsetDifference
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
//replaceASM(startOffset: 0x80227e64 - kDolToRAMOffsetDifference, newASM: [0x38800010])
//
//
//// filter tinted lens expert belt
//
//// tinted lens
//let oldLensBranch = 0x80216ac4 - kDolToRAMOffsetDifference
//
//let lens2Start = 0x8021c2f0 - kDolToRAMOffsetDifference
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
//	createBranchAndLinkFrom(offset: lens2Start + 0x1c, toOffset: 0x801efcac - kDolToRAMOffsetDifference), // get pokemon pointer
//	0xa063080c,	// lhz r3, 0x80c(r3)
//	0x2803006a,	// cmpwi r3, tinted lens
//	powerPCBranchNotEqualFromOffset(from: 0x28, to: 0x38), // bne lens end
//
//	0x1C7D0014,	// mulli r3, r29, 20
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
//let oldFilterBranch = 0x80216ad4 - kDolToRAMOffsetDifference
//revertDolInstructionAtOffsets(offsets: [oldFilterBranch, oldLensBranch])
//
//// filter + expert belt
//let filter2Start = 0x802295F8 - kDolToRAMOffsetDifference
//
//let getItem = 0x8020384c - kDolToRAMOffsetDifference
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
//	createBranchAndLinkFrom(offset: filter2Start + 0x1c, toOffset: 0x801efcac - kDolToRAMOffsetDifference), // get pokemon pointer
//	0xa063080c,	// lhz r3, 0x80c(r3) (get ability)
//	0x28030065,	// cmpwi r3, filter
//	powerPCBranchNotEqualFromOffset(from: 0x28, to: 0x38),
//
//	0x1C7D004B,	// mulli r3, r29, 75
//	0x38000064,	// li r0, 100
//	0x7FA303D7,	// divw r29, r3, r0
//
//	0x38600011, //li r3, 17 (attacking pokemon)
//	0x38800000, // li r4, 0
//	createBranchAndLinkFrom(offset: filter2Start + 0x40, toOffset: 0x801efcac - kDolToRAMOffsetDifference), // get pokemon pointer
//	createBranchAndLinkFrom(offset: filter2Start + 0x44, toOffset: getItem), // get item's hold item id
//	0x28030047, // cmpwi r3, 71 (compare with expert belt)
//	powerPCBranchNotEqualFromOffset(from: 0x4c, to: 0x5c),
//
//	0x1C7D0078,	// mulli r3, r29, 120
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
//let getEffectiveness = 0x8022271c - kDolToRAMOffsetDifference
//
//let effectiveEnd = 0x78
//let filterCheckStart = 0x58
//let tintedCheckStart = 0x44
//let filterStart = 0x6c
//let tintedStart = 0x74
//
//let effectiveStart = 0x80229578 - kDolToRAMOffsetDifference
//let effectiveBranch = 0x80216840 - kDolToRAMOffsetDifference
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
//// expert belt tinted lens filter on shadow moves
//let shadowTintedBranch = 0x216dd0
//let shadowFilterBranch = 0x216e00
//let shadowTintedStart = 0xB99FA8
//let shadowFilterStart = 0xB99FC4
//XGAssembly.replaceASM(startOffset: shadowTintedBranch - kDolToRAMOffsetDifference, newASM: [XGAssembly.createBranchFrom(offset: shadowTintedBranch, toOffset: shadowTintedStart)])
//XGAssembly.replaceASM(startOffset: shadowFilterBranch - kDolToRAMOffsetDifference, newASM: [XGAssembly.createBranchFrom(offset: shadowFilterBranch, toOffset: shadowFilterStart)])
//XGAssembly.replaceRELASM(startOffset: shadowTintedStart - kRELtoRAMOffsetDifference, newASM: [
//	0x7f83e378, // mr	r3, r28 (attacking pokemon)
//	0xa063080c,	// lhz r3, 0x80c(r3) (get ability)
//	0x2803006a,	// cmpwi r3, tinted lens
//	XGAssembly.powerPCBranchNotEqualFromOffset(from: 0x0, to: 0x8), // bne lens end
//	0x5739083c,	// rlwinm	r25, r25, 1, 0, 30 (7fffffff) (25 << 1)
//	0x7fe3fb78, // mr	r3, r31 (overwritten code)
//	XGAssembly.createBranchFrom(offset: shadowTintedStart + 0x18, toOffset: shadowTintedBranch + 0x4)
//])
//let getItem2 = 0x20384c
//XGAssembly.replaceRELASM(startOffset: shadowFilterStart - kRELtoRAMOffsetDifference, newASM: [
//
//	0x7f63db78, // mr r3, r27 (defending pokemon)
//	0xa063080c,	// lhz r3, 0x80c(r3) (get ability)
//	0x28030065,	// cmpwi r3, filter
//	XGAssembly.powerPCBranchNotEqualFromOffset(from: 0x0, to: 0x10), // bne filter end
//	0x1cb9004B, // mulli	r5, r25, 75
//	0x38000064, // li	r0, 100
//	0x7f2503d6, // divw	r25, r5, r0
//
//	0x7f83e378, // mr	r3, r28 (attacking pokemon)
//	XGAssembly.createBranchAndLinkFrom(offset: shadowFilterStart + 0x20, toOffset: getItem2), // get item's hold item id
//	0x28030047, // cmpwi r3, 71 (compare with expert belt)
//	XGAssembly.powerPCBranchNotEqualFromOffset(from: 0x0, to: 0x10), // bne expert belt end
//	0x1cb90078, // mulli	r5, r25, 120
//	0x38000064, // li	r0, 100
//	0x7f2503d6, // divw	r25, r5, r0
//
//	0x7fe3fb78, // mr	r3, r31 (overwritten code)
//	XGAssembly.createBranchFrom(offset: shadowFilterStart + 0x3c, toOffset: shadowFilterBranch + 0x4),
//	// filler
//	kNopInstruction,
//	kNopInstruction,
//	kNopInstruction,
//	kNopInstruction,
//	kNopInstruction,
//])
//
//// expert belt fix
//let filter2Start = 0x2295F8 - kDolToRAMOffsetDifference
//let getItem = 0x20384c - kDolToRAMOffsetDifference
//XGAssembly.replaceASM(startOffset: filter2Start, newASM: [
//
//	0x9421ffe0, // stwu	sp, -0x0020 (sp)
//	0x7c0802a6, // mflr	r0
//	0x90010024, // stw	r0, 0x0024 (sp)
//	0xbfa10014, // stmw	r29, 0x0014 (sp)
//	0x83B2009C, // lwz	r29, 0x009C (r18)
//
//	0x38600012, // li r3, 18 (defending pokemon)
//	0x38800000, // li r4, 0
//	XGAssembly.createBranchAndLinkFrom(offset: filter2Start + 0x1c, toOffset: 0x1efcac - kDolToRAMOffsetDifference), // get pokemon pointer
//	0xa063080c,	// lhz r3, 0x80c(r3) (get ability)
//	0x28030065,	// cmpwi r3, filter
//	XGAssembly.powerPCBranchNotEqualFromOffset(from: 0x28, to: 0x38),
//
//	0x1C7D004B,	// mulli r3, r29, 75
//	0x38000064,	// li r0, 100
//	0x7FA303D7,	// divw r29, r3, r0
//
//	0x38600011, //li r3, 17 (attacking pokemon)
//	0x38800000, // li r4, 0
//	XGAssembly.createBranchAndLinkFrom(offset: filter2Start + 0x40, toOffset: 0x1efcac - kDolToRAMOffsetDifference), // get pokemon pointer
//	XGAssembly.createBranchAndLinkFrom(offset: filter2Start + 0x44, toOffset: getItem), // get item's hold item id
//	0x28030047, // cmpwi r3, 71 (compare with expert belt)
//	XGAssembly.powerPCBranchNotEqualFromOffset(from: 0x4c, to: 0x5c),
//
//	0x1C7D0078,	// mulli r3, r29, 120
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
//// timer ball update to closer to gen V+ mechanics (maxes in 15 turns)
//XGAssembly.replaceASM(startOffset: 0x219444 - kDolToRAMOffsetDifference, newASM: [
//	0x54630C3C, // r3  = r3 * 2
//	0x3B83000A, // r28  = r3 + 10
//])
//
//renameZaprong(newName: "BonBon")
//
//// shadow terrain
//let terrainBranch = 0x8022a60c - kDolToRAMOffsetDifference
//let terrainStart = 0x8021e9ec - kDolToRAMOffsetDifference
//let terrainTrue = 0x8022a618 - kDolToRAMOffsetDifference
//let terrainFalse = 0x8022a63c - kDolToRAMOffsetDifference
//let checkShadowMove = 0x8013d03c - kDolToRAMOffsetDifference
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
//let checkShadowPokemon = 0x80149014 - kDolToRAMOffsetDifference
//let itemBranch = 0x8022a678 - kDolToRAMOffsetDifference
//let itemStart = 0x802219e0 - kDolToRAMOffsetDifference
//let itemEnd = itemBranch + 0x4
//let itemBuff = 0x68
//let itemNerf = 0x104
//let defenderStart = 0x80
//let defenderEnd = 0x118
//let getStats = 0x80146078 - kDolToRAMOffsetDifference
//let getEvolutionMethod = 0x80145c18 - kDolToRAMOffsetDifference
//let getItemParameter = 0x80203828 - kDolToRAMOffsetDifference
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
//let auraAnimation = 0x80205c9c - kDolToRAMOffsetDifference
//
//let auraStart   = 0x80229734 - kDolToRAMOffsetDifference
//
//let auraBranch = 0x80215e08 - kDolToRAMOffsetDifference
//
//let checkStatus = 0x802025f0 - kDolToRAMOffsetDifference
//let getCurrentMove = 0x80148d64 - kDolToRAMOffsetDifference
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
//	createBranchAndLinkFrom(offset: auraStart + 0x18, toOffset: 0x801efcac - kDolToRAMOffsetDifference), // get pokemon pointer
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
//	let ow = XGUtility.exportDatFromPKX(pkx: file)
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


//// shadow shake
//let shakeBranch = 0x216d94 - kDolToRAMOffsetDifference
//let shakeStart = 0x21fe38 - kDolToRAMOffsetDifference
//let groundTrue = 0x216e10 - kDolToRAMOffsetDifference
//let groundFalse = shakeBranch + 0x4
//let setEffect = 0x1f057c - kDolToRAMOffsetDifference
//let checkForType = 0x2054fc - kDolToRAMOffsetDifference
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
//let suckerBranch = 0x216e10 - kDolToRAMOffsetDifference
//let suckerStart = 0x21fe88 - kDolToRAMOffsetDifference
//let suckerEnd = suckerBranch + 0x4
////let setEffect = 0x1f057c - kDolToRAMOffsetDifference
//let getCurrentMove = 0x148d64 - kDolToRAMOffsetDifference
//let getMovePower = 0x13e71c - kDolToRAMOffsetDifference
//let getMoveOrder = 0x1f4300 - kDolToRAMOffsetDifference
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
//let skillBranch1 = 0x221d70 - kDolToRAMOffsetDifference
//let skillBranch2 = 0x221d98 - kDolToRAMOffsetDifference
//let skillStart = 0x152548 - kDolToRAMOffsetDifference
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
//let shadeStart = 0x219380 - kDolToRAMOffsetDifference
//let checkShadow = 0x13efec - kDolToRAMOffsetDifference
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
//replaceASM(startOffset: 0x219370 - kDolToRAMOffsetDifference, newASM: [0x3b800023])
//
//// magic bounce 2
//let setStatus = 0x2024a4 - kDolToRAMOffsetDifference
//let getMove = 0x148d64 - kDolToRAMOffsetDifference
//let coatBranch = 0x218590 - kDolToRAMOffsetDifference
//let coatReturn = coatBranch + 0x4
//let coatStart = 0x21ea68 - kDolToRAMOffsetDifference
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
//let coatCheckBranch = 0x20e3c4 - kDolToRAMOffsetDifference
//let coatCheckReturn = coatCheckBranch + 0x4
//let coatCheckStart = 0x21dc10 - kDolToRAMOffsetDifference
//let checkStatus = 0x2025f0 - kDolToRAMOffsetDifference
//let getPokemon = 0x1efcac - kDolToRAMOffsetDifference
//let setMove = 0x14774c - kDolToRAMOffsetDifference
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
//let coatChangeBranch = 0x209bac - kDolToRAMOffsetDifference
//let coatChangeReturn = coatChangeBranch + 0x4
//let coatNopOffset = 0x209bb4 - kDolToRAMOffsetDifference
//let coatChangeStart = 0x21bc80 - kDolToRAMOffsetDifference
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
//let sarfissBranch = 0x221238 - kDolToRAMOffsetDifference
//let sarfissStart = 0x221998 - kDolToRAMOffsetDifference
//let sarfissReturn = sarfissBranch + 0x8
//let sarfissNoDamage = 0x22127c - kDolToRAMOffsetDifference
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
////Sand rush
//let sandstart = 0x2009c0
//// slush rush speed
//let slushBranch = sandstart + 0x10
//let slushstart = XGAssembly.ASMfreeSpacePointer()
//XGAssembly.replaceDOLASM(startOffset: slushstart - kDOLtoRAMOffsetDifference, newASM: [
//	0x2817005b, // cmpwi r23, sand rush
//	0x40820008, // bne 0x8
//	XGAssembly.createBranchFrom(offset: slushstart + 0x8, toOffset: sandstart + 0x1c),
//	0x28170057, // cmpwi r23, slush rush
//	0x41820008, // beq 0x8
//	XGAssembly.createBranchFrom(offset: slushstart + 0x14, toOffset: sandstart + 0x24),
//	0x281C0004, // cmpwi r28, hail
//	0x41820008, // beq 0x8
//	XGAssembly.createBranchFrom(offset: slushstart + 0x20, toOffset: sandstart + 0x24),
//	XGAssembly.createBranchFrom(offset: slushstart + 0x24, toOffset: sandstart + 0x3c),
//])
//
//// slush rush and snow cloak immune to hail
//let slimStart = 0x22129c - kDolToRAMOffsetDifference
//XGAssembly.replaceASM(startOffset: slimStart, newASM: [
//	0x57e0043e, // rlwinm	r0, r31, 0, 16, 31 (0000ffff)
//	0x28000069, // cmpwi r0, snow cloak
//	XGAssembly.powerPCBranchEqualFromOffset(from: 0x8, to: 0x3c),
//	0x28000057, // cmpwi r0, slush rush
//	XGAssembly.powerPCBranchEqualFromOffset(from: 0x10, to: 0x3c),
//])
//
//// aura filter immune to shadow sky
//let afissBranch = 0x2212e4 - kDolToRAMOffsetDifference
//let afissReturn = afissBranch + 0x4
//let afissNoDamage = 0x221330 - kDolToRAMOffsetDifference
//let afissStart = 0x2219b8 - kDolToRAMOffsetDifference
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
////let checkStatus = 0x2025f0 - kDolToRAMOffsetDifference
//let rageStart = 0x22a67c - kDolToRAMOffsetDifference
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
//let dol = XGFiles.dol.data!
//dol.replaceByteAtOffset(0x3f93e0 + (48 * 0x14) + 4, withByte: 4)
//
//// make tail wind last 4 turns
////let dol = XGFiles.dol.data!
//dol.replaceByteAtOffset(0x3f93e0 + (75 * 0x14) + 4, withByte: 4)
//
//for tm in XGTMs.allTMs() {
//
//	tm.updateItemDescription()
//
//}

// binding moves residual damage to 1/8 (whirpool, firespin, etc.)
//XGAssembly.replaceASM(startOffset: 0x22807c - kDolToRAMOffsetDifference, newASM: [0x38800008])


//let dive = XGFiles.nameAndFolder("ball_dive.fdat", .TextureImporter).compress()
//XGFiles.fsys("people_archive.fsys").fsysData.replaceFile(file: dive)


//// sash/sturdy 2 (multihit moves work)
//let sash2Branch   = 0x216038
//let sash2Start    = 0xb99350
//let getMoveEffect = 0x13e6e8
//XGAssembly.replaceASM(startOffset: sash2Branch - kDolToRAMOffsetDifference, newASM: [
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
//let hunterStart = 0x22a6a4 - kDolToRAMOffsetDifference
//let checkShadowPokemon = 0x149014 - kDolToRAMOffsetDifference
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
//let hexStart = 0x22a6ec - kDolToRAMOffsetDifference
//let checkNoStatus = 0x203744 - kDolToRAMOffsetDifference
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
//XGAssembly.replaceASM(startOffset: 0x218bb4 - kDolToRAMOffsetDifference, newASM: [0x4800003c])


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

////Sand rush
//let sandstart = 0x2009c0 + kDolToRAMOffsetDifference
//// slush rush speed
//let slushBranch = sandstart + 0x14
//let slushstart = 0xB99ED8
//XGAssembly.replaceASM(startOffset: slushBranch - kDolToRAMOffsetDifference, newASM: [XGAssembly.createBranchFrom(offset: slushBranch, toOffset: slushstart)])
//XGAssembly.replaceRELASM(startOffset: slushstart - kRELtoRAMOffsetDifference, newASM: [
//	0x2817005b, // cmpwi r23, sand rush
//	0x40820008, // bne 0x8
//	XGAssembly.createBranchFrom(offset: slushstart + 0x8, toOffset: sandstart + 0x1c),
//	0x28170057, // cmpwi r23, slush rush
//	0x41820008, // beq 0x8
//	XGAssembly.createBranchFrom(offset: slushstart + 0x14, toOffset: sandstart + 0x24),
//	0x281C0004, // cmpwi r28, hail
//	0x41820008, // beq 0x8
//	XGAssembly.createBranchFrom(offset: slushstart + 0x20, toOffset: sandstart + 0x24),
//	XGAssembly.createBranchFrom(offset: slushstart + 0x24, toOffset: sandstart + 0x3c),
//])
//
//// slush rush and snow cloak immune to hail
//let slimStart = 0x22129c - kDolToRAMOffsetDifference
//XGAssembly.replaceASM(startOffset: slimStart, newASM: [
//	0x57e0043e, // rlwinm	r0, r31, 0, 16, 31 (0000ffff)
//	0x28000069, // cmpwi r0, snow cloak
//	XGAssembly.powerPCBranchEqualFromOffset(from: 0x8, to: 0x3c),
//	0x28000057, // cmpwi r0, slush rush
//	XGAssembly.powerPCBranchEqualFromOffset(from: 0x10, to: 0x3c),
//])

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
//XGAssembly.replaceASM(startOffset: terrainBranch - kDolToRAMOffsetDifference, newASM: [XGAssembly.createBranchFrom(offset: terrainBranch, toOffset: terrainStart),kNopInstruction])
//XGAssembly.replaceRELASM(startOffset: terrainStart - kRELtoRAMOffsetDifference, newASM: terrainCode)

//// shadow terrain residual healing to 1/10
//XGAssembly.replaceASM(startOffset: 0x227ae8 - kDolToRAMOffsetDifference, newASM: [0x3880000A])
//
//// regular moves doe 75% damage in shadow terrain
//XGAssembly.replaceASM(startOffset: 0x22a62c - kDolToRAMOffsetDifference, newASM: [
//	0x1C160003, // mulli	r0, r22, 3
//	0x7C001670, // srawi	r0, r0,2
//])

//// allow endured the hit message to be set elsewhere (effectiveness 70) (interferes with focus sash message)
//for offset in [0x2160f8, 0x2160e0] {
//	XGAssembly.replaceASM(startOffset: offset - kDolToRAMOffsetDifference, newASM: [0x38800047])
//}
//
//// spiky shield 1 (replaces endure effect)
//XGAssembly.replaceASM(startOffset: 0x223514 - kDolToRAMOffsetDifference, newASM: [0x28000113])
//XGAssembly.replaceASM(startOffset: 0x223570 - kDolToRAMOffsetDifference, newASM: [kNopInstruction])
//XGAssembly.replaceASM(startOffset: 0x2235dc - kDolToRAMOffsetDifference, newASM: [kNopInstruction,kNopInstruction, kNopInstruction])
//let endureRemove = 0x21607c - kDolToRAMOffsetDifference
//XGAssembly.replaceASM(startOffset: endureRemove, newASM: [kNopInstruction,kNopInstruction,kNopInstruction,kNopInstruction,kNopInstruction])
//XGAssembly.replaceASM(startOffset: 0x2160d8 - kDolToRAMOffsetDifference, newASM: [0x48000030])
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
//XGAssembly.replaceASM(startOffset: rockyBranch - kDolToRAMOffsetDifference, newASM: [XGAssembly.createBranchFrom(offset: rockyBranch, toOffset: rockyStart)])
//XGAssembly.replaceRELASM(startOffset: rockyStart - kRELtoRAMOffsetDifference, newASM: rockyCode)


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
//XGAssembly.replaceASM(startOffset: hpCheckBranch - kDolToRAMOffsetDifference, newASM: [XGAssembly.createBranchFrom(offset: hpCheckBranch, toOffset: hpCheckStart)])
//XGAssembly.replaceASM(startOffset: hpCheckStart - kDolToRAMOffsetDifference, newASM: hpCode)

//// foul play 2, include stat boosts on foe
//let fpBranch = 0x22a120 - kDolToRAMOffsetDifference
//let fpStart = 0x2209cc - kDolToRAMOffsetDifference
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
//let roarStart = 0x221c54 - kDolToRAMOffsetDifference
//XGAssembly.replaceASM(startOffset: roarStart, newASM: [0x7c7f1b78,kNopInstruction,kNopInstruction])
//
//// roar move routine doesn't show animation etc.
//let roarRoutineStart = 0x413f45
//let dol = XGFiles.dol.data!
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
//XGAssembly.replaceASM(startOffset: statBranch - kDolToRAMOffsetDifference, newASM: [
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
//// might help with some issues with animating custom stat boost stages which are > +2 or < -2
//let nerfBranch = 0x210ce4 - kDolToRAMOffsetDifference
//let buffBranch = 0x210cd4 - kDolToRAMOffsetDifference
//XGAssembly.replaceASM(startOffset: nerfBranch, newASM: [0x48000024])
//XGAssembly.replaceASM(startOffset: buffBranch, newASM: [0x40800024])


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
//		(pokemon("marill"),move("draining kiss"),.hardy,.water,0),
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
//		(pokemon("zubat"),move("air slash"),.hardy,.flying,0),
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
//		(pokemon("grumpig"),move("psyshock"),.modest,.psychic,0),
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
//		(pokemon("sableye"),move("toxic"),.brave,.ghost,0),
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
//		(pokemon("registeel"),move("superpower"),.hardy,.steel,0),
//		(pokemon("omastar"),move("scald"),.hardy,.rock,0),
//		(pokemon("lapras"),move("hydro pump"),.hardy,.ice,0),
//	//card 8
//		(pokemon("dragonite"),move("dragon claw"),.jolly,.dragon,0),
//		(pokemon("aggron"),move("metal claw"),.adamant,.rock,0),
//		(pokemon("dragonite"),move("iron tail"),.adamant,.flying,0),
//		(pokemon("tyranitar"),move("stone edge"),.adamant,.rock,0),
//		(pokemon("altaria"),move("disarming voice"),.hardy,.dragon,0),
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

//let names = ["Starter Card", "Match-Up Card", "Mix-Up Card", "Edgy Card", "Immunity Card", "Bug Card", "Solid Card", "Dragon Card", "Legend Card", "Myth Card", "Bonsly Card"]
//let descs = ["A simple Card for learning the rules.",
//			 "Watch out for unexpected match-ups!",
//			 "This one will try to trick you.",
//			 "Type advantage isn't a guarantee.",
//			 "Good luck landing any hits...",
//			 "No strategy here. Are you adaptable?",
//			 "Your starter is no good. Get Catching!",
//			 "All strong but which have the best moves?",
//			 "Legendary pokemon come out to play!",
//			 "Can you handle the strongest pokemon?",
//			 "Little pokemon with big moves."]
//
//for i in 0 ..< CommonIndexes.NumberOfBingoCards.value {
//	let card = XGBattleBingoCard(index: i)
//	print("Bingo Card \(i)")
//	getStringSafelyWithID(id: card.detailsID).duplicateWithString("[07]{01}" + descs[i]).replace()
//	getStringSafelyWithID(id: card.nameID).duplicateWithString(names[i]).replace()
//}


//let earthquakeStart = 0x4158fb - kDolTableToRAMOffsetDifference
//let earthquakeRoutine = [
//
//	// intro 0x4158fb
//	0x00, 0x32, 0x80, 0x22, 0x0a, 0x17, 0x80, 0x4e, 0x85, 0xc3, 0x1, 0x02, 0x3b,
//
//	// next target 0x415908
//	0xc2,
//
//	// reset 0x415909
//	0x26,
//	0x32, 0x80, 0x4e, 0x85, 0xc3, 0x80, 0x22, 0x0a, 0x17, 0x1,
//
//	// check if should work and check accuracy 0x415914
//	0x00, 0x01, 0x80, 0x41, 0x59, 0x8e, 0x00, 0x00,
//	0x29, 0x80, 0x41, 0x59, 0x34,
//
//	// filler 0x415922
//	0x00, 0x00, 0x00, 0x00, 0x00,
//	0x00, 0x00, 0x00, 0x00, 0x00,
//	0x00, 0x00, 0x00, 0x00, 0x00,
//	0x00, 0x00, 0x00, 0x00,
//
//	// set damage multiplier to 1 0x415934
//	0x39, 0x80, 0x4e, 0xb9, 0x38, 0x00, 0x02, 0x00, 0x00,
//	0x2f, 0x80, 0x4e, 0xb9, 0x5e, 0x01,
//
//	// start move 0x415943
//	0xfc, 0x07, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x39, 0x00, 0x00, 0x00, 0x00, 0x80, 0x4e, 0xb9, 0x5e,
//
//	// start damage routine 0x415957
//	0x3b, 0x3b, 0x3b, 0x3b, 0x3b, // filler
//	0x05, 0x06, 0x07, 0x08, // calcs
//	0x0a, 0x0b, 0x00, // animations
//	0x0f, 0x5d, 0x12, 0x3b, 0x0c, 0x12, 0x0e, 0x13, 0x00, 0x40, 0x10, 0x13, 0x00, 0x50, // messages
//	0x0d, 0x12, 0x0b, 0x04, 0x1a, 0x12, 0x00, 0x00, 0x00, 0x00, 0x00, // animations 2
//	0x2f, 0x80, 0x4e, 0xb9, 0x47, 0x00, 0x16, 0x4a, 0x02, 0x10, // after move
//	0x7c, 0x80, 0x41, 0x59, 0x09, 0x01, // jump while valid target
//	0x04, 0x3e, // end move
//
//	// attack missed 0x41598e
//	0x3a, 0x00, 0x20, 0x07, 0x46, 0x12, 0x17, 0x00, 0x00, 0x00, 0x00, 0x0f, 0x10, 0x13, 0x00, 0x50, 0x0b, 0x04, 0x2f, 0x80, 0x4e, 0xb9, 0x47, 0x00, 0x4a, 0x02, 0x10, 0x7c, 0x80, 0x41, 0x59, 0x09, 0x01, 0x3e,]
//
//let dol = XGFiles.dol.data!
//dol.replaceBytesFromOffset(earthquakeStart, withByteStream: earthquakeRoutine)
//dol.save()

//// new uturn routine using update jump if status so volt switch won't trigger on ground types
//let uturnRoutine = XGAssembly.routineRegularHitOpenEnded() + [
//	// baton pass routine
//	0x77, 0x11, 0x07, 0x51, 0x11, 0x80, 0x41, 0x5c, 0xb4, 0xe1, 0x11, 0x3b, 0x52, 0x11, 0x02, 0x59, 0x11, 0x4d, 0x11,
//  0x4e, 0x11, 0x02,  // 0x02 prevents passing statuses effect from baton pass (use 0x01 if you want the effect)
//  0x74, 0x11, 0x14, 0x80, 0x2f, 0x90, 0xe0, 0x4f, 0x11, 0x01, 0x13, 0x00, 0x00, 0x3b, 0x53, 0x11, 0x3b, 0x3e,
//]
//let uturnOffset = 0xB9B634
//XGAssembly.setMoveEffectRoutine(effect: 57, fileOffset: uturnOffset - kRELtoRAMOffsetDifference, moveToREL: true, newRoutine: uturnRoutine)
//
//// dragon tail
//let dragonTailRoutine = XGAssembly.routineRegularHitOpenEnded() + [
//	// roar routine
//	0x1f, 0x12, 0x15, 0x80, 0x41, 0x7a, 0x7f,
//	0x90, 0x80, 0x41, 0x5c, 0xb4,
//]
//// use this one to remove suction cups as an ability
//let dragonTailRoutine2 = XGAssembly.routineRegularHitOpenEnded() + [
//	// roar
//	0x90, 0x80, 0x41, 0x5c, 0xb4,
//]
//
//let dragontailOffset = 0xB9B7D0
//XGAssembly.setMoveEffectRoutine(effect: move("dragon tail").data.effect, fileOffset: dragontailOffset - kRELtoRAMOffsetDifference, moveToREL: true, newRoutine: dragonTailRoutine2)
//
//let shadowAnalysisRoutine = XGAssembly.routineRegularHitOpenEnded() + [0xa4, 0x80, 0x41, 0x5c, 0xb4, 0x11, 0x00, 0x00, 0x4e, 0xa0, 0x13, 0x00, 0x60, 0x0b, 0x04, 0x29, 0x80, 0x41, 0x41, 0x0f,]
//let analysisOffset = 0xB9B81C
//XGAssembly.setMoveEffectRoutine(effect: move("shadow analysis").data.effect, fileOffset: analysisOffset - kRELtoRAMOffsetDifference, moveToREL: true, newRoutine: shadowAnalysisRoutine)
//
//let shadowGiftRoutine = [0x00, 0x02, 0x04, 0x50, 0x11, 0x80, 0x41, 0x5c, 0x93, 0x00, 0x0a, 0x0b, 0x04, 0x77, 0x11, 0x07, 0x51, 0x11, 0x80, 0x41, 0x5c, 0x93, 0xe1, 0x11, 0x3b, 0x52, 0x11, 0x02, 0x59, 0x11, 0x4d, 0x11, 0x4e, 0x11, 0x01, 0x74, 0x11, 0x14, 0x80, 0x2f, 0x90, 0xe0, 0x4f, 0x11, 0x01, 0x13, 0x00, 0x00, 0x3b, 0x53, 0x11,
//// branch cosmic power boosts
//0x29, 0x80, 0x41, 0x66, 0x8d,]
//
//let skillSwap = [0x00, 0x02, 0x04, 0x01, 0x80, 0x41, 0x5c, 0x93, 0xff, 0xff, 0xd9, 0x80, 0x41, 0x5c, 0x93, 0x0a, 0x0b, 0x04, 0x0a, 0x0b, 0x00, 0x11, 0x00, 0x00, 0x4e, 0xd2, 0x13, 0x00, 0x60, 0x0b, 0x04, 0x53, 0x11, 0x53, 0x12, 0x29, 0x80, 0x41, 0x41, 0x0f,]
//
//
//
//let shadowFreezeRoutine =  [0x00, 0x02, 0x04, 0x1e, 0x12, 0x00, 0x00, 0x00, 0x14, 0x80, 0x41, 0x5c, 0x93, 0x1d, 0x12, 0x00, 0x00, 0x00, 0x07, 0x80, 0x41, 0x5e, 0xb9, 0x23, 0x12, 0x0f, 0x80, 0x41, 0x5c, 0xc6, 0x1f, 0x12, 0x28, 0x80, 0x41, 0x5e, 0x81, 0x3b, 0x12, 0x2f, 0x80, 0x41, 0x5e, 0x81, 0x1f, 0x12, 0x31, 0x80, 0x41, 0x5e, 0x81, 0x1d, 0x12, 0x00, 0x00, 0x00, 0x01, 0x80, 0x41, 0x5c, 0x93, 0x01, 0x80, 0x41, 0x5c, 0x93, 0x00, 0x00, 0x20, 0x12, 0x00, 0x4b, 0x80, 0x41, 0x6d, 0xb2, 0x0a, 0x0b, 0x04, 0x2f, 0x80, 0x4e, 0x85, 0xc3, 0x04, 0x17, 0x0b, 0x04, 0x29, 0x80, 0x41, 0x41, 0x0f,]
//
// without magma armour
////let shadowFreezeRoutine =  [0x00, 0x02, 0x04, 0x1e, 0x12, 0x00, 0x00, 0x00, 0x14, 0x80, 0x41, 0x5c, 0x93, 0x1d, 0x12, 0x00, 0x00, 0x00, 0x07, 0x80, 0x41, 0x5e, 0xb9, 0x23, 0x12, 0x0f, 0x80, 0x41, 0x5c, 0xc6, 0x3b, 0x3b, 0x3b, 0x3b, 0x3b, 0x3b, 0x3b, 0x1f, 0x12, 0x2f, 0x80, 0x41, 0x5e, 0x81, 0x1f, 0x12, 0x31, 0x80, 0x41, 0x5e, 0x81, 0x1d, 0x12, 0x00, 0x00, 0x00, 0x01, 0x80, 0x41, 0x5c, 0x93, 0x01, 0x80, 0x41, 0x5c, 0x93, 0x00, 0x00, 0x20, 0x12, 0x00, 0x4b, 0x80, 0x41, 0x6d, 0xb2, 0x0a, 0x0b, 0x04, 0x2f, 0x80, 0x4e, 0x85, 0xc3, 0x04, 0x17, 0x0b, 0x04, 0x29, 0x80, 0x41, 0x41, 0x0f,]
//
//let routines : [(effect: Int, routine: [Int], offset: Int)] = [
//
//	(28,dragonTailRoutine, 0xb99524),
//	(57, uturnRoutine, 0xb9a670),
//	(213, shadowGiftRoutine, 0xb995c2),
//	(191, skillSwap, 0xb995fa),
//	(122, shadowAnalysisRoutine, 0xb99622),
//
//	(55, XGAssembly.routineForMultipleStatBoosts(RAMOffset: 0x80b9966a, boosts: [(stat: XGStats.accuracy, stages: XGStatStages.plus_1), (stat: XGStats.attack, stages: XGStatStages.plus_1)], isSecondaryEffect: false), 0xb9966a), // hone claws
//
//	(56, XGAssembly.routineForMultipleStatBoosts(RAMOffset: 0x80b996d4, boosts: [(stat: XGStats.special_attack, stages: XGStatStages.plus_1), (stat: XGStats.special_defense, stages: XGStatStages.plus_1), (stat: XGStats.speed, stages: XGStatStages.plus_1)], isSecondaryEffect: false), 0xb996d4), // quiver dance
//
//	(61, XGAssembly.routineForMultipleStatBoosts(RAMOffset: 0x80b99766, boosts: [(stat: XGStats.attack, stages: XGStatStages.plus_1), (stat: XGStats.defense, stages: XGStatStages.plus_1), (stat: XGStats.accuracy, stages: XGStatStages.plus_1)], isSecondaryEffect: false), 0xb99766), // coil
//
//	(135, XGAssembly.routineForMultipleStatBoosts(RAMOffset: 0x80b997f8, boosts: [(stat: XGStats.speed, stages: XGStatStages.plus_1), (stat: XGStats.evasion, stages: XGStatStages.plus_1),], isSecondaryEffect: false), 0xb997f8), // shadow haste
//
//	(203, XGAssembly.routineForMultipleStatBoosts(RAMOffset: 0x80b99862, boosts: [(stat: XGStats.attack, stages: XGStatStages.plus_1), (stat: XGStats.speed, stages: XGStatStages.plus_2),], isSecondaryEffect: false), 0xb99862), // shift gear
//
//	(154, XGAssembly.routineForMultipleStatBoosts(RAMOffset: 0x80b998cc, boosts: [(stat: XGStats.attack, stages: XGStatStages.plus_1), (stat: XGStats.accuracy, stages: XGStatStages.plus_2),], isSecondaryEffect: false), 0xb998cc), // shadow focus
//
//	(74, XGAssembly.routineForMultipleStatBoosts(RAMOffset: 0x80b99936, boosts: [(stat: XGStats.attack, stages: XGStatStages.plus_2), (stat: XGStats.special_attack, stages: XGStatStages.plus_2), (stat: XGStats.speed, stages: XGStatStages.plus_2), (stat: XGStats.defense, stages: XGStatStages.minus_1), (stat: XGStats.special_defense, stages: XGStatStages.minus_1)], isSecondaryEffect: false), 0xb99936), // shell smash
//
//	(163, XGAssembly.routineForMultipleStatBoosts(RAMOffset: 0x80b99a06, boosts: [(stat: XGStats.attack, stages: XGStatStages.plus_1), (stat: XGStats.defense, stages: XGStatStages.plus_1), (stat: XGStats.speed, stages: XGStatStages.plus_1), (stat: XGStats.special_attack, stages: XGStatStages.plus_1), (stat: XGStats.special_defense, stages: XGStatStages.plus_1)], isSecondaryEffect: false), 0xb99a06), // latent power
//
//	(145, XGAssembly.routineForMultipleStatBoosts(RAMOffset: 0x80b99ae8, boosts: [(stat: XGStats.evasion, stages: XGStatStages.minus_1), (stat: XGStats.special_defense, stages: XGStatStages.plus_3)], isSecondaryEffect: false), 0xb99ae8), // shadow barrier
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
////var currentOffset = XGAssembly.ASMfreeSpacePointer()
//for routine in routines {
//
////	// run first to generate offsets
////	print("effect \(routine.effect) - \(currentOffset.hexString())")
////	currentOffset += routine.routine.count
//
//	// fill in offsets then run this to actually add them
//	XGAssembly.setMoveEffectRoutine(effect: routine.effect, fileOffset: routine.offset - kDOLtoRAMOffsetDifference, moveToREL: false, newRoutine: routine.routine)
//
//}


//// make orre colosseum 6 vs. 6
//for offset in [0x0a1d48, 0x0a1d94] {
//	XGAssembly.replaceASM(startOffset: offset - kDolToRAMOffsetDifference, newASM: [0x28000000])
//}
//XGAssembly.replaceASM(startOffset: 0x0a183c - kDolToRAMOffsetDifference, newASM: [XGAssembly.createBranchFrom(offset: 0x0a183c, toOffset: 0x0a1d24)])
//for b in 87 ... 114 {
//	let battle = XGBattle(index: b)
//	battle.pokemonPerPlayer = 6
//	battle.save()
//}

//// shadow pokemon can't be battled after being captured 2
//// remove old shadow generation code
//XGAssembly.replaceASM(startOffset: 0x1fabf0 - kDolToRAMOffsetDifference, newASM: [0x7f03c378])

//let checkCaught = 0x14b024 - kDolToRAMOffsetDifference
//let checkPurified = 0x14b058 - kDolToRAMOffsetDifference
//
//let shadowBattleBranch2 = 0x1faa90 - kDolToRAMOffsetDifference
//let shadowBattleStart2  = 0x220f10 - kDolToRAMOffsetDifference
//// r20 stored shadow data start
////
//XGAssembly.replaceASM(startOffset: shadowBattleBranch2, newASM: [
//	XGAssembly.createBranchFrom(offset: shadowBattleBranch2, toOffset: shadowBattleStart2),
//	])
//XGAssembly.replaceASM(startOffset: shadowBattleStart2, newASM: [
//
//	0x7c741b78, // mr	r20, r3 overwritten code
//
//	// exclude greevil's shadow pokemon ids (decimal 0x4a - 0x4f)
//	0x281A004a, // cmpwi r26, 0x4a
//	XGAssembly.powerPCBranchLessThanFromOffset(from: 0x0, to: 0x10), // blt check generate
//	0x281A0050, // cmpwi r26, 0x50
//	XGAssembly.powerPCBranchGreaterThanOrEqualFromOffset(from: 0x0, to: 0x8), // bgteq check generate
//	XGAssembly.createBranchFrom(offset: 0x14, toOffset: 0x40), //---- normal exec
//
//	// check should generate 0x18
//
//	// check if shadow id has been caught
//	0x7e83a378, // mr r3, r20
//	XGAssembly.createBranchAndLinkFrom(offset: shadowBattleStart2 + 0x1c, toOffset: checkCaught),
//	0x5460063f, //rlwinm.	r0, r3, 0, 24, 31 (000000ff)
//	XGAssembly.powerPCBranchNotEqualFromOffset(from: 0x24, to: 0x38), // don't generate
//
//	// also need to check if shadow id has been purified in case those don't fall under caught
//	0x7e83a378, // mr r3, r20
//	XGAssembly.createBranchAndLinkFrom(offset: shadowBattleStart2 + 0x2c, toOffset: checkPurified),
//	0x5460063f, //rlwinm.	r0, r3, 0, 24, 31 (000000ff)
//	XGAssembly.powerPCBranchEqualFromOffset(from: 0x34, to: 0x40), // normal exec
//
//	// don't generate 0x38
//	0x3B200000, // li r25, 0
//	0x3B400000, // li r26, 0
//
//	// return to normal execution 0x40
//	0x7f43d378, // mr r3, r26 (overwritten code)
//	XGAssembly.createBranchFrom(offset: shadowBattleStart2 + 0x44, toOffset: shadowBattleBranch2 + 0x4)// branch back
//	])



//// wild battles for groudon, kyogre and rayquaza
//let wildbattle = XGBattle(index: 9)
//let wild = wildbattle.trainer!
//let fields = [104,182,163]
//for index in 212 ... 214 {
//	let trainer = XGTrainer(index: index, deck: .DeckStory)
//	let battle = XGBattle.battleForTrainer(index: index, deck: .DeckStory)!
//	trainer.nameID = wild.nameID
//	trainer.trainerModel = wild.trainerModel
//	trainer.trainerClass = wild.trainerClass
//	trainer.cameraEffects = wild.cameraEffects
//	trainer.save()
//
//	battle.BGMusicID = 1252
//	battle.battleField = XGTrainer(index: fields[index - 212], deck: .DeckStory).battleData?.battleField
//	battle.battleStyle = XGBattleStyles.single
//	battle.setToWildPokemon()
//	battle.save()
//}

//let relk = XGMapRel(file: .rel("M1_water_colo_field.rel"))
//let kyogre = relk.characters[6]
//kyogre.characterID = 0
//kyogre.model = XGCharacterModel(index: 42)
//kyogre.xCoordinate = 0.0
//kyogre.yCoordinate = 0.0
//kyogre.zCoordinate = 0.0
//kyogre.angle = 0
//kyogre.movementType = XGCharacterMovements.index(0x10)
//kyogre.save()

//let relg = XGMapRel(file: .rel("D6_fort_3F_1.rel"))
//let groudon = relg.characters[3]
//groudon.characterID = 0
//groudon.model = XGCharacterModel(index: 103)
//groudon.xCoordinate = 75.0
//groudon.yCoordinate = 0
//groudon.zCoordinate = 11.9
//groudon.angle = 0
//groudon.movementType = XGCharacterMovements.index(0x10)
//groudon.scriptIndex = 11
//groudon.save()


//let relr = XGMapRel(file: .rel("D5_factory_top.rel"))
//let rayquaza = relr.characters[0]
//rayquaza.characterID = 0
//rayquaza.model = XGCharacterModel(index: 41)
//rayquaza.xCoordinate = -79.0
//rayquaza.yCoordinate = 29.99
//rayquaza.zCoordinate = 118.0
//rayquaza.angle = 0
//rayquaza.movementType = XGCharacterMovements.index(0x10)
//rayquaza.save()



//let models = ["mewtwo", "suicune", "entei", "raikou", "rayquaza", "kyogre", "groudon"]
//let indices = [52,53,54,55,56,57,132]
//let anims = [0,0,0,0,0,0,2]
//let archive = XGFiles.fsys("people_archive.fsys").fsysData
//
//for i in 0 ..< models.count {
//	let model = XGFiles.nameAndFolder(models[i] + "_ow.dat", .TextureImporter)
//	copyOWPokemonIdleAnimationFromIndex(index: anims[i], forModel: model)
//	archive.shiftAndReplaceFileWithIndex(indices[i], withFile: model.compress())
//	let modelData = XGCharacterModel(index: i)
//	modelData.boundBox = [22.00, 52.00, 8.00, -300.00, 300.00, -120.00, 120.00, 6.00]
//	modelData.save()
//}
//archive.save()
//XGISO().shiftAndReplaceFile(archive.file)


//let wildbattle = XGBattle(index: 9)
//let wild = wildbattle.trainer!
//wildbattle.rawData.byteString.println()
//let fields = [330,217,441]
//for index in 209 ... 211 {
//	let trainer = XGTrainer(index: index, deck: .DeckStory)
//	let battle = XGBattle.battleForTrainer(index: index, deck: .DeckStory)!
//	trainer.nameID = wild.nameID
//	trainer.trainerModel = wild.trainerModel
//	trainer.trainerClass = wild.trainerClass
//	trainer.cameraEffects = wild.cameraEffects
//	trainer.save()
//
//	battle.BGMusicID = 1252
//	battle.battleField = XGBattle(index: fields[index - 209]).battleField
//	battle.battleStyle = XGBattleStyles.single
//	battle.setToWildPokemon()
//	battle.save()
//}

//let rel = XGMapRel(file: .rel("D5_out.rel"))
//let raikou = rel.characters[10]
//raikou.characterID = 0
//raikou.model = XGCharacterModel(index: 40)
//raikou.scriptIndex = 7
//raikou.zCoordinate = -160
//raikou.save()

//let rel = XGMapRel(file: .rel("D3_ship_deck.rel"))
//let entei = rel.characters[5]
//entei.characterID = 0
//entei.model = XGCharacterModel(index: 39)
//entei.xCoordinate = 0
//entei.save()

//let rel = XGMapRel(file: .rel("M1_out.rel"))
//let suicune = rel.characters[13]
//suicune.characterID = 0
//suicune.model = XGCharacterModel(index: 38)
//suicune.xCoordinate = 0.0
//suicune.yCoordinate = 66.04
//suicune.zCoordinate = -210.0
//suicune.scriptIndex = 19
//suicune.save()
//let jiji = rel.characters[10]
//jiji.xCoordinate = 0.0
//jiji.yCoordinate = 66.04
//jiji.zCoordinate = -170.0
//jiji.save()
//let boy = rel.characters[11]
//boy.scriptIndex = 21
//boy.save()
//let seedot = rel.characters[30]
//let jiji2 = rel.characters[29]
//seedot.xCoordinate = -14.0
//seedot.yCoordinate = 34.0
//seedot.zCoordinate = -110
//jiji2.xCoordinate = -14.0
//jiji2.yCoordinate = 34.0
//jiji2.zCoordinate = -115
//seedot.save()
//jiji.save()



//let newItems : [(index: Int, name: String, quantity: Int)] = [
//	(8,"TM11",1), // wisp
//	(1,"TM41",1), // toxic
//	(20,"TM03",1), // u-turn
//	(96,"TM21",1), // zen headbutt
//	(32,"TM36",1), // x-scissor
//	(99,"TM44",1), // night slash
//	(94,"TM07",1), // foul play
//	(5,"TM19",1), // sludgebomb
//	(108,"TM48",1), // stone edge
//	(64,"TM02",1), // fire blast
//	(59,"TM23",1), // dragon pulse
//	(27,"TM22",1), // discharge
//	(87,"TM39",1), // waterfall
//	(52,"TM40",1), // dragon claw
//	(29,"TM08",1), // flash cannon
//	(12,"TM06",1), // dazzling gleam
//	(90,"TM18",1), // freeze dry
//	(40,"TM04",1), // hurricane
//	(39,"TM34",1), // solar beam
//	(31,"timer ball",3),
//  (34,"thick club",1),
//]
//
//for (index, name, quantity) in newItems {
//	let treasure = XGTreasure(index: index)
//	treasure.itemID = item(name).index
//	treasure.quantity = quantity
//	treasure.save()
//}

//getStringSafelyWithID(id: 34076).duplicateWithString("[Speaker]: Rooooaaaaarrr!![Dialogue End]").replace()
//getStringSafelyWithID(id: 34077).duplicateWithString("[Speaker]: I think that was...[Clear Window]a Raikou![Dialogue End]").replace()
//getStringSafelyWithID(id: 34078).duplicateWithString("[Speaker]: I'm not lying. I swear![New Line]I saw it.[New Line]It ran away but maybe[New Line]it will probably return soon.[Clear Window][Speaker]: Hmm...[New Line]I wonder if the other two[New Line]legendary beasts are around Orre too![Dialogue End]").replace()
//getStringSafelyWithID(id: 34079).duplicateWithString("[Speaker]: I wonder if he really[New Line]saw a legendary pokémon.[Clear Window][Speaker]: They rarely stay still so[New Line]they're hard to catch[New Line]but maybe if you come back later...[Clear Window]Nah, forget it.[Clear Window]A little kid like you[New Line]can't catch a legendary pokémon![Dialogue End]").replace()


//XGAssembly.replaceASM(startOffset: 0x1faf50 - kDolToRAMOffsetDifference, newASM: [0x280a0032]) // compare with 50 pokespot entries so that "cave" runs into "all" where the static encounters are stored
//
// hard code ow wild pokemon for each map
//let owMonStart = 0x1fae4c
//let owCodeStart = 0xB99D48
//let owReturn = 0x1fae88
//XGAssembly.replaceASM(startOffset: owMonStart - kDolToRAMOffsetDifference, newASM: [
//	0x2c170039, // cmpwi r23, esaba A
//	0x41820018, // beq
//	0x2c17003b, // cmpwi r23, esaba C
//	0x41820020, // beq
//	0x3b600002, // li r27, 2
//	XGAssembly.createBranchFrom(offset: owMonStart + 0x14, toOffset: owCodeStart), // load species into r0
//	kNopInstruction,
//])
//XGAssembly.replaceRELASM(startOffset: owCodeStart - kRELtoRAMOffsetDifference, newASM: [
//	0x2c17002d, // cmpwi r23, D5 out
//	XGAssembly.powerPCBranchNotEqualFromOffset(from: 0x0, to: 0x8),
//	0x380000f3, // li r0, raikou
//	0x2c17002a, // cmpwi r23, D3_ship_deck
//	XGAssembly.powerPCBranchNotEqualFromOffset(from: 0x0, to: 0x8),
//	0x380000f4, // li r0, entei
//	0x2c170007, // cmpwi r23, M1_out
//	XGAssembly.powerPCBranchNotEqualFromOffset(from: 0x0, to: 0x8),
//	0x380000f5, // li r0, suicune
//	0x2c170000, // cmpwi r23, -
//	XGAssembly.powerPCBranchNotEqualFromOffset(from: 0x0, to: 0x8),
//	0x38000194, // li r0, kyogre
//	0x2c170000, // cmpwi r23, -
//	XGAssembly.powerPCBranchNotEqualFromOffset(from: 0x0, to: 0x8),
//	0x38000195, // li r0, groudon
//	0x2c170000, // cmpwi r23, -
//	XGAssembly.powerPCBranchNotEqualFromOffset(from: 0x0, to: 0x8),
//	0x38000196, // li r0, rayquaza
//	0x2c170000, // cmpwi r23, -
//	XGAssembly.powerPCBranchNotEqualFromOffset(from: 0x0, to: 0x8),
//	0x38000096, // li r0, mewtwo
//
//	// for future expansion
//	0x2c170000, // cmpwi r23, -
//	XGAssembly.powerPCBranchNotEqualFromOffset(from: 0x0, to: 0x8),
//	0x38000000, // li r0, --
//	0x2c170000, // cmpwi r23, -
//	XGAssembly.powerPCBranchNotEqualFromOffset(from: 0x0, to: 0x8),
//	0x38000000, // li r0, -
//	0x2c170000, // cmpwi r23, -
//	XGAssembly.powerPCBranchNotEqualFromOffset(from: 0x0, to: 0x8),
//	0x38000000, // li r0, --
//	0x2c170000, // cmpwi r23, -
//	XGAssembly.powerPCBranchNotEqualFromOffset(from: 0x0, to: 0x8),
//	0x38000000, // li r0, --
//	0x2c170000, // cmpwi r23, -
//	XGAssembly.powerPCBranchNotEqualFromOffset(from: 0x0, to: 0x8),
//	0x38000000, // li r0, --
//	kNopInstruction,
//	kNopInstruction,
//
//	XGAssembly.createBranchFrom(offset: owCodeStart + 0x98, toOffset: owReturn),
//
//	])
//
//XGPokeSpots.all.setEntries(entries: 15)

//// sitrus berry
//let sitrusBranch = 0x223efc
//let sitrusStart = 0xB9A018
//
//let getHPFraction = 0x203688
//let sitrusCode : ASM = [
//
//	0x281b00fc, // cmpwi r27, 0xfd
//	XGAssembly.powerPCBranchNotEqualFromOffset(from: 0x0, to: 0x1c),
//	0x7fe3fb78, // mr	r3, r31
//	0x38800004, // li	r4, 4
//	XGAssembly.createBranchAndLinkFrom(offset: sitrusStart + 0x10, toOffset: getHPFraction),
//	0x7c601b78, // mr	r0, r3
//	0x7c1b0378, // mr	r27, r0
//	XGAssembly.createBranchFrom(offset: 0x0, toOffset: 0x20),
//	0x281b00fe, // cmpwi r27, 0xfe
//	XGAssembly.powerPCBranchNotEqualFromOffset(from: 0x0, to: 0x18),
//	0x7fe3fb78, // mr	r3, r31
//	0x38800002, // li	r4, 2
//	XGAssembly.createBranchAndLinkFrom(offset: sitrusStart + 0x30, toOffset: getHPFraction),
//	0x7c601b78, // mr	r0, r3
//	0x7c1b0378, // mr	r27, r0
//
//	0x57a3043e, // rlwinm	r3, r29, 0, 16, 31 (0000ffff) overwritten code
//	XGAssembly.createBranchFrom(offset: sitrusStart + 0x40, toOffset: sitrusBranch + 0x4)
//]
//
//XGAssembly.replaceASM(startOffset: sitrusBranch - kDolToRAMOffsetDifference, newASM: [XGAssembly.createBranchFrom(offset: sitrusBranch, toOffset: sitrusStart)])
//XGAssembly.replaceRELASM(startOffset: sitrusStart - kRELtoRAMOffsetDifference, newASM: sitrusCode)
//
//let sb = item("sitrus berry").data
//sb.parameter = 0xfd
//sb.save()

//// wide guard
//let wideGuardBranchLinks = [0x218204, 0x218184]
//let wideGuardStart = 0xb99de4
//
//for offset in wideGuardBranchLinks {
//	XGAssembly.replaceASM(startOffset: offset - kDolToRAMOffsetDifference, newASM: [XGAssembly.createBranchAndLinkFrom(offset: offset, toOffset: wideGuardStart), 0x28030001])
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

//let dol = XGFiles.dol.data!
//
//let spreadAbsorbedStart = 0x2209f8  - kDolToRAMOffsetDifference
//let spreadA : UInt32 = 0x8022
//let spreadB : UInt32 = 0x09f8
//let spreadC : UInt32 = 0x0000
//let spreadMoveAbsorbedRoutine = [0x3A, 0x00, 0x20, 0x46, 0x12, 0x17, 0x00, 0x00, 0x00, 0x00, 0x0B, 0x00, 0x11, 0x00, 0x00, 0x4E, 0xFC, 0x78, 0x12, 0x13, 0x00, 0x50, 0x0B, 0x04, 0x29, 0x80, 0x41, 0x59, 0xa8, 0x00, 0x00, 0x00, 0x60, 0x00, 0x00, 0x00]
//
//dol.replaceBytesFromOffset(spreadAbsorbedStart, withByteStream: spreadMoveAbsorbedRoutine)
//dol.save()
//
//let spreadCheckStart = 0x2209a4 - kDolToRAMOffsetDifference
//let spreadCheckBranch = 0x22586c - kDolToRAMOffsetDifference
//let getTargets = 0x13e784 - kDolToRAMOffsetDifference
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

//// all colosseum battles are single battles except mirror b
//for trainer in XGDecks.DeckColosseum.allTrainers where trainer.index > 8 {
//	let battle = trainer.battleData!
//	battle.battleStyle = .single
//	battle.save()
//}

// print all treasure locations
//var treasures = [XGTreasure]()
//for i in 0 ..< CommonIndexes.NumberTreasureBoxes.value {
//	treasures.append(XGTreasure(index: i))
//}
//
//for tr in treasures.sorted(by: { (t1, t2) -> Bool in
//	return t1.room.name < t2.room.name
//}) {
//	print(tr.index.hexString() + ":",tr.item.name, "x" + tr.quantity.string,"\n" + tr.room.name, "flag:", tr.flag)
//	print(tr.xCoordinate, tr.yCoordinate, tr.zCoordinate, tr.angle,"\n")
//}


//let indexes = [0x16, 0x26, 0x22, 0x2d, 0x3d, 064, 0x5d, 0xd, 0x1, 0x69, 0x71, 0x29, 0x36]
//let newitems = ["great ball", "TM51", "Rare Candy", "potion", "white herb", "TM24", "TM55", "rare candy", "TM52", "TM53", "rare candy", "TM54", "SM01"]
//let quants = [2, 1, 1, 6, 4, 1, 1, 1, 1, 1, 3, 1, 1]
//
//for i in 0 ..< indexes.count {
//	let tr = XGTreasure(index: indexes[i])
//	tr.itemID = item(newitems[i]).index
//	tr.quantity = quants[i]
//	tr.save()
//}

//let firstImpression = [0x00, 0x83, 0x80, 0x41, 0x5c, 0x91, 0x29, 0x80, 0x41, 0x40, 0x90]
//
//var currentOffset = XGAssembly.ASMfreeSpacePointer()
//print(currentOffset.hex())
//XGAssembly.setMoveEffectRoutine(effect: 47, fileOffset: currentOffset - kDOLtoRAMOffsetDifference, moveToREL: false, newRoutine: firstImpression)


//// create over world models for pokespot pokemon
//let file = XGFiles.fsys("people_archive.fsys")
//let fsys = file.fsysData
//
//for i in 0 ... 2 {
//	let spot = XGPokeSpots(rawValue: i)!
//
//	for j in 0 ..< spot.numberOfEntries() {
//		let mon = XGPokeSpotPokemon(index: j, pokespot: spot).pokemon.stats
//		let data = mon.pkxData!
//
//		let ow = XGUtility.exportDatFromPKX(pkx: data)
//		ow.file = .nameAndFolder(mon.name.string, .TOC)
//		ow.save()
//
//		let model = ow.file
//		XGUtility.copyOWPokemonIdleAnimationFromIndex(index: 0, forModel: model)
//
//		let identifier = mon.index * 0x10000 + 0x0400
//		let index = fsys.indexForIdentifier(identifier: identifier)
//		fsys.shiftAndReplaceFileWithIndex(index, withFile: ow.file.compress())
////		fsys.addFile(ow, fileType: .dat, compress: true, shortID: mon.index)
//		print("added file:", ow.file.fileName, i, "-", j)
//
//	}
//}

//fsys.save()
//
//// increase number of tms by replacing hms
//let dol = XGFiles.dol.data!
//dol.replaceWordAtOffset(0x15e92c - kDolToRAMOffsetDifference, withBytes: 0x28030038)
//dol.replaceWordAtOffset(0x15e948 - kDolToRAMOffsetDifference, withBytes: 0x3803ffc8)
//dol.save()
//
//// remove amplifier ability code
//XGAssembly.replaceASM(startOffset: 0x220d20 - kDolToRAMOffsetDifference, newASM: [kNopInstruction, kNopInstruction, kNopInstruction, kNopInstruction, kNopInstruction, kNopInstruction, kNopInstruction])

// replace "but it already has a burn"
//getStringSafelyWithID(id: 20041).duplicateWithString("But it failed!").replace()

//// pokespot pokemon's pid is randomly generated at start of encounter rather than at spawn
//XGAssembly.replaceASM(startOffset: 0x1fb054 - kDolToRAMOffsetDifference, newASM: [kNopInstruction])
//
//
//
//// life orb
//let lifeBranch = 0x2250f4
//let lifeStart = 0xB9A1E8
//let lifeEnd = lifeBranch + 0x4 // oh wow, what a grim variable name XD
//let lifeCodeEnd = 0xa4
//
//let getMovePower = 0x13e71c
//let getItem = 0x20384c
//let checkStatus = 0x2025f0
//let animSoundCallBack = 0x2236a8
//
//XGAssembly.replaceASM(startOffset: lifeBranch - kDolToRAMOffsetDifference, newASM: [
//	XGAssembly.createBranchFrom(offset: lifeBranch, toOffset: lifeStart),
//])
//
//XGAssembly.replaceRELASM(startOffset: lifeStart - kRELtoRAMOffsetDifference, newASM: [
//	0x7fc3f378, // mr r3, r30 (pokemon pointer)
//	XGAssembly.createBranchAndLinkFrom(offset: lifeStart + 0x4, toOffset: getItem), // get item's hold item id
//	0x2803004b, // cmpwi r3, 75 (compare with life orb)
//	XGAssembly.powerPCBranchNotEqualFromOffset(from: 0xc, to: lifeCodeEnd),
//	0x7fc3f378, // mr r3, r30 (pokemon pointer)
//	0xa063080c,	// lhz r3, 0x80c(r3) (get ability)
//	0x28030023, // cmpwi r3, sheer force
//	XGAssembly.powerPCBranchEqualFromOffset(from: 0x1c, to: lifeCodeEnd),
//	0x281a0000, // cmpwi r26, 0 (check if move failed),
//	XGAssembly.powerPCBranchEqualFromOffset(from: 0x24, to: lifeCodeEnd),
//	0x7ea3ab78, // mr r3, r21 (current move)
//	XGAssembly.createBranchAndLinkFrom(offset: lifeStart + 0x2c, toOffset: getMovePower),
//	0x28030001, // cmpwi r3, 1
//	XGAssembly.powerPCBranchLessThanOrEqualFromOffset(from: 0x34, to: lifeCodeEnd),
//
//	0x7fc3f378, // mr r3, r30 (pokemon pointer)
//	0x38800007, // li r4, frozen
//	XGAssembly.createBranchAndLinkFrom(offset: lifeStart + 0x40, toOffset: checkStatus),
//	0x28030001, // cmpwi r3, 1
//	XGAssembly.powerPCBranchEqualFromOffset(from: 0x48, to: lifeCodeEnd),
//
//	0x7fc3f378, // mr r3, r30 (pokemon pointer)
//	0x38800008, // li r4, sleep
//	XGAssembly.createBranchAndLinkFrom(offset: lifeStart + 0x54, toOffset: checkStatus),
//	0x28030001, // cmpwi r3, 1
//	XGAssembly.powerPCBranchEqualFromOffset(from: 0x5c, to: lifeCodeEnd),
//
//	0xa07e000c, // lhz	r3, 0x000c(r30)
//	0x28030001, // cmpwi r3, 1
//	XGAssembly.powerPCBranchEqualFromOffset(from: 0x68, to: lifeCodeEnd),
//
//	// set life orb activated flag
//	0x7fc3f378, // mr r3, r30 (pokemon pointer)
//	0x38800001, // li r4, 1
//	0xb083000c, // sth	r4, 0x000c (r3)
//
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
//	XGAssembly.createBranchAndLinkFrom(offset: lifeStart + 0xa0, toOffset: animSoundCallBack),
//	// life code end
//	0x38600000, // lir3, 0 (code that was overwritten by branch)
//	XGAssembly.createBranchFrom(offset: lifeStart + 0xa8, toOffset: lifeEnd)
//])
//
//// remove life orb activated flags
//let lifeOrb2Branch = 0x2172b8 - kDolToRAMOffsetDifference
//let lifeOrb2Start  = 0x220f58 - kDolToRAMOffsetDifference
//XGAssembly.replaceASM(startOffset: lifeOrb2Branch, newASM: [
//0x7C7F1B78, // mr r31, r3
//XGAssembly.createBranchAndLinkFrom(offset: lifeOrb2Branch + 0x4, toOffset: lifeOrb2Start),
//0x38600000, // li r3, 0
//])
//XGAssembly.replaceASM(startOffset: lifeOrb2Start, newASM: [
//0x38800000, // li r4, 0
//0xb083000c, // sth	r4, 0x000c (r3)
//XGAssembly.powerPCBranchLinkReturn()
//])
//// flinch status remains set for whole move routine
//// may need to end flinch status at end of turn but seems to happen automatically in testing
//// just look out for edge cases
//XGAssembly.replaceASM(startOffset: 0x226ed0 - kDolToRAMOffsetDifference, newASM: [.nop])
//
//
//// life orb on flinch
//let lifeOrbFlinchBranch = 0xb9a208
//let lifeFlinchTrue = 0xb9a28c
//let lifeOrbFlinchStart = 0xB9AE9C
//let checkStatus = 0x2025f0
//XGAssembly.replaceRELASM(startOffset: lifeOrbFlinchBranch - kRELtoRAMOffsetDifference, newASM: [.b(lifeOrbFlinchStart), .nop])
//XGAssembly.replaceRELASM(startOffset: lifeOrbFlinchStart - kRELtoRAMOffsetDifference, newASM: [
//	.cmpwi(.r26, 0), // overwritten - check move didn't miss or fail
//	.bne_f(0, 8),
//	.b(lifeFlinchTrue),
//	.mr(.r3, .r30),
//	.li(.r4, 17), // flinched status
//	.bl(checkStatus),
//	.cmpwi(.r3, 1),
//	.bne_f(0, 8),
//	.b(lifeFlinchTrue),
//	.b(lifeOrbFlinchBranch + 4)
//])

//
//// snow cloak
//let snowBranch = 0x21793c - kDolToRAMOffsetDifference
//let snowStart = 0x220f64 - kDolToRAMOffsetDifference
//let evasion = 0x217954 - kDolToRAMOffsetDifference
//XGAssembly.replaceASM(startOffset: snowBranch, newASM: [
//XGAssembly.createBranchFrom(offset: snowBranch, toOffset: snowStart),
//0x281d0003, // cmplwi r29, sandstorm
//])
//XGAssembly.replaceASM(startOffset: snowStart, newASM: [
//0x281d0004, // cmplwi r29, hail
//XGAssembly.powerPCBranchEqualFromOffset(from: 0x4, to: 0xc),
//XGAssembly.createBranchFrom(offset: snowStart + 0x8, toOffset: snowBranch + 0x4),
//
//0x281a0069, // cmpwi r26, snow cloak
//XGAssembly.powerPCBranchEqualFromOffset(from: 0x10, to: 0x18),
//XGAssembly.createBranchFrom(offset: snowStart + 0x14, toOffset: snowBranch + 0x4),
//XGAssembly.createBranchFrom(offset: snowStart + 0x18, toOffset: evasion),
//])

//// freeze dry, scrappy
//let freezeBranches = [0x216828,0x216858]
//let freezeStarts = [0xB99F00,0xb9a2cc]
//let getAbility = 0x2055c8
//for i in 0 ..< freezeBranches.count {
//	let branch = freezeBranches[i]
//	XGAssembly.replaceASM(startOffset: branch - kDolToRAMOffsetDifference, newASM: [XGAssembly.createBranchAndLinkFrom(offset: branch, toOffset: freezeStarts[i])])
//}
//let typeRegisters : ASM = [
//0x7f24cb78, // mr r4, r25
//0x7f04c378, // mr r4, r24
//]
//for i in 0 ..< freezeStarts.count {
//	let freezeStart = freezeStarts[i]
//	let typeRegister = typeRegisters[i]
//	XGAssembly.replaceRELASM(startOffset: freezeStart - kRELtoRAMOffsetDifference, newASM: [
//
//		0x281500c6, // cmpwi r21, freeze dry
//		XGAssembly.powerPCBranchNotEqualFromOffset(from: 0x0, to: 0x14), //bne 0x14
//		0x2804000b, // cmpwi r4, water type
//		XGAssembly.powerPCBranchNotEqualFromOffset(from: 0x0, to: 0xc), //bne 0xc
//		0x38600041, // li r3, super effective
//		0x4e800020, // blr
//
//		0x9421fff0, // stwu	sp, -0x0010 (sp)
//		0x7c0802a6, // mflr	r0
//		0x90010014, // stw	r0, 0x0014 (sp)
//
//		0x28040007, // cmpwi r4, ghost type
//		XGAssembly.powerPCBranchNotEqualFromOffset(from: 0x0, to: 0x34), //bne 0x34
//		0x7ee3bb78, // mr r3, r23
//		XGAssembly.createBranchAndLinkFrom(offset: freezeStart + 0x30, toOffset: getAbility),
//		0x2803005c, // cmpwi r3, scrappy
//
//		XGAssembly.powerPCBranchNotEqualFromOffset(from: 0x0, to: 0x24), //bne 0x24
//
//		// check normal or fighting type move
//		0x5680043e, // rlwinm	r0, r20, 0, 16, 31 (0000ffff)
//		0x28000002, // cmplwi	r0, flying type
//		XGAssembly.powerPCBranchGreaterThanOrEqualFromOffset(from: 0x0, to: 0x18),
//
//		0x3860003F, // li r3, neutral
//		0x80010014, // lwz	r0, 0x0014 (sp)
//		0x7c0803a6, // mtlr	r0
//		0x38210010, // addi	sp, sp, 16
//		0x4e800020, // blr
//
//		0x7e83a378, // mr r3, r20
//		typeRegister,
//
//		// get type matchup
//		0x1ca30030,
//		0x5480083c,
//		0x80cd89ac,
//		0x7ca50214,
//		0x3805000c,
//		0x7c66022e,
//
//		0x80010014, // lwz	r0, 0x0014 (sp)
//		0x7c0803a6, // mtlr	r0
//		0x38210010, // addi	sp, sp, 16
//
//		0x4e800020, // blr
//		])
//}


//// orre colosseum single/double battle options (also need to edit script)
//XGDecks.DeckColosseum.addPokemonEntries(count: 28 * 6)
//XGDecks.DeckColosseum.addTrainerEntries(count: 28)
//
//
//let rel = XGFiles.common_rel.data!
//var oldbattles = [Int]()
//var newbattles = [Int]()
//for i in 41 ... 68 {
//	let orre = XGTrainer(index: i, deck: .DeckColosseum).battleData!
//	let new  = XGBattle(index: orre.index - 0x48)
//
//	let start = new.startOffset
//	let oldData = orre.rawData
//	rel.replaceBytesFromOffset(start, withByteStream: oldData)
//
//	oldbattles.append(orre.index)
//	newbattles.append(new.index)
//
//}
//rel.save()
//for i in 41 ... 68 {
//	let oldt = XGTrainer(index: i     , deck: .DeckColosseum)
//	let newt = XGTrainer(index: i + 28, deck: .DeckColosseum)
//	let new  = XGBattle(index: newbattles[i - 41])
//
//	new.battleStyle = .double
//	new.trainerID = i + 28
//	new.save()
//
//	newt.cameraEffects = oldt.cameraEffects
//	newt.defeatTextID = oldt.defeatTextID
//	newt.nameID = oldt.nameID
//	newt.preBattleTextID = oldt.preBattleTextID
//	newt.trainerClass = oldt.trainerClass
//	newt.trainerModel = oldt.trainerModel
//	newt.victoryTextID = oldt.victoryTextID
//	newt.AI = oldt.AI
//	newt.trainerStringID = oldt.trainerStringID
//	newt.save()
//
//}

//
//
//
//for i in 69 ... 69 + 27 {
//	let t = XGTrainer(index: i, deck: .DeckColosseum)
//	for p in 0 ... 5 {
//		if t.pokemon[p].index == 0 {
//			t.pokemon[p] = XGDecks.DeckColosseum.unusedPokemon()
//			if t.pokemon[p].index != 0 {
//				let poke = t.pokemon[p].data
//				poke.species = XGPokemon.pokemon(1)
//				poke.level = 60
//				poke.IVs = 31
//				poke.save()
//				t.save()
//			}
//		}
//	}
//}
//
//for i in 41 ... 68 {
//	let oldt = XGTrainer(index: i, deck: .DeckColosseum)
//	let newt = XGTrainer(index: i + 28, deck: .DeckColosseum)
//	for j in 0 ... 5 {
//		let old = oldt.pokemon[j].data
//		let new = newt.pokemon[j].data
//		new.species = old.species
//		new.ability = old.ability
//		new.gender = old.gender
//		new.EVs = old.EVs
//		new.happiness = old.happiness
//		new.item = old.item
//		new.moves = old.moves
//		new.nature = old.nature
//		new.shinyness = old.shinyness
//		new.save()
//	}
//}
//
//
//
//
//
//getStringSafelyWithID(id: 0x8ABE).duplicateWithString("[Speaker]: At the Orre Colosseum, battles[New Line]are conducted.[New Line]You are permitted to battle with 6 Pokémon.[Clear Window][Speaker]: Battles are held in knockout style.[New Line]You must beat four trainers in a row to win [New Line]the challenge.[Clear Window][Speaker]: If you win a challenge, you may advance to[New Line]the next group of opponents.[Clear Window][Speaker]: If you manage to win a round, you will be[New Line]awarded Poké Coupons.[Clear Window][Speaker]: You can choose to compete in[New Line]single or double battles through[New Line]this menu.[Dialogue End]").replace()
//
//getStringSafelyWithID(id: 0x8ABF).duplicateWithString("[Speaker]: Battle Style set to Single.[Dialogue End]").replace()
//getStringSafelyWithID(id: 0x8AC0).duplicateWithString("[Speaker]: Battle Style set to Double.[Dialogue End]").replace()
//
//getStringSafelyWithID(id: 0x8abc).duplicateWithString("Set Style: Single").replace()
//getStringSafelyWithID(id: 0x8abd).duplicateWithString("Set Style: Double").replace()

//// mt. battle prize names
//// chikorita
//getStringSafelyWithID(id: 31305).duplicateWithString("Mew").replace()
//// cyndaquil
//getStringSafelyWithID(id: 31306).duplicateWithString("Celebi").replace()
//// totodile
//getStringSafelyWithID(id: 31307).duplicateWithString("Jirachi").replace()

//let mart = XGPokemart(index: 3)
//mart.items.append(item("Poké Snack"))
//mart.firstItemIndex = 59
//mart.save()
//
//for m in [2, 1] {
//	let mart = XGPokemart(index: m)
//	mart.firstItemIndex += 11
//	mart.save()
//}
//for m in [16, 17, 18] {
//	let mart = XGPokemart(index: m)
//	mart.firstItemIndex = 19
//	mart.items = [2,3,4,9,13,17,25,26,30].map({ (i) -> XGItems in
//		return XGBattleCD(index: i).getItem()
//	})
//	mart.save()
//}
//
//var marts = [XGPokemart]()
//for i in 0 ..< PocketIndexes.numberOfMarts.value {
//	marts.append(XGPokemart(index: i))
//
//}
//marts.sort { (m1, m2) -> Bool in
//	m1.firstItemIndex < m2.firstItemIndex
//}
//for mart in marts {
//	printg("mart:",mart.index, "  used item indexes:", mart.firstItemIndex, "-", mart.firstItemIndex + mart.items.count,"   start offset:", mart.itemsStartOffset.hexString())
//	printg(mart.items.map({ (i) -> String in
//		return i.name.string
//	}))
//	printg("")
//}

//getStringSafelyWithID(id: 24177).duplicateWithString("[Speaker]: Aarrghh![Wait Input]").replace()
//getStringSafelyWithID(id: 24180).duplicateWithString("[Speaker]: Thanks for playing XG![New Line]Don't forget to check out Mt.Battle.[New Line]There's a surprise at the top.[Wait Input]").replace()
//
//
//
//
//
//// repeat ball catch rate to 3.5x
//XGAssembly.replaceASM(startOffset: 0x21942c - kDolToRAMOffsetDifference, newASM: [0x3b800023])
//

// multi battle with gonzap to enter key lair
//let oldGonzap = XGTrainer(index: 145, deck: .DeckStory)
//let oldBodyBuilder = XGTrainer(index: 22, deck: .DeckStory)
//let oldBodyBuilder2 = XGTrainer(index: 111, deck: .DeckStory)
//let gonzap = XGTrainer(index: 225, deck: .DeckStory)
//let b1 = XGTrainer(index: 209, deck: .DeckStory)
//let b2 = XGTrainer(index: 210, deck: .DeckStory)
//
//for trainer in [gonzap, b1, b2] {
//	trainer.AI = XGAI.offensive.rawValue
//	trainer.defeatTextID = 0
//	trainer.preBattleTextID = 0
//	trainer.victoryTextID = 0
//}
//b1.nameID = oldBodyBuilder.nameID
//b2.nameID = oldBodyBuilder2.nameID

//gonzap.trainerModel = oldGonzap.trainerModel
//gonzap.cameraEffects = oldGonzap.cameraEffects
//gonzap.nameID = oldGonzap.nameID
//gonzap.trainerClass = oldGonzap.trainerClass
//gonzap.save()
//for trainer in [b1, b2] {
//	trainer.trainerModel = oldBodyBuilder.trainerModel
//	trainer.cameraEffects = oldBodyBuilder.cameraEffects
//	trainer.trainerClass = oldBodyBuilder.trainerClass
//	trainer.save()
//}
//
//let gonzapMultiBattle = gonzap.battleData!
//let oldBattle = oldGonzap.battleData!
//let zookBattle = XGTrainer(index: 147, deck: .DeckStory).battleData!
//gonzapMultiBattle.p3TID = 209
//gonzapMultiBattle.p3Deck = .DeckStory
//gonzapMultiBattle.p3Controller = .AI
//gonzapMultiBattle.p4TID = 210
//gonzapMultiBattle.p4Deck = .DeckStory
//gonzapMultiBattle.p4Controller = .AI
//gonzapMultiBattle.pokemonPerPlayer = 6
//gonzapMultiBattle.trainersPerSide = 2
//gonzapMultiBattle.battleStyle = .single
//gonzapMultiBattle.BGMusicID = oldBattle.BGMusicID
//gonzapMultiBattle.battleField = zookBattle.battleField
//gonzapMultiBattle.battleType = .story
//gonzapMultiBattle.unknown = oldBattle.unknown
//gonzapMultiBattle.unknown2 = oldBattle.unknown2
//gonzapMultiBattle.save()


//// herbal medicine fix
//let hp = item("heal powder").data
//hp.parameter = item("full heal").data.parameter
//hp.save()
//let rh = item("revival herb").data
//rh.parameter = item("max revive").data.parameter
//rh.save()
//let ep = item("energy powder").data
//ep.parameter = item("super potion").data.parameter
//ep.save()
//let er = item("energy root").data
//er.parameter = item("hyper potion").data.parameter
//er.save()
//
//// sitrus berry fix
//XGAssembly.replaceRELASM(startOffset: 0xb9a018 - kRELtoRAMOffsetDifference, newASM: [0x281b00fc])
//
//let sitrus2Branch = 0x15f2fc
//let sitrus2Start = 0xB9A358
//XGAssembly.replaceASM(startOffset: sitrus2Branch - kDolToRAMOffsetDifference, newASM: [XGAssembly.createBranchFrom(offset: sitrus2Branch, toOffset: sitrus2Start)])
//XGAssembly.replaceRELASM(startOffset: sitrus2Start, newASM: [
//	0x2c0000fc, // cmpwi r0, 252
//	XGAssembly.powerPCBranchEqualFromOffset(from: 0, to: 8), // beq 8
//	XGAssembly.createBranchFrom(offset: sitrus2Start + 0x8, toOffset: 0x15f32c), // b 0x15f32c
//	0x5463FC7F, // rlwinm.	r3, r3, 31, 17, 31 (0000fffe) divide by 2, divided by 2 again after branch
//	XGAssembly.createBranchFrom(offset: sitrus2Start + 0x10, toOffset: 0x15f310), // b 15f310
//])
//
//let sb = item("sitrus berry").data
//sb.parameter = 0xfc
//sb.save()

//// paralysis moves don't affect electric types
//let thunderwaveRoutine =  [0x00, 0x02, 0x04, 0x1f, 0x12, 0x07, 0x80, 0x41, 0x4d, 0x01, 0x23, 0x12, 0x0d, 0x80, 0x41, 0x5c, 0xc6, 0x1e, 0x12, 0x00, 0x00, 0x00, 0x14, 0x80, 0x41, 0x5c, 0x93, 0x07, 0xf9, 0x07, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x3d, 0x00, 0x00, 0x00, 0x00, 0x80, 0x4e, 0xb9, 0x5e, 0x2a, 0x00, 0x80, 0x4e, 0xb9, 0x5e, 0x00, 0x80, 0x41, 0x5c, 0x93, 0x1d, 0x12, 0x00, 0x00, 0x00, 0x05, 0x80, 0x41, 0x4c, 0xe8, 0x1d, 0x12, 0x00, 0x00, 0x00, 0x01, 0x80, 0x41, 0x5c, 0x93, 0x01, 0x80, 0x41, 0x5c, 0x93, 0x00, 0x00, 0x20, 0x12, 0x00, 0x4b, 0x80, 0x41, 0x6d, 0xb2, 0x0a, 0x0b, 0x04, 0x2f, 0x80, 0x4e, 0x85, 0xc3, 0x05, 0x17, 0x10, 0x13, 0x00, 0x50, 0x0b, 0x04, 0x29, 0x80, 0x41, 0x41, 0x0f,]
//
//let routines : [(effect: Int, routine: [Int], offset: Int)] = [
//	(67, thunderwaveRoutine, 0xB9A4AC),
//]
//
////var currentOffset = XGAssembly.ASMfreeSpacePointer()
//for routine in routines {
////	// run first to generate offsets
////	print("effect \(routine.effect) - \(currentOffset.hexString())")
////	currentOffset += routine.routine.count
//
//	// fill in offsets then run this to actually add them
//	XGAssembly.setMoveEffectRoutine(effect: routine.effect, fileOffset: routine.offset - kDOLtoRAMOffsetDifference, moveToREL: false, newRoutine: routine.routine)
//}
//// secondary move effects can't paralyse electric types
//let paraStart = 0xB9A520
//let paraBranch = 0x213dbc
//let checkHasType = 0x2054fc
//let getPointer = 0x1efcac
//XGAssembly.replaceASM(startOffset: paraBranch - kDolToRAMOffsetDifference, newASM: [XGAssembly.createBranchFrom(offset: paraBranch, toOffset: paraStart)])
//XGAssembly.replaceRELASM(startOffset: paraStart - kRELtoRAMOffsetDifference, newASM: [
//	0x3bed87a0, // overwritten code
//	0x881f0003, // lbz	r0, 0x0003 (r31) get move secondary effect index
//	0x28000005, // cmpwi r0, paralysis chance
//	XGAssembly.powerPCBranchEqualFromOffset(from: 0x0, to: 0x8),
//	XGAssembly.createBranchFrom(offset: paraStart + 0x10, toOffset: paraBranch + 0x4),
//	0x38600012, // li r3, 18
//	0x38800000, // li r4, 0
//	XGAssembly.createBranchAndLinkFrom(offset: paraStart + 0x1c, toOffset: getPointer),
//	0x3880000d, // li r4, electric
//	XGAssembly.createBranchAndLinkFrom(offset: paraStart + 0x24, toOffset: checkHasType),
//	0x28030001, // cmpwi r3, 1
//	XGAssembly.powerPCBranchNotEqualFromOffset(from: 0x0, to: 0x8),
//	0x3ba00000, // li	r29, 0
//	XGAssembly.createBranchFrom(offset: paraStart + 0x34, toOffset: paraBranch + 0x4)
//
//])

//// spore/powder moves don't affect grass types prankster doesn't affect dark types
//let sporeBranch = 0x225870
//let sporeStart = 0xB9A558
//let moveGetTargets = 0x13e784
//let checkHasType = 0x2054fc
//let getPointer = 0x1efcac
//let getCurrentMove = 0x148d64
//let getAbility = 0x2055c8
//let moveGetCategory = 0x13e7f0
//let moveGetPriority = 0x13e7b8
//let moveRoutineSetPosition = 0x2236d4
//
//let sporeEnd = 0x58
//let sporeBlocked = 0x44
//let pranksterEnd = 0xf0
//let pranksterBlocked = 0xe0
//
//XGAssembly.replaceASM(startOffset: sporeBranch - kDolToRAMOffsetDifference, newASM: [XGAssembly.createBranchFrom(offset: sporeBranch, toOffset: sporeStart)])
//XGAssembly.replaceRELASM(startOffset: sporeStart - kRELtoRAMOffsetDifference, newASM: [
//
//	0x38600012, // li r3, 18 (defending pokemon)
//	0x38800000, // li r4, 0
//	XGAssembly.createBranchAndLinkFrom(offset: sporeStart + 0x8, toOffset: getPointer), // get pokemon pointer
//	0x3880000c, // li r4, grass
//	XGAssembly.createBranchAndLinkFrom(offset: sporeStart + 0x10, toOffset: checkHasType),
//	0x28030001, // cmpwi r3, 1
//	XGAssembly.powerPCBranchNotEqualFromOffset(from: 0x18, to: sporeEnd),
//
//	0x38600011, // li r3, 17 (attacking pokemon)
//	0x38800000, // li r4, 0
//	XGAssembly.createBranchAndLinkFrom(offset: sporeStart + 0x24, toOffset: getPointer), // get pokemon pointer
//	XGAssembly.createBranchAndLinkFrom(offset: sporeStart + 0x28, toOffset: getCurrentMove),
//	0x28030093, // cmpwi r3, spore
//	XGAssembly.powerPCBranchEqualFromOffset(from: 0x30, to: sporeBlocked),
//	0x2803004e, // cmpwi r3, stun spore
//	XGAssembly.powerPCBranchEqualFromOffset(from: 0x38, to: sporeBlocked),
//	0x2803004f, // cmpwi r3, sleep powder
//	XGAssembly.powerPCBranchNotEqualFromOffset(from: 0x40, to: sporeEnd),
//
//	// spore blocked 0x44
//	0x3c6080ba, // lis	r3, 0x80ba
//	0x3863a650, // subi	r3, r3, 0x59b0
//	XGAssembly.createBranchAndLinkFrom(offset: sporeStart + 0x4c, toOffset: moveRoutineSetPosition),
//	0x3bc00001, // li	r30, 1
//	XGAssembly.createBranchFrom(offset: 0x54, toOffset: pranksterEnd),
//
//	// spore end 0x58
//	0x38600012, // li r3, 18 (defending pokemon)
//	0x38800000, // li r4, 0
//	XGAssembly.createBranchAndLinkFrom(offset: sporeStart + 0x60, toOffset: getPointer), // get pokemon pointer
//	0x38800011, // li r4, dark
//	XGAssembly.createBranchAndLinkFrom(offset: sporeStart + 0x68, toOffset: checkHasType),
//	0x28030001, // cmpwi r3, 1
//	XGAssembly.powerPCBranchNotEqualFromOffset(from: 0x70, to: pranksterEnd),
//
//	0x38600011, // li r3, 17 (attacking pokemon)
//	0x38800000, // li r4, 0
//	XGAssembly.createBranchAndLinkFrom(offset: sporeStart + 0x7c, toOffset: getPointer), // get pokemon pointer
//	0xa063080c, // lhz	r3, 0x080C (r3) get ability
//	0x28030059, // cmpwi r3, prankster
//	XGAssembly.powerPCBranchNotEqualFromOffset(from: 0x88, to: pranksterEnd),
//
//	0x38600011, // li r3, 17 (attacking pokemon)
//	0x38800000, // li r4, 0
//	XGAssembly.createBranchAndLinkFrom(offset: sporeStart + 0x94, toOffset: getPointer), // get pokemon pointer
//	XGAssembly.createBranchAndLinkFrom(offset: sporeStart + 0x98, toOffset: getCurrentMove),
//	XGAssembly.createBranchAndLinkFrom(offset: sporeStart + 0x9c, toOffset: moveGetCategory),
//	0x28030000, // cmpwi r3, status
//	XGAssembly.powerPCBranchNotEqualFromOffset(from: 0xa4, to: pranksterEnd),
//
//	0x38600011, // li r3, 17 (attacking pokemon)
//	0x38800000, // li r4, 0
//	XGAssembly.createBranchAndLinkFrom(offset: sporeStart + 0xb0, toOffset: getPointer), // get pokemon pointer
//	XGAssembly.createBranchAndLinkFrom(offset: sporeStart + 0xb4, toOffset: getCurrentMove),
//	XGAssembly.createBranchAndLinkFrom(offset: sporeStart + 0xb8, toOffset: moveGetPriority),
//	0x28030000, // cmpwi r3, 0
//	XGAssembly.powerPCBranchNotEqualFromOffset(from: 0xc0, to: pranksterEnd),
//
//	0x38600011, // li r3, 17 (attacking pokemon)
//	0x38800000, // li r4, 0
//	XGAssembly.createBranchAndLinkFrom(offset: sporeStart + 0xcc, toOffset: getPointer), // get pokemon pointer
//	XGAssembly.createBranchAndLinkFrom(offset: sporeStart + 0xd0, toOffset: getCurrentMove),
//	XGAssembly.createBranchAndLinkFrom(offset: sporeStart + 0xd4, toOffset: moveGetTargets),
//	0x28030005, // cmpwi r3, user
//	XGAssembly.powerPCBranchEqualFromOffset(from: 0xdc, to: pranksterEnd),
//
//	// prankster blocked 0xe0
//	0x3c6080ba, // lis	r3, 0x80ba
//	0x3863a650, // subi	r3, r3, 0x59b0
//	0x3bc00001, // li	r30, 1
//	XGAssembly.createBranchAndLinkFrom(offset: sporeStart + 0xec, toOffset: moveRoutineSetPosition),
//
//	// prankster end 0xf0
//	0x7fc3f378, // mr r3, r30 overwritten code
//	XGAssembly.createBranchFrom(offset: sporeStart + 0xf4, toOffset: sporeBranch + 0x4)
//])
//XGAssembly.replaceRELASM(startOffset: 0xb9a650 - kRELtoRAMOffsetDifference, newASM: [ 0x02298041, 0x5cc60000, ])

//// spread moves damage reduced by 25% when hitting multiple targets
//let spreadBranches = [0x22aa4c, 0x22a8f4]
//let spreadStart = 0xB9A658
//let spreadMaths = [0x22aa60, 0x22a908]
//for offset in spreadBranches {
//	XGAssembly.replaceASM(startOffset: offset - kDolToRAMOffsetDifference, newASM: [XGAssembly.createBranchAndLinkFrom(offset: offset, toOffset: spreadStart)])
//}
//for offset in spreadMaths {
//	XGAssembly.replaceASM(startOffset: offset - kDolToRAMOffsetDifference, newASM: [
//		0x1dce0003, // mulli r14, r14, 3  (r14 * 3)
//		0x7dce1670, // srawi r14, r14, 2  ( r14 >> 2 == r14 / 4)
//	])
//}
//XGAssembly.replaceRELASM(startOffset: spreadStart - kRELtoRAMOffsetDifference, newASM: [
//	0x28000004, // cmpwi r0, both foes spread move
//	XGAssembly.powerPCBranchNotEqualFromOffset(from: 0x0, to: 0xc),
//
//	// if it passes first test then we can return without checking the second condition
//	// we simply do the comparison again so the next line will do the right jump after returning
//	0x28000004, // cmpwi r0, both foes spread move
//	XGAssembly.powerPCBranchLinkReturn(),
//
//	// otherwise we check the second condition and once we return the jump will be based on that
//	// as the first comparison no longer affects the results
//	0x28000006, // cmpwi r0, both foes and ally spread move
//	XGAssembly.powerPCBranchLinkReturn(),
//])

//// move effect 203 always neutral damage addition to freeze dry and scrappy code
//let neutralStart = 0xB9A834
//let neutralBranch = 0x216d80
//let getMoveEffect = 0x13e6e8
//let neutralSkip = 0x216e10
//let setEffectiveness = 0x1f057c
//let checkSetEffectiveness = 0x1f05d0
//XGAssembly.setMoveEffectRoutineRAMOffset(effect: 203, RAMOffset: 0x80414b23)
//XGAssembly.replaceASM(startOffset: neutralBranch - kDolToRAMOffsetDifference, newASM: [
//	.b(neutralStart),
//	// overwritten code
//	.mr(.r3, .r26),
//	.bl(0x13d03c),
//	.cmpwi(.r3, 1),
//])
//XGAssembly.replaceRELASM(startOffset: neutralStart - kRELtoRAMOffsetDifference, newASM: [
//	.mr(.r3, .r26), // move id
//	.bl(getMoveEffect),
//	.cmpwi(.r3, 203), // new effect always neutral damage
//	.beq_f(0, 8),
//	.b(neutralBranch + 0x4),
//
//	// neutral damage
//	.mr(.r3, .r31),
//	.li(.r4, XGEffectivenessValues.neutral.rawValue),
//	.bl(checkSetEffectiveness),
//	.cmpwi(.r3, 2),
//	.beq_f(0, 8),
//	.b(neutralSkip),
//	.mr(.r3, .r31),
//	.li(.r4, XGEffectivenessValues.neutral.rawValue),
//	.li(.r5, 0),
//	.bl(setEffectiveness),
//	.b(neutralSkip),
//
//])

//// ghost types can't be trapped
//let ghostBranch = 0x20f7b0
//let ghostStart = 0xB9A874
//let checkHasType = 0x2054fc
//let ghostSkip = 0x20f980
//
//XGAssembly.replaceASM(startOffset: ghostBranch - kDolToRAMOffsetDifference, newASM: [
//	.b(ghostStart),
//	.cmpwi(.r31, 50), // compare ability with runaway (overwritten code)
//])
//XGAssembly.replaceRELASM(startOffset: ghostStart - kRELtoRAMOffsetDifference, newASM: [
//	.mr(.r3, .r28),
//	.li(.r4, XGMoveTypes.ghost.rawValue),
//	.bl(checkHasType),
//	.cmpwi(.r3, 1),
//	.beq_f(0, 8),
//	.b(ghostBranch + 0x4),
//	.li(.r3, 0),
//	.b(ghostSkip),
//])


//let toxicBranch = 0x2178d4
//let toxicStart = 0xB9A894
//let checkHasType = 0x2054fc
//let toxicSkip = 0x2179b8
//XGAssembly.replaceASM(startOffset: toxicBranch - kDolToRAMOffsetDifference, newASM: [
//	.b(toxicStart)
//])
//XGAssembly.replaceRELASM(startOffset: toxicStart - kRELtoRAMOffsetDifference, newASM: [
//	.mr(.r3, .r23),
//	.li(.r4, XGMoveTypes.poison.rawValue),
//	.bl(checkHasType),
//	.cmpwi(.r3, 1),
//	.beq_f(0, 8),
//	.b(toxicBranch + 0x4),
//	.li(.r22, 100), // set accuracy
//	.b(toxicSkip)
//])


//// ghosts can't be trapped 2
//let ghost2Branch = 0x1f279c
//let ghost2Start = 0xB9AA58
//let checkType = 0x2054fc
//XGAssembly.replaceASM(startOffset: ghost2Branch - kDolToRAMOffsetDifference, newASM: [.b(ghost2Start)])
//XGAssembly.replaceRELASM(startOffset: ghost2Start - kRELtoRAMOffsetDifference, newASM: [
//
//	.stwu(.sp, .sp, -0x20),
//	.stmw(.r31, .sp, 0x10),
//	.mr(.r31, .r3),
//
//	.mr(.r3, .r25),
//	.li(.r4, XGMoveTypes.ghost.rawValue),
//	.bl(checkType),
//	.cmpwi(.r3, 1),
//	.bne_f(0, 8),
//	.li(.r31, 0),
//
//	.mr(.r3, .r31),
//	.lmw(.r31, .sp, 0x10),
//	.addi(.sp, .sp, 0x20),
//
//	.lmw(.r25, .sp, 0x14), // overwritten
//	.b(ghost2Branch + 4)
//])
//
//// flame orb / toxic orb poison heal
//
//XGAbilities.ability(50).name.duplicateWithString("Poison Heal").replace()
//XGAbilities.ability(50).adescription.duplicateWithString("Heals when poisoned.").replace()
//
//// remove runaway effect
//XGAssembly.replaceASM(startOffset: 0x20f7b0 - kDolToRAMOffsetDifference, newASM: [
//	.b(0x20f7c4),
//	.nop,
//	.nop
//])
//
//let flameOrb = XGItem(index: 190)
//let toxicOrb = XGItem(index: 185)
//flameOrb.name.duplicateWithString("Flame Orb").replace()
//toxicOrb.name.duplicateWithString("Toxic Orb").replace()
//flameOrb.descriptionID = toxicOrb.descriptionID
//toxicOrb.descriptionString.duplicateWithString("Inflicts the holder with[New Line]a status at the[New Line]of the turn.").replace()
//
//flameOrb.holdItemID = 78
//toxicOrb.holdItemID = 79
//for orb in [flameOrb, toxicOrb] {
//	orb.bagSlot = .items
//	orb.canBeHeld = true
//	orb.couponPrice = 200
//	orb.price = 500
//	orb.friendshipEffects = [0,0,0]
//	orb.inBattleUseID = 0
//	orb.parameter = 0
//	orb.save()
//}
//
//let badPoisonResidualBranch = 0x227d88
//let poisonResidualBranch = 0x227d0c
//let badPoisonSkip = 0x227e08
//let poisonSkip = 0x227d58
//let poisonHealStart1 = 0xB9AA30
//let poisonHealStart2 = 0xB9AA44
//
//XGAssembly.replaceASM(startOffset: poisonResidualBranch - kDolToRAMOffsetDifference, newASM: [.b(poisonHealStart1)])
//XGAssembly.replaceRELASM(startOffset: poisonHealStart1, newASM: [
//	.cmpwi(.r28, ability("poison heal").index),
//	.bne_f(0, 8),
//	.b(poisonSkip),
//	.lwz(.r0, .r13, -0x44e8), // overwritten
//	.b(poisonResidualBranch + 4)
//])
//XGAssembly.replaceASM(startOffset: badPoisonResidualBranch - kDolToRAMOffsetDifference, newASM: [.b(poisonHealStart2)])
//XGAssembly.replaceRELASM(startOffset: poisonHealStart2, newASM: [
//	.cmpwi(.r28, ability("poison heal").index),
//	.bne_f(0, 8),
//	.b(badPoisonSkip),
//	.lwz(.r0, .r13, -0x44e8), // overwritten
//	.b(badPoisonResidualBranch + 4)
//])
//
//
//let orbBranch = 0x225ab4
//let orbStart = 0xB9A8B4
//let checkFullHP = 0x201d20
//let checkStatus = 0x2025f0
//let checkSetStatus = 0x20254c
//let checkHasType = 0x2054fc
//let setStatus = 0x2024a4
//let checkNoStatus = 0x203744
//let getHPFraction = 0x203688
//let storeHPLoss = 0x13e094
//let animSoundCallback = 0x2236a8
//let getItem = 0x20384c // get item's hold item id
//
//let healOffset = orbStart + 0x34
//let flameOrbOffset = orbStart + 0x6c
//let toxicOrbOffset = orbStart + 0xec
//let returnOffset = orbStart + 0x174
//XGAssembly.replaceASM(startOffset: orbBranch - kDolToRAMOffsetDifference, newASM: [ .b(orbStart) ])
//XGAssembly.replaceRELASM(startOffset: orbStart - kRELtoRAMOffsetDifference, newASM: [
//
//	.lhz(.r3, .r31, 0x80c), // get ability
//	.cmpwi(.r3, ability("poison heal").index),
//	.bne(flameOrbOffset),
//	.mr(.r3, .r31),
//	.li(.r4, 3), // poison
//	.bl(checkStatus),
//	.cmpwi(.r3, 1),
//	.beq(healOffset),
//	.mr(.r3, .r31),
//	.li(.r4, 4), // bad poison
//	.bl(checkStatus),
//	.cmpwi(.r3, 1),
//	.bne(flameOrbOffset),
//
//	//heal offset 0x34
//	.mr(.r3, .r31),
//	.bl(checkFullHP),
//	.cmpwi(.r3, 1),
//	.beq(flameOrbOffset),
//	.mr(.r3, .r31),
//	.li(.r4, 8), // 1/8 max hp
//	.bl(getHPFraction),
//	.rlwinm(.r0, .r3, 0, 16, 31),
//	.neg(.r4, .r0),
//	.mr(.r3, .r30),
//	.bl(storeHPLoss),
//	.lis(.r3, 0x8041),
//	.addi(.r3, .r3, 31004),
//	.bl(animSoundCallback),
//
//	// flame orb offset 0x6c
//	.mr(.r3, .r31),
//	.bl(getItem),
//	.cmpwi(.r3, item("flame orb").data.holdItemID),
//	.bne(toxicOrbOffset),
//
//	.mr(.r3, .r31),
//	.li(.r4, XGMoveTypes.fire.rawValue),
//	.bl(checkHasType),
//	.cmpwi(.r3, 1),
//	.beq(returnOffset),
//
//	.mr(.r3, .r31),
//	.bl(checkNoStatus),
//	.cmpwi(.r3, 1),
//	.bne(returnOffset),
//
//	.lhz(.r3, .r31, 0x80c), // get ability
//	.cmpwi(.r3, ability("water veil").index),
//	.beq(returnOffset),
//
//	// activate burn
//	.mr(.r3, .r31),
//	.li(.r4, 6), // burn
//	.bl(checkSetStatus),
//	.cmpwi(.r3, 2),
//	.bne(returnOffset),
//	.mr(.r3, .r31),
//	.li(.r4, 6), // burn
//	.li(.r5, 0),
//	.bl(setStatus),
//
//	.nop, // .li(.r4, 3), // burn chance secondary effect
//	.nop, // .lis(.r3, 0x8042),
//	.nop, // .rlwinm(.r0, .r4, 2, 0, 29),
//	.nop, // .subi(.r3, .r3, 31568),
//	.nop, // .lwzx(.r3, .r3, .r0),
//	.nop, // .bl(animSoundCallback),
//
//	.b(returnOffset),
//
//
//	// toxic orb offset 0xec
//	.cmpwi(.r3, item("toxic orb").data.holdItemID),
//	.bne(returnOffset),
//
//	.mr(.r3, .r31),
//	.li(.r4, XGMoveTypes.poison.rawValue),
//	.bl(checkHasType),
//	.cmpwi(.r3, 1),
//	.beq(returnOffset),
//
//	.mr(.r3, .r31),
//	.li(.r4, XGMoveTypes.steel.rawValue),
//	.bl(checkHasType),
//	.cmpwi(.r3, 1),
//	.beq(returnOffset),
//
//	.mr(.r3, .r31),
//	.bl(checkNoStatus),
//	.cmpwi(.r3, 1),
//	.bne(returnOffset),
//
//	.lhz(.r3, .r31, 0x80c), // get ability
//	.cmpwi(.r3, ability("immunity").index),
//	.beq(returnOffset),
//
//	// activate poison
//
//	.mr(.r3, .r31),
//	.li(.r4, 4), // badly poisoned
//	.bl(checkSetStatus),
//	.cmpwi(.r3, 2),
//	.bne(returnOffset),
//	.mr(.r3, .r31),
//	.li(.r4, 4), // badly poisoned
//	.li(.r5, 0),
//	.bl(setStatus),
//
//	.nop, // .li(.r4, 6), // badly poison chance secondary effect
//	.nop, // .lis(.r3, 0x8042),
//	.nop, // .rlwinm(.r0, .r4, 2, 0, 29),
//	.nop, // .subi(.r3, .r3, 31568),
//	.nop, // .lwzx(.r3, .r3, .r0),
//	.nop, // .bl(animSoundCallback),
//
//	// return offset 0x174
//	.lmw(.r28, .sp, 0x10), // overwritten code
//	.b(orbBranch + 0x4)
//])

//// ability capsule
//
//let capsuleFuncStart = 0xB9AB08
//let selectPokemon = 0x2420c
//let storePokemonPointer = 0x24148
//let displayMessage = 0x117468 // r3 : 2  |  r4 : message string id | r5 & r6: 0
//let waitMessage = 0x1173a8 // r3 = 1
//let getName = 0x149584 // param index 0x16
//let setMessageParam = 0x2370ec // r3 = param index, r4 = value
//let getAbility = 0x1416a4 // param indexes 0x1a & 0x1b
//let abilityGetPointer = 0x144298
//let abilityPointerGetNameID = 0x144280
//let stringIDGetPointer = 0x107300
//let getAbilityIndex = 0x1491d0
//let itemMessage = 0xa481c
//let closeWindow = 0x241e0
//let getSpecies = 0x1470c4
//let speciesGetStats = 0x146078
//let statsGetAbilityWithIndex = 0x145c80
//
//XGAssembly.replaceRELASM(startOffset: capsuleFuncStart - kRELtoRAMOffsetDifference, newASM: [
//
//	.stwu(.sp, .sp, -0x40),
//	.mflr(.r0),
//	.stw(.r0, .sp, 0x44),
//	.stmw(.r23, .sp, 0x1c),
//	.mr(.r23, .r4),
//
//	// select party pokemon
//	.li(.r3, 0),
//	.li(.r4, 1),
//	.bl(selectPokemon),
//	.cmpwi(.r3, 0),
//	.bge_f(0, 0x20),
//
//	// return
//	.bl(closeWindow),
//	.li(.r3, 1),
//	.lmw(.r23, .sp, 0x1c),
//	.lwz(.r0, .sp, 0x44),
//	.mtlr(.r0),
//	.addi(.sp, .sp, 0x40),
//	.blr,
//
//	// store pokemon pointer
//	.mr(.r27, .r3),
//	.addi(.r4, .sp, 12),
//	.addi(.r5, .sp,  8),
//	.bl(storePokemonPointer),
//	.lwz(.r3, .sp, 12),
//	.mr(.r31, .r3),
//
//	// check if has second ability
//	.bl(getSpecies),
//	.bl(speciesGetStats),
//	.li(.r4, 1),
//	.bl(statsGetAbilityWithIndex),
//	.cmpwi(.r3, 0),
//	.bne_f(0, 0x30),
//
//	// ability capsule useless
//
//	.lis(.r3, 0x1),
//	.subi(.r3, .r3, (0x10000 - 0xe2c4)),
//	.bl(itemMessage),
//	.mr(.r3, .r27),
//	.bl(closeWindow),
//
//	// return
//	.li(.r3, 1),
//	.lmw(.r23, .sp, 0x1c),
//	.lwz(.r0, .sp, 0x44),
//	.mtlr(.r0),
//	.addi(.sp, .sp, 0x40),
//	.blr,
//
//	// get pokemon name
//	.mr(.r3, .r31),
//	.bl(getName),
//	.mr(.r30, .r3),
//
//	// get ability before
//	.mr(.r3, .r31),
//	.bl(getAbility),
//	.bl(abilityGetPointer),
//	.bl(abilityPointerGetNameID),
//	.bl(stringIDGetPointer),
//	.mr(.r29, .r3),
//
//	// switch abilities
//	.mr(.r3, .r31),
//	.bl(getAbilityIndex),
//	.cmpwi(.r3, 1),
//
//	.lbz(.r3, .r31, 0x1d),
//	.beq_f(0, 0xc),
//
//	.addi(.r3, .r3, 0x40),
//	.b_f(0, 8),
//	.subi(.r3, .r3, 0x40),
//	.stb(.r3, .r31, 0x1d),
//
//	// get ability after
//	.mr(.r3, .r31),
//	.bl(getAbility),
//	.bl(abilityGetPointer),
//	.bl(abilityPointerGetNameID),
//	.bl(stringIDGetPointer),
//	.mr(.r28, .r3),
//
//	// set message params
//	.li(.r3, 0x16),
//	.mr(.r4, .r30),
//	.bl(setMessageParam),
//	.li(.r3, 0x1a),
//	.mr(.r4, .r29),
//	.bl(setMessageParam),
//	.li(.r3, 0x1b),
//	.mr(.r4, .r28),
//	.bl(setMessageParam),
//
//	// display message
//	.lis(.r3, 0x1),
//	.subi(.r3, .r3, (0x10000 - 0xe2c3)),
//	.bl(itemMessage),
//	.mr(.r3, .r27),
//	.bl(closeWindow),
//
//	// return
//	.li(.r0, 1),
//	.stw(.r0, .r23, 0),
//	.li(.r3, 0),
//	.lmw(.r23, .sp, 0x1c),
//	.lwz(.r0, .sp, 0x44),
//	.mtlr(.r0),
//	.addi(.sp, .sp, 0x40),
//	.blr,
//
//])
//// set used capsule strings in start.dol string table by replacing unused string
//getStringSafelyWithID(id: 0xe2c3).duplicateWithString("[16]'s ability changed from [1a][New Line]to [1b]![Dialogue End]").replace()
//getStringSafelyWithID(id: 0xe2c4).duplicateWithString("The ability could not be changed.[Dialogue End]").replace()
//
//let ac = XGItem(index: 55)
//ac.name.duplicateWithString("Ability Capsule").replace()
//ac.descriptionString.duplicateWithString("Switches a[New Line]Pokémon's ability.").replace()
//ac.holdItemID = 0
//ac.bagSlot = .items
//ac.canBeHeld = true
//ac.couponPrice = 500
//ac.price = 2000
//ac.friendshipEffects = [0,0,0]
//ac.inBattleUseID = 0
//ac.parameter = 0
//ac.function1 = UInt32(capsuleFuncStart) + 0x80000000
//ac.function2 = ac.function1
//ac.save()

//// remove white smoke ability
//XGAssembly.replaceASM(startOffset: 0x222170 - kDolToRAMOffsetDifference, newASM: [
//	.b(0x2221f8),
//	.nop
//])
//// remove shield dust ability
//XGAssembly.replaceASM(startOffset: 0x214004 - kDolToRAMOffsetDifference, newASM: [
//	.b(0x214038),
//	.nop
//])
//
//// remove water veil ability
//let wispRoutine = [0x00, 0x02, 0x04, 0x1e, 0x12, 0x00, 0x00, 0x00, 0x14, 0x80, 0x41, 0x5c, 0x93, 0x1d, 0x12, 0x00, 0x00, 0x00, 0x06, 0x80, 0x41, 0x5e, 0xb9, 0x23, 0x12, 0x0a, 0x80, 0x41, 0x5c, 0xc6, 0x3b, 0x3b, 0x3b, 0x3b, 0x3b, 0x3b, 0x3b, 0x1d, 0x12, 0x00, 0x00, 0x00, 0x01, 0x80, 0x41, 0x5c, 0x93, 0x01, 0x80, 0x41, 0x5c, 0x93, 0x00, 0x00, 0x20, 0x12, 0x00, 0x4b, 0x80, 0x41, 0x6d, 0xb2, 0x0a, 0x0b, 0x04, 0x2f, 0x80, 0x4e, 0x85, 0xc3, 0x03, 0x17, 0x0b, 0x04, 0x29, 0x80, 0x41, 0x41, 0x0f,]
//XGAssembly.setMoveEffectRoutine(effect: move("will-o-wisp").data.effect, fileOffset: 0x415e32 - kDolTableToRAMOffsetDifference, moveToREL: false, newRoutine: wispRoutine)
//XGAssembly.replaceASM(startOffset: 0x214304 - kDolToRAMOffsetDifference, newASM: [
//	.b(0x21436c),
//	.nop
//])
//
//// remove oblivious ability
//XGAssembly.replaceASM(startOffset: 0x225518 - kDolToRAMOffsetDifference, newASM: [
//	.nop,
//	.nop
//])
//XGAssembly.replaceASM(startOffset: 0x2210e8 - kDolToRAMOffsetDifference, newASM: [
//	.b(0x221100),
//	.nop
//])
//
//// remove own tempo ability
//let dol = XGFiles.dol.data!
//dol.replaceBytesFromOffset(0x411B31 , withByteStream: [0x3b,0x3b,0x3b,0x3b,0x3b,0x3b,0x3b,])
//dol.save()
//XGAssembly.replaceASM(startOffset: 0x21479c - kDolToRAMOffsetDifference, newASM: [
//	.nop,
//	.nop
//])
//
//// remove magnet pull ability
//XGAssembly.replaceASM(startOffset: 0x20f8a4 - kDolToRAMOffsetDifference, newASM: [
//	.b(0x20f910),
//	.nop
//])
//
//// remove magnet pull ability
//XGAssembly.replaceASM(startOffset: 0x1f2678 - kDolToRAMOffsetDifference, newASM: [
//	.li(.r31, 0),
//	.b(0x1f2694),
//	.nop
//])
//
//let unaware = XGAbilities.ability(21)
//let sniper = XGAbilities.ability(42)
//unaware.name.duplicateWithString("Unaware").replace()
//unaware.adescription.duplicateWithString("Ignores stat changes.")
//sniper.name.duplicateWithString("Sniper").replace()
//sniper.adescription.duplicateWithString("Stronger critical hits.")
//
//// unaware, sniper
//XGAssembly.replaceASM(startOffset: 0x22a720 - kDolToRAMOffsetDifference, newASM: [
//	.li(.r4, 6),
//	.lwz(.r3, .sp, 0x30), // defending ability
//	.cmpwi(.r3, ability("unaware").index),
//	.bne_f(0, 0xc),
//	.stw(.r4, .sp, 0x24),
//	.stw(.r4, .sp, 0x28),
//	.cmpwi(.r27, ability("unaware").index), // attacking ability
//	.bne_f(0, 0xc),
//	.stw(.r4, .sp, 0x34),
//	.stw(.r4, .sp, 0x38),
//	.cmpwi(.r27, ability("sniper").index),
//	.bne_f(0, 0x14),
//	.cmpwi(.r26, 3), // critical hit
//	.bne_f(0, 0xc),
//	.mulli(.r14, .r14, 3),
//	.srawi(.r14, .r14, 1),
//
//])
//
//
//// faster weather animations
//let fasterWeatherAnimationsBranch = 0x211a3c
//let fastWeatherStart = 0xB9AC6C
//let weatherAnimation = 0x210d4c
//// compare r4 with weather indexes and only if not weather, branch link to animation
//XGAssembly.replaceASM(startOffset: fasterWeatherAnimationsBranch - kDolToRAMOffsetDifference, newASM: [.b(fastWeatherStart)])
//XGAssembly.replaceRELASM(startOffset: fastWeatherStart - kRELtoRAMOffsetDifference, newASM: [
//	.cmpwi(.r4, 0xc), // sand storm
//	.beq_f(0, 0x18),
//	.cmpwi(.r4, 0xd), // hail
//	.beq_f(0, 0x10),
//	.cmpwi(.r4, 0x25), // shadow sky
//	.beq_f(0, 0x8),
//	.bl(weatherAnimation),
//	.b(fasterWeatherAnimationsBranch + 4)
//])




//// 50% berries figy, wiki, mago, aguav, iapapa
//XGAssembly.replaceASM(startOffset: 0x22498c - kDolToRAMOffsetDifference, newASM: [.li(.r4, 4)])
//for i in 143 ... 147 {
//	let berry = XGItem(index: i)
//	berry.parameter = 2
//	berry.save()
//}
//
//// berries after move
//let berryStart = 0x223734
//let berryBranch = 0x2275d0
//XGAssembly.replaceASM(startOffset: berryBranch - kDolToRAMOffsetDifference, newASM: [.bl(berryStart)])
//
//// copied from end turn item activation but ammended to only factor in berries
//XGAssembly.replaceASM(startOffset: berryStart - kDolToRAMOffsetDifference, newASM: [
//	.li(.r4, 0),
//	.stwu(.sp, .sp, -0x60),
//	.mflr(.r0),
//	.stw(.r0, .sp, 0x64),
//	.stmw(.r20, .sp, 0x30),
//	.mr(.r21, .r4),
//	.mr(.r31, .r3),
//	.li(.r30, 0),
//	.li(.r26, 0),
//	.mr(.r3, .r31),
//	.bl(0x204a70), // check has hp
//	.rlwinm_(.r0, .r3, 0, 24, 31),
//	.bne_f(0, 0xc),
//	.li(.r3, 0),
//	.b(0x2247e0),
//	.mr(.r3, .r31),
//	.bl(0x203870), // get item
//	.mr(.r25, .r3),
//	.mr(.r3, .r31),
//	.bl(0x20384c), // get held item id
//	.mr(.r20, .r3),
//	.mr(.r3, .r31),
//	.bl(0x203828), // get parameter
//	.mr(.r27, .r3),
//	.mr(.r3, .r31),
//	.bl(0x148da8), // get move routine pointer
//	.mr(.r22, .r3),
//	.mr(.r3, .r31),
//	.bl(0x20489c), // get stats
//	.mr(.r23, .r3),
//	.bl(0x149410), // get hp
//	.mr(.r29, .r3),
//	.mr(.r3, .r23),
//	.bl(0x1493f0), // get max hp
//	.mr(.r4, .r25),
//	.mr(.r25, .r3),
//	.li(.r3, 0),
//	.bl(0x1f65bc), // set message param 41 to item
//	.rlwinm(.r0, .r20, 0, 16, 31),
//	.cmplwi(.r0, 23), // adjusted to max held item id for berries and white herb)
//	.ble_f(0, 8),
//	.b(0x224774),
//	.lis(.r3, 0x8042),
//	.rlwinm(.r0, .r0, 2, 0, 29),
//	.subi(.r3, .r3, 31296),
//	.lwzx(.r0, .r3, .r0),
//	.mtctr(.r0),
//	.bctr
//
//
//])

//// electric types can't be paralysed 2
//let paraBranch = 0x2144e0
//let paraStart = 0xB9AC8C
//let paraSkip = 0x214660
//let paraTrue = paraBranch + 0x8
//let checkHasType = 0x2054fc
//// compare ability in r22 to limber and compare type to electric battle pokemon in r19
//XGAssembly.replaceASM(startOffset: paraBranch - kDolToRAMOffsetDifference, newASM: [.b(paraStart)])
//XGAssembly.replaceRELASM(startOffset: paraStart - kRELtoRAMOffsetDifference, newASM: [
//	.cmpwi(.r0, ability("limber").index),
//	.bne_f(0, 8),
//	.b(paraSkip),
//
//	.mr(.r3, .r19), // battle pokemon
//	.li(.r4, XGMoveTypes.electric.rawValue),
//	.bl(checkHasType),
//	.cmpwi(.r3, 1),
//	.bne_f(0, 8),
//	.b(paraSkip),
//
//	.b(paraTrue)
//
//])
//
//
//// foul play
//let foulBranch = 0x22a188
//let foulStart = 0x22278c
//let foulEnd = foulBranch + 0x8
//let getAttackStat = 0x1493d0
//XGAssembly.replaceASM(startOffset: foulBranch - kDolToRAMOffsetDifference, newASM: [.b(foulStart), .nop])
//XGAssembly.replaceASM(startOffset: foulStart - kDolToRAMOffsetDifference, newASM: [
//	.mr(.r20, .r0), // overwritten code
//	.mr(.r3, .r17),
//
//	// get move data pointer
//	.mulli(.r0, .r3, 56),
//	.lwz(.r3, .r13, -0x762c),
//	.add(.r3, .r3, .r0),
//	.lhz(.r3, .r3, 0x1c),
//	.cmplwi(.r3, 15),
//	.bne_f(0x0, 0x14),
//
//	.mr_(.r3, .r18),
//	.beq_f(0, 0xc),
//
//	.bl(getAttackStat),
//	.mr(.r21, .r3),
//
//	// return
//	.mr(.r3, .r18), // overwritten code
//	.b(foulEnd)
//])

//// fix animation inconsistencies 2 for +3 and higher stat boosts
//XGAssembly.replaceASM(startOffset: 0x2117e4 - kDolToRAMOffsetDifference, newASM: [0x40800028])
//
//// unaware, sniper
//XGAssembly.replaceASM(startOffset: 0x22a720 - kDolToRAMOffsetDifference, newASM: [
//
//	.li(.r4, 6),
//	.lwz(.r3, .sp, 0x30), // defending ability
//	.cmpwi(.r3, ability("unaware").index),
//	.bne_f(0, 0xc),
//	.stw(.r4, .sp, 0x24),
//	.stw(.r4, .sp, 0x28),
//	.cmpwi(.r27, ability("unaware").index), // attacking ability
//	.bne_f(0, 0xc),
//	.stw(.r4, .sp, 0x34),
//	.stw(.r4, .sp, 0x38),
//	.cmpwi(.r27, ability("sniper").index),
//	.bne_f(0, 0x14),
//	.cmpwi(.r26, 3), // critical hit
//	.bne_f(0, 0xc),
//	.mulli(.r14, .r14, 3),
//	.srawi(.r14, .r14, 1),
//
//])
//
//
//let statBoostAnimationRoutineStart = 0xB9ADE4
//let statBoostAnimationRoutine = [0x2f, 0xff, 0x01, 0x60, 0x1e, 0x00, 0x2f, 0x80, 0x4e, 0x85, 0xc3, 0x00, 0x29, 0x80, 0x41, 0x79, 0x63, 0x3b, 0x3b, 0x3b]
//let rel = XGFiles.common_rel.data!
//rel.replaceBytesFromOffset(statBoostAnimationRoutineStart - kRELtoRAMOffsetDifference, withByteStream: statBoostAnimationRoutine)
//rel.save()
//
//// store value at address
//
//// ability stat booster (r3 index of stat to boost + stages, r4 battle pokemon)
//let statBoosterStart = 0xB9ACC0 //old at 0xB9A6F8
//let getStatIndex = 0x222484
//let getValueWithIndex = 0x142e7c
//let unknownFunc = 0x148a98
//let setParams = 0x1f6780
//let setValueWithIndex = 0x141d14
//let animSoundCallback = 0x2236a8
//
//XGAssembly.replaceRELASM(startOffset: statBoosterStart - kRELtoRAMOffsetDifference, newASM: [
//	.stwu(.sp, .sp, -0x50),
//	.mflr(.r0),
//	.stw(.r0, .sp, 0x54),
//	.stmw(.r20, .sp, 0x10),
//
//	.mr(.r24, .r3),
//	.rlwinm(.r3, .r3, 0, 28, 31), // 0x0000000f stat index to boost
//	.mr(.r20, .r3),
//	.mr(.r31, .r4),
//	.bl(getStatIndex),
//
//	.mr(.r29, .r3),
//	.mr(.r3, .r31),
//	.li(.r4, 0),
//	.mr(.r5, .r29),
//	.li(.r6, 0),
//	.bl(getValueWithIndex),
//
//	.cmpwi(.r3, 12),
//	.bge_f(0, 0xcc),
//
//	.extsb(.r28, .r3),
//	.mr(.r3, .r31),
//	.bl(unknownFunc),
//	.cmplwi(.r3, 2),
//	.beq_f(0, 0xb8),
//
//	.mr(.r4, .r31),
//	.li(.r3, 0),
//	.bl(setParams),
//
//	.rlwinm(.r3, .r24, 0, 24, 27), // 0x000000f0 stat boost stages
//	.srawi(.r21, .r3, 4),
//	.add(.r7, .r28, .r21),
//	.cmpwi(.r7, 12),
//	.ble_f(0, 8),
//	.li(.r7, 12),
//	.mr(.r3, .r31),
//	.mr(.r5, .r29),
//	.li(.r4, 0),
//	.li(.r6, 0),
//	.bl(setValueWithIndex),
//
//	.lwz(.r23, .r13, -0x44fc),
//	.addis(.r23, .r23, 1),
//	.lbz(.r25, .r23, 0x60a4),
//	.lbz(.r26, .r23, 0x60a5),
//	.lbz(.r27, .r23, 0x601e),
//	.lis(.r3, 0x804f),
//	.subi(.r3, .r3, 0x10_000 - 0x85C3),
//	.lbz(.r22, .r3, 0),
//
//	.lis(.r6, 0x80BA),
//	.subi(.r6, .r6, 0x10_000 - 0xADE9),
//	.stb(.r24, .r6, 0),
//
//	.li(.r5, 14),
//	.cmpwi(.r21, 1),
//	.ble_f(0, 8),
//	.nop,
//	.add(.r5, .r5, .r20),
//
//	.lis(.r3, 0x80BA),
//	.subi(.r3, .r3, 0x10_000 - 0xADEF),
//	.stb(.r5, .r3, 0),
//
//	.li(.r0, 0),
//	.stb(.r5, .r23, 0x60a4),
//	.stb(.r0, .r23, 0x60a5),
//	.lis(.r3, 0x80BA),
//	.subi(.r3, .r3, 0x10_000 - 0xADE4),
//	.bl(animSoundCallback),
//
//	.stb(.r25, .r23, 0x60a4),
//	.stb(.r26, .r23, 0x60a5),
//	.stb(.r27, .r23, 0x601e),
//	.lis(.r3, 0x804f),
//	.subi(.r3, .r3, 0x10_000 - 0x85C3),
//	.stb(.r22, .r3, 0),
//
//	.lmw(.r20, .sp, 0x10),
//	.lwz(.r0, .sp, 0x54),
//	.mtlr(.r0),
//	.addi(.sp, .sp, 0x50),
//	.blr,
//	.nop
//
//])
//
//// defiant competitive
//let defiantBranch = 0x2223d0
//let defiantStart = 0xB9A7D8
//XGAssembly.replaceASM(startOffset: defiantBranch - kDolToRAMOffsetDifference, newASM: [XGAssembly.createBranchFrom(offset: defiantBranch, toOffset: defiantStart)])
//XGAssembly.replaceRELASM(startOffset: defiantStart - kRELtoRAMOffsetDifference, newASM: [
//	0x7f800774, // extsb	r0, r28 (stat change stages)
//	0x28000080, // cmplwi r0, 0x80 // treats negative as big number
//	XGAssembly.powerPCBranchGreaterThanOrEqualFromOffset(from: 0x0, to: 0xc),
//	0x3a6d87a0, // overwritten code
//	XGAssembly.createBranchFrom(offset: defiantStart + 0x10, toOffset: defiantBranch + 4),
//
//	0x57200673, // rlwinm.	r0, r25, 0, 25, 25 (00000040) affects user mask
//	XGAssembly.powerPCBranchEqualFromOffset(from: 0x0, to: 0xc),
//	0x3a6d87a0, // overwritten code
//	XGAssembly.createBranchFrom(offset: defiantStart + 0x20, toOffset: defiantBranch + 4),
//
//	0x281a0067, // cmpwi r26, defiant
//	XGAssembly.powerPCBranchNotEqualFromOffset(from: 0x0, to: 0x18),
//
//	0x38600021, // li r3, attack, 2 stages
//	0x7f04c378, // mr r4, r24
//	XGAssembly.createBranchAndLinkFrom(offset: defiantStart + 0x34, toOffset: statBoosterStart),
//	0x3a6d87a0, // overwritten code
//	XGAssembly.createBranchFrom(offset: defiantStart + 0x3c, toOffset: defiantBranch + 4),
//
//	0x281a0068, // cmpwi r26, competitive
//	XGAssembly.powerPCBranchNotEqualFromOffset(from: 0x0, to: 0x10),
//
//	0x38600024, // li r3, sp. attack, 2 stages
//	0x7f04c378, // mr r4, r24
//	XGAssembly.createBranchAndLinkFrom(offset: defiantStart + 0x50, toOffset: statBoosterStart),
//	0x3a6d87a0, // overwritten code
//	XGAssembly.createBranchFrom(offset: defiantStart + 0x58, toOffset: defiantBranch + 4),
//
//])
//
//
//// immune to moves abilities r31 current move r3 defending ability
//let originOffset = 0x225804
//let originNopOffset = 0x225838
//let immunitiesStart = 0xB9A05C
//let statBoost = 0xB9ACC0
//
//let moveGetSnatchFlag = 0x13e5e4
//let moveGetSoundFlag = 0x13e548
//let moveGetType = 0x13e870
//let moveCheckShadow = 0x13e514
//
//let powerupImmune = 0x14c
//let immune = 0x154
//let powerupNotImmune = 0x15c
//let notImmune = 0x164
//
//XGAssembly.replaceASM(startOffset: originOffset - kDolToRAMOffsetDifference, newASM: [0x3bc00000,XGAssembly.createBranchAndLinkFrom(offset: originOffset + 0x4, toOffset: immunitiesStart),0x28030001])
//XGAssembly.replaceASM(startOffset: originNopOffset - kDolToRAMOffsetDifference, newASM: [kNopInstruction])
//XGAssembly.replaceRELASM(startOffset: immunitiesStart - kRELtoRAMOffsetDifference, newASM: [
//0x9421ffdc, 0x7c0802a6, 0x90010028, 0x93e1001c, 0x93c10018, 0x93a10014, 0x93810010, 0x93610020,
//
//// 0x20
//0x7c7c1b78, // mr r28,r3
//0x7fe3fb78, // mr r3, r31
//XGAssembly.createBranchAndLinkFrom(offset: immunitiesStart + 0x28, toOffset: moveGetSnatchFlag),
//0x7c7e1b78, // mr r30, r3
//0x7fe3fb78, // mr r3, r31
//XGAssembly.createBranchAndLinkFrom(offset: immunitiesStart + 0x34, toOffset: moveGetSoundFlag),
//0x7C7D1B78, // mr r29, r3
//0x7fe3fb78, // mr r3, r31
//XGAssembly.createBranchAndLinkFrom(offset: immunitiesStart + 0x40, toOffset: moveCheckShadow),
//0x7c7b1b78, // mr r27, r3
//0x7fe3fb78, // mr r3, r31
//XGAssembly.createBranchAndLinkFrom(offset: immunitiesStart + 0x4c, toOffset: moveGetType),
//0x7C7F1B78, // mr r31, r3
//0x7f83e378, //mr r3,r28
//
//// 0x58 bulletproof
//0x2803004e,0x4082000c,0x281e0001,XGAssembly.powerPCBranchEqualFromOffset(from: 0x64, to: immune),
//
//// 0x68 soundproof
//0x2803002b,0x40820010,0x281d0001,0x40820008,XGAssembly.createBranchFrom(offset: 0x78, toOffset: immune),
//
//// 0x7c lightning rod
//0x2803001f,0x40820014,0x281f000d,0x4082000c,0x38600014,XGAssembly.createBranchFrom(offset: 0x90, toOffset: powerupImmune),
//
//// 0x94 motor drive
//0x2803005f,0x40820014,0x281f000d,0x4082000c,0x38600013,XGAssembly.createBranchFrom(offset: 0xa8, toOffset: powerupImmune),
//
//// 0xac storm drain
//0x28030060,0x40820014,0x281f000b,0x4082000c,0x38600014,XGAssembly.createBranchFrom(offset: 0xc0, toOffset: powerupImmune),
//
//// 0xc4 sap sipper
//0x28030061,0x40820014,0x281f000c,0x4082000c,0x38600011,XGAssembly.createBranchFrom(offset: 0xd8, toOffset: powerupImmune),
//
//// 0xdc justified on dark moves
//0x28030062,0x40820024,0x281f0011,0x4082000c,0x38600011,XGAssembly.createBranchFrom(offset: 0xf0, toOffset: powerupNotImmune),
//
//// 0xf4 justified on shadow moves
//0x281b0001,0x4082000c,0x38600021,XGAssembly.createBranchFrom(offset: 0x100, toOffset: powerupNotImmune),
//
//// 0x104 rattled on bug moves
//0x2803003c,0x4082005c,0x281f0006,0x4082000c,0x38600013,XGAssembly.createBranchFrom(offset: 0x118, toOffset: powerupNotImmune),
//// 0x11c rattled on ghost moves
//0x281f0007,0x4082000c,0x38600013,XGAssembly.createBranchFrom(offset: 0x128, toOffset: powerupNotImmune),
//// 0x12c rattled on dark moves
//0x281f0011,0x4082000c,0x38600013,XGAssembly.createBranchFrom(offset: 0x138, toOffset: powerupNotImmune),
//// 0x13c rattled on shadow moves
//0x281b0001,0x40820024,0x38600013,XGAssembly.createBranchFrom(offset: 0x148, toOffset: powerupNotImmune),
//
//
//
//// 0x14c power up immune
//0x80810014,
//XGAssembly.createBranchAndLinkFrom(offset: immunitiesStart + 0x150, toOffset: statBoost),
//
//// 0x154 immune
//0x38600001,
//0x48000010,
//
//// 0x15c power up not immune
//0x80810014,
//XGAssembly.createBranchAndLinkFrom(offset: immunitiesStart + 0x160, toOffset: statBoost),
//
//// 0x164 not immune
//0x38600000,
//
//// 0x168
//0x80010028, 0x83e1001c, 0x83c10018, 0x83a10014, 0x83810010, 0x83610020, 0x7c0803a6, 0x38210024, 0x4e800020
//])
//
//// check if move immune ability is being activated on user
//let immuneSelfBranch = 0x2257f4
//let immuneSelfStart = 0xB99F8C
//let getMoveTargets = 0x13e784
//let selfReturn = 0x22580c
//let notSelfReturn = 0x225800
//XGAssembly.replaceASM(startOffset: immuneSelfBranch - kDolToRAMOffsetDifference, newASM: [
//	0x7C7F1B78,	// mr r31, r3
//	XGAssembly.createBranchAndLinkFrom(offset: immuneSelfBranch + 0x4, toOffset: getMoveTargets),
//	XGAssembly.createBranchFrom(offset: immuneSelfBranch + 0x8, toOffset: immuneSelfStart),
//])
//XGAssembly.replaceRELASM(startOffset: immuneSelfStart - kRELtoRAMOffsetDifference, newASM: [
//
//	0x28030005, // cmpwi r3, move user
//	0x40820010, // bne 0x10
//	0x38600000, // li r3, 0
//	0x3bc00000, // li r30, 0
//	XGAssembly.createBranchFrom(offset: immuneSelfStart + 0x10, toOffset: selfReturn),
//	0x7fa3eb78, // mr r3, r29
//	XGAssembly.createBranchFrom(offset: immuneSelfStart + 0x18, toOffset: notSelfReturn),
//
//])
//
//
//
//// moxie
//let moxieBranch = 0x225108
//let moxieStart  = 0xb9a294
//let checkHP = 0x204a70
////let statBoost = 0xB9ACC0
//
//XGAssembly.replaceASM(startOffset: moxieBranch - kDolToRAMOffsetDifference, newASM: [XGAssembly.createBranchFrom(offset: moxieBranch, toOffset: moxieStart)])
//XGAssembly.replaceRELASM(startOffset: moxieStart - kRELtoRAMOffsetDifference, newASM: [
//0x7fe3fb78, // mr r3, r31 (defending pokemon pointer)
//XGAssembly.createBranchAndLinkFrom(offset: moxieStart + 0x4, toOffset: checkHP),
//0x28030001, // cmpwi r3, 1
//XGAssembly.powerPCBranchEqualFromOffset(from: 0xc, to: 0x2c),
//
//0x7fc3f378, // mr r3, r30 (attacking pokemon pointer)
//0xa063080c,	// lhz r3, 0x80c(r3) (get ability)
//0x2803003a, // cmpwi r3, moxie
//XGAssembly.powerPCBranchNotEqualFromOffset(from: 0x1c, to: 0x2c),
//
//0x38600011, // li r3, attack stat, 1 stage
//0x7fc4f378, // mr r4, r30 battle pokemon
//XGAssembly.createBranchAndLinkFrom(offset: moxieStart + 0x28, toOffset: statBoost),
//
//0x5704043e, // rlwinm	r4, r24, 0, 16, 31 (0000ffff) overwritten code
//XGAssembly.createBranchFrom(offset: moxieStart + 0x30, toOffset: moxieBranch + 0x4),
//
//])
//
//
//
//// ability activation animation
//let abilityActivateStart = 0xB9ADF8
////let getStatIndex = 0x222484
////let getValueWithIndex = 0x142e7c
////let unknownFunc = 0x148a98
////let setParams = 0x1f6780
////let setValueWithIndex = 0x141d14
////let animSoundCallback = 0x2236a8
//
//XGAssembly.replaceRELASM(startOffset: abilityActivateStart - kRELtoRAMOffsetDifference, newASM: [
//	.stwu(.sp, .sp, -0x50),
//	.mflr(.r0),
//	.stw(.r0, .sp, 0x54),
//	.stmw(.r20, .sp, 0x10),
//
//	.mr(.r4, .r3),
//	.li(.r3, 0),
//	.bl(setParams),
//
//	.lwz(.r23, .r13, -0x44fc),
//	.addis(.r23, .r23, 1),
//	.lbz(.r25, .r23, 0x60a4),
//	.lbz(.r26, .r23, 0x60a5),
//	.lbz(.r27, .r23, 0x601e),
//	.lis(.r3, 0x804f),
//	.subi(.r3, .r3, 0x10_000 - 0x85C3),
//	.lbz(.r22, .r3, 0),
//
//	.lis(.r6, 0x80BA),
//	.subi(.r6, .r6, 0x10_000 - 0xADE9),
//
//	.li(.r24, 0x16),
//	.stb(.r24, .r6, 0),
//
//	.lis(.r3, 0x80BA),
//	.subi(.r3, .r3, 0x10_000 - 0xADEF),
//	.li(.r5, 20),
//	.stb(.r5, .r3, 0),
//
//	.li(.r0, 0),
//	.stb(.r5, .r23, 0x60a4),
//	.stb(.r0, .r23, 0x60a5),
//	.lis(.r3, 0x80BA),
//	.subi(.r3, .r3, 0x10_000 - 0xADE4),
//	.bl(animSoundCallback),
//
//	.stb(.r25, .r23, 0x60a4),
//	.stb(.r26, .r23, 0x60a5),
//	.stb(.r27, .r23, 0x601e),
//	.lis(.r3, 0x804f),
//	.subi(.r3, .r3, 0x10_000 - 0x85C3),
//	.stb(.r22, .r3, 0),
//
//	.lmw(.r20, .sp, 0x10),
//	.lwz(.r0, .sp, 0x54),
//	.mtlr(.r0),
//	.addi(.sp, .sp, 0x50),
//	.blr,
//	.nop
//
//	])
//
//
//// natural cure activation message
//let naturalBranch = 0x21c5fc
//let naturalStart = 0x2226e4
//let naturalEnd = naturalBranch + 0x4
//XGAssembly.replaceASM(startOffset: naturalBranch - kDolToRAMOffsetDifference, newASM: [XGAssembly.createBranchFrom(offset: naturalBranch, toOffset: naturalStart)])
//XGAssembly.replaceASM(startOffset: naturalStart - kDolToRAMOffsetDifference, newASM: [
//	0x7fe3fb78, // mr r3, r31
//	XGAssembly.createBranchAndLinkFrom(offset: naturalStart + 0x4, toOffset: abilityActivateStart),
//	0x7fe3fb78, // mr r3, r31
//	XGAssembly.createBranchFrom(offset: naturalStart + 0xc, toOffset: naturalEnd)
//])
//
//// trace, download, trickster
//let get_pointer_index_func = 0x1f3f3c
//let get_pointer_general_func = 0x1efcac
//let check_status_func = 0x1f848c
//let set_status_function = 0x1f8438
//let end_status_function = 0x1f8534
//
//let entryBranch = 0x225d18
//let entryStart = 0x222554
//let entryEnd = 0x225d1c
//let traceStart = entryStart + 0x20
//let downloadStart = traceStart + 0x44
//let tricksterStart = downloadStart + 0x14
//let traceIndex : UInt32 = 36
//let downloadIndex : UInt32 = 100
//let tricksterIndex : UInt32 = 57
//let checkSetStatus = 0x20254c
//let setStatus = 0x2024a4
//let activate = abilityActivateStart
//XGAssembly.replaceASM(startOffset: entryBranch - kDolToRAMOffsetDifference, newASM: [XGAssembly.createBranchFrom(offset: entryBranch, toOffset: entryStart)])
//XGAssembly.replaceASM(startOffset: entryStart - kDolToRAMOffsetDifference, newASM: [
//	0x5460043e,																	// rlwinm r0, r3
//	0x28000000 + traceIndex,													// cmpwi r0, trace
//	XGAssembly.powerPCBranchEqualFromOffset(from: entryStart + 0x8, to: traceStart),		// beq traceStart:
//	0x28000000 + downloadIndex,													// cmpwi r0, download
//	XGAssembly.powerPCBranchEqualFromOffset(from: entryStart + 0x10, to: downloadStart),	// beq downloadStart:
//	0x28000000 + tricksterIndex,												// cmpwi r0, trickster
//	XGAssembly.powerPCBranchEqualFromOffset(from: entryStart + 0x18, to: tricksterStart),	// beq tricksterStart:
//	XGAssembly.createBranchFrom(offset: entryStart + 0x1c, toOffset: entryEnd),			// b entryEnd
//	//traceStart: 0x20 -------->
//	0x7fe3fb78,																	// mr r3, r31
//	0x8863084d,																	// lbz r3, 0x084d(r3)
//	0x5460063f,																	// rlwinm r0, r3
//	XGAssembly.powerPCBranchNotEqualFromOffset(from: traceStart + 0xc, to: entryEnd),		// bne entryEnd
//	0x7fe3fb78,																	// mr r3, r31
//	0x3880003c,																	// li r4, 60
//	XGAssembly.createBranchAndLinkFrom(offset:traceStart + 0x18, toOffset: checkSetStatus),// bl checkIfCanSetStatus
//	0x28030002,																	// cmpwi r3, 2
//	XGAssembly.powerPCBranchNotEqualFromOffset(from: 0, to: 0x14),							// bne don't set
//	0x7fe3fb78,																	// mr r3, r31
//	0x3880003c,																	// li r4, 60
//	0x38a00000,																	// li r5, 0
//	XGAssembly.createBranchAndLinkFrom(offset: traceStart + 0x30, toOffset: setStatus),	// bl set status
//	0x7fe3fb78,																	// mr r3, r31
//	0x38800001,																	// li r4, 1
//	0x9883084d,																	// stb r4, 0x084d(r3)
//	XGAssembly.createBranchFrom(offset: traceStart + 0x40, toOffset: entryEnd),			// b entryEnd
//	//downloadStart: 0x64 -------->
//	0x7fe3fb78,																	// mr r3, r31
//	0x7C641B78,																	// mr r4, r3
//	0x38600004,																	// li r3, 4
//	XGAssembly.createBranchAndLinkFrom(offset: downloadStart + 0xc, toOffset: activate),	// bl activate ability (stat boost)
//	XGAssembly.createBranchFrom(offset: downloadStart + 0x10, toOffset: entryEnd),			// b entry end
//	//tricksterStart: 0x78 -------->
//	0x7fe3fb78,																	// mr r3, r31
//	XGAssembly.createBranchAndLinkFrom(offset: tricksterStart + 0x4, toOffset: abilityActivateStart),
//	0x38600000,	// li r3, 0
//	XGAssembly.createBranchAndLinkFrom(offset: tricksterStart + 0x0c, toOffset: get_pointer_index_func),	// bl get_pointer_index
//	0x7C641B78,	// mr r4, r3
//	0x38600002,	// li r3, 2
//	XGAssembly.createBranchAndLinkFrom(offset: tricksterStart + 0x18, toOffset: get_pointer_general_func), // bl get_pointer_general
//	0x7C7F1B78,	// mr r31, r3
//	0x3880004C,	// li r4, 76
//	XGAssembly.createBranchAndLinkFrom(offset: tricksterStart + 0x24, toOffset: check_status_func), // bl check_status
//	0x28030002,	// cmpwi r3, 2
//	XGAssembly.powerPCBranchNotEqualFromOffset(from: tricksterStart + 0x2c, to: entryEnd),
//	0x7fe3fb78,	//0x28 mr r3, r31
//	0x3880004C,	//0x2c li r4, 76
//	0x38a00000,	//0x30 li r5, 0
//	XGAssembly.createBranchAndLinkFrom(offset: tricksterStart + 0x3c, toOffset: set_status_function), //0x34 bl set_status
//	0x38600001,	//0x38 li r3, 1
//	XGAssembly.createBranchAndLinkFrom(offset: tricksterStart + 0x44, toOffset: get_pointer_index_func), //0x3c bl get_pointer_index
//	0x7C641B78,	//0x40 mr r4, r3
//	0x38600002,	//0x44 li r3, 2
//	XGAssembly.createBranchAndLinkFrom(offset: tricksterStart + 0x50, toOffset: get_pointer_general_func), //0x48 bl get_pointer_general
//	0x3880004C,	//0x4c li r4, 76
//	0x38a00000,	//0x50 li r5, 0
//	XGAssembly.createBranchAndLinkFrom(offset: tricksterStart + 0x5c, toOffset: set_status_function), //0x54 bl set_status
//	XGAssembly.createBranchFrom(offset: tricksterStart + 0x60, toOffset: entryEnd), //0x58 b entry end:
//])

//// one trick room expiry message
//getStringSafelyWithID(id: 20099).duplicateWithString("The [0d] wore off!").replace()
//let trickExpireBranch = 0x228dc4
//let trickExpireStart = 0xB9AEC4
//let trickExpireSkip = 0x228dd0
//XGAssembly.replaceASM(startOffset: trickExpireBranch - kDolToRAMOffsetDifference, newASM: [.b(trickExpireStart)])
//XGAssembly.replaceRELASM(startOffset: trickExpireStart - kRELtoRAMOffsetDifference, newASM: [
//	.cmplwi(.r28, 1),
//	.bne_f(0, 8),
//	.b(trickExpireSkip),
//	.lis(.r3, 0x8041), // overwritten code
//	.b(trickExpireBranch + 4)
//])

//// moves thaw from frozen
//let thawBranch = 0x226d6c
//let thawStart = 0xB9AED8
//let thawTrue = thawStart + 0x38
//let thawFalse = thawStart + 0x3c
//XGAssembly.replaceASM(startOffset: thawBranch - kDolToRAMOffsetDifference, newASM: [.b(thawStart), .nop, .nop])
//XGAssembly.replaceRELASM(startOffset: thawStart - kRELtoRAMOffsetDifference, newASM: [
//	.cmpwi(.r30, move("flame wheel").index),
//	.beq(thawTrue),
//	.cmpwi(.r30, move("flare blitz").index),
//	.beq(thawTrue),
//	.cmpwi(.r30, move("scald").index),
//	.beq(thawTrue),
//	.cmpwi(.r30, move("sacred fire").index),
//	.beq(thawTrue),
//	.cmpwi(.r30, move("shadow blaze").index),
//	.beq(thawTrue),
//	.cmpwi(.r30, move("shadow tribute").index),
//	.beq(thawTrue),
//	.cmpwi(.r26, 125), // move effect burn chance and thaw from frozen
//	.bne(thawFalse),
//	// thaw true 0x38
//	.b(0x226da4),
//	// thaw false 0x3c
//	.b(0x226d78)
//])

// lode stone evolution item
//let linkItem = XGItems.item(99).data
//linkItem.function1 = 0x800a54ac
//linkItem.function2 = 0x800a54ac
//linkItem.inBattleUseID = 53
//linkItem.save()

//// set confusion chance to hurt user to 1 in 3
//let confusionStart = 0x2270f0
//XGAssembly.replaceASM(startOffset: confusionStart - kDolToRAMOffsetDifference, newASM: [
//	.cmplwi(.r3, 0x5555), // 1 in 3
//	.bgt(0x227110), // not confused
//])

//// item activation function
//let itemActivationStringID = 1426
//let table = XGFiles.msg("fight")
//let string = XGString(string: "[Pokemon 0x10]'s [Item 0x29] activated.", file: table, sid: itemActivationStringID)
//_ = table.stringTable.addString(string, increaseSize: true, save: true)
//
//let itemActivationStart = 0xB9B3C0
//let setMessageParam = 0x2370ec // r3 = param index, r4 = value
//let getItemID = 0x203870
//let getItemName = 0x15ef7c
//let getString = 0x107300
//let displayMessage = 0x20f568
//let pause = 0x1ef5a4
//let displayBattleMessage = 0xB9B41C
//
//// display an msg id in battle
//let displayMessageStart = 0xB9B41C
//XGAssembly.replaceRamASM(RAMOffset: displayMessageStart, newASM: [
//	.stwu(.sp, .sp, -0x10),
//	.mflr(.r0),
//	.stw(.r0, .sp, 0x14),
//	.bl(displayMessage),
//	.li(.r3, 32),
//	.bl(pause),
//	.lwz(.r0, .sp, 0x14),
//	.mtlr(.r0),
//	.addi(.sp, .sp, 0x10),
//	.blr
//])
//XGAssembly.replaceRamASM(RAMOffset: itemActivationStart, newASM: [
//	.stwu(.sp, .sp, -0x10),
//	.mflr(.r0),
//	.stw(.r0, .sp, 0x14),
//	.stmw(.r30, .sp, 0x8),
//	.mr(.r31, .r3),
//
//	.mr(.r4, .r3),
//	.li(.r3, 0x10),
//	.bl(setMessageParam),
//
//	.mr(.r3, .r31),
//	.bl(getItemID),
//	.bl(getItemName),
//	.bl(getString),
//	.mr(.r4, .r3),
//	.li(.r3, 0x29),
//	.bl(setMessageParam),
//
//	.li(.r3, itemActivationStringID),
//	.bl(displayBattleMessage),
//	.nop,
//
//	.lmw(.r30, .sp, 0x8),
//	.lwz(.r0, .sp, 0x14),
//	.mtlr(.r0),
//	.addi(.sp, .sp, 0x10),
//	.blr
//])
//
//// new trick room tailwind
//let trickStart = 0xB9B51C
//let trickBranch = 0x1f4430
//let getPokemonPointer = 0x1efcac
//let getFieldEffect = 0x1f84e0
//XGAssembly.replaceRamASM(RAMOffset: trickBranch, newASM: [.bl(trickStart)])
//XGAssembly.replaceRamASM(RAMOffset: trickStart, newASM: [
//	.stwu(.sp, .sp, -0x10),
//	.mflr(.r0),
//	.stw(.r0, .sp, 0x14),
//	.stw(.r28, .sp, 0x8),
//	.stw(.r31, .sp, 0xc),
//
//	.mr(.r4, .r26),
//	.li(.r3, 2),
//	.bl(getPokemonPointer),
//	.mr(.r31, .r3),
//
//	.mr(.r4, .r25),
//	.li(.r3, 2),
//	.bl(getPokemonPointer),
//	.mr(.r28, .r3),
//
//	.label("tail wind checks"),
//	.li(.r4, XGStatusEffects.safeguard.rawValue), // edited to tailwind
//	.bl(getFieldEffect),
//	.cmpwi(.r3, 1),
//	.bne_f(0, 8),
//	.rlwinm(.r29, .r29, 1, 0, 30), // double speed
//
//	.mr(.r3, .r31),
//	.li(.r4, XGStatusEffects.safeguard.rawValue), // edited to tailwind
//	.bl(getFieldEffect),
//	.cmpwi(.r3, 1),
//	.bne_f(0, 8),
//	.rlwinm(.r30, .r30, 1, 0, 30), // double speed
//
//	.label("trick room checks"),
//	.mr(.r3, .r28),
//	.li(.r4, XGStatusEffects.mist.rawValue), // edited to trick room
//	.bl(getFieldEffect),
//	.cmpwi(.r3, 1),
//	.beq_l("compare reversed"),
//
//	.mr(.r3, .r31),
//	.li(.r4, XGStatusEffects.mist.rawValue), // edited to trick room
//	.bl(getFieldEffect),
//	.cmpwi(.r3, 1),
//	.beq_l("compare reversed"),
//
//	.label("compare normal"),
//	.cmplw(.r29, .r30),
//	.b_l("return"),
//
//	.label("compare reversed"),
//	.cmplw(.r30, .r29),
//
//	.label("return"),
//	.lwz(.r28, .sp, 0x8),
//	.lwz(.r31, .sp, 0xc),
//	.lwz(.r0, .sp, 0x14),
//	.mtlr(.r0),
//	.addi(.sp, .sp, 0x10),
//	.blr
//])
//
//// rewrite original code
//XGAssembly.replaceRamASM(RAMOffset: 0x225ab4, newASM: [.lmw(.r28, .sp, 0x10)])
//
//// flame orb toxic orb poison heal
//let orbBranch = 0x227eb4
//let orbStart = 0xB9A8B4
//let checkFullHP = 0x201d20
//let checkStatus = 0x2025f0
//let checkSetStatus = 0x20254c
//let checkHasType = 0x2054fc
//let setStatus = 0x2024a4
//let checkNoStatus = 0x203744
//let getHPFraction = 0x203688
//let storeHPLoss = 0x13e094
//let animSoundCallback = 0x2236a8
//let getItem = 0x20384c // get item's hold item id
//let itemMessage = 0xB9B3C0
//
//let healOffset = orbStart + 0x34
//let flameOrbOffset = orbStart + 0x6c
//let toxicOrbOffset = orbStart + 0xec
//let returnOffset = orbStart + 0x174
//
//XGAssembly.replaceASM(startOffset: orbBranch - kDolToRAMOffsetDifference, newASM: [ .b(orbStart) ])
//XGAssembly.replaceRELASM(startOffset: orbStart - kRELtoRAMOffsetDifference, newASM: [
//
//	.lhz(.r3, .r31, 0x80c), // get ability
//	.cmpwi(.r3, ability("poison heal").index),
//	.bne(flameOrbOffset),
//	.mr(.r3, .r31),
//	.li(.r4, 3), // poison
//	.bl(checkStatus),
//	.cmpwi(.r3, 1),
//	.beq(healOffset),
//	.mr(.r3, .r31),
//	.li(.r4, 4), // bad poison
//	.bl(checkStatus),
//	.cmpwi(.r3, 1),
//	.bne(flameOrbOffset),
//
//	//heal offset 0x34
//	.mr(.r3, .r31),
//	.bl(checkFullHP),
//	.cmpwi(.r3, 1),
//	.beq(flameOrbOffset),
//	.mr(.r3, .r31),
//	.li(.r4, 8), // 1/8 max hp
//	.bl(getHPFraction),
//	.rlwinm(.r0, .r3, 0, 16, 31),
//	.neg(.r4, .r0),
//	.mr(.r3, .r30),
//	.bl(storeHPLoss),
//	.lis(.r3, 0x8041),
//	.addi(.r3, .r3, 31004),
//	.bl(animSoundCallback),
//
//	// flame orb offset 0x6c
//	.mr(.r3, .r31),
//	.bl(getItem),
//	.cmpwi(.r3, item("flame orb").data.holdItemID),
//	.bne(toxicOrbOffset),
//
//	.mr(.r3, .r31),
//	.li(.r4, XGMoveTypes.fire.rawValue),
//	.bl(checkHasType),
//	.cmpwi(.r3, 1),
//	.beq(returnOffset),
//
//	.mr(.r3, .r31),
//	.bl(checkNoStatus),
//	.cmpwi(.r3, 1),
//	.bne(returnOffset),
//
//	.nop,
//	.nop,
//	.nop,
//
//	// activate burn
//	.mr(.r3, .r31),
//	.li(.r4, 6), // burn
//	.bl(checkSetStatus),
//	.cmpwi(.r3, 2),
//	.bne(returnOffset),
//	.mr(.r3, .r31),
//	.li(.r4, 6), // burn
//	.li(.r5, 0),
//	.bl(setStatus),
//
//
//	.nop,
//	.nop,
//	.nop,
//	.nop,
//	.mr(.r3, .r31),
//	.bl(itemMessage),
//	.b(returnOffset),
//
//
//	// toxic orb offset 0xec
//	.cmpwi(.r3, item("toxic orb").data.holdItemID),
//	.bne(returnOffset),
//
//	.mr(.r3, .r31),
//	.li(.r4, XGMoveTypes.poison.rawValue),
//	.bl(checkHasType),
//	.cmpwi(.r3, 1),
//	.beq(returnOffset),
//
//	.mr(.r3, .r31),
//	.li(.r4, XGMoveTypes.steel.rawValue),
//	.bl(checkHasType),
//	.cmpwi(.r3, 1),
//	.beq(returnOffset),
//
//	.mr(.r3, .r31),
//	.bl(checkNoStatus),
//	.cmpwi(.r3, 1),
//	.bne(returnOffset),
//
//	.lhz(.r3, .r31, 0x80c), // get ability
//	.cmpwi(.r3, ability("immunity").index),
//	.beq(returnOffset),
//
//	// activate poison
//
//	.mr(.r3, .r31),
//	.li(.r4, 4), // badly poisoned
//	.bl(checkSetStatus),
//	.cmpwi(.r3, 2),
//	.bne(returnOffset),
//	.mr(.r3, .r31),
//	.li(.r4, 4), // badly poisoned
//	.li(.r5, 0),
//	.bl(setStatus),
//
//	.nop,
//	.nop,
//	.nop,
//	.nop,
//	.mr(.r3, .r31),
//	.bl(itemMessage),
//
//	// return offset 0x174
//	.lwz(.r0, .r13, -0x44e8), // overwritten code
//	.b(orbBranch + 0x4)
//])

//
//// sound moves hit through substitute
//let subJumpBranch = 0x2135ac
//let subJumpStart = 0xB9AF18
//let getPokemonPointer = 0x1efcac
//let getCurrentMove = 0x148d64
//let moveGetSoundFlag = 0x13e548
//let moveRoutineGetPosition = 0x2236f8
//XGAssembly.replaceRamASM(RAMOffset: subJumpBranch, newASM: [
//	.b(subJumpStart),
//	.cmpwi(.r3, 1)
//])
//XGAssembly.replaceRamASM(RAMOffset: subJumpStart, newASM: [
//	.cmpwi(.r3, 1),
//	.beq_f(0, 8),
//	.b(subJumpBranch + 4),
//	.lwz(.r0, .r13, -0x44F0),
//	.lwz(.r0, .r0, 2),
//	.cmpwi(.r0, XGStatusEffects.substitute.rawValue),
//	.beq_f(0, 8),
//	.b(subJumpBranch + 4),
//	.li(.r3, 17), // attacking pokemon
//	.li(.r4, 0),
//	.bl(getPokemonPointer),
//	.bl(getCurrentMove),
//	.bl(moveGetSoundFlag),
//	.cmpwi(.r3, 1),
//	.beq_f(0, 0xc),
//	.li(.r3, 1),
//	.b(subJumpBranch + 4),
//	.li(.r3, 0),
//	.b(subJumpBranch + 4),
//
//])
//let subDamageBranch = 0x216054
//let subDamageStart = 0xB9AF64
////let moveGetSoundFlag = 0x13e548
//XGAssembly.replaceRamASM(RAMOffset: subDamageBranch, newASM: [
//	.b(subDamageStart),
//	.nop
//])
//XGAssembly.replaceRamASM(RAMOffset: subDamageStart, newASM: [
//	.cmpwi(.r3, 1),
//	.beq_f(0, 0xc),
//	.b(subDamageBranch + 8),
//	// sound check
//	.mr(.r3, .r28),
//	.bl(moveGetSoundFlag),
//	.cmpwi(.r3, 1),
//	.bne_f(0, 8),
//	// sound move so count as no sub
//	.b(subDamageBranch + 8),
//	// not sound move so count sub as normal
//	.b(0x21614c)
//])
//let subReduceHPBranch = 0x215868
//let subReduceHPStart = 0xB9AF88
////let moveGetSoundFlag = 0x13e548
//XGAssembly.replaceRamASM(RAMOffset: subReduceHPBranch, newASM: [
//	.mr(.r18, .r3),
//	.b(subReduceHPStart)
//])
//XGAssembly.replaceRamASM(RAMOffset: subReduceHPStart, newASM: [
//	.cmpwi(.r3, 0),
//	.bne_f(0, 8),
//	.b(0x2158e0),
//
//	.mr(.r3, .r25),
//	.bl(moveGetSoundFlag),
//	.cmpwi(.r3, 1),
//	.bne_f(0, 0xc),
//
//	.li(.r18, 0),
//	.b(0x2158e0),
//
//	.b(subReduceHPBranch + 8)
//
//])
//

//// super effective type damage reducing berries
//
//for i in item("chople berry").index ... item("colbur berry").index {
//	let itemData = XGItems.item(i).data
//	let type = XGMoveTypes(rawValue: i - item("chilan berry").index) ?? .normal
//	itemData.parameter = type.rawValue
//	itemData.save()
//	_ = itemData.descriptionString.duplicateWithString("Weakens one[New Line]super effective[New Line]\(type.name.lowercased()) type move.").replace()
//}
//var itemData = item("chilan berry").data
//itemData.parameter = XGMoveTypes.normal.rawValue
//itemData.save()
//_ = itemData.descriptionString.duplicateWithString("A hold item[New Line]that weakens one[New Line]normal type move.").replace()
//
//itemData = item("dosha berry").data
//itemData.parameter = 255
//itemData.save()
//_ = itemData.descriptionString.duplicateWithString("A hold item[New Line]that weakens one[New Line]shadow move.").replace()
//
//for i in item("chilan berry").index ... item("dosha berry").index {
//	let itemData = XGItems.item(i).data
//	itemData.holdItemID = 81
//	itemData.friendshipEffects = [2,1,0]
//	itemData.inBattleUseID = 0
//	itemData.canBeHeld = true
//	itemData.couponPrice = 50
//	itemData.price = 20
//	itemData.bagSlot = .berries
//	itemData.save()
//}
//
//let typeBerriesBranch = 0x215ffc
//let typeBerriesStart = 0xB9B020
//let getAdjustedMoveType = 0x13e134
//let checkShadowMove = 0x13d03c
//let getEffectiveness = 0x1f0684
//let checkSetEffectiveness = 0x1f05d0
//let setEffectiveness = 0x1f057c
//let getStatsPointer = 0x148e0c
////let getPokemonPointer = 0x1efcac
//let getMoveRoutinePointer = 0x148da8
//// set message id 20148 to pokemon's berry activated param 41 item
//XGAssembly.replaceRamASM(RAMOffset: typeBerriesBranch, newASM: [.b(typeBerriesStart), .nop])
//XGAssembly.replaceRamASM(RAMOffset: typeBerriesStart, newASM: [
//	.cmpwi(.r23, item("haban berry").data.holdItemID), // all type berries use same id
//	.bne_l("return"),
//
//	.mr(.r3, .r28),
//	.bl(checkShadowMove),
//	.cmpwi(.r3, 1),
//	.bne_l("type check"),
//
//	.cmpwi(.r30, 0xff), // shadow berry parameter
//	.beq_l("reduce damage"),
//	.b_l("return"),
//
//	.label("type check"),
//	.li(.r3, 17), // attacking pokemon
//	.li(.r4, 0),
//	.bl(getPokemonPointer),
//	.bl(getMoveRoutinePointer),
//	.bl(getAdjustedMoveType),
//	.cmpw(.r3, .r30), // compare with item parameter
//	.bne_l("return"),
//
//	.cmpwi(.r30, XGMoveTypes.normal.rawValue),
//	.beq_l("reduce damage"),
//
//	.li(.r3, 17), // attacking pokemon
//	.li(.r4, 0),
//	.bl(getPokemonPointer),
//	.bl(getMoveRoutinePointer),
//	.li(.r4, XGStatusEffects.super_effective.rawValue),
//	.bl(getEffectiveness),
//	.cmpwi(.r3, 1),
//	.bne_l("return"),
//
//	.label("reduce damage"),
//	.mr(.r3, .r26),
//	.li(.r4, XGStatusEffects.endured.rawValue),
//	.bl(checkSetEffectiveness),
//	.cmpwi(.r3, 2),
//	.bne_l("return"),
//
//	.mr(.r3, .r26),
//	.li(.r4, XGStatusEffects.endured.rawValue),
//	.li(.r5, 0),
//	.bl(setEffectiveness),
//
//	.li(.r3, 2),
//	.divw(.r25, .r25, .r3), // halve damage
//
//	.label("return"),
//	.cmpwi(.r25, 0),
//	.bne_f(0, 8),
//	.li(.r25, 1),
//	.b(typeBerriesBranch + 4),
//
//])
//let typeBerryRemoveBranches = [0x2152f0, 0x2153ec]
//let typeBerryRemoveStart = 0xB9B0E8
//let typeBerryRemoveEnd = 0x215470 // branch here when done
//for branch in typeBerryRemoveBranches {
//	XGAssembly.replaceRamASM(RAMOffset: branch, newASM: [
//		.b(typeBerryRemoveStart),
//		.nop
//	])
//}
//XGAssembly.replaceRamASM(RAMOffset: typeBerryRemoveStart, newASM: [
//	.li(.r28, 20148), // "[pokemon 0x10] endured the hit", changed to "[pokemon 0x10]'s [Item 0x29][New Line]weakened the move!"
//	.li(.r3, 18), // defending pokemon
//	.li(.r4, 0),
//	.bl(getPokemonPointer),
//	.lwz(.r3, .r3, 0),
//	.li(.r4, 0),
//	.sth(.r4, .r3, 6), // delete pokemon's item
//	.b(typeBerryRemoveEnd)
//])
//
//// Super luck
//let superLuck = XGAbilities.ability(12)
//_ = superLuck.name.duplicateWithString("Super Luck").replace()
//_ = superLuck.adescription.duplicateWithString("Increases critical rate.").replace()
//
//let superLuckBranch = 0x216fa0
//let superLuckStart = 0xB9B108
//let getAbility = 0x2055c8
////let getPokemonPointer = 0x1efcac
//XGAssembly.replaceRamASM(RAMOffset: superLuckBranch, newASM: [.b(superLuckStart)])
//XGAssembly.replaceRamASM(RAMOffset: superLuckStart, newASM: [
//	.rlwinm(.r25, .r0, 0, 16, 31), // overwritten code
//	.li(.r3, 17), // attacking pokemon
//	.li(.r4, 0),
//	.bl(getPokemonPointer),
//	.bl(getAbility),
//	.cmpwi(.r3, ability("super luck").index),
//	.bne_f(0, 8),
//	.addi(.r25, .r25, 1),
//	.b(superLuckBranch + 4),
//])
//
//// wide lens aura stabiliser
//let lensBranch = 0x217968
//let lensStart = 0xB9B12C
////let getItemID = 0x203870
//let getItemParameter = 0x15eee0
////let getItem = 0x20384c // get item's hold item id
////let getPokemonPointer = 0x1efcac
////let checkShadowMove = 0x13d03c
//XGAssembly.replaceRamASM(RAMOffset: lensBranch, newASM: [.b(lensStart)])
//XGAssembly.replaceRamASM(RAMOffset: lensStart, newASM: [
//
//	.li(.r3, 17), // attacking pokemon
//	.li(.r4, 0),
//	.bl(getPokemonPointer),
//	.bl(getItem),
//	.cmpwi(.r3, item("wide lens").data.holdItemID),
//	.beq_l("accuracy boost"),
//
//	.cmpwi(.r3, item("aura stabiliser").data.holdItemID),
//	.bne_l("return"),
//
//	.mr(.r3, .r20), // current move
//	.bl(checkShadowMove),
//	.cmpwi(.r3, 1),
//	.bne_l("return"),
//
//	.label("accuracy boost"),
//	.li(.r3, 17), // attacking pokemon
//	.li(.r4, 0),
//	.bl(getPokemonPointer),
//	.bl(getItemID),
//	.bl(getItemParameter),
//	.mullw(.r22, .r22, .r3),
//	.li(.r3, 100),
//	.divw(.r22, .r22, .r3),
//
//	.label("return"),
//	.rlwinm(.r0, .r25, 0, 16, 31), // overwritten
//	.b(lensBranch + 4)
//])

//// aura stabiliser prevents reverse mode
//let reverseBranch = 0x226818
//let reverseStart = 0xB9B614
//let getItem = 0x20384c // get item's hold item id
//XGAssembly.replaceRamASM(RAMOffset: reverseBranch, newASM: [.b(reverseStart)])
//XGAssembly.replaceRamASM(RAMOffset: reverseStart, newASM: [
//
//	.mr(.r3, .r30), // pokemon
//	.bl(getItem),
//	.cmpwi(.r3, item("aura stabiliser").data.holdItemID),
//	.beq_l("skip"),
//
//	.label("no skip"),
//	.mr(.r3, .r30), // overwritten
//	.b(reverseBranch + 4),
//
//	.label("skip"),
//	.li(.r3, 0),
//	.b(0x226b20)
//])


//
//// function check if move was successful
//// check flinched, frozen, sleep, move failed, missed, protected, etc.
//let checkAttackedStart = 0xB9B300
//let checkMoveDidntFail = 0x1f04fc
////let getMoveRoutinePointer = 0x148da8
////let checkStatus = 0x2025f0
////let getPokemonPointer = 0x1efcac
//XGAssembly.replaceRamASM(RAMOffset: checkAttackedStart, newASM: [
//	.stwu(.sp, .sp, -0x20),
//	.mflr(.r0),
//	.stw(.r0, .sp, 0x24),
//	.stmw(.r30, .sp, 0x10),
//
//	.li(.r3, 17), // attacking pokemon
//	.li(.r4, 0),
//	.bl(getPokemonPointer),
//	.mr(.r30, .r3),
//
//	.li(.r4, XGStatusEffects.freeze.rawValue),
//	.bl(checkStatus),
//	.cmpwi(.r3, 1),
//	.bne_f(0, 0xc),
//	.li(.r3, 0),
//	.b_l("return"),
//
//	.mr(.r3, .r30),
//	.li(.r4, XGStatusEffects.sleep.rawValue),
//	.bl(checkStatus),
//	.cmpwi(.r3, 1),
//	.bne_f(0, 0xc),
//	.li(.r3, 0),
//	.b_l("return"),
//
//	.mr(.r3, .r30),
//	.li(.r4, XGStatusEffects.flinched.rawValue),
//	.bl(checkStatus),
//	.cmpwi(.r3, 1),
//	.bne_f(0, 0xc),
//	.li(.r3, 0),
//	.b_l("return"),
//
//	.mr(.r3, .r30),
//	.li(.r4, XGStatusEffects.must_recharge.rawValue),
//	.bl(checkStatus),
//	.cmpwi(.r3, 1),
//	.bne_f(0, 0xc),
//	.li(.r3, 0),
//	.b_l("return"),
//
//	.lbz(.r3, .r30, 0x83c), // check fully paralysed
//	.cmpwi(.r3, 1),
//	.bne_f(0, 0xc),
//	.li(.r3, 0),
//	.b_l("return"),
//
//
//	.mr(.r3, .r30),
//	.bl(getMoveRoutinePointer),
//	.bl(checkMoveDidntFail),
//
//	.label("return"),
//	.lmw(.r30, .sp, 0x10),
//	.lwz(.r0, .sp, 0x24),
//	.mtlr(.r0),
//	.addi(.sp, .sp, 0x20),
//	.blr
//])

//// muscle band, wise glasses and knock off damage boost
//let calcDamageBoostsBranch = 0x22a760
//let calcDamageStart = 0xB9AFB0
//let getItemID = 0x203870
//let getMoveEffect = 0x13e6e8
////let getItemID = 0x203870
//XGAssembly.replaceRamASM(RAMOffset: calcDamageBoostsBranch, newASM: [
//	.b(calcDamageStart)
//])
//XGAssembly.replaceRamASM(RAMOffset: calcDamageStart, newASM: [
//	.label("muscle band check"),
//	.cmpwi(.r28, item("muscle band").data.holdItemID),
//	.bne_l("wise glasses check"),
//	.cmpwi(.r24, XGMoveCategories.physical.rawValue),
//	.bne_l("wise glasses check"),
//	.lwz(.r3, .sp, 0x20), // item parameter
//	.mullw(.r14, .r14, .r3),
//	.li(.r3, 100),
//	.divw(.r14, .r14, .r3),
//
//	.label("wise glasses check"),
//	.cmpwi(.r28, item("wise glasses").data.holdItemID),
//	.bne_l("knock off check"),
//	.cmpwi(.r24, XGMoveCategories.special.rawValue),
//	.bne_l("knock off check"),
//	.lwz(.r3, .sp, 0x20), // item parameter
//	.mullw(.r14, .r14, .r3),
//	.li(.r3, 100),
//	.divw(.r14, .r14, .r3),
//
//	.label("knock off check"),
//	.mr(.r3, .r17),
//	.bl(getMoveEffect), // get move effect
//	.cmpwi(.r3, move("knock off").data.effect),
//	.bne_l("return"),
//
//	.mr(.r3, .r16), // defending pokemon
//	.bl(getItemID),
//	.cmpwi(.r3, 0),
//	.beq_l("return"),
//
//	.mulli(.r14, .r14, 150),
//	.li(.r3, 100),
//	.divw(.r14, .r14, .r3),
//
//	.label("return"),
//	.b(calcDamageBoostsBranch + 4)
//])


// poison touch ability
//
//// remove magma armour
//XGAbilities.ability(40).name.duplicateWithString("Poison Touch").replace()
//XGAbilities.ability(40).adescription.duplicateWithString("Contact may poison.").replace()
//
//let shadowFreezeRoutine =  [0x00, 0x02, 0x04, 0x1e, 0x12, 0x00, 0x00, 0x00, 0x14, 0x80, 0x41, 0x5c, 0x93, 0x1d, 0x12, 0x00, 0x00, 0x00, 0x07, 0x80, 0x41, 0x5e, 0xb9, 0x23, 0x12, 0x0f, 0x80, 0x41, 0x5c, 0xc6, 0x1f, 0x12, 0x19, 0x80, 0x41, 0x5e, 0x81, 0x1f, 0x12, 0x2f, 0x80, 0x41, 0x5e, 0x81, 0x1f, 0x12, 0x31, 0x80, 0x41, 0x5e, 0x81, 0x1d, 0x12, 0x00, 0x00, 0x00, 0x01, 0x80, 0x41, 0x5c, 0x93, 0x01, 0x80, 0x41, 0x5c, 0x93, 0x00, 0x00, 0x20, 0x12, 0x00, 0x4b, 0x80, 0x41, 0x6d, 0xb2, 0x0a, 0x0b, 0x04, 0x2f, 0x80, 0x4e, 0x85, 0xc3, 0x04, 0x17, 0x0b, 0x04, 0x29, 0x80, 0x41, 0x41, 0x0f,]
//
//let routine : (effect: Int, routine: [Int], offset: Int) = (162, shadowFreezeRoutine, 0xb99ce9)
//XGAssembly.setMoveEffectRoutine(effect: routine.effect, fileOffset: routine.offset - kRELtoRAMOffsetDifference, moveToREL: true, newRoutine: routine.routine)
//let magmaArmourOffset = 0x21443c - kDolToRAMOffsetDifference
//XGAssembly.replaceASM(startOffset: magmaArmourOffset, newASM: [.nop,.nop,.nop])
//
//let poisonTouchBranch = 0x225580
//let poisonTouchStart = 0xB9B1D8
//let RNG16Bit = 0x25ca08
////let animSoundCallback = 0x2236a8
//let checkHasHP = 0x204a70
//let checkAttackSuccess = 0xB9B300
//XGAssembly.replaceASM(startOffset: poisonTouchBranch - kDolToRAMOffsetDifference, newASM: [.b(poisonTouchStart)])
//XGAssembly.replaceRamASM(RAMOffset: poisonTouchStart, newASM: [
//
//	.cmpwi(.r26, 1), // check move succeeded
//	.bne_l("return"),
//
//	.bl(checkAttackSuccess),
//	.cmpwi(.r3, 1), // check wasn't prevented by status
//	.bne_l("return"),
//
//	.mr(.r3, .r31), // defending pokemon
//	.bl(checkHasHP),
//	.cmpwi(.r3, 1),
//	.bne_l("return"),
//
//	.cmpwi(.r25, 1), // contact check
//	.bne_l("return"),
//
//	.cmpwi(.r16, ability("poison touch").index),
//	.bne_l("return"),
//
//	// get random number
//	.bl(RNG16Bit),
//
//	// calculate random number % 10 (remainder)
//	// result is random number between 0 and 9
//	.li(.r4, 10),
//	.divw(.r0, .r3, .r4),
//	.mullw(.r0, .r0, .r4),
//	.sub(.r0, .r3, .r0),
//
//	// activate if random number less than 3 (30% chance)
//	.cmpwi(.r0, 2),
//	.bgt_l("return"),
//
//	// activate poison
//	.lwz(.r0, .r13, -0x44e8),
//	.ori(.r0, .r0, 0x2000),
//	.stw(.r0, .r13, -0x44e8),
//	.subi(.r5, .r13, 30816),
//	.li(.r4, 2), // poison secondary effect
//	.stb(.r4, .r5, 3),
//	.lis(.r3, 0x8041),
//	.addi(.r3, .r3, 31755),
//	.bl(animSoundCallback),
//	.li(.r17, 1),
//
//	.label("return"),
//	.mr(.r3, .r17),
//	.b(poisonTouchBranch + 4)
//])
//
//// rocky helmet, spiky shield fix
//let rockyHelmetFixBranch = 0xb99414
//let rockyHelmetFixStart = 0xB9B2A8
////let checkAttackSuccess = 0xB9B300
//XGAssembly.replaceRamASM(RAMOffset: rockyHelmetFixBranch, newASM: [.b(rockyHelmetFixStart)])
//XGAssembly.replaceRamASM(RAMOffset: rockyHelmetFixStart, newASM: [
//	.cmpwi(.r26, 1),
//	.bne_l("fail"),
//	.bl(checkAttackSuccess),
//	.cmpwi(.r3, 1),
//	.bne_l("fail"),
//
//	.mr(.r3, .r30), // attacking pokemon
//	.bl(checkHasHP),
//	.cmpwi(.r3, 1),
//	.bne_l("fail"),
//
//	.label("success"),
//	.b(rockyHelmetFixBranch + 0xc),
//	.label("fail"),
//	.b(rockyHelmetFixBranch + 8),
//
//])
//
// checks if attacking pokemon has hp
//let hpCheckStart = 0xB9B27C
////let getPokemonPointer = 0x1efcac
//XGAssembly.replaceRamASM(RAMOffset: hpCheckStart, newASM: [
//	.stwu(.sp, .sp, -0x10),
//	.mflr(.r0),
//	.stw(.r0, .sp, 0x14),
//
//	.li(.r3, 17),
//	.li(.r4, 0),
//	.bl(getPokemonPointer),
//	.bl(checkHasHP),
//
//	.lwz(.r0, .sp, 0x14),
//	.mtlr(.r0),
//	.addi(.sp, .sp, 0x10),
//	.blr
//
//])
//// life orb fix
//let fixBranch = 0xb9a208
//let lifeOrbFixStart = 0xB9B2D4
//XGAssembly.replaceRamASM(RAMOffset: fixBranch, newASM: [
//	.b(lifeOrbFixStart)
//])
//XGAssembly.replaceRamASM(RAMOffset: lifeOrbFixStart, newASM: [
//	.cmpwi(.r26, 1),
//	.bne_l("fail"),
//	.bl(checkAttackSuccess),
//	.cmpwi(.r3, 1),
//	.bne_l("fail"),
//
//	.mr(.r3, .r30), // attacking pokemon
//	.bl(checkHasHP),
//	.cmpwi(.r3, 1),
//	.bne_l("fail"),
//
//	.label("success"),
//	.b(0xb9a20c),
//	.label("fail"),
//	.b(0xb9a28c),
//])
//
//// remove sleep talk and snore
//XGAssembly.replaceRamASM(RAMOffset: 0x226cdc, newASM: [
//	.nop,
//	.nop,
//	.nop,
//	.nop,
//	.nop,
//])
//
//// set confusion chance to hurt user to 1 in 3
//let confusionStart = 0x2270f0
//XGAssembly.replaceASM(startOffset: confusionStart - kDolToRAMOffsetDifference, newASM: [
//	.cmplwi(.r3, 0xaaaa), // 1 in 3
//	.blt(0x227110), // not confused
//])
//
//// spread moves on water absorb, volt absorb, flash fire
//XGAssembly.replaceRamASM(RAMOffset: 0x2255a4, newASM: [.stmw(.r23, .sp, 0x8)])
//XGAssembly.replaceRamASM(RAMOffset: 0x2257bc, newASM: [.lmw(.r23, .sp, 0x8)])
//XGAssembly.replaceRamASM(RAMOffset: 0x2255f0, newASM: [
//	.mr(.r29, .r3),
//	.li(.r23, 0),
//	.mr(.r3, .r28),
//])
//for offset in [0x22566c, 0x22567c, 0x2256ac, 0x2256bc, 0x22573c, 0x22574c, 0x225784, 0x225794] {
//	XGAssembly.replaceRamASM(RAMOffset: offset, newASM: [.mr(.r23, .r3)])
//}
//let absorbRoutineBranch = 0x2257b8
//let absorbStart = 0xB9B444
//let getTargets = 0x13e784
//let setMoveRoutinePosition = 0x2236d4
////let animSoundCallback = 0x2236a8
//XGAssembly.replaceRamASM(RAMOffset: absorbRoutineBranch, newASM: [.b(absorbStart)])
//XGAssembly.replaceRamASM(RAMOffset: absorbStart, newASM: [
//
//	.cmpwi(.r23, 0),
//	.beq_l("return false"),
//	.mr(.r3, .r23),
//	.bl(animSoundCallback),
//
//	.mr(.r3, .r24),
//	.bl(getTargets),
//	.cmpwi(.r3, XGMoveTargets.bothFoesAndAlly.rawValue),
//	.bne_l("end routine"),
//
//	.lis(.r3, 0x8041),
//	.addi(.r3, .r3, 0x59a9),
//	.bl(setMoveRoutinePosition),
//	.b_l("return true"),
//
//	.label("end routine"),
//	.lis(.r3, 0x8041),
//	.addi(.r3, .r3, 0x4119),
//	.bl(setMoveRoutinePosition),
//
//	.label("return true"),
//	.li(.r3, 1),
//	.b(absorbRoutineBranch + 4),
//
//	.label("return false"),
//	.li(.r3, 0),
//	.b(absorbRoutineBranch + 4)
//])

//// new gale wings, prankster
//let priorityAbilitiesBranches = [0x1f43ec, 0x1f43f8]
//let priorityAbilitiesStart = 0xB9B490
//let getCurrentMove = 0x2045b4
//let getPriority = 0x13e7b8
//let getAbility = 0x2055c8
//let getType = 0x13e870
//let getCategory = 0x13e7f0
//for branch in priorityAbilitiesBranches {
//	XGAssembly.replaceRamASM(RAMOffset: branch, newASM: [.bl(priorityAbilitiesStart)])
//}
//XGAssembly.replaceRamASM(RAMOffset: priorityAbilitiesStart, newASM: [
//	.stwu(.sp, .sp, -0x10),
//	.mflr(.r0),
//	.stw(.r0, .sp, 0x14),
//	.stmw(.r30, .sp, 0x8),
//
//	.mr(.r31, .r3),
//	.bl(getCurrentMove),
//	.mr(.r30, .r3),
//	.bl(getPriority),
//	.cmpwi(.r3, 0),
//	.bne_l("no boost"),
//
//	.mr(.r3, .r31),
//	.bl(getAbility),
//	.cmpwi(.r3, ability("prankster").index),
//	.beq_l("prankster check"),
//	.cmpwi(.r3, ability("gale wings").index),
//	.bne_l("no boost"),
//
//	.label("gale wings check"),
//	.mr(.r3, .r30),
//	.bl(getType),
//	.cmpwi(.r3, XGMoveTypes.flying.rawValue),
//	.beq_l("boost priority"),
//	.b_l("no boost"),
//
//	.label("prankster check"),
//	.mr(.r3, .r30),
//	.bl(getCategory),
//	.cmpwi(.r3, XGMoveCategories.none.rawValue),
//	.beq_l("boost priority"),
//	.b_l("no boost"),
//
//	.label("boost priority"),
//	.li(.r3, 1),
//	.b_l("return"),
//
//	.label("no boost"),
//	.mr(.r3, .r30),
//	.bl(getPriority),
//
//	.label("return"),
//	.lmw(.r30, .sp, 0x8),
//	.lwz(.r0, .sp, 0x14),
//	.mtlr(.r0),
//	.addi(.sp, .sp, 0x10),
//	.blr
//])
//
//
//// fix type damage reducing berries ending multi hit moves
//let dol = XGFiles.dol.data!
//dol.replaceWordAtOffset(0x414659 - kDolTableToRAMOffsetDifference, withBytes: 0x80414659)
//dol.save()
//
// fix berry glitch on moves like earthquake
//XGAssembly.replaceRamASM(RAMOffset: 0x210214, newASM: [.nop])
//
//
//// new skill link
//let skillBranches = [0x221d70, 0x221d98]
//let skillStart = 0xB9B5C8
//for branch in skillBranches {
//	XGAssembly.replaceRamASM(RAMOffset: branch, newASM: [.bl(skillStart)])
//}
//XGAssembly.replaceRamASM(RAMOffset: skillStart, newASM: [
//	.rlwinm(.r4, .r0, 0, 24, 31),
//	.subi(.r3, .r31, 1608),
//	.lhz(.r3, .r3, 0x80c),
//	.cmpwi(.r3, ability("skill link").index),
//	.bne_l("return"),
//	.li(.r4, 5),
//
//	.label("return"),
//	.blr
//])
//
//// new magic coat mirror match check
//// prevents infinite loops of magic bounce
//// if user has magic bounce then ignore target magic bounce
//let magicBranch = 0x218568
//let magicCheckStart  = 0xB9B5E4
//let magicTrueOffset  = 0x21856c
//let magicFalseOffset = 0x2185dc
//let getAbilityb = 0x148898
//XGAssembly.replaceRamASM(RAMOffset: magicBranch, newASM: [.b(magicCheckStart)])
//XGAssembly.replaceRamASM(RAMOffset: magicCheckStart, newASM: [
//
//	.bne_l("magic false"),
//	.mr(.r3, .r29),
//	.bl(getAbilityb),
//	.cmpwi(.r3, ability("magic bounce").index),
//	.beq_l("magic false"),
//
//	.label("magic true"),
//	.b(magicTrueOffset),
//
//	.label("magic false"),
//	.b(magicFalseOffset)
//])
//
//// new sash/sturdy shedinja check
//// prevents focus sash from activating on shedinja since sash is infinite
//// works by skipping focus sash checks if pokemon has 1hp
////
//let shedinjaBranch = 0x216010
//let shedinjaTrueBranch = 0x216048
//let shedinjaFalseBranch = 0x216014
//let shedinjaCheckStart = 0xB9B600
//XGAssembly.replaceRamASM(RAMOffset: shedinjaBranch, newASM: [.b(shedinjaCheckStart)])
//XGAssembly.replaceRamASM(RAMOffset: shedinjaCheckStart, newASM: [
//	.cmpwi(.r31, 1), // current hp
//	.beq_l("skip sash"),
//
//	.cmpwi(.r23, item("focus sash").data.holdItemID),
//	.label("check sash"),
//	.b(shedinjaBranch + 4),
//
//	.label("skip sash"),
//	.b(0x216048)
//])
//
//// move routine jump if status >0xff will jump if move failed (protect, type immunity, flinched, etc.), and if move target is set, will jump if target doesn't have hp
//let jumpBranch = 0x21354c
//let jumpStart = 0xB9B6A4
//let checkAttackSuccess = 0xB9B300
//let checkHasHP = 0x204a70
//XGAssembly.replaceRamASM(RAMOffset: jumpBranch, newASM: [.b(jumpStart)])
//XGAssembly.replaceRamASM(RAMOffset: jumpStart, newASM: [
//	.cmpwi(.r4, 1),
//	.bne_l("check custom"),
//	.b(jumpBranch + 8),
//
//	.label("check custom"),
//	.cmplwi(.r4, 0x80),
//	.bge_l("custom status"),
//	.b(0x213578),
//
//	.label("custom status"),
//	.cmplwi(.r4, 0xff),
//	.bne_l("reserved for future expansion"),
//
//	.bl(checkAttackSuccess),
//	.cmpwi(.r3, 1),
//	.beq_l("check hp"),
//	.b_l("jump"),
//
//	.label("check hp"),
//	.mr(.r3, .r31),
//	.bl(checkHasHP),
//	.cmpwi(.r3, 1),
//	.bne_l("jump"),
//	.b_l("no jump"),
//
//	.label("reserved for future expansion"),
//	.nop,
//	.nop,
//	.nop,
//	.nop,
//	.nop,
//	.nop,
//	.nop,
//	.nop,
//	.nop,
//	.nop,
//	.nop,
//	.nop,
//	.nop,
//	.nop,
//	.nop,
//	.nop,
//	.nop,
//	.nop,
//	.nop,
//	.nop,
//	.nop,
//	.nop,
//	.nop,
//	.nop,
//	.nop,
//	.nop,
//	.nop,
//	.nop,
//	.nop,
//	.nop,
//	.nop,
//	.nop,
//	.nop,
//	.nop,
//	.nop,
//	.nop,
//
//	.label("no jump"),
//	.b(0x2135d8),
//	.label("jump"),
//	.b(0x213560),
//	.nop,
//	.nop
//])
//
//
//let poisonTouchBranch = 0x225580
//let poisonTouchStart = 0xB9B1D8
//let RNG16Bit = 0x25ca08
//let animSoundCallback = 0x2236a8
////let checkHasHP = 0x204a70
////let checkAttackSuccess = 0xB9B300
//XGAssembly.replaceASM(startOffset: poisonTouchBranch - kDolToRAMOffsetDifference, newASM: [.b(poisonTouchStart)])
//XGAssembly.replaceRamASM(RAMOffset: poisonTouchStart, newASM: [
//
//	.cmpwi(.r26, 1), // check move succeeded
//	.bne_l("return"),
//
//	.bl(checkAttackSuccess),
//	.cmpwi(.r3, 1), // check wasn't prevented by status
//	.bne_l("return"),
//
//	.mr(.r3, .r31), // defending pokemon
//	.bl(checkHasHP),
//	.cmpwi(.r3, 1),
//	.bne_l("return"),
//
//	.cmpwi(.r25, 1), // contact check
//	.bne_l("return"),
//
//	.cmpwi(.r16, ability("poison touch").index),
//	.bne_l("return"),
//
//	// get random number
//	.bl(RNG16Bit),
//
//	// calculate random number % 10 (remainder)
//	// result is random number between 0 and 9
//	.li(.r4, 10),
//	.divw(.r0, .r3, .r4),
//	.mullw(.r0, .r0, .r4),
//	.sub(.r0, .r3, .r0),
//
//	// activate if random number less than 3 (30% chance)
//	.cmpwi(.r0, 2),
//	.bgt_l("return"),
//
//	// activate poison
//	.lwz(.r0, .r13, -0x44e8),
//	.ori(.r0, .r0, 0x2000),
//	.stw(.r0, .r13, -0x44e8),
//	.subi(.r5, .r13, 30816),
//	.li(.r4, 2), // poison secondary effect
//	.stb(.r4, .r5, 3),
//	.lis(.r3, 0x8041),
//	.addi(.r3, .r3, 31755),
//	.bl(animSoundCallback),
//	.li(.r17, 1),
//
//	.label("return"),
//	.mr(.r3, .r17),
//	.b(poisonTouchBranch + 4)
//])
//
//// rocky helmet, spiky shield fix
//let rockyHelmetFixBranch = 0xb99414
//let rockyHelmetFixStart = 0xB9B2A8
////let checkAttackSuccess = 0xB9B300
//XGAssembly.replaceRamASM(RAMOffset: rockyHelmetFixBranch, newASM: [.b(rockyHelmetFixStart)])
//XGAssembly.replaceRamASM(RAMOffset: rockyHelmetFixStart, newASM: [
//	.cmpwi(.r26, 1),
//	.bne_l("fail"),
//	.bl(checkAttackSuccess),
//	.cmpwi(.r3, 1),
//	.bne_l("fail"),
//
//	.mr(.r3, .r30), // attacking pokemon
//	.bl(checkHasHP),
//	.cmpwi(.r3, 1),
//	.bne_l("fail"),
//
//	.label("success"),
//	.b(rockyHelmetFixBranch + 0xc),
//	.label("fail"),
//	.b(rockyHelmetFixBranch + 8),
//
//])
//
//let hpCheckStart = 0xB9B27C
//let getPokemonPointer = 0x1efcac
//XGAssembly.replaceRamASM(RAMOffset: hpCheckStart, newASM: [
//	.stwu(.sp, .sp, -0x10),
//	.mflr(.r0),
//	.stw(.r0, .sp, 0x14),
//
//	.li(.r3, 17),
//	.li(.r4, 0),
//	.bl(getPokemonPointer),
//	.bl(checkHasHP),
//
//	.lwz(.r0, .sp, 0x14),
//	.mtlr(.r0),
//	.addi(.sp, .sp, 0x10),
//	.blr
//
//])
//// life orb fix
//let fixBranch = 0xb9a208
//let lifeOrbFixStart = 0xB9B2D4
//XGAssembly.replaceRamASM(RAMOffset: fixBranch, newASM: [
//	.b(lifeOrbFixStart)
//])
//XGAssembly.replaceRamASM(RAMOffset: lifeOrbFixStart, newASM: [
//	.cmpwi(.r26, 1),
//	.bne_l("fail"),
//	.bl(checkAttackSuccess),
//	.cmpwi(.r3, 1),
//	.bne_l("fail"),
//
//	.mr(.r3, .r30), // attacking pokemon
//	.bl(checkHasHP),
//	.cmpwi(.r3, 1),
//	.bne_l("fail"),
//
//	.label("success"),
//	.b(0xb9a20c),
//	.label("fail"),
//	.b(0xb9a28c),
//])

//// remove sticky hold on knock off
//XGAssembly.replaceRamASM(RAMOffset: 0x214f1c, newASM: [.b(0x214f48)])
//
//// shadow pokemon receive full exp instead of 80%
//XGAssembly.replaceRamASM(RAMOffset: 0x212eac, newASM: [
//	.mr(.r0, .r18),
//	.nop,
//	.nop
//])

//// scale experience based on level
//// defeating a higher level pokemon than the player's pokemon yields more exp
//// defeating a lower level pokemon yields less exp
//// makes it easier to stay on the level curve of the game
//let expBranch = 0x212df0
//let expStart = 0xB9B788
//let getLevel = 0x2037d0 // from main pointer (fainted pokemon)
//let getStatsLevel = 0x2037f4 // from stats pointer (recipient)
//// r30 fainted pokemon
//// r19 receiving pokemon
//// r15 usable
//// r18 experience
//XGAssembly.replaceRamASM(RAMOffset: expBranch, newASM: [.b(expStart), .mr(.r3, .r19),])
//XGAssembly.replaceRamASM(RAMOffset: expStart, newASM: [
//
//	.lwz(.r18, .sp, 0xc),
//
//	// get exp recipient level
//	.mr(.r3, .r19),
//	.bl(getStatsLevel),
//	.mr(.r15, .r3),
//
//	// get fainted pokemon level
//	.mr(.r3, .r30),
//	.bl(getLevel),
//
//	// create multiplier
//	// (2 x fainted level) ^ 3 (normally power 2.5 but too much stress in ASM plus 3x makes the multiplier more powerful)
//	// ------------------------
//	// (recipient level + fainted level) ^ 3 (same here)
//
//	.add(.r15, .r15, .r3), // recipient level + fainted level
//	.mulli(.r3, .r3, 2), // fainted level x 2
//	// watch out for integer overflow
//	// do each individual multiplication and division in pairs 3 times
//
//	.mullw(.r18, .r18, .r3), // exp x fainted
//	.divw(.r18, .r18, .r15), // exp / rec+faint
//
//	.mullw(.r18, .r18, .r3), // exp x fainted
//	.divw(.r18, .r18, .r15), // exp / rec+faint
//
//	.mullw(.r18, .r18, .r3), // exp x fainted
//	.divw(.r18, .r18, .r15), // exp / rec+faint
//
//	// if exp drops to 0 due to integer division then set it to 1
//	.cmpwi(.r18, 0),
//	.bne_f(0, 8),
//	.li(.r18, 1),
//
//	// return
//	.b(expBranch + 4)
//])

// Don't forget to update the custom script classes JSON to include the new class and functions before compiling scripts
//// Create custom class in scripting engine
//XGDolPatcher.zeroForeignStringTables()
//let freeSpacePointer = XGAssembly.ASMfreeSpacePointer()
//printg(freeSpacePointer.hexString())
//XGScriptClass.createCustomClass(withIndex: 34, atRAMOffset: freeSpacePointer, numberOfFunctions: 256)

//// Add ASM for functions for custom class
//// Make sure to add these after code above is run before adding the class functions
//// The first chunk of code will print out the offsets. Write them down somewhere for future use.
//let jumpTableRAMOffset = 0x80B99390
//let customClassReturnOffset: UInt32 = 0x80B99378
//
//// Add custom class functions for reading from z, r and l triggers
//for i in 0 ... 2 {
//	let freeSpacePointer2 = XGAssembly.ASMfreeSpacePointer()
//	let p1PadButtonPressMaskOffset: UInt32 = 0x80444b20
//	let buttonMask: UInt32 = UInt32(1 << (i + 4))
//
//	XGScriptClass.addASMFunctionToCustomClass(jumpTableRAMOffset: jumpTableRAMOffset, functionIndex: i, codeOffsetInRAM: freeSpacePointer2, code: [
//		XGASM.loadImmediateShifted32bit(register: .r3, value: p1PadButtonPressMaskOffset).0,
//		XGASM.loadImmediateShifted32bit(register: .r3, value: p1PadButtonPressMaskOffset).1,
//		.lha(.r3, .r3, 0),
//		.andi_(.r3, .r3, buttonMask),
//		.srawi(.r3, .r3, UInt32(i) + 4),
//		.stw(.r3, .r4, 4),
//		.li(.r3, 1),
//		.sth(.r3, .r4, 0),
//		XGASM.loadImmediateShifted32bit(register: .r4, value: customClassReturnOffset).0,
//		XGASM.loadImmediateShifted32bit(register: .r4, value: customClassReturnOffset).1,
//		.mr(.r0, .r4),
//		.mtctr(.r0),
//		.bctr
//	])
//}

////Auto add pov code to all scripts in XDS folder
//for file in  XGFolders.XDS.files where file.fileType == .xds {
//	var text = file.text
//	text = text.replacingOccurrences(of: "// Macro defintions\n", with: "// Macro defintions\ndefine #enablePOVFlag 983\n")
//	text = text.replacingOccurrences(of: "\nfunction @preprocess() {\n", with: "global enablePOV = NO\n\nfunction @preprocess() {\n\tenablePOV = getFlag(#enablePOVFlag)\n")
//	text = text.replacingOccurrences(of: "function @hero_main() {\n", with: """
//	function @hero_main() {
//
//	\tcameraXRotation = 0.0
//	\tcurrentCameraBounce = 0.0
//	\tcameraBounceRadius = 0.5
//	\tcameraBounceFramesPerCycle = 0
//	\tcameraBounceMINFramesPerCycle = 15.0
//	\tcameraHeight = 12.0
//	\tfieldOfView = 60
//	\tcameraXRotationPerFrameDegrees = 5.0
//	\tcameraRadius = 5 // how far away the camera should be so it isn't inside michael
//
//
//	""")
//
//	let cameraControlText = """
//	\n\nif (Controller.isZButtonPressed() = YES) {
//		enablePOV = enablePOV ^ YES
//		if (enablePOV = NO) {
//			Camera.reset()
//			setFlagToFalse(#enablePOVFlag)
//		}
//
//		if (enablePOV = YES) {
//			setFlagToTrue(#enablePOVFlag)
//		}
//	}
//
//	if (enablePOV = YES) {
//		position = #player.getPosition()
//		angle = #player.getRotation()
//		pi = 3.141592
//		angleRadians = -((((180 - angle) * 2) * pi) / 360.0)
//
//		cameraXRotationPerFrameRadians = ((cameraXRotationPerFrameDegrees * 2) * pi) / 360.0
//
//		playerSpeed = #player.getMovementSpeed()
//		isWalking = playerSpeed > 0.0
//
//		if (isWalking = YES) {
//			cameraBounceFramesPerCycle = cameraBounceMINFramesPerCycle / playerSpeed
//			if (cameraBounceFramesPerCycle > 0) {
//				currentCameraBounce = currentCameraBounce + (360.0 / cameraBounceFramesPerCycle)
//			}
//		}
//
//		if (isWalking = NO) {
//			currentCameraBounce = 0
//		}
//		if (currentCameraBounce > 360) {
//			currentCameraBounce = currentCameraBounce - 360
//		}
//
//		cameraBounceSinDisplacement = sin(currentCameraBounce)
//		currentCameraBounceAdjusted = cameraBounceRadius * cameraBounceSinDisplacement
//
//		if ((Controller.isRButtonPressed()) and (cameraXRotation <= (pi / 2))) {
//			cameraXRotation = cameraXRotation + cameraXRotationPerFrameRadians
//		}
//		if ((Controller.isLButtonPressed()) and (cameraXRotation >= -((pi / 2)))) {
//			cameraXRotation = cameraXRotation - cameraXRotationPerFrameRadians
//		}
//		//if (Controller.isZButtonPressed()) {  // maybe use a d-pad button here for resetting the camera
//		//   cameraXRotation = 0
//		//}
//
//		// Use trig to figure out how far away the camera should be from michael in the x and z axes
//		if (angle < 90) {
//			vx = cameraRadius * sin(angle)
//			vz = cameraRadius * cos(angle)
//			goto @angleEnd
//		}
//		if (angle < 180) {
//			vx = cameraRadius * sin((180 - angle))
//			vz = 0 - (cameraRadius * cos((180 - angle)))
//			goto @angleEnd
//		}
//		if (angle < 270) {
//			vx = 0 - (cameraRadius * sin((angle - 180)))
//			vz = 0 - (cameraRadius * cos((angle - 180)))
//			goto @angleEnd
//		}
//		vx = -(cameraRadius * sin((360 - angle)))
//		vz = cameraRadius * cos((360 - angle))
//		@angleEnd
//
//		Camera.function48()  // don't know what this does yet
//		Camera.setPosition2((getvx(position) + vx) ((getvy(position) + cameraHeight) + currentCameraBounceAdjusted) (getvz(position) + vz))
//		Camera.setRotationAboutAxesRadians(cameraXRotation angleRadians 0)
//		Camera.setFieldOfView(fieldOfView)
//	}
//
//	Player.processEvents()
//	yield(1)
//	""".replacingOccurrences(of: "\n", with: "\n    ")
//
//	text = text.replacingOccurrences(of:
//	"\n    Player.processEvents()\n    yield(1)", with: cameraControlText)
//
//	text = text.replacingOccurrences(of:
//		"\n    var_1.Player.processEvents()\n    yield(1)", with: cameraControlText.replacingOccurrences(of: "Player.processEvents()", with: "var_1.Player.processEvents()"))
//
//	text = text.replacingOccurrences(of:
//		"\n    var_2.Player.processEvents()\n    yield(1)", with: cameraControlText.replacingOccurrences(of: "Player.processEvents()", with: "var_1.Player.processEvents()"))
//
//	XGUtility.saveString(text, toFile: file)
//}

// free cam with c stick
//XGPatcher.disableCStickMovement()
//
//// Don't forget to update the custom script classes JSON to include the new class and functions before compiling scripts
//// Create custom class in scripting engine
//if let freeSpacePointer = XGAssembly.ASMfreeSpaceRAMPointer(),
//   let (_, jumpTableRAMOffset, customClassReturnOffset) = XGScriptClass.createCustomClass(withIndex: 34, atRAMOffset: freeSpacePointer, numberOfFunctions: 2) {
//
//	// Add custom class function for reading c stick inputs
//	let cstickXFunctionRAMOffset = 0x8010409c
//	let cstickYFunctionRAMOffset = 0x80104040
//	let functions = [cstickXFunctionRAMOffset, cstickYFunctionRAMOffset]
//	for i in 0 ... 1 {
//		let functionOffset = functions[i]
//		guard let freeSpacePointer2 = XGAssembly.ASMfreeSpaceRAMPointer() else {
//			continue
//		}
//
//		XGScriptClass.addASMFunctionToCustomClass(jumpTableRAMOffset: jumpTableRAMOffset, functionIndex: i, codeOffsetInRAM: freeSpacePointer2, code: [
//			.stwu(.sp, .sp, -8),
//			.stw(.r31, .sp, 4),
//			.mr(.r31, .r4),
//			.li(.r3, 1), // controller index
//			.li(.r4, 0), // not sure what this does
//			.bl(functionOffset),
//			.extsb(.r3, .r3),
//			.stw(.r3, .r31, 4),
//			.li(.r3, 1),
//			.sth(.r3, .r31, 0),
//			.lwz(.r31, .sp, 4),
//			.addi(.sp, .sp, 8),
//			XGASM.loadImmediateShifted32bit(register: .r4, value: customClassReturnOffset).0,
//			XGASM.loadImmediateShifted32bit(register: .r4, value: customClassReturnOffset).1,
//			.mr(.r0, .r4),
//			.mtctr(.r0),
//			.bctr
//		])
//	}
//}

//XGUtility.importFileToISO(.dol, save: false)
//XGUtility.importFileToISO(.fsys("M2_out"), encode: true, save: true, importFiles: nil)


// String ids for stat names used in pokemon summary screen
// in order to show which stats are affected by a pokemon's nature
// in the pokemon summary screen loop, every time the current pokemon is queried
// check its nature and based on that update the strings
// starting with msg id 0x3ada at offset 0x31c860 in start.dol
// Each subsequent stat msg id is stored 0x1c bytes after the previous one
// The string itself starts with a predefined colour special flag
// Make copies of each string with the colour set to red and blue using the custom colour special character
// e.g. [8]{FF0000FF} for hard red
// Then each loop overwrite those addresses so the msg id that gets used will match the current pokemon's nature
// Bonus, reset them when summary screen is closed

//// Use output from dolmatch program by mparisi to copy the symbols from one symbol map to a new symbol map for another dol
//
//// RAM Dumps which include the dol file
//let gxxj = XGFiles.nameAndFolder("GXXP01.raw", .Documents).data!
//let nxxj = XGFiles.nameAndFolder("NXXJ01.raw", .Documents).data!
//
//var matchMap = XGFiles.nameAndFolder("matches.txt", .Documents).text.split(separator: "\n")
//let nxMap = XGFiles.nameAndFolder("NXXJ01.map", .Documents).text.split(separator: "\n")
//let outFile = XGFiles.nameAndFolder("GXXP01.map", .Documents)
//var outText = ""
//var isInDataSection = false
//var lastDataMatchOffset = 0x0
//for line in nxMap {
//	if line.starts(with: ".rodata") {
//		isInDataSection = true
//	}
//
//	if !line.starts(with: " ") {
//		outText += "\n\n"
//	}
//
//	guard !line.starts(with: "  UNUSED") else {
//		continue
//	}
//	guard line.starts(with: "  0") else {
//		outText += line + "\n"
//		continue
//	}
//
//	var newLine = String(line).replacingOccurrences(of: "\t", with: " ")
//	let parts = line.replacingOccurrences(of: "    ", with: "  0 ").replacingOccurrences(of: "  ", with: " ").split(separator: " ").map { String($0) }
//	let symbolLength = ("0x" + parts[1]).integerValue ?? 0
//	let virtualAddress = parts[2]
//	let fileOffset = parts[3]
//	let alignment = parts[4]
//
//	guard alignment != "1",
//		  alignment != "0" else {
//		continue
//	}
//
//	let symbolName = parts[5]
//
//	for part in parts where part.contains("\\") {
//		if let finalPathComponent = part.split(separator: "\\").last {
//			newLine = newLine.replacingOccurrences(of: part, with: String(finalPathComponent))
//		}
//	}
//
//	if !isInDataSection {
//		if let matchLineIndex = matchMap.firstIndex(where: { matchLine in
//			let line = String(matchLine)
//			return line.contains(symbolName)
//		}) {
//			let matchLine = String(matchMap[matchLineIndex])
//			let matchParts = matchLine.split(separator: " ")
//			let matchReleaseAddress = String(matchParts[2])
//			newLine = newLine.replacingOccurrences(of: virtualAddress, with: matchReleaseAddress)
//			newLine = newLine.replacingOccurrences(of: fileOffset, with: "00000000")
//			outText += newLine + "\n"
//
//			matchMap.remove(at: matchLineIndex)
//		}
//	} else {
//		guard !symbolName.starts(with: "*"),
//			  !symbolName.starts(with: "."),
//			  symbolLength > 0 else {
//				  continue
//			  }
//
//		// Subtract 0x80000000 from the virtual address by removing leading digit
//		let nxRamOffset = ("0x" + virtualAddress.substring(from: 1, to: virtualAddress.length)).integerValue ?? 0
//		guard nxRamOffset > 0 else {
//			continue
//		}
//		let subData = nxxj.getSubDataFromOffset(nxRamOffset, length: symbolLength)
//		if !subData.isNull,
//		   let matchOffset = gxxj.search(for: subData, fromOffset: lastDataMatchOffset) {
//			lastDataMatchOffset = matchOffset + symbolLength
//			var matchOffsetString = matchOffset.hex()
//			while matchOffsetString.length < 7 {
//				matchOffsetString = "0" + matchOffsetString
//			}
//			matchOffsetString = "8" + matchOffsetString
//			newLine = newLine.replacingOccurrences(of: virtualAddress, with: matchOffsetString)
//			newLine = newLine.replacingOccurrences(of: fileOffset, with: "00000000")
//			outText += newLine + "\n"
//		}
//	}
//}
//outText.save(toFile: outFile)

// For the official symbols which had previously been named, append the modders determined name to the symbol name
// so we can still search for them using the pevious terms we used; especially since a lot of official names are broken english/japanese
// Any which aren't matched in the official map don't need to be added in as we can load the official map in dolphin after loading
// the previous map and then save the new combined map

//let officialMap = XGFiles.nameAndFolder("GXXE01.map", .Documents).text.split(separator: "\n")
//var moddersMap = XGFiles.nameAndFolder("modders.map", .Documents).text.split(separator: "\n").filter { str in
//	return !str.contains("zz_0") && !str.contains("?")
//}
//let outFile = XGFiles.nameAndFolder("GXXE01 combined.map", .Documents)
//var outText = ""
//
//for line in officialMap {
//	var outLine = String(line)
//
//	guard outLine.starts(with: "  0") else {
//		outText += outLine + "\n"
//		continue
//	}
//
//	let officialParts = outLine.split(separator: " ").map { String($0) }
//	let virtualAddress = officialParts[2]
//
//	if let matchLineIndex = moddersMap.firstIndex(where: { matchLine in
//		let line = String(matchLine)
//		return line.contains(virtualAddress)
//	}) {
//		let matchLine = String(moddersMap[matchLineIndex])
//		let matchParts = matchLine.split(separator: " ")
//		let matchModdersName = String(matchParts[4])
//		outLine = outLine + " (\(matchModdersName.replacingOccurrences(of: "zz_", with: "")))"
//
//		moddersMap.remove(at: matchLineIndex)
//	}
//
//	outText += outLine + "\n"
//}
//outText.save(toFile: outFile)
































































































//// xds script for pokespots to only load models that are available
//// prevents randomised versions from crashing
//
//var models = [Int]()
//for i in 0 ... 2 {
//
//	let spot = XGPokeSpots(rawValue: i)!
//	for index in 0 ..< spot.numberOfEntries {
//		let mon = XGPokeSpotPokemon(index: index, pokespot: spot)
//		let species = mon.pokemon.index
//		if species != 414 && species != 415 && species != 0 {
//			models.append(species)
//		}
//	}
//}
//
//var string = "global pokemonModels = ["
//for species in models.sorted() {
//	string += " \(species)"
//}
//string += " ]"
//printg(models.count)
//printg(string)



//// import nintendon't gci save to dolphin gci to import into mem card
//let to = XGFiles.nameAndFolder("GXXE.raw", .Resources).data
//let from = XGFiles.nameAndFolder("GXXE.gci", .Resources).data
//let toStart = 0xB2000
//let fromStart = 0x40
//let save = from.getByteStreamFromOffset(fromStart, length: 0x56000)
//to.replaceBytesFromOffset(toStart, withByteStream: save)
//to.save()

//// import dolphin gci save to nintendon't gci file
//let from = XGFiles.nameAndFolder("GXXE.raw", .Resources).data
//let to = XGFiles.nameAndFolder("GXXE.gci", .Resources).data
//let fromStart = 0xB2000
//let toStart = 0x40
//let save = from.getByteStreamFromOffset(fromStart, length: 0x56000)
//to.replaceBytesFromOffset(toStart, withByteStream: save)
//to.save()




//for m in XGMoves.allMoves().filter({ (m) -> Bool in
//	return (m.index < kNumberOfMoves - 1)
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



//for file in XGFolders.Rels.files where file.fileType == .rel {
//	let rel = file.mapData
//	print(file.fileName)
//	for chara in rel.characters {
//		print("id:", chara.characterID.hexString(), "model", chara.model.hexString(), (XGCharacterModel(rawValue: chara.model) ?? .none).name, "script:", chara.scriptIndex.hexString(), chara.scriptName)
//	}
//	print("")
//}




//XGUtility.importTextures()
//XGUtility.exportTextures()

//let bingotex = XGFiles.texture("uv_str_bingo_00.fdat")
//XGFiles.fsys("bingo_menu").fsysData.replaceFile(file: bingotex.compress())


// manually change shinyness using hex editor
//let shinyStart = 0x1fa930
//let getTrainerData = 0x1cefb4
//let trainerGetTID = 0x14e118
//print("shiny glitch")
//(shinyStart - kDolToRAMOffsetDifference + kDolToISOOffsetDifference).hexString().println()
//print("shiny glitch branch links")
////	0x38600000, // li r3, 0
////	0x38800002, // li r4, 2
//XGAssembly.createBranchAndLinkFrom(offset: shinyStart + 0x8, toOffset: getTrainerData).hexString().println()
//XGAssembly.createBranchAndLinkFrom(offset: shinyStart + 0xc, toOffset: trainerGetTID).hexString().println()
//
//
//
//print("shiny glitch")
//(0x1248a8 - kDolToRAMOffsetDifference + kDolToISOOffsetDifference).hexString().println()
//// 0x3B800000
//



