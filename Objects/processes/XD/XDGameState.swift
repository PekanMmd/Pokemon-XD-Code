//
//  XDGameState.swift
//  GoD Tool
//
//  Created by Stars Momodu on 29/09/2021.
//

import Foundation

var kCurrentBattleIDRAMOffset: Int {
	switch region {
	case .US: return 0x804EB910
	default: return -1
	}
}
var kCurrentRoomIDRAMOffset: Int {
	switch region {
	case .US: return 0x80814ab6
	default: return -1
	}
}
var kPlayerCoordinatesRAMOffset: Int {
	switch region {
	case .US: return 0x0
	default: return -1
	}
}
var kPlayerMovementSpeedRAMOffset: Int {
	switch region {
	case .US: return 0x0
	default: return -1
	}
}

class XDGameState: Codable {
	let battle: XGBattle?
	let currentRoom: XGRoom?

	init?(process: XDProcess) {
		guard region == .US else { return nil }

		let battleID = process.read2Bytes(atAddress: kCurrentBattleIDRAMOffset) ?? 0
		if battleID > 0, battleID < CommonIndexes.NumberOfBattles.value {
			battle = XGBattle(index: battleID)
		} else { battle = nil }

		let currentRoomID = process.read2Bytes(atAddress: kCurrentRoomIDRAMOffset) ?? 0
		currentRoom = currentRoomID > 0 ? XGRoom.roomWithID(currentRoomID) : nil
	}

	func write(process: XDProcess) {
		if let battle = self.battle {
			let battleStart = CommonIndexes.Battles.startOffset + (battle.index * kSizeOfBattleData) + kRELtoRAMOffsetDifference
			if let battleData = process.read(atAddress: battleStart, length: kSizeOfBattleData) {

				battleData.replaceByteAtOffset(kBattleBattleTypeOffset, withByte: battle.battleType.rawValue)
				battleData.replaceByteAtOffset(kBattleTrainersPerSideOffset, withByte: battle.trainersPerSide)
				battleData.replaceByteAtOffset(kBattlePokemonPerPlayerOffset, withByte: battle.pokemonPerPlayer)
				battleData.replaceByteAtOffset(kBattleStyleOffset, withByte: battle.battleStyle.rawValue)
				battleData.replaceByteAtOffset(kBattleColosseumRoundOffset, withByte: battle.round.rawValue)
				battleData.replaceByteAtOffset(kBattleUnknown1Offset, withByte: battle.unknown ? 1 : 0)
				battleData.replaceByteAtOffset(kBattleUnknown2Offset, withByte: battle.unknown2)

				battleData.replace2BytesAtOffset(kBattleFieldOffset, withBytes: battle.battleField.index)
				battleData.replace2BytesAtOffset(kBattleBGMOffset, withBytes: battle.BGMusicID)

				battleData.replace2BytesAtOffset(kBattlePlayer1DeckIDOffset, withBytes: (battle.p1Deck ?? .DeckDarkPokemon).id)
				battleData.replace2BytesAtOffset(kBattlePlayer1TrainerIDOffset, withBytes: battle.p1TID)
				battleData.replaceByteAtOffset(kBattlePlayer1ControlOffset, withByte: battle.p1Controller.rawValue)

				battleData.replace2BytesAtOffset(kBattlePlayer2DeckIDOffset, withBytes: (battle.p2Deck ?? .DeckDarkPokemon).id)
				battleData.replace2BytesAtOffset(kBattlePlayer2TrainerIDOffset, withBytes: battle.p2TID)
				battleData.replaceByteAtOffset(kBattlePlayer2ControlOffset, withByte: battle.p2Controller.rawValue)

				battleData.replace2BytesAtOffset(kBattlePlayer3DeckIDOffset, withBytes: (battle.p3Deck ?? .DeckDarkPokemon).id)
				battleData.replace2BytesAtOffset(kBattlePlayer3TrainerIDOffset, withBytes: battle.p3TID)
				battleData.replaceByteAtOffset(kBattlePlayer3ControlOffset, withByte: battle.p3Controller.rawValue)

				battleData.replace2BytesAtOffset(kBattlePlayer4DeckIDOffset, withBytes: (battle.p4Deck ?? .DeckDarkPokemon).id)
				battleData.replace2BytesAtOffset(kBattlePlayer4TrainerIDOffset, withBytes: battle.p4TID)
				battleData.replaceByteAtOffset(kBattlePlayer4ControlOffset, withByte: battle.p4Controller.rawValue)
				process.write(battleData, atAddress: battleStart)
			}
		}

	}
}

extension XDGameState: Equatable {
	static func == (lhs: XDGameState, rhs: XDGameState) -> Bool {
		guard let lj = try? lhs.JSONRepresentation(),
			  let rj = try? rhs.JSONRepresentation()
		else {
			return false
		}
		return lj.rawBytes == rj.rawBytes
	}
}
