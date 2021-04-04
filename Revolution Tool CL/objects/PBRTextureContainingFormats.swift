//
//  File.swift
//  GoD Tool
//
//  Created by Stars Momodu on 04/11/2020.
//

import Foundation

class PBRTextureContaining: GoDTexturesContaining {
	fileprivate var modelNumberOfTexturesOffset: Int { return -1 }
	fileprivate var modelTextureHeadersPointersOffset: Int { return -1 }

	fileprivate var sizeOfTexturePointerData: Int { return 4 }
	fileprivate var offsetOfTexturePointerInData: Int { return 0 }
	fileprivate var texturePointersFixedStartOffset: Int { return -1 }
	fileprivate var textureHeadersPointerOffsetRelativeToOffset: Int { return 0 }

	var numberOfTextures = -1
	var textureHeadersPointersOffset = -1

	var textureHeaderOffsets = [Int]()
	var textureDataOffsets = [Int]()

	var data: XGMutableData?

	fileprivate init() {}

	fileprivate convenience init(file: XGFiles) {
		self.init(data: file.data)
	}

	fileprivate init(data: XGMutableData?) {
		guard let data = data else { return }
		self.data = data

		numberOfTextures = data.get2BytesAtOffset(modelNumberOfTexturesOffset)
		textureHeadersPointersOffset = texturePointersFixedStartOffset == -1 ? data.get4BytesAtOffset(modelTextureHeadersPointersOffset) + textureHeadersPointerOffsetRelativeToOffset : texturePointersFixedStartOffset
		for i in 0 ..< numberOfTextures {
			let pointerDataOffset = textureHeadersPointersOffset + (i * sizeOfTexturePointerData)
			var textureStart = data.getWordAtOffset(pointerDataOffset + offsetOfTexturePointerInData).int
			if data.file.fileType == .gpd {
				if data.get2BytesAtOffset(pointerDataOffset + 2) == 0xc0d {
					textureStart = textureStart + data.get4BytesAtOffset(textureStart + 4)
				}
				if data.get4BytesAtOffset(pointerDataOffset + 4) != 0 {
					// not a texture
					textureStart = -1
				}
			}
			if textureStart >= 0 {
				textureHeaderOffsets.append(textureStart)
			}
		}
		textureDataOffsets = textureHeaderOffsets.map { (headerOffset) -> Int in
			let dataRelativeOffset = data.getWordAtOffset(headerOffset + 0x28).int32
			return dataRelativeOffset + headerOffset
		}

	}

	static func fromFile(_ file: XGFiles) -> PBRTextureContaining? {
		switch file.fileType {
		case .sdr:
			return PBRSDRModel(file: file)
		case .odr:
			return PBRODRModel(file: file)
		case .mdr:
			return PBRMDRModel(file: file)
		case .mnr:
			return PBRMNRData(file: file)
		case .gpd:
			return PBRGPDData(file: file)
		case .gfl:
			return PBRGFLData(file: file)
		default:
			return nil
		}
	}
}

class PBRMNRData: PBRTextureContaining {
	override var modelNumberOfTexturesOffset: Int { return 0xa }
	override var modelTextureHeadersPointersOffset: Int { return 0x20 }
}

class PBRODRModel: PBRTextureContaining {
	override var modelNumberOfTexturesOffset: Int { return 0x18 }
	override var modelTextureHeadersPointersOffset: Int { return 0xc }
}

class PBRMDRModel: PBRTextureContaining {
	override var modelNumberOfTexturesOffset: Int { return 0xc }
	override var modelTextureHeadersPointersOffset: Int { return 0x8 }
}

class PBRGPDData: PBRTextureContaining {
	override var sizeOfTexturePointerData: Int { return 0xc }
	override var offsetOfTexturePointerInData: Int { return 0x8 }
	override var texturePointersFixedStartOffset: Int { return 0x10 }

	override var modelNumberOfTexturesOffset: Int { return 0xa }
	override var modelTextureHeadersPointersOffset: Int { return -1 }
}

class PBRGFLData: PBRTextureContaining {

	fileprivate convenience init(file: XGFiles) {
		self.init(data: file.data)
	}

	fileprivate override init(data: XGMutableData?) {
		super.init()

		guard let data = data else { return }
		self.data = data

		numberOfTextures = data.get2BytesAtOffset(4)
		textureHeadersPointersOffset = data.get2BytesAtOffset(6) * 0x10 + 0x2c
		for i in 0 ..< numberOfTextures {
			let pointerDataOffset = textureHeadersPointersOffset + (i * 8)
			let textureStart = data.getWordAtOffset(pointerDataOffset + 4).int
			textureHeaderOffsets.append(textureStart)
		}
		textureDataOffsets = textureHeaderOffsets.map { (headerOffset) -> Int in
			let dataRelativeOffset = data.getWordAtOffset(headerOffset + 0x28).int32
			return dataRelativeOffset + headerOffset
		}

	}
}

struct SDRMaterial: CustomStringConvertible {
	var headerOffset: Int
	var name: String
	var diffuseReflection: XGColour
	var specularReflection: XGColour

	var description: String {
		return """
		Material: \(name)
		Header Offset: \(headerOffset)
		Diffuse
		red: \(diffuseReflection.red.hex()) green: \(diffuseReflection.green.hex()) blue: \(diffuseReflection.blue.hex())
		Specular
		red: \(specularReflection.red.hex()) green: \(specularReflection.green.hex()) blue: \(specularReflection.blue.hex())
		"""
	}
}

class PBRSDRModel: PBRTextureContaining {
	override var modelNumberOfTexturesOffset: Int { return 0x1a }
	override var modelTextureHeadersPointersOffset: Int { return 0xc }

	var materials = [SDRMaterial]()

	convenience init(file: XGFiles) {
		self.init(data: file.data)
	}

	override init(data: XGMutableData?) {
		super.init(data: data)
		guard let data = data else { return }

		let numberOfMaterials = data.get2BytesAtOffset(0x1e)
		let materialHeadersPointersOffset = data.get4BytesAtOffset(0x14)
		for i in 0 ..< numberOfMaterials {
			let materialHeaderPointer = data.get4BytesAtOffset(materialHeadersPointersOffset + (i * 4))
			let materialNamePointer = data.get4BytesAtOffset(materialHeaderPointer)
			let materialName = data.getStringAtOffset(materialNamePointer, charLength: .char)
			let materialProperties = data.getWordStreamFromOffset(materialHeaderPointer + 0x60, length: 8)
			let diffuseColour = XGColour(raw: materialProperties[0], format: .RGBA32)
			let specularColour = XGColour(raw: materialProperties[1], format: .RGBA32)
			materials.append(.init(headerOffset: materialHeaderPointer, name: materialName, diffuseReflection: diffuseColour, specularReflection: specularColour))
		}
	}

	func writeMaterials(save: Bool = true) {
		guard let data = data else { return }
		for material in materials {
			data.replaceBytesFromOffset(material.headerOffset + 0x60, withWordStream: [material.diffuseReflection.RGBA32Representation.uint32, material.specularReflection.RGBA32Representation.uint32])
		}
		if save {
			data.save()
		}
	}
}
