//
//  DATModel.swift
//  GoD Tool
//
//  Created by Stars Momodu on 02/04/2021.
//

import Foundation

class DATModel: CustomStringConvertible, GoDTexturesContaining {

	var data: XGMutableData?
	var textureHeaderOffsets: [Int] {
		return nodes?.textureHeaderOffsets.map { $0 + 32 } ?? []
	}
	var textureDataOffsets: [Int] {
		return nodes?.textureDataOffsets.map { $0 + 32 } ?? []
	}
	var texturePaletteData: [(format: Int?, offset: Int?, numberOfEntries: Int)] {
		return nodes?.texturePalettes.map {
			return (format: $0.format, offset: $0.offset +? 32, numberOfEntries: $0.numberOfEntries)
		} ?? []
	}
	var usesDATTextureHeaderFormat: Bool { return true }

	var vertexColourProfile: XGImage {
		return nodes?.vertexColourProfile ?? .dummy
	}

	var modelData: XGMutableData
	var header: GoDStructData
	var nodes: DATNodes?

	var description: String {
		return "File: \(modelData.file.path)"
			+ header.description
			+ "\nNodes:\n"
			+ (nodes?.rootNode.description ?? "-")
	}

	convenience init?(file: XGFiles) {
		guard let data = file.data else { return nil }
		self.init(data: data)
	}

	private let datArchiveHeaderStruct = GoDStruct(name: "DAT Model Header", format: [
		.word(name: "File Size", description: "", type: .uint),
		.word(name: "Data Size", description: "", type: .uint),
		.word(name: "Node Count", description: "", type: .uint),
		.word(name: "Public Root Nodes Count", description: "", type: .uint),
		.word(name: "External Root Nodes Count", description: "", type: .uint),
		.array(name: "Padding", description: "", property:
				.word(name: "Padding", description: "", type: .null), count: 3)
	])

	init(data: XGMutableData) {
		self.data = data

		header = GoDStructData(properties: datArchiveHeaderStruct, fileData: data, startOffset: 0)
		let headerLength = datArchiveHeaderStruct.length
		modelData = data.getSubDataFromOffset(headerLength, length: data.length - headerLength)

		if let nodesSize: Int = header.get("Node Count") *? 4,
		   let publicCount: Int = header.get("Public Root Nodes Count"),
		   let externCount: Int = header.get("External Root Nodes Count"),
		   let dataSize: Int = header.get("Data Size")
		{
			let rootNodesOffset = dataSize + nodesSize
			nodes = DATNodes(firstRootNodeOffset: rootNodesOffset, publicCount: publicCount, externCount: externCount, data: modelData)
		}
	}

	func save() {
		let headerLength = datArchiveHeaderStruct.length
		data?.replaceData(data: modelData, atOffset: headerLength)
		data?.save()
	}
}
