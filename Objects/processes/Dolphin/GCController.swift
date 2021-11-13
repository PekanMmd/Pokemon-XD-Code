//
//  GCController.swift
//  GoD Tool
//
//  Created by Stars Momodu on 30/09/2021.
//

import Foundation

#if !GAME_PBR
enum GameController: Int, Codable {
	case p1 = 1, p2, p3, p4

	var startOffset: Int {
		switch region {
		case .US:
			return 0x80444b20 + ((rawValue - 1) * 0x7c)
		case .EU:
			return -1
		case .JP:
			return -1
		case .OtherGame:
			return -1
		}
	}
}
enum ControllerButtons: Int, Codable {
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

struct ControllerStickInput: Codable {
	enum StickDirectionX: Int, Codable {
		case left, right, neutral
		var offsets: [Int] {
			switch self {
			case .left, .right: return [0]
			case .neutral: return [0, 1]
			}
		}
	}
	enum StickDirectionY: Int, Codable {
		case up, down, neutral
		var offsets: [Int] {
			switch self {
			case .up, .down: return [1]
			case .neutral: return [0, 1]
			}
		}
	}

	private(set) var directionX: StickDirectionX = .neutral
	private(set) var directionY: StickDirectionY = .neutral
	private(set) var percentageX: UInt = 0
	private(set) var percentageY: UInt = 0

	var rawValue: UInt16 {
		var result: UInt16 = 0
		let scaleX = min(percentageX, 100)
		let scaleY = min(percentageY, 100)
		if percentageX > 0  {
			switch directionX {
			case .left: result += UInt16(0x100 - ((scaleX * 0x80) / 100)) << 8
			case .right: result += UInt16((scaleX * 0x7F) / 100) << 8
			case .neutral: break
			}
		}

		if percentageY > 0  {
			switch directionY {
			case .up: result += UInt16(0x100 - ((scaleY * 0x80) / 100))
			case .down: result += UInt16((scaleY * 0x7F) / 100)
			case .neutral: break
			}
		}
		return result
	}

	func maskedWith(stick: ControllerStickInput) -> ControllerStickInput {
		var directionX = self.directionX
		var percentageX = self.percentageX
		if stick.directionX != self.directionX {
			percentageX = UInt(min( 100, max(0 ,abs(Int(self.percentageX) - Int(stick.percentageX)))))
			if percentageX == 0 {
				directionX = .neutral
			} else {
				directionX = self.percentageX > stick.percentageX ? self.directionX : stick.directionX
			}
		} else {
			percentageX = min(100, self.percentageX + stick.percentageX)
			if percentageX == 0 {
				directionX = .neutral
			}
		}

		var directionY = self.directionY
		var percentageY = self.percentageY
		if stick.directionY != self.directionY {
			percentageY = UInt(min( 100, max(0 ,abs(Int(self.percentageY) - Int(stick.percentageY)))))
			if percentageY == 0 {
				directionY = .neutral
			} else {
				directionY = self.percentageY > stick.percentageY ? self.directionY : stick.directionY
			}
		} else {
			percentageY = min(100, self.percentageY + stick.percentageY)
			if percentageX == 0 {
				directionX = .neutral
			}
		}

		return ControllerStickInput(directionX: directionX, directionY: directionY, percentageX: percentageX, percentageY: percentageY)
	}
}

extension ControllerStickInput {
	init(rawValue: UInt16) {
		func stickPercentage(_ value: Int) -> UInt {
			if value > 0 {
				return UInt(value * 100 / 127)
			} else if value < 0 {
				return UInt((-value) * 100 / 128)
			} else {
				return 0
			}
		}

		let x = Int(rawValue >> 8)
		let y = Int(rawValue & 0xFF)
		self.percentageX = stickPercentage(x)
		self.percentageY = stickPercentage(y)
		self.directionX = x < 0 ? .left : .right
		self.directionY = y < 0 ? .up : .down
	}
}

struct GCPad: Codable {
	var player: GameController = .p1
	var duration = settings.inputDuration

	var Start = false
	var A = false
	var B = false
	var X = false
	var Y = false
	var R = false
	var L = false
	var Z = false
	var Up = false
	var Down = false
	var Left = false
	var Right = false

