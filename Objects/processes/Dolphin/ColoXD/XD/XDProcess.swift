//
//  XDProcess.swift
//  GoD Tool
//
//  Created by Stars Momodu on 10/11/2021.
//

import Foundation

extension XDProcess {

	// An optional location which gets called after the health and safety screen.
	// This should give the game an early opportunity to clear the instruction
	// cache without relying on hitting a breakpoint first.
	var cacheClearInitialInjectionPoint: Int? {
		switch region {
		case .US: return nil
		default:
			return nil
		}
	}

	var ICFlashInvalidate: Int {
		switch region {
		case .US: return 0x800aad88
		default:
			assertionFailure()
			return -1
		}
	}

	var OSReport: Int {
		switch region {
		case .US: return 0x800abc80
		default:
			assertionFailure()
			return -1
		}
	}

	var GSLog: Int {
		switch region {
		case .US: return 0x802a65cc
		default:
			assertionFailure()
			return -1
		}
	}

	var inputCopyBranch: Int {
		switch region {
		case .US: return 0x80104a30
		default:
			assertionFailure()
			return -1
		}
	}

	var yield: Int {
		switch region {
		case .US: return 0x801034e8
		default:
			assertionFailure()
			return -1
		}
	}

	// MARK: - Context
	func getBooleanFlag(_ flag: XDSFlags) -> Bool {
		return getBooleanFlag(flag.rawValue)
	}

	func getBooleanFlag(_ id: Int) -> Bool {
		return getFlag(id) == 1
	}

	func getFlag(_ flag: XDSFlags) -> Int? {
		return getFlag(flag.rawValue)
	}

	func getFlag(_ id: Int) -> Int? {
		// Based on Ghidra decomp
		guard id < CommonIndexes.NumberOfGeneralFlags.value else { return nil }

		let flagsStart = CommonIndexes.GeneralFlags.startOffset + kRELtoRAMOffsetDifference
		let metaDataStart = CommonIndexes.FlagsMetaData.startOffset + kRELtoRAMOffsetDifference
		let flagOffset = flagsStart + (id * 6)
		guard let unknown1 = read2Bytes(atAddress: flagOffset + 2),
			  let unknown4o = readByte(atAddress: flagOffset) else {
			return nil
		}
		let unknown4 = unknown4o & 0x3f
		let unknown3 = unknown1 >> 5
		let unknown5 = unknown1 & 0x1f

		guard let unknownAddress = read4Bytes(atAddress: metaDataStart + (unknown4o >> 3 & 0x18) + 4),
			  unknownAddress > 0 else {
			return nil
		}

		if unknown4 < 2 {
			guard let unknownBaseValue = read4Bytes(atAddress: unknownAddress + (unknown3 * 4)) else { return nil }
			return (unknownBaseValue >> unknown5) & 1
		} else {
			let offset = unknown3 * 4
			guard let unknownA = read4Bytes(atAddress: unknownAddress + offset + 4),
				  let unknownB = read4Bytes(atAddress: unknownAddress + offset),
				  let unknownC = read4Bytes(atAddress: 0x8040b4a0 + (unknown4 * 4)) else { return nil }

			return ((unknownA << (0x20 - unknown5)) | (unknownB >> unknown5))
				& unknownC
		}
	}

}
