//
//  DATNodes.swift
//  GoD Tool
//
//  Created by Stars Momodu on 02/04/2021.
//

import Foundation

class DATNodes {

	static let datArchiveHeaderStruct = GoDStruct(name: "DAT Model Header", format: [
		.word(name: "File Size", description: "", type: .uint),
		.word(name: "Data Size", description: "", type: .uint),
		.word(name: "Node Count", description: "", type: .uint),
		.word(name: "Public Root Nodes Count", description: "", type: .uint),
		.word(name: "External Root Nodes Count", description: "", type: .uint),
		.array(name: "Padding", description: "", property:
				.word(name: "Padding", description: "", type: .null), count: 3)
	])

	static func rootNodesData(firstRootNodeOffset offset: Int, publicCount: Int, externCount: Int, data: XGMutableData) -> GoDStructData {
		let rootNodesCount = publicCount + externCount
		let stringsOffset = offset + (rootNodesCount * 8)

		var rootNodes = [GoDStructData]()

		var currentOffset = offset
		(0 ..< publicCount + externCount).forEach { (index) in
			rootNodes.append(rootNodeStructData(data: data, offset: currentOffset, stringsOffset: stringsOffset))
			currentOffset += 8
		}

		let rootNodeStruct = GoDStruct(name: "Root Node", format: [
			.word(name: "Node Pointer", description: "The type of node is determined by the name string", type: .pointer),
			.pointer(property:
				.string(name: "Node Type Name", description: "", maxCharacterCount: nil, charLength: .char), offsetBy: 0, isShort: false)
		])
		let rootNodesArrayStruct = GoDStruct(name: "Root Nodes Array", format: [
			.array(name: "Root Nodes", description: "", property:
				.subStruct(name: "Root Node", description: "", property: rootNodeStruct), count: rootNodes.count)
		])

		return GoDStructData(
			fileData: data,
			startOffset: offset,
			properties: rootNodesArrayStruct,
			values: [
				.array(
					property: rootNodesArrayStruct.format[0],
					rawValues: rootNodes.map({ data -> GoDStructValues in
						return .subStruct(property: .subStruct(name: "Root Node", description: "", property: rootNodeStruct), data: data)
					})
				)
			])
	}

	static func rootNodeStructData(data: XGMutableData, offset: Int, stringsOffset: Int) -> GoDStructData {
		// Read them once without pointers to check the type of each node
		// Then read a second time with the names specified to get the specific struct for that node type
		let rootNodeStruct = GoDStruct(name: "Root Node", format: [
			.word(name: "Pointer", description: "Temporarily use a non recursive pointer just to check the type name", type: .pointer),
			.pointer(property: .string(name: "Node Type Name", description: "", maxCharacterCount: nil, charLength: .char), offsetBy: stringsOffset, isShort: false)
		])
		let rootNodeTypeData = GoDStructData(properties: rootNodeStruct, fileData: data, startOffset: offset)
		
		guard let typeName: String = rootNodeTypeData.get("Node Type Name"),
			  let pointer: Int = rootNodeTypeData.get("Pointer") else {
			return .null
		}

		let subStruct: GoDStructData
		switch typeName {
		case "scene_data": subStruct = sceneData(data: data, offset: pointer)
		case "bound_box": subStruct = boundBox(data: data, offset: pointer)
		default: return rootNodeTypeData
		}

		rootNodeTypeData.set("Pointer", to: .pointer(property: .subStruct(name: "Root Node", description: "", property: subStruct.properties), rawValue: pointer, value: subStruct))
		return rootNodeTypeData
	}

