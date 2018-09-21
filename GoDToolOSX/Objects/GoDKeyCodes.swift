//
//  GoDKeyCodes.swift
//  GoDToolCL
//
//  Created by The Steez on 03/09/2018.
//

import Foundation

enum KeyCodeName: UInt16 {
	case W		= 13
	case A		= 0
	case S		= 1
	case D		= 2
	case i		= 34
	case enter	= 36
	case space  = 49
	case one	= 18
	case two	= 19
	case three	= 20
	case four	= 21
	case five	= 23
	case six	= 22
	case seven	= 26
	case eight	= 28
	case nine	= 25
	case zero	= 29
	case plus	= 24
	case minus	= 27
	case up		= 126
	case down	= 125
	case left	= 123
	case right	= 124
	case tab	= 48
	case delete	= 51
	case lessthan = 43
	case morethan = 47
	
	static var allKeys : [KeyCodeName] {
		var keys = [KeyCodeName]()
		for i : UInt16 in 0 ... 255 {
			if let key = KeyCodeName(rawValue: i) {
				keys.append(key)
			}
		}
		return keys
	}
	
	static var dictionaryOfKeys : [KeyCodeName: Bool] {
		var keys = [KeyCodeName: Bool]()
		
		for key in allKeys {
			keys[key] = false
		}
		
		return keys
	}
}
