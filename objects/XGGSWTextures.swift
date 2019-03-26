//
//  XGGSWTextures.swift
//  GoD Tool
//
//  Created by The Steez on 01/03/2019.
//

import Foundation

struct GSWMetaData {
	var id = 0
	var startOffset = 0
	var dataSize = 0
	
}

class XGGSWTextures {
	/*
	 * These are files used for animations such as images moving across the screen
	 * (unlike .atx files which are individual frames of an animated image like .gifs)
	 * They contain multiple distinct data sections which can be texture data
	 * or animation data.
	 * I haven't quite figured out how to systematically traverse each section so
	 * for now this class will search for the characteristics of the section headers
	 * of textures.
	 */
	
	private var gswdata : XGMutableData!
	private var metaData : [GSWMetaData]!
	
	var file : XGFiles {
		return gswdata.file
	}
	
	var subFilenamesPrefix : String {
		return file.fileName.removeFileExtensions() + "_gsw_"
	}
	
	convenience init(file: XGFiles) {
		self.init(data: file.data!)
	}
	
	init(data: XGMutableData) {
		
		let numberOfIDs = data.get2BytesAtOffset(0x18)
		self.gswdata = data
		self.metaData = [GSWMetaData]()
		
		// I think the first section with id 0 is always the same format
		// i.e. not a texture
		for id in 1 ... numberOfIDs where id <= 0xFF {
			if let result = searchForID(id) {
				self.metaData.append(result)
			}
		}
		
	}
	
	private func searchForID(_ id: Int) -> GSWMetaData? {
		// assumes the id is never more than 1 byte long
		// will ammend if I find evidence to the contrary
		let headerMarker = [0x03, 0x00, 0x00, id]
		
		for offset in self.gswdata.occurencesOfBytes(headerMarker) {
			// bytes in texture data representing 8bitsperpixel indexed image.
			// could also add options for other texture formats but these are all
			// i've seen so far.
			if self.gswdata.get2BytesAtOffset(offset + 0x24) == 0x0801 {
				let formatID = gswdata.get4BytesAtOffset(offset + 0x28)
				if let _ = GoDTextureFormats(rawValue: formatID) {
					
					let paletteStart = gswdata.get4BytesAtOffset(offset + 0x68)
					let textureSize = paletteStart + 0x200 // palette should always be 0x200 bytes long
					let textureStart = offset + 0x20
					return GSWMetaData(id: id, startOffset: textureStart, dataSize: textureSize)
					
				}
				
			}
		}
		
		return nil
	}
	
	func extractTextureData() -> [XGMutableData] {
		var textures = [XGMutableData]()
		
		for info in self.metaData {
			let filename = self.subFilenamesPrefix + "\(info.id).gtx"
			let textureFile = XGFiles.nameAndFolder(filename, self.file.folder)
			
			let byteStream = self.gswdata.getByteStreamFromOffset(info.startOffset, length: info.dataSize)
			let data = XGMutableData(byteStream: byteStream, file: textureFile)
			textures.append(data)
		}
		
		return textures
	}
	
	func importTextureData(_ texture: XGMutableData, withID id: Int) {
		for info in self.metaData where info.id == id {
			if info.dataSize == texture.length {
				self.gswdata.replaceData(data: texture, atOffset: info.startOffset)
			} else {
				printg("Couldn't import gsw texture: \(texture.file.path) because the filesize doesn't match.")
			}
		}
	}
	
	func save() {
		self.gswdata.save()
	}
	
}















