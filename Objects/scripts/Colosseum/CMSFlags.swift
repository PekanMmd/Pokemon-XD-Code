//
//  CMSFlags.swift
//  GoD Tool
//
//  Created by Stars Momodu on 08/06/2021.
//

import Foundation

enum XDSFlags: Int, Codable, CaseIterable {

	case none = 0



	var name : String {
		switch self {
		case .none						: return "NONE"
		}
	}
}
