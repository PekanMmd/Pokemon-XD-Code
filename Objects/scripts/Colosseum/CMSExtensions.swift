//
//  CMSExtensions.swift
//  GoD Tool
//
//  Created by Stars Momodu on 09/06/2021.
//

import Foundation

extension Array where Element == CMSExpr {
	private var indexOfLastAction: Int? {
		var index = count - 1
		while index >= 0 {
			if self[index].isFullStatement {
				return index
			} else {
				index -= 1
			}
		}
		return nil
	}

	var actionCount: Int {
		var count = 0

		for expr in self {
			if expr.isFullStatement {
				count += 1
			} else {
				continue
			}
		}

		return count
	}

	var lastAction: CMSExpr? {
		if let index = indexOfLastAction {
			return self[index]
		}
		return nil
	}

	mutating func removeLastAction() {
		if let index = indexOfLastAction {
			remove(at: index)
		}
	}
}
