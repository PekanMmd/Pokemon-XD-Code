//
//  XGPokeSpots.swift
//  XG Tool
//
//  Created by The Steez on 08/06/2015.
//  Copyright (c) 2015 Ovation International. All rights reserved.
//

import Foundation

enum XGPokeSpots : Int, XGDictionaryRepresentable {
	
	case rock		= 0x00
	case oasis		= 0x01
	case cave		= 0x02
	case all		= 0x03
	
	var string : String {
		get {
			switch self {
				case .rock	: return "Rock"
				case .oasis	: return "Oasis"
				case .cave	: return "Cave"
				case .all	: return "All"
			}
		}
	}
	
	var dictionaryRepresentation: [String : AnyObject] {
		get {
			return ["Value" : self.rawValue as AnyObject]
		}
	}
	
	var readableDictionaryRepresentation: [String : AnyObject] {
		get {
			return ["Value" : self.string as AnyObject]
		}
	}
	
	func numberOfEntries() -> Int {
		let rel = XGFiles.common_rel.data
		return Int(rel.get4BytesAtOffset(0xa7fa8 + (self.rawValue * 0xC)))
	}
	
	func setEntries(entries: UInt32) {
		let rel = XGFiles.common_rel.data
		let locationOffset = 0xa7fa8 + (self.rawValue * 0xC)
		rel.replace4BytesAtOffset(locationOffset, withBytes: entries)
		rel.save()
	}
	
	func dataTableStartOffset() -> Int {
		let rel = XGFiles.common_rel.data
		return Int(rel.get4BytesAtOffset( 0xa8194 + (self.rawValue * 0x30) )) + kRELDataStartOffset
	}
	
	func relocatePokespotData(toOffset offset: UInt32) {
		
		let rel = XGFiles.common_rel.data
		let locationOffset  = 0xa8194 + (self.rawValue * 0x30)
		let locationOffset2 = 0xa89cc + (self.rawValue * 0x10)
		let newOffset = offset - UInt32(kRELDataStartOffset)
		
		rel.replace4BytesAtOffset(locationOffset, withBytes: newOffset)
		rel.replace4BytesAtOffset(locationOffset + 8, withBytes: newOffset)
		rel.replace4BytesAtOffset(locationOffset2, withBytes: newOffset)
		rel.save()
		
	}
}





















