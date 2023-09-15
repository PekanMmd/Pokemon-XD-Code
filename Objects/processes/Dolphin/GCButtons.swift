//
//  GCButtons.swift
//  GoD Tool
//
//  Created by Stars Momodu on 08/03/2023.
//

import Foundation

enum ControllerButtons: Int, Codable {
	case NONE	 = 0x0
	case LEFT    = 0x1
	case RIGHT   = 0x2
	case DOWN    = 0x4
	case UP      = 0x8
	case Z       = 0x10
	case R       = 0x20
	case L       = 0x40
	case A       = 0x100
	case B       = 0x200
	case X       = 0x400
	case Y       = 0x800
	case START   = 0x1000
}
