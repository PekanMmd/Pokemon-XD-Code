//
//  XGDictionaryRepresentable.swift
//  XGCommandLineTools
//
//  Created by The Steez on 29/08/2016.
//  Copyright © 2016 Ovation International. All rights reserved.
//

import Foundation

protocol XGDictionaryRepresentable {
	
	var dictionaryRepresentation		 : [String : AnyObject] { get }
	var readableDictionaryRepresentation : [String : AnyObject] { get }
	
}