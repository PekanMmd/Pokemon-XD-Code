//
//  PBRTMs.swift
//  Revolution Tool CL
//
//  Created by The Steez on 28/12/2018.
//

import Foundation

enum XGTMs: XGIndexedValue {
	case tm(Int)
	case tutor(Int)
	
	var index : Int {
		switch self {
		case .tm(let i): return i
		default:
			assertionFailure("Only for XD compatibility")
			return -1
		}
	}
	
	var move : XGMoves {
		return .index(GoDDataTableEntry.TMs(index: index - 1).getShort(0))
	}

	var category: Int {
		return GoDDataTableEntry.TMs(index: index - 1).getByte(2)
	}

	var isHM: Bool {
		return index > kNumberOfTMs
	}

	func replaceWithMove(_ move: XGMoves) {
		let tableEntry = GoDDataTableEntry.TMs(index: index - 1)
		tableEntry.setShort(0, to: move.index)
		tableEntry.save()
	}

	static var allTMs: [XGTMs] {
		(1 ... kNumberOfTMs).map { (index) -> XGTMs in
			.tm(index)
		}
	}
	
	static var allTMsAndHNs: [XGTMs] {
		(1 ... kNumberOfTMsAndHMs).map { (index) -> XGTMs in
			.tm(index)
		}
	}
}

extension XGTMs: XGEnumerable {
	var enumerableName: String {
		let prefix = isHM ? "HM" : "TM"
		let index = isHM ? self.index - 92 : self.index
		return String(format: "\(prefix)%02d", index)
	}

	var enumerableValue: String? {
		return move.name.unformattedString
	}

	static var className: String {
		return "TMs"
	}

	static var allValues: [XGTMs] {
		return allTMs
	}
}










