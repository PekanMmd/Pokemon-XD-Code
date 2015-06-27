//
//  XGResources.swift
//  XG Tool
//
//  Created by The Steez on 01/06/2015.
//  Copyright (c) 2015 Ovation International. All rights reserved.
//

import UIKit

enum XGResources {
	
	case JSON(String)
	case PNG(String)
	case FDAT(String)
	case BIN(String)
	case DOL
	case NameAndFileType(String, String)
	
	var path : String? {
		get{
			return NSBundle.mainBundle().pathForResource(name, ofType: fileType)
		}
	}
	
	var name : String {
		get {
			switch self {
				case .JSON(let name)							: return name
				case .PNG(let name)								: return name
				case .FDAT(let name)							: return name
				case .BIN(let name)								: return name
				case .DOL										: return "Start"
				case .NameAndFileType(let name, let fileType)	: return name
			}
		}
	}
	
	var fileType : String {
		get {
			switch self {
				case .JSON									: return ".json"
				case .PNG									: return ".png"
				case .FDAT									: return ".fdat"
				case .BIN									: return ".bin"
				case .DOL									: return ".dol"
				case .NameAndFileType(let _, let filetype)	: return filetype
			}
		}
	}
	
	var fileName : String {
		get {
			return name + fileType
		}
	}
	
	var fileSize : Int {
		get {
			return XGFiles.Resources(self).fileSize
		}
	}
	
	var data : XGMutableData {
		get {
			return XGFiles.Resources(self).data
		}
	}
	
	var json : AnyObject {
		get {
			return XGFiles.Resources(self).json
		}
	}
	
	var image : UIImage {
		get {
			return XGFiles.Resources(self).image
		}
	}
	
	var stringTable : XGStringTable {
		get {
			return XGFiles.Resources(self).stringTable
		}
	}
	
}



















