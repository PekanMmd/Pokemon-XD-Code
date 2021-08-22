//
//  WZXModel.swift
//  GoD Tool
//
//  Created by Stars Momodu on 13/08/2021.
//

import Foundation


class WZXModel {

	lazy var particleDataOffsets: [Int] = {
		var offsets = [Int]()
		var lastRange: Range<Int>? = 0 ..< 0
		let GPT1Data = XGMutableData(string: "GPT1").data
		while lastRange != nil {
			let searchRange = (lastRange?.endIndex ?? 0) ..< data.length
			lastRange = data.data.firstRange(of: GPT1Data, in: searchRange)
			if let range = lastRange {
				offsets.append(range.startIndex)
			}
		}
		return offsets
	}()

	lazy var datModelOffsets: [Int] = {
		// This method is a little crude but until we figure out how to parse the wzx headers properly
		// we can search for patterns which represent the start of a .dat model.
		// They're easy to spot by eye so basically trying to programmatically explain what
		// we can see intuitively
		// The "scene_data" text at the end is a dead give away. Another strategy would be to start by searching for that
		// and then figuring out the start offset by searching for the header in the range before.

		var offsets = [Int]()
		var lastRange: Range<Int>? = 0 ..< 0
		// The .dat header has 0x00000001 at the end and is followed by 16 null bytes.
		let endOfHeaderMarker = XGMutableData(byteStream: [
			0x00,0x00,0x00,0x01,
			0x00,0x00,0x00,0x00,
			0x00,0x00,0x00,0x00,
			0x00,0x00,0x00,0x00,
			0x00,0x00,0x00,0x00
		])
		while lastRange != nil {
			let searchRange = (lastRange?.endIndex ?? 0) ..< data.length
			lastRange = data.data.firstRange(of: endOfHeaderMarker.data, in: searchRange)
			if let range = lastRange {
				// The end of header pattern is generic enough that there will likely be false positives.
				// Once we find it we check the surrounding data to see if it's consistent with a model header.


				let modelStartOffset = range.startIndex - 12

				// The values at these two offsets should be the same
				let modelLength = data.get4BytesAtOffset(modelStartOffset)
				let possibleModelLengthRepeatOffsets = [8, 20, 28]
				let lengthMatch = possibleModelLengthRepeatOffsets.reduce(false) { (result, offset) -> Bool in
					return result || (modelLength == data.get4BytesAtOffset(modelStartOffset - offset))
				}

				// Model should end with the scene_data section text
				// Don't know if any have bound boxes but we can check for that as well just in case
				let modelEndOffset = modelStartOffset + modelLength
				let expectedSceneDataOffset = modelEndOffset - "scene_data ".length // extra space for null termination character
				let expectedBoundBoxOffset = modelEndOffset - "bound_box ".length

				guard lengthMatch,
					  modelLength > 32, // Doubt the size would be this low for any actual models
					  modelEndOffset <= data.length, // just check that there's anything set for the other values
					  data.getStringAtOffset(expectedSceneDataOffset) == "scene_data"
						|| data.getStringAtOffset(expectedBoundBoxOffset) == "bound_box"
				else {
					continue
				}
				
				lastRange = modelStartOffset ..< modelEndOffset
				offsets.append(modelStartOffset)
			}
		}
		return offsets
	}()

	var models: [XGMutableData] {
		var modelsData = [XGMutableData]()
		datModelOffsets.forEachIndexed { (index, offset) in
			let modelStart = offset
			let modelLength = data.get4BytesAtOffset(modelStart)
			let modelData = data.getSubDataFromOffset(modelStart, length: modelLength)
			if let file = fileForModelWithIndex(index) {
				modelData.file = file
				modelsData.append(modelData)
			} else {
				assertionFailure("Model should have indexed filename")
			}
		}
		return modelsData
	}

	var data: XGMutableData

	convenience init?(file: XGFiles) {
		guard let data = file.data else { return nil }
		self.init(data: data)
	}

	init(data: XGMutableData) {
		self.data = data
	}

	func fileForModelWithIndex(_ index: Int) -> XGFiles? {
		guard index < datModelOffsets.count else {
			return nil
		}
		return XGFiles.nameAndFolder(data.file.fileName.removeFileExtensions() + "_\(index).wzx.dat", data.file.folder)
	}

	@discardableResult
	func importModel(_ model: XGMutableData, atIndex index: Int, save shouldSave: Bool = true) -> Bool {
		guard index < datModelOffsets.count else {
			printg("Couldn't import \(model.file.path) into \(data.file.path)\nModel with index \(index) doesn't exist")
			return false
		}

		let startOffset = datModelOffsets[index]
		let currentModelLength = data.get4BytesAtOffset(startOffset)
		
		guard model.length == currentModelLength else {
			printg(printg("Couldn't import \(model.file.path) into \(data.file.path)\nThe tool does not currently support importing a model with a different length to the original.\nExpected length: \(currentModelLength)"))
			return false
		}

		data.replaceData(data: model, atOffset: startOffset)

		if shouldSave {
			save()
		}
		return true
	}

	func save() {
		data.save()
	}
}
