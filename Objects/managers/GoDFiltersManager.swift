//
//  GoDFiltersManager.swift
//  GoD Tool
//
//  Created by Stars Momodu on 17/08/2021.
//

import Foundation

class GoDFiltersManager {
	enum Filters: String, CustomStringConvertible, CaseIterable {
		case none = "None"
		case shiftRedMinor = "Minor Red Shift"
		case redScale = "Red Scale"
		case primaryShift = "Primary Shift"
		case reversePrimaryShift = "Reverse Primary Shift"

		var description: String {
			return rawValue
		}

		func apply(to image: XGImage) {
			image.pixels.forEach { self.apply(to: $0) }
		}

		func apply(to colour: XGColour) {
			switch self {
			case .none:
				break
			case .shiftRedMinor:
				GoDFiltersManager.shiftRed(pixel: colour, threshold: 20)
			case .redScale:
				GoDFiltersManager.redScale(pixel: colour)
			case .primaryShift:
				GoDFiltersManager.primaryShift(pixel: colour)
			case .reversePrimaryShift:
				GoDFiltersManager.reversePrimaryShift(pixel: colour)
			}
		}
	}

	private static func cap(_ value: Int) -> Int {
		return max(0, min(255, value))
	}

	static func shiftRed(pixel: XGColour, threshold: Int) {
		pixel.red += cap(threshold)
		pixel.green -= cap(threshold / 2)
		pixel.blue -= cap(threshold / 2)
	}

	static func redScale(pixel: XGColour) {
		let ranks = [pixel.red, pixel.green, pixel.blue].sorted()
		let lowerAverage = (ranks[0] + ranks[1]) / 2
		pixel.red = ranks[2]
		pixel.green = cap(lowerAverage)
		pixel.blue = cap(lowerAverage)
	}

	static func primaryShift(pixel: XGColour) {
		let r = pixel.red
		let g = pixel.green
		let b = pixel.blue
		pixel.red = g
		pixel.green = b
		pixel.blue = r
	}

