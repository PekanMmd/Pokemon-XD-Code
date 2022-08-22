//
//  CMProcess.swift
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
		case .US: return 0x8009b3e8
		default:
			assertionFailure()
			return -1
		}
	}

	var OSReport: Int {
		switch region {
		case .US: return 0x8009c2e0
		default:
			assertionFailure()
			return -1
		}
	}

	var GSLog: Int {
		switch region {
		case .US: return 0x800ae9ac
		default:
			assertionFailure()
			return -1
		}
	}

	var inputCopyBranch: Int {
		switch region {
		case .US: return 0x800f837c
		default:
			assertionFailure()
			return -1
		}
	}

	var yield: Int {
		switch region {
		case .US: return 0x800f0308
		default:
			assertionFailure()
			return -1
		}
	}
}
