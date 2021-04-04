//
//  DATModel.swift
//  GoD Tool
//
//  Created by Stars Momodu on 02/04/2021.
//

import Foundation

class DATModel: CustomStringConvertible {

	var modelData: XGMutableData
	var header: GoDStructData
	var nodes: GoDStructData?

	var description: String {
		return "File: \(modelData.file.path)"
			+ header.description
			+ "\nNodes:\n"
			+ (nodes?.description ?? "-")
	}

	convenience init?(file: XGFiles) {
		guard let data = file.data else { return nil }
		self.init(data: data)
	}

	init(data: XGMutableData) {
		header = GoDStructData(properties: DATNodes.datArchiveHeaderStruct, fileData: data, startOffset: 0)
		let headerLength = DATNodes.datArchiveHeaderStruct.length
		modelData = data.getSubDataFromOffset(headerLength, length: data.length - headerLength)

		if let nodesSize: Int = header.get("Node Count") *? 4,
		   let publicCount: Int = header.get("Public Root Nodes Count"),
		   let externCount: Int = header.get("External Root Nodes Count"),
		   let dataSize: Int = header.get("Data Size")
		{
			let rootNodesOffset = dataSize + nodesSize
			nodes = DATNodes.rootNodesData(firstRootNodeOffset: rootNodesOffset, publicCount: publicCount, externCount: externCount, data: modelData)
		}
	}
}
