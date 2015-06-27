//
//  XGPokemon.swift
//  XG Tool
//
//  Created by The Steez on 01/06/2015.
//  Copyright (c) 2015 Ovation International. All rights reserved.
//

import Foundation

enum XGItems {
	
	case Item(Int)
	
	var index : Int {
		get {
			switch self {
				case .Item(let i): return i
			}
		}
	}
	
	var startOffset : Int {
		get{
			return kFirstItemOffset + (index * kSizeOfItemData)
		}
	}
	
	var nameID : Int {
		get {
			var data  = XGFiles.Common_rel.data
			return data.get2BytesAtOffset(startOffset + kItemNameIDOffset)
		}
	}
	
	var descriptionID : Int {
		get {
			var data  = XGFiles.Common_rel.data
			return data.get2BytesAtOffset(startOffset + kItemDescriptionIDOffset)
		}
	}
	
	var name : XGString {
		get {
			var table = XGStringTable.common_rel()
			return table.stringSafelyWithID(nameID)
		}
	}
	
	var descriptionString : XGString {
		get {
			var table = XGFiles.StringTable("pocket_menu.fdat").stringTable
			return table.stringSafelyWithID(descriptionID)
		}
	}
	
}

enum XGOriginalItems {
	
	case Item(Int)
	
	var index : Int {
		get {
			switch self {
			case .Item(let i): return i
			}
		}
	}
	
	var startOffset : Int {
		get{
			return kFirstItemOffset + (index * kSizeOfItemData)
		}
	}
	
	var nameID : Int {
		get {
			var data  = XGResources.FDAT("common_rel").data
			return data.get2BytesAtOffset(startOffset + kItemNameIDOffset)
		}
	}
	
	var name : XGString {
		get {
			var table = XGStringTable.common_relOriginal()
			return table.stringSafelyWithID(nameID)
		}
	}
	
}