	static func reversePrimaryShift(pixel: XGColour) {
		let r = pixel.red
		let g = pixel.green
		let b = pixel.blue
		pixel.red = b
		pixel.green = r
		pixel.blue = g
	}

//	static func shiftGreen(pixel: XGColour, threshold: Int) -> XGColour {
//		var newPixel = pixel
//		newPixel.green += threshold / 5
//		return newPixel
//	}
//
//	static func shiftBlue(pixel: XGColour, threshold: Int) -> XGColour {
//		var newPixel = pixel
//		newPixel.blue += threshold / 5
//		return newPixel
//	}
//
//	static func shiftYellow(pixel: XGColour, threshold: Int) -> XGColour {
//		var newPixel = pixel
//		newPixel.red += threshold / 5
//		newPixel.green += threshold / 5
//		return newPixel
//	}
//
//	static func shiftMagenta(pixel: XGColour, threshold: Int) -> XGColour {
//		var newPixel = pixel
//		newPixel.red += threshold / 5
//		newPixel.blue += threshold / 5
//		return newPixel
//	}
//
//	static func shiftCyan(pixel: XGColour, threshold: Int) -> XGColour {
//		var newPixel = pixel
//		newPixel.green += threshold / 5
//		newPixel.blue += threshold / 5
//		return newPixel
//	}
//
//	static func shiftBrightness(pixel: XGColour, threshold: Int) -> XGColour {
//		var newPixel = pixel
//		newPixel.red += threshold / 5
//		newPixel.green += threshold / 5
//		newPixel.blue += threshold / 5
//		return newPixel
//	}
//
//	static func shiftDarkness(pixel: XGColour, threshold: Int) -> XGColour {
//		var newPixel = pixel
//		newPixel.red -= threshold / 5
//		newPixel.green -= threshold / 5
//		newPixel.blue -= threshold / 5
//		return newPixel
//	}
//
//	func recolourGreyScale(pixel: Pixel) -> [Pixel] {
//		var newPixel = pixel
//
//		let colour = pixel.colour
//		let average = (colour.red + colour.blue + colour.green) / 3
//
//		newPixel.colour = (average, average, average, colour.alpha)
//
//		return [newPixel]
//	}
//
//	func recolourRedScale(pixel: Pixel) -> [Pixel] {
//		var newPixel = pixel
//		let colour = pixel.colour
//		let average = (colour.red + colour.blue + colour.green) / 3
//		newPixel.colour.red = average
//		newPixel.colour.green = 0
//		newPixel.colour.blue = 0
//		return [newPixel]
//	}
//
//	func recolourGreenScale(pixel: Pixel) -> [Pixel] {
//		var newPixel = pixel
//		let colour = pixel.colour
//		let average = (colour.red + colour.blue + colour.green) / 3
//		newPixel.colour.red = 0
//		newPixel.colour.green = average
//		newPixel.colour.blue = 0
//		return [newPixel]
//	}
//
//	func recolourBlueScale(pixel: Pixel) -> [Pixel] {
//		var newPixel = pixel
//		let colour = pixel.colour
//		let average = (colour.red + colour.blue + colour.green) / 3
//		newPixel.colour.red = 0
//		newPixel.colour.green = 0
//		newPixel.colour.blue = average
//		return [newPixel]
//	}
//
//	func recolourPrimaryShift(pixel: Pixel) -> [Pixel] {
//		var newPixel = pixel
//
//		let oldColour = pixel.colour
//		newPixel.colour.red = oldColour.green
//		newPixel.colour.green = oldColour.blue
//		newPixel.colour.blue = oldColour.red
//
//		return [newPixel]
//	}
//
//	func recolourReversePrimaryShift(pixel: Pixel) -> [Pixel] {
//		var newPixel = pixel
//
//		let oldColour = pixel.colour
//		newPixel.colour.red = oldColour.blue
//		newPixel.colour.green = oldColour.red
//		newPixel.colour.blue = oldColour.green
//
//		return [newPixel]
//	}
//
//	func invertColour(_ colour: Colour) -> Colour {
//		return (255 - colour.red, 255 - colour.green, 255 - colour.blue, colour.alpha)
//	}
//
//	func recolourInverse(pixel: Pixel) -> [Pixel] {
//		var newPixel = pixel
//
//		newPixel.colour = invertColour(pixel.colour)
//
//		return [newPixel]
//	}
//
//	/***********************************************\
//	 ***** Intermediate *****
//	\***********************************************/
//	func recolourSepia(pixel: Pixel) -> [Pixel] {
//		var newPixel = pixel
//		let grey = recolourGreyScale(pixel: pixel)[0].colour
//		newPixel.colour = (grey.red * 13 / 10, grey.green * 11 / 10, grey.blue * 9 / 10, pixel.colour.alpha)
//
//		return [newPixel]
//	}
//
//	func recolour50ShadesOfGrey(pixel: Pixel) -> [Pixel] {
//		var newPixel = pixel
//
//		let colour = pixel.colour
//		var average = (colour.red + colour.blue + colour.green) / 3
//		average /= 5
//		average *= 5
//
//		newPixel.colour = (average, average, average, colour.alpha)
//
//		return [newPixel]
//	}
//
//	func intensity(colour c: Colour) -> Int {
//		return (c.red + c.green + c.blue) / 3
//	}
//
//	func recolourContrast(pixel: Pixel) -> [Pixel] {
//		var newPixel = pixel
//
//		let isIntense = intensity(colour: pixel.colour) > 127
//		let colourMultiplier = 1 + (isIntense ? (threshold.float / 255) : -(threshold.float / 255))
//
//		let red = (pixel.colour.red.float * colourMultiplier).int
//		let green = (pixel.colour.green.float * colourMultiplier).int
//		let blue = (pixel.colour.blue.float * colourMultiplier).int
//
//		newPixel.colour = (red, green, blue, pixel.colour.alpha)
//
//		return [newPixel]
//	}
//
//	func recolourColourContrast(pixel: Pixel) -> [Pixel] {
//		var newPixel = pixel
//		var colour = pixel.colour
//		let shiftAmount = threshold / 10
//
//		colour.red += colour.red > 127 ? shiftAmount : -shiftAmount
//		colour.green += colour.green > 127 ? shiftAmount : -shiftAmount
//		colour.blue += colour.blue > 127 ? shiftAmount : -shiftAmount
//
//		newPixel.colour = colour
//
//		return [newPixel]
//	}
//
//	func recolourPrimaryMap(pixel: Pixel) -> [Pixel] {
//		var newPixel = pixel
//		let colour = pixel.colour
//		if colour.red > colour.green && colour.red > colour.blue {
//			newPixel.colour = 0xFF0000FF.hexColour
//		} else if colour.green > colour.red && colour.green > colour.blue {
//			newPixel.colour = 0x00FF00FF.hexColour
//		} else if colour.blue > colour.green && colour.blue > colour.red {
//			newPixel.colour = 0x0000FFFF.hexColour
//		} else if intensity(colour: colour) > 127 {
//			newPixel.colour = 0xFFFFFFFF.hexColour
//		} else {
//			newPixel.colour = 0x000000FF.hexColour
//		}
//
//		return [newPixel]
//	}
//
//	/***********************************************\
//	 ***** Advanced *****
//	\***********************************************/
//	func recolourPrimaryScale(pixel: Pixel) -> [Pixel] {
//		var newPixel = pixel
//		let colour = pixel.colour
//		if colour.red > colour.green && colour.red > colour.blue {
//			return recolourRedScale(pixel: pixel)
//		} else if colour.green > colour.red && colour.green > colour.blue {
//			return recolourGreenScale(pixel: pixel)
//		} else if colour.blue > colour.green && colour.blue > colour.red {
//			return recolourBlueScale(pixel: pixel)
//		} else if intensity(colour: colour) > 127 {
//			newPixel.colour = 0xFFFFFFFF.hexColour
//		} else {
//			newPixel.colour = 0x000000FF.hexColour
//		}
//
//		return [newPixel]
//	}
//
//	func recolourHORaTONe(pixel: Pixel) -> [Pixel] {
//		var newPixel = pixel
//		let colour = pixel.colour
//		let intensityValue = intensity(colour: colour)
//
//		if intensityValue > 127 {
//			newPixel.colour.red = intensityValue
//			newPixel.colour.green = intensityValue / 4
//			newPixel.colour.blue = 0
//		} else {
//			newPixel.colour.red = intensityValue / 2
//			newPixel.colour.blue = intensityValue
//			newPixel.colour.green = 0
//		}
//
//		return [newPixel]
//	}
//
//	func swapHighAndLowIntensities(_ colour: Colour) -> Colour {
//		var newColour = colour
//		if colour.red > colour.green && colour.red > colour.blue {
//			if colour.blue < colour.green {
//				newColour.red = colour.blue
//				newColour.blue = colour.red
//			} else {
//				newColour.red = colour.green
//				newColour.green = colour.red
//			}
//		} else if colour.green > colour.red && colour.green > colour.blue {
//			if colour.blue < colour.red {
//				newColour.green = colour.blue
//				newColour.blue = colour.green
//			} else {
//				newColour.red = colour.green
//				newColour.green = colour.red
//			}
//		} else if colour.blue > colour.green && colour.blue > colour.red {
//			if colour.red < colour.green {
//				newColour.red = colour.blue
//				newColour.blue = colour.red
//			} else {
//				newColour.blue = colour.green
//				newColour.green = colour.blue
//			}
//		}
//		return newColour
//	}
//
//	func recolourTwoTone(pixel: Pixel) -> [Pixel] {
//		var newPixel = pixel
//		let colour = pixel.colour
//		let intensityValue = intensity(colour: colour)
//
//		var highTone = selectedColour
//		var lowTone = swapHighAndLowIntensities(highTone)
//
//		// this seems to make the images nicer
//		if lowTone.green > highTone.green {
//			let temp = highTone
//			highTone = lowTone
//			lowTone = temp
//		}
//
//		let redFraction: CGFloat
//		let greenFraction: CGFloat
//		let blueFraction: CGFloat
//
//		if intensityValue > 127 {
//			let highToneMax = max(highTone.red.float, highTone.green.float, highTone.blue.float, 0.1)
//			redFraction = max(highTone.red.float, 0.1) / highToneMax
//			greenFraction = max(highTone.green.float, 0.1) / highToneMax
//			blueFraction = max(highTone.blue.float, 0.1) / highToneMax
//		} else {
//			let lowToneMax = max(lowTone.red.float, lowTone.green.float, lowTone.blue.float, 0.1)
//			redFraction = max(lowTone.red.float, 0.1) / lowToneMax
//			greenFraction = max(lowTone.green.float, 0.1) / lowToneMax
//			blueFraction = max(lowTone.blue.float, 0.1) / lowToneMax
//		}
//
//		let pixelIntensity = intensityValue.float
//
//		let red = pixelIntensity * redFraction
//		let green = pixelIntensity * greenFraction
//		let blue = pixelIntensity * blueFraction
//
//		newPixel.colour = (red.int, green.int, blue.int, pixel.colour.alpha)
//
//		return [newPixel]
//	}
//
//	func coloursHaveSimilarRatio(c1: Colour, c2: Colour, minRatio: CGFloat, maxRatio: CGFloat) -> Bool {
//		let red_green1  = (c1.red.float   / max(c1.green.float, 1))
//		let green_blue1 = (c1.green.float / max(c1.blue.float , 1))
//
//		let red_green2  = (c2.red.float   / max(c2.green.float, 1))
//		let green_blue2 = (c2.green.float / max(c2.blue.float , 1))
//
//		let rgRatio = red_green1  / max(red_green2, 0.001)
//		let gbRatio = green_blue1 / max(green_blue2, 0.001)
//
//		return rgRatio < maxRatio && rgRatio > minRatio &&
//			gbRatio < maxRatio && gbRatio > minRatio
//	}
//
//	func recolourFilterColour(pixel: Pixel) -> [Pixel] {
//		let colour = pixel.colour
//		let minRatio = (255 - threshold).float / 255
//		let maxRatio = threshold == 255 ? 256 : 255 / (255 - threshold).float
//
//		if coloursHaveSimilarRatio(c1: selectedColour, c2: colour, minRatio: minRatio, maxRatio: maxRatio) {
//			return [pixel]
//		}
//
//		return recolourGreyScale(pixel: pixel)
//	}
//
//	func recolourGreyColour(pixel: Pixel) -> [Pixel] {
//		let colour = pixel.colour
//		let minRatio = (255 - threshold).float / 255
//		let maxRatio = threshold == 255 ? 256 : 255 / (255 - threshold).float
//
//		if coloursHaveSimilarRatio(c1: selectedColour, c2: colour, minRatio: minRatio, maxRatio: maxRatio) {
//			return recolourGreyScale(pixel: pixel)
//		}
//
//		return [pixel]
//	}
//
//	func recolourTransparentColour(pixel: Pixel) -> [Pixel] {
//		let colour = pixel.colour
//		let minRatio = (255 - threshold).float / 255
//		let maxRatio = threshold == 255 ? 256 : 255 / (255 - threshold).float
//
//		if coloursHaveSimilarRatio(c1: selectedColour, c2: colour, minRatio: minRatio, maxRatio: maxRatio) {
//			var newPixel = pixel
//			newPixel.colour = 0x00000000.hexColour
//			return [newPixel]
//		}
//
//		return [pixel]
//	}
//
//	func recolourHeatMap(pixel: Pixel) -> [Pixel] {
//		var newPixel = pixel
//		let intensityValue = 255 - intensity(colour: pixel.colour)
//		let quarterSize = 255 / 4
//		let quarterDisplacement = (intensityValue % quarterSize).float / quarterSize.float
//		let variableValue = (255 * quarterDisplacement).int
//		let boostColour: Colour
//
//		if intensityValue < quarterSize {
//			boostColour = (255, variableValue, 0, 255)
//		} else if intensityValue < quarterSize * 2 {
//			boostColour = (255 - variableValue, 255, 0, 255)
//		} else if intensityValue < quarterSize * 3 {
//			boostColour = (0, 255, variableValue, 255)
//		} else {
//			boostColour = (0, 255 - variableValue, 255, 255)
//		}
//
//		newPixel.colour = boostColour
//		return [newPixel]
//	}

}
#if !GAME_PBR
extension DATModel {
	func applyFilter(_ filter: GoDFiltersManager.Filters) {
		nodes?.vertexColours.values.sorted { $0.offset < $1.offset }.forEach { (colour) in
			filter.apply(to: colour)
			if let oldRed = colour.structData.valueForPropertyWithName("Red") {
				colour.structData.set("Red", to: .value(property: oldRed.property, rawValue: colour.red))
			}
			if let oldBlue = colour.structData.valueForPropertyWithName("Blue") {
				colour.structData.set("Blue", to: .value(property: oldBlue.property, rawValue: colour.blue))
			}
			if let oldGreen = colour.structData.valueForPropertyWithName("Green") {
				colour.structData.set("Green", to: .value(property: oldGreen.property, rawValue: colour.green))
			}
			if let oldAlpha = colour.structData.valueForPropertyWithName("Alpha") {
				colour.structData.set("Alpha", to: .value(property: oldAlpha.property, rawValue: colour.alpha))
			}
			colour.structData.save(writeData: false)
		}
		
	}
}
#endif
