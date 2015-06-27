//
//  XGBattleBingoPanel.swift
//  XG Tool
//
//  Created by The Steez on 11/06/2015.
//  Copyright (c) 2015 Ovation International. All rights reserved.
//

import Foundation

enum XGBattleBingoPanel	{
	
	case MysteryPanel(XGBattleBingoItem)
	case Pokemon(XGBattleBingoPokemon)
	
}

enum XGBattleBingoItem : Int {
	
	case MasterBall = 0x1
	case EPx1		= 0x2
	case EPx2		= 0x3
	
}