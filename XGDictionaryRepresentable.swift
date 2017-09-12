//
//  XGDictionaryRepresentable.swift
//  XGCommandLineTools
//
//  Created by StarsMmd on 29/08/2016.
//  Copyright © 2016 StarsMmd. All rights reserved.
//

import Foundation

protocol XGDictionaryRepresentable {
	
	var dictionaryRepresentation		 : [String : AnyObject] { get }
	var readableDictionaryRepresentation : [String : AnyObject] { get }
	
}
