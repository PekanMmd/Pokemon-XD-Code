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
		textureHeadersPointersOffset = data.get4BytesAtOffset(modelTextureHeadersPointersOffset)
		textureHeaderOffsets = data.getWordStreamFromOffset(textureHeadersPointersOffset, length: numberOfTextures * 4).map { $0.int }
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