	var stick  = ControllerStickInput()
	var cStick = ControllerStickInput()

	var tag: String?

	var rawData: XGMutableData {
		let data = XGMutableData(length: 12)
		var buttonMask = 0
		if A { buttonMask |= ControllerButtons.A.rawValue }
		if B { buttonMask |= ControllerButtons.B.rawValue }
		if X { buttonMask |= ControllerButtons.X.rawValue }
		if Y { buttonMask |= ControllerButtons.Y.rawValue }
		if R { buttonMask |= ControllerButtons.R.rawValue }
		if L { buttonMask |= ControllerButtons.L.rawValue }
		if Z { buttonMask |= ControllerButtons.Z.rawValue }
		if Up { buttonMask |= ControllerButtons.UP.rawValue }
		if Down { buttonMask |= ControllerButtons.DOWN.rawValue }
		if Left { buttonMask |= ControllerButtons.LEFT.rawValue }
		if Right { buttonMask |= ControllerButtons.RIGHT.rawValue }
		if Start { buttonMask |= ControllerButtons.START.rawValue }
		data.replace2BytesAtOffset(0, withBytes: buttonMask)

		data.replace2BytesAtOffset(2, withBytes: Int(stick.rawValue))
		data.replace2BytesAtOffset(4, withBytes: Int(cStick.rawValue))

		return data
	}

	func maskedWith(pad: GCPad) -> GCPad {
		var newPad = GCPad()

		newPad.A = self.A || pad.A
		newPad.B = self.B || pad.B
		newPad.X = self.X || pad.X
		newPad.Y = self.Y || pad.Y
		newPad.R = self.R || pad.R
		newPad.L = self.L || pad.L
		newPad.Z = self.Z || pad.Z
		newPad.Up = self.Up || pad.Up
		newPad.Down = self.Down || pad.Down
		newPad.Left = self.Left || pad.Left
		newPad.Right = self.Right || pad.Right
		newPad.Start = self.Start || pad.Start

		newPad.stick = self.stick.maskedWith(stick: pad.stick)
		newPad.cStick = self.cStick.maskedWith(stick: pad.cStick)
		newPad.tag = self.tag

		return newPad
	}

	func disableButtons(_ buttons: [ControllerButtons]) -> GCPad {
		var pad = self
		buttons.forEach { (button) in
			switch button {
			case .UP: pad.Up = false
			case .RIGHT: pad.Right = false
			case .DOWN: pad.Down = false
			case .LEFT: pad.Left = false
			case .Z: pad.Z = false
			case .R: pad.R = false
			case .L: pad.L = false
			case .A: pad.A = false
			case .B: pad.B = false
			case .X: pad.X = false
			case .Y: pad.Y = false
			case .START: pad.Start = false
			}
		}
		return pad
	}

	static func button(_ button: ControllerButtons, duration: Double = settings.inputDuration, player: GameController = .p1) -> GCPad {
		var pad = GCPad(player: player, duration: duration)
		switch button {
		case .UP: pad.Up = true
		case .RIGHT: pad.Right = true
		case .DOWN: pad.Down = true
		case .LEFT: pad.Left = true
		case .Z: pad.Z = true
		case .R: pad.R = true
		case .L: pad.L = true
		case .A: pad.A = true
		case .B: pad.B = true
		case .X: pad.X = true
		case .Y: pad.Y = true
		case .START: pad.Start = true
		}
		return pad
	}

	static func neutral(duration: Double, player: GameController = .p1) -> GCPad {
		return GCPad(player: player, duration: duration)
	}
}

extension GCPad {
	init(rawData: XGMutableData, player: GameController, tag: String? = nil) {
		self.player = player
		self.tag = tag
		let mask = rawData.get2BytesAtOffset(0)
		let stick = rawData.getHalfAtOffset(2)
		let cStick = rawData.getHalfAtOffset(4)

		self.Left    = mask & 0x1 > 0
		self.Right   = mask & 0x2 > 0
		self.Down    = mask & 0x4 > 0
		self.Up      = mask & 0x8 > 0
		self.Z       = mask & 0x10 > 0
		self.R       = mask & 0x20 > 0
		self.L       = mask & 0x40 > 0
		self.A       = mask & 0x100 > 0
		self.B       = mask & 0x200 > 0
		self.X       = mask & 0x400 > 0
		self.Y       = mask & 0x800 > 0
		self.Start   = mask & 0x1000 > 0

		self.stick = ControllerStickInput(rawValue: stick)
		self.cStick = ControllerStickInput(rawValue: cStick)
	}
}

class ControllerInputs {
	typealias GCPadInputSequence = [GCPad] // pads within a sequence are input serially
	private(set) var inputsSequences = SafeArray<GCPadInputSequence>() // all sequences are input concurrently
	// buttons currently pressed in game by player