	static func sceneData(data: XGMutableData, offset: Int) -> GoDStructData {
		func sceneDataStruct(modelSetsCount: Int? = nil) -> GoDStruct {
			return GoDStruct(name: "Scene Data", format: [
				.pointer(property:
					.array(name: "Model Sets", description: "", property:
						.word(name: "Model Set Pointers", description: "", type: .pointer),
								   count: modelSetsCount), offsetBy: 0, isShort: false),
				.word(name: "Camera Set", description: "", type: .pointer),
				.word(name: "Light Set", description: "", type: .pointer),
				.word(name: "Fog Data", description: "", type: .pointer)
			])
		}
		let sceneData = GoDStructData(properties: sceneDataStruct(), fileData: data, startOffset: offset)
		let modelSetPointers: [Int?] = sceneData.get("Model Sets") ?? []
		let modelSetsCount = modelSetPointers.count
		sceneData.properties = sceneDataStruct(modelSetsCount: modelSetsCount)
		
		let modelSetsProperty = sceneData.properties.format[0]
		let modelSetsPointer = sceneData.valueForPropertyWithName("Model Sets")?.rawValue() ?? -1

		sceneData.set(
			modelSetsProperty.name,
			to: .pointer(
				property: modelSetsProperty,
				rawValue: modelSetsPointer,
				value: GoDStructData(
					fileData: data,
					startOffset: modelSetsPointer,
					properties: GoDStruct(
						name: "Model Sets",
						format: [.array(name: "Model Sets", description: "", property:
									.word(name: "Model Set Pointers", description: "", type: .pointer), count: modelSetsCount)]),
					values: [
						.array(property: .word(name: "Model Set Pointers", description: "", type: .pointer), rawValues: modelSetPointers.map({ (pointer) -> GoDStructValues in
							let set = pointer == nil ? GoDStructData.null : modelSet(data: data, offset: pointer!)
							return .pointer(property: .subStruct(name: "Model Set", description: "", property: set.properties), rawValue: pointer ?? 0, value: set)
						}))
					])))

		if let pointer: Int = sceneData.get("Camera Set") {
			let set = cameraSet(data: data, offset: pointer)
			sceneData.set("Camera Set", to: .pointer(property: .subStruct(name: "Camera Set", description: "", property: set.properties), rawValue: pointer, value: set))
		}

		if let pointer: Int = sceneData.get("Light Set") {
			let set = lightSet(data: data, offset: pointer)
			sceneData.set("Light Set", to: .pointer(property: .subStruct(name: "Light Set", description: "", property: set.properties), rawValue: pointer, value: set))
		}

		if let pointer: Int = sceneData.get("Fog Data") {
			let set = cameraSet(data: data, offset: pointer)
			sceneData.set("Fog Data", to: .pointer(property: .subStruct(name: "Fog Data", description: "", property: set.properties), rawValue: pointer, value: set))
		}

		return sceneData
	}

	static func boundBox(data: XGMutableData, offset: Int) -> GoDStructData {
		return .staticString("Bound Box Not Implemented")
	}

	static func cameraSet(data: XGMutableData, offset: Int) -> GoDStructData {
		return .staticString("Camera Set Not Implemented")
	}

	static func lightSet(data: XGMutableData, offset: Int) -> GoDStructData {
		return .staticString("Light Set Not Implemented")
	}

	static func fogData(data: XGMutableData, offset: Int) -> GoDStructData {
		return .staticString("Fog Data Not Implemented")
	}

	static func modelSet(data: XGMutableData, offset: Int) -> GoDStructData {
		let modelSetStruct = GoDStruct(name: "Model Set", format: [
			.word(name: "Joint", description: "", type: .pointer),
			.word(name: "Animated Joint", description: "", type: .pointer),
			.word(name: "Material Animated Joint", description: "", type: .pointer),
			.word(name: "Shape Animated Joint", description: "", type: .pointer)
		])
		let modelSet = GoDStructData(properties: modelSetStruct, fileData: data, startOffset: offset)

		if let pointer: Int = modelSet.get("Joint") {
			let joint = jointData(data: data, offset: pointer)
			modelSet.set("Joint", to: .pointer(property: .subStruct(name: "Joint", description: "", property: joint.properties), rawValue: pointer, value: joint))
		}

		if let pointer: Int = modelSet.get("Animated Joint") {
			let joint = animatedJoint(data: data, offset: pointer)
			modelSet.set("Animated Joint", to: .pointer(property: .subStruct(name: "Animated Joint", description: "", property: joint.properties), rawValue: pointer, value: joint))
		}

		if let pointer: Int = modelSet.get("Material Animated Joint") {
			let joint = materialAnimatedJoint(data: data, offset: pointer)
			modelSet.set("Material Animated Joint", to: .pointer(property: .subStruct(name: "Material Animated Joint", description: "", property: joint.properties), rawValue: pointer, value: joint))
		}

		if let pointer: Int = modelSet.get("Shape Animated Joint") {
			let joint = shapeAnimatedJoint(data: data, offset: pointer)
			modelSet.set("Shape Animated Joint", to: .pointer(property: .subStruct(name: "Shape Animated Joint", description: "", property: joint.properties), rawValue: pointer, value: joint))
		}

		return modelSet
	}

