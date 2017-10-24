//
//  XGCharacterModels.swift
//  GoD Tool
//
//  Created by The Steez on 22/10/2017.
//
//

import Foundation

let kSizeOfCharacterModel = 0x34

let kCharacterModelFSYSIdentifier = 0x4 // corresponds to the id of the model's file in people_archive.fsys. This is the word at offset 0 of each of the file entry details in the fsys (also used to refer to the model in scripts)


class XGCharacterModels : NSObject {

	var index = 0
	var identifier = 0
	var name = ""
	var fsysIndex = -1
	
	var startOffset = 0
	
	var rawData : [Int] {
		return XGFiles.common_rel.data.getByteStreamFromOffset(self.startOffset, length: kSizeOfCharacterModel)
	}
	
	init(index: Int) {
		super.init()
		
		self.index = index
		self.startOffset = CommonIndexes.CharacterModels.startOffset + (self.index * kSizeOfCharacterModel)
		self.identifier = Int(XGFiles.common_rel.data.get4BytesAtOffset(self.startOffset + kCharacterModelFSYSIdentifier))
		
		let file = XGFiles.fsys("people_archive.fsys")
		if file.exists {
			let fsys = file.fsysData
			let fsysIndex = fsys.indexForIdentifier(identifier: self.identifier)
			if fsysIndex >= 0 {
				self.name = fsys.fileNames[fsysIndex]
				self.fsysIndex = fsysIndex
			}
		}
	}
	
}


