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
			}
			textureHeaderOffsets.append(textureStart)
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

class PBRSDRModel: PBRTextureContaining {
	override var modelNumberOfTexturesOffset: Int { return 0x1a }
	override var modelTextureHeadersPointersOffset: Int { return 0xc }
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
	override var sizeOfTexturePointerData: Int { return 0x8 }
	override var offsetOfTexturePointerInData: Int { return 0x0 }
	override var texturePointersFixedStartOffset: Int { return -1 }
	override var textureHeadersPointerOffsetRelativeToOffset: Int { return 4 }

	override var modelNumberOfTexturesOffset: Int { return 4 }
	override var modelTextureHeadersPointersOffset: Int { return 0x14 }
}