	static func animatedJoint(data: XGMutableData, offset: Int) -> GoDStructData {
		return .staticString("Animated Joint Not Implemented")
	}

	static func materialAnimatedJoint(data: XGMutableData, offset: Int) -> GoDStructData {
		return .staticString("Material Animated Joint Not Implemented")
	}

	static func shapeAnimatedJoint(data: XGMutableData, offset: Int) -> GoDStructData {
		return .staticString("Shape Animated Joint Not Implemented")
	}

	static func jointData(data: XGMutableData, offset: Int) -> GoDStructData {
		let jointStruct = GoDStruct(name: "Joint", format: [
			.pointer(property:
						.string(name: "Name", description: "", maxCharacterCount: nil, charLength: .char), offsetBy: 0, isShort: false),
			.bitArray(name: "Flags", description: "", bitFieldNames: [
				"JOBJ_SKELETON",
				"JOBJ_SKELETON_ROOT",
				"JOBJ_ENVELOPE_MODEL",
				"JOBJ_CLASSICAL_SCALING",
				"JOBJ_HIDDEN",
				"JOBJ_PTCL",
				"JOBJ_MTX_DIRTY",
				"JOBJ_LIGHTING",
				"JOBJ_TEXGEN",
				"JOBJ_BILLBOARD_1",
				"JOBJ_BILLBOARD_2",
				"JOBJ_BILLBOARD_3",
				"JOBJ_INSTANCE",
				"JOBJ_PBILLBOARD",
				"JOBJ_SPLINE",
				"JOBJ_FLIP_IK",
				"JOBJ_SPECULAR",
				"JOBJ_USE_QUATERNION",
				"JOBJ_TRSP_1",
				"JOBJ_TRSP_2",
				"JOBJ_TRSP_3",
				"JOBJ_TYPE_1",
				"JOBJ_TYPE_2",
				"JOBJ_USER_DEFINED_MTX",
				"JOBJ_MTX_INDEPEND_PARENT",
				"JOBJ_MTX_INDEPEND_SRT",
				"JOBJ_UNKNOWN",
				"JOBJ_UNKNOWN_2",
				"JOBJ_ROOT_1",
				"JOBJ_ROOT_2",
				"JOBJ_ROOT_3",
				"JOBJ_SHADOW"
			]),
			.word(name: "Child Joint", description: "", type: .pointer),
			.word(name: "Next Joint", description: "", type: .pointer),
			.word(name: "Variable Pointer", description: "Type of object it points to is determined by the flags. Can be Spline, Particles or Mesh", type: .pointer),
			.vector(name: "Rotation", description: ""),
			.vector(name: "Scale", description: ""),
			.vector(name: "Position", description: ""),
			.word(name: "Invbind", description: "", type: .pointer),
			.word(name: "R Object", description: "", type: .pointer)
		])
		let joint = GoDStructData(properties: jointStruct, fileData: data, startOffset: offset)

		if let pointer: Int = joint.get("Child Joint") {
			let child = jointData(data: data, offset: pointer)
			joint.set("Child Joint", to: .pointer(property: .subStruct(name: "Joint", description: "", property: child.properties), rawValue: pointer, value: child))
		}

		if let pointer: Int = joint.get("Next Joint") {
			let next = jointData(data: data, offset: pointer)
			joint.set("next Joint", to: .pointer(property: .subStruct(name: "Joint", description: "", property: next.properties), rawValue: pointer, value: next))
		}

		if let bitFields: [String: Bool] = joint.get("Flags"), let pointer: Int = joint.get("Variable Pointer")  {
			let subStruct: GoDStructData
			if bitFields["JOBJ_PTCL"] == true {
				subStruct = particles(data: data, offset: pointer)
			} else if bitFields["JOBJ_SPLINE"] == true {
				subStruct = spline(data: data, offset: pointer)
			} else {
				subStruct = mesh(data: data, offset: pointer)
			}
			joint.set("Variable Pointer", to: .pointer(property: .subStruct(name: subStruct.properties.name, description: "", property: subStruct.properties), rawValue: pointer, value: subStruct))
		}

		return joint
	}

	static func spline(data: XGMutableData, offset: Int) -> GoDStructData {
		return .staticString("Spline Not Implemented")
	}

	static func particles(data: XGMutableData, offset: Int) -> GoDStructData {
		return .staticString("Particles Not Implemented")
	}

	static func mesh(data: XGMutableData, offset: Int) -> GoDStructData {
		return .staticString("Mesh Not Implemented")
	}
}