//enum XGCharacterModels : Int {
//	
//	case none = 0x0
//	case mana_0000 = 0x1 // jovi
//	case mana_0100 = 0x2
//	case box1 = 0x3 // pokefood box (maybe tbox)
//	case t_box_00 = 0x4 // from citadark lava room. (maybe box1)
//	case snatchdan_0000 = 0x5
//	case snatchdan_0100 = 0x6
//	case rinto_0000 = 0x7 // no snag machine
//	case rinto_0100 = 0x8
//	case rinto_1000 = 0x9 // snag machine
//	case rinto_1100 = 0xa
//	case agent1_f_0000 = 0xb
//	case agent1_f_0100 = 0xc
//	case agent1_m_0000 = 0xd
//	case agent1_m_0100 = 0xe
//	case agent2_m_0000 = 0xf
//	case agent2_m_0100 = 0x10
//	case agent3_m_0000 = 0x11
//	case agent3_m_0100 = 0x12
//	case ardos_0000 = 0x13
//	case ardos_0100 = 0x14
//	case baba1_0000 = 0x15
//	case baba1_0100 = 0x16
//	case barten_0000 = 0x17
//	case bigboss_0000 = 0x18
//	case bigboss_0100 = 0x19
//	case bigboss_1000 = 0x1a
//	case bigboss_1100 = 0x1b
//	case boy_0000 = 0x1c
//	case caster_a_0000 = 0x1d
//	case caster_a_01000 = 0x1e
//	case dr_fad_0000 = 0x1f // kaminko
//	case dr_fad_0100 = 0x20
//	case eldes_0000 = 0x21
//	case eldes_0100 = 0x22
//	case gaderi_0000 = 0x23 // looks like gorigan was originally called gaderi but changed very late in development
//	case gaderi_0100 = 0x24
//	case gba_emr_f_0100 = 0x25
//	case gba_emr_m_0100 = 0x26
//	case gba_fl_f_0100 = 0x27
//	case gba_fl_m_0100 = 0x28
//	case gba_rs_f_0100 = 0x29
//	case gba_rs_m_0100 = 0x2a
//	case ginzaru_0000 = 0x2b
//	case ginzaru_0100 = 0x2c
//	case girl_0000 = 0x2d
//	case gonza_0000 = 0x2e
//	case gonza_0100 = 0x2f
//	case girl_1000 = 0x30
//	case girl_1100 = 0x31
//	case girl_2000 = 0x32
//	case gyma_m_0000 = 0x33
//	case gyma_m_1000 = 0x34 // vander (senety in jp)
//	case gyma_m_1100 = 0x35 // vander
//	case gyma_m_2000 = 0x36
//	case gyma_m_2100 = 0x37
//	case gyma_m_3000 = 0x38
//	case gyma_m_3100 = 0x39
//	case unused_3a = 0x3a // appears as snagem grunt
//	case unused_3b = 0x3b // appears as snagem grunt
//	case unused_3c = 0x3c // appears as snagem grunt
//	case unused_3d = 0x3d // appears as snagem grunt
//	case unused_3e = 0x3e // appears as snagem grunt
//	case unused_3f = 0x3f // appears as snagem grunt
//	case heboy_0000 = 0x40
//	case heboy_0100 = 0x41
//	case hexa_0000 = 0x42
//	case hexa_0100 = 0x43
//	case hexa_1000 = 0x44
//	case hexa_1100 = 0x45
//	case hexa_2000 = 0x46
//	case hexa_2100 = 0x47
//	case hexa_3000 = 0x48
//	case hexa_3100 = 0x49
//	case hexa_4000 = 0x4a
//	case hexa_4100 = 0x4b
//	case hexa_5000 = 0x4c
//	case hexa_5100 = 0x4d
//	case unused_4e = 0x4e // appears as snagem grunt
//	case unused_4f = 0x4f // appears as snagem grunt
//	case info = 0x50
//	case ippan_f_0000 = 0x51
//	case ippan_f_0100 = 0x52
//	case ippan_m_0000 = 0x53
//	case ippan_m_0100 = 0x54
//	case jiji1_0000 = 0x55
//	case jiji1_0100 = 0x56
//	case jiji2 = 0x57
//	case juggler_0000 = 0x58 // street performer
//	case juggler_0100 = 0x59
//	case klein_0000 = 0x5a
//	case klein_0100 = 0x5b
//	case kuro_0000 = 0x5c // bitt
//	case unused_5d = 0x5d // appears as snagem grunt
//	case layla_0000 = 0x5e
//	case layla_0100 = 0x5f
//	case lilya_0000 = 0x60
//	case lilya_0100 = 0x61
//	case logan_0000 = 0x62
//	case logan_0100 = 0x63
//	case mage_0000 = 0x64 // lovrina
//	case mage_0100 = 0x65
//	case master_0000 = 0x66
//	case unused_67 = 0x67 // appears as snagem grunt
//	case mcgroudon_0100 = 0x68
//	case mirrabo_0000 = 0x69
//	case mirrabo_0100 = 0x6a
//	case niku_f_0000 = 0x6b
//	case niku_f_0100 = 0x6c
//	case niku_m_0000 = 0x6d
//	case niku_m_0100 = 0x6e
//	case niku_m_1000 = 0x6f // battlus
//	case niku_m_1100 = 0x70
//	case obasan_0000 = 0x71
//	case obo_0000 = 0x72 // rich boy
//	case unused_73 = 0x73 // appears as snagem grunt
//	case ojisan1_0000 = 0x74 // casual guy
//	case ojisan1_0100 = 0x75
//	case ojisan2_0000 = 0x76
//	case ojo_0000 = 0x77
//	case unused_78 = 0x78 // appears as snagem grunt
//	case ojo_1000 = 0x79
//	case unused_7a = 0x7a
//	case pc_f_0000 = 0x7b
//	case pc_f_1000 = 0x7c
//	case ren_0000 = 0x7d // secc
//	case ren_0100 = 0x7e
//	case research_f_0000 = 0x7f
//	case research1_m_0000 = 0x80
//	case research2_m_0000 = 0x81
//	case research2_m_0100 = 0x82
//	case rider_m_0000 = 0x83
//	case unused_84 = 0x84 // appears as snagem grunt
//	case sailor1_0000 = 0x85 // smaller sailor
//	case sailor1_0100 = 0x86
//	case sailor2_0000 = 0x87 // bigger sailor
//	case sailor2_0100 = 0x88
//	case sailor3_0000 = 0x89
//	case sailor3_0100 = 0x8a
//	case seigi_0000 = 0x8b
//	case unused_8c = 0x8c // appears as snagem grunt
//	case unused_8d = 0x8d // appears as snagem grunt
//	case setsuma_0000 = 0x8e // beluh
//	case shiho_0000 = 0x8f // megg
//	case unused_90 = 0x90 // appears as snagem grunt
//	case shop_m = 0x91
//	case silver_0000 = 0x92
//	case unused_93 = 0x93 // appears as snagem grunt
//	case sled_0000 = 0x94 // nett
//	case unused_95 = 0x95 // appears as snagem grunt
//	case unused_96 = 0x96 // appears as snagem grunt
//	case unused_97 = 0x97 // appears as snagem grunt
//	case sport_m = 0x98
//	case unused_99 = 0x99 // appears as snagem grunt
//	case tessla_0000 = 0x9a // chobin
//	case tessla_0100 = 0x9b
//	case thief_f_0000 = 0x9c
//	case thief_f_0100 = 0x9d
//	case thief_m_1000 = 0x9e // rogue cail (could be thief_m_0000)
//	case toroy_0000 = 0x9f // trudly
//	case toroy_0100 = 0xa0
//	case trainer_f_0000 = 0xa1
//	case trainer_f_0100 = 0xa2
//	case trainer_m_0000 = 0xa3
//	case trainer_m_0100 = 0xa4
//	case tv_crew_0000 = 0xa5
//	case uranai_0000 = 0xa6
//	case unused_a7 = 0xa7 // appears as snagem grunt
//	case unused_a8 = 0xa8 // appears as snagem grunt
//	case wazzle_0000 = 0xa9 // snattle
//	case wazzle_0100 = 0xaa
//	case willy_0000 = 0xab
//	case willy_0100 = 0xac
//	case worker_0000 = 0xad
//	case worker_0100 = 0xae
//	case zack_0000 = 0xaf // perr
//	case unused_b0 = 0xb0 // appears as snagem grunt
//	case takara = 0xb1
//	case kirari = 0xb2
//	case crab = 0xb3 // krabby
//	case thief_f_1000 = 0xb4
//	case thief_f_1100 = 0xb5
//	case zaksuka = 0xb6 // zook
//	case zangoose = 0xb7
//	case magic_0000 = 0xb8 // razell (guessed their filenames are magic. needs testing)
//	case magic_1000 = 0xb9 // dazell
//	case kunugidama = 0xba // pineco
//	case kirlia = 0xbb // kirlia
//	case truck_1100 = 0xbc // could be truck. needs testing
//	case girl_2 = 0xbd // not sure which one
//	case hassboh = 0xbe // lotad
//	case ametama = 0xbf // surskit
//	case happinas = 0xc0 // blissey
//	case prasle = 0xc1
//	case minun = 0xc2
//	case nuoh = 0xc3 // quagsire
//	case koduck = 0xc4 // psyduck
//	case nazonokusa = 0xc5 // oddish
//	case coil = 0xc6 // magnemite
//	case guraena = 0xc7 // mightyena
//	case subame = 0xc8 // taillow
//	case pikachu = 0xc9
//	case wakasyamo = 0xca // combusken
//	case sonans = 0xcb // wobbuffet
//	case kakureon = 0xcc
//	case hunter_f = 0xcd
//	case rider_m = 0xce
//	case sheriff_as_0000 = 0xcf // johnson
//	case sheriff_0000 = 0xd0 // sherles
//	case enekororo = 0xd1 // delcatty
//	case sand = 0xd2 // sandshrew
//	case absol = 0xd3
//	case konohana = 0xd4 // nuzleaf
//	case hanecco = 0xd5 // hoppip
//	case ishitsubute = 0xd6 // geodude
//	case yomawaru = 0xd7 // duskull
//	case baba1_1000 = 0xd8 // not sure which one
//	case theif_m_1000 = 0xd9
//	case kinococo = 0xda // shroomish
//	case casey = 0xdb // abra
//	case yachino = 0xdc // wakin
//	case unused_dd = 0xdd // appears as snagem grunt
//	case kusaihana = 0xde // gloom
//	case runpappa = 0xdf // ludicolo
//	case marilli = 0xe0 // azumarill
//	case darklugia = 0xe1 // shadow lugia
//	case powalen = 0xe2 // castform
//	// seedot
//	// linoone
//	// emili
//	// mckyogre
//	// trapinch
//	// gligar
//	// invisible
//	// aron
//	// wooper
//	// krane
//	// zook
//	// verich
//	// zook
//	// michael w/o snag machine
//	// truck
//	case luxocruiser = 0xf3
//	// flat box 0xf4
//	
//	case chopper_0000 = 0xf9
//	// shadow lugia flying downwards
//	case chopper_0100 = 0xfb
//	// ss libra
//	// jigglypuff
//	// michael without snag machine
//	// little girl 0xff
//	case snatch_0100 = 0x100
//	// scooter
//	// mayor 0x102
//	
//	
//	
//	case usohachi = 0x112
//	case jiji1_2 = 0x114
//	
//	var name: String {
//		switch self {
//		case .mana_0000:
//			return "mana"
//		case .mana_0100:
//			return "mana bf"
//		case .box1:
//			return "pokefood box"
//			
//		case .dr_fad_0000:
//			return "Dr. Kaminko"
//			
//		case .gaderi_0000:
//			return "gorigan"
//			
//		case .gyma_m_1000:
//			return "vander"
//		case .gyma_m_1100:
//			return "vander"
//			
//		case .heboy_0000:
//			return "folly"
//		case .hexa_0000:
//			return "resix"
//		case .hexa_0100:
//			return "resix bf"
//		case .hexa_1000:
//			return "blusix"
//		case .hexa_1100:
//			return "blusix bf"
//		case .hexa_2000:
//			return "browsix"
//		case .hexa_2100:
//			return "browsix bf"
//		case .hexa_3000:
//			return "yellosix"
//		case .hexa_3100:
//			return "yellosix bf"
//		case .hexa_4000:
//			return "purpsix"
//		case .hexa_4100:
//			return "purpsix bf"
//		case .hexa_5000:
//			return "greesix"
//		case .hexa_5100:
//			return "greesix bf"
//			
//		case .ippan_f_0000:
//			return "beauty"
//		case .ippan_m_0000:
//			return "casual dude"
//		case .jiji1_0000:
//			return "fun old man"
//			
//		case .layla_0000:
//			return "marcia"
//			
//		case .master_0000:
//			return "outskirt stand owner"
//			
//		case .mirrabo_0000:
//			return "miror b"
//			
//		case .tessla_0000:
//			return "chobin"
//			
//		case .toroy_0000:
//			return "trudly"
//			
//		case .takara:
//			return "treasure chest"
//		case .kirari:
//			return "sparkle"
//			
//		case .sheriff_0000:
//			return "chief sherles"
//			
//		case .enekororo:
//			return "delcatty"
//			
//		case .hanecco:
//			return "hoppip"
//			
//		case .casey:
//			return "abra"
//			
//		case .kusaihana:
//			return "gloom"
//			
//		case .usohachi:
//			return "bonsly"
//			
//		case .snatch_0100:
//			return "snag machine"
//			
//		default:
//			return "-"
//		}
//	}
//	
//	var dataStart : Int {
//		return CommonIndexes.CharacterModels.startOffset + (self.rawValue * kSizeOfCharacterModel)
//	}
//	
//	var fsysIdentifier : Int {
//		return Int(XGFiles.common_rel.data.get4BytesAtOffset(dataStart + kCharacterModelFSYSIdentifier))
//	}
//	
//	var rawData : [Int] {
//		return XGFiles.common_rel.data.getByteStreamFromOffset(dataStart, length: kSizeOfCharacterModel)
//	}
//	
//}












