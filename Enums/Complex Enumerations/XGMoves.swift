//
//  XGMoves.swift
//  XG Tool
//
//  Created by The Steez on 01/06/2015.
//  Copyright (c) 2015 Ovation International. All rights reserved.
//

import Foundation

let kFirstShadowMoveIndex	= 0x164
let kLastShadowMoveIndex	= 0x176

enum XGMoves {
	
	case Move(Int)
	
	var index : Int {
		get {
			switch self {
				case .Move(let i): return i
			}
		}
	}
	
	var startOffset : Int {
		get {
			return kFirstMoveOffset + (index * kSizeOfMoveData)
		}
	}
	
	var nameID : Int {
		get {
			return XGFiles.Common_rel.data.get2BytesAtOffset(startOffset + kMoveNameIDOffset)
		}
	}
	
	var name : XGString {
		get {
			return XGStringTable.common_rel().stringSafelyWithID(nameID)
		}
	}
	
	var descriptionID : Int {
		get {
			return XGFiles.Common_rel.data.get2BytesAtOffset(startOffset + kMoveDescriptionIDOffset)
		}
	}
	
	var description : XGString {
		get {
			return XGStringTable.dol().stringSafelyWithID(descriptionID)
		}
	}
	
	var type : XGMoveTypes {
		get {
			let index = XGFiles.Common_rel.data.getByteAtOffset(startOffset + kMoveTypeOffset)
			return XGMoveTypes(rawValue: index) ?? .Normal
		}
	}
	
	var category : XGMoveCategories {
		get {
			let index = XGFiles.Common_rel.data.getByteAtOffset(startOffset + kMoveCategoryOffset)
			return XGMoveCategories(rawValue: index) ?? .None
		}
	}
	
	var isShadowMove : Bool {
		get {
			return (self.index >= kFirstShadowMoveIndex) && (self.index <= kLastShadowMoveIndex)
		}
	}
	
}

enum XGOriginalMoves {
	
	case Move(Int)
	
	var index : Int {
		get {
			switch self {
			case .Move(let i): return i
			}
		}
	}
	
	var startOffset : Int {
		get {
			return XGMoves.Move(index).startOffset
		}
	}
	
	var nameID : Int {
		get {
			return XGResources.FDAT("common_rel").data.get2BytesAtOffset(startOffset + kMoveNameIDOffset)
		}
	}
	
	var name : XGString {
		get {
			var table = XGStringTable.common_relOriginal()
			return table.stringSafelyWithID(nameID)
		}
	}
	
	var type : XGMoveTypes {
		get {
			let index = XGResources.FDAT("common_rel").data.getByteAtOffset(startOffset + kMoveTypeOffset)
			return XGMoveTypes(rawValue: index) ?? .Normal
		}
	}
	
	var isShadowMove : Bool {
		get {
			return (self.index >= kFirstShadowMoveIndex) && (self.index <= kLastShadowMoveIndex)
		}
	}
	
}
































