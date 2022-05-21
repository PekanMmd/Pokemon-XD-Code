//
//  main.swift
//  XGCommandLineTools
//
//  Created by StarsMmd on 13/11/2015.
//  Copyright © 2015 StarsMmd. All rights reserved.
//
//

import Foundation

ToolProcess.loadISO(exitOnFailure: true)

DiscordPlaysOrre().launch()





//var roomsWithWarps = [Int]()
//var elevatorCount = 0
//for interactionPoint in XGInteractionPointData.allValues {
////			guard interactionPoint.room?.map != .PokemonHQ,
////				  guard interactionPoint.room?.name != "worldmap" else {
////				continue
////			}
//
//			let info = interactionPoint.info
//
//			switch info {
//			case .Warp:
//				roomsWithWarps.addUnique(interactionPoint.roomID)
//			case .Elevator:
//				elevatorCount += 1
//			case .CutsceneWarp:
//				roomsWithWarps.addUnique(interactionPoint.roomID)
//			default:
//				break
//			}
//}