	var nextInput: [GCPad] {
		var pads = [
			GCPad(player: .p1), GCPad(player: .p2), GCPad(player: .p3), GCPad(player: .p4),
			GCPad(player: .p1, tag: "write:origin"), GCPad(player: .p2, tag: "write:origin"), GCPad(player: .p3, tag: "write:origin"), GCPad(player: .p4, tag: "write:origin")
		]

		var hasWriteOrigin = false
		inputsSequences.perform(operation: { (inputSequences) in

			for sequence in inputSequences {
				if let next = sequence.first(where: { (pad) -> Bool in
					pad.duration > 0
				}) {
					var index = next.player.rawValue - 1
					if next.tag?.contains("write:origin") ?? false {
						index += 4
						hasWriteOrigin = true
					}
					pads[index] = pads[index].maskedWith(pad: next)
				}
			}
		})

		if !hasWriteOrigin {
			pads = Array(pads[0 ... 3])
		}

		return pads
	}

	func input(_ button: ControllerButtons, duration: Double = settings.inputDuration, player: GameController = .p1, tag: String? = nil) {
		input(buttons: [button], duration: duration, player: player)
	}

	func stickInput(_ stick: ControllerStickInput, duration: Double = settings.inputDuration, player: GameController = .p1, tag: String? = nil) {
		input(stick: stick, duration: duration, player: player)
	}

	func cStickInput(_ stick: ControllerStickInput, duration: Double = settings.inputDuration, player: GameController = .p1, tag: String? = nil) {
		input(cStick: stick, duration: duration, player: player)
	}

	func input(buttons: [ControllerButtons] = [], stick: ControllerStickInput? = nil, cStick: ControllerStickInput? = nil, duration: Double = settings.inputDuration, player: GameController = .p1, tag: String? = nil) {
		var pad = GCPad(player: player, duration: duration)
		for button in buttons {
			switch button {
			case .UP: pad.Up = true
			case .RIGHT: pad.Right = true
			case .DOWN: pad.Down = true
			case .LEFT: pad.Left = true
			case .Z: pad.Z = true
			case .R: pad.R = true
			case .L: pad.L = true
			case .A: pad.A = true
			case .B: pad.B = true
			case .X: pad.X = true
			case .Y: pad.Y = true
			case .START: pad.Start = true
			}
		}
		if let stick = stick {
			pad.stick = stick
		}
		if let cStick = cStick {
			pad.cStick = cStick
		}
		input(pad)
	}

	func input(_ pad: GCPad) {
		input([pad])
	}

	func input(_ sequence: GCPadInputSequence) {
		inputsSequences.append(sequence)
	}

	func delayPendingInput(duration: Double) {
		inputsSequences.perform { (inputSequences) -> [GCPadInputSequence] in
			var newSequences = [GCPadInputSequence]()
			for sequence in inputSequences {
				newSequences.append([GCPad(duration: duration)] + sequence)
			}
			return newSequences
		}
	}

	func clearPendingInput() {
		inputsSequences.removeAll()
	}

	func elapseTime(_ duration: Double) {
		var newSequences = [GCPadInputSequence]()

		inputsSequences.perform { (inputSequences) -> [GCPadInputSequence] in
			for sequence in inputSequences {
				var newSequence = GCPadInputSequence()
				var nextInputDecreased = false

				for pad in sequence {
					var updatedPad = pad
					if !nextInputDecreased, pad.duration > 0 {
						nextInputDecreased = true
						updatedPad.duration = max(0, pad.duration - duration)
					}
					newSequence.append(updatedPad)
				}

				if nextInputDecreased {
					newSequences.append(newSequence)
				}
			}

			return newSequences
		}

	}
}
#endif

