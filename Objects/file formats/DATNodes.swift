//
//  DATNodes.swift
//  GoD Tool
//
//  Created by Stars Momodu on 02/04/2021.
//

import Foundation

class DATNodes {
	enum ColourFormat {
		case RGBA8, RGBA6, RGBA4, RGBX8, RGB8, RGB565
	}

	class VertexColour: XGColour {
		let offset: Int
		let structData: GoDStructData
		init(data: GoDStructData) {
			self.offset = data.startOffset
			self.structData = data
			let red: Int = data.get("Red") ?? 0
			let green: Int = data.get("Green") ?? 0
			let blue: Int = data.get("Blue") ?? 0
			let alpha: Int = data.get("Alpha") ?? 0xFF
			super.init(red: red, green: green, blue: blue, alpha: alpha)
		}
		
		required init(from decoder: Decoder) throws {
			fatalError("init(from:) has not been implemented")
		}
	}

	var textureHeaderOffsets = [Int]()
	var textureDataOffsets = [Int]()
	var texturePalettes = [(format: Int?, offset: Int?, numberOfEntries: Int)]()

	var vertexColours = [Int: VertexColour]()

	var vertexColourProfile: XGImage {
		let colours = vertexColours.values.sorted { (v1, v2) -> Bool in
			let hsv1 = v1.hsv
			let hsv2 = v2.hsv

			if hsv1.hue == hsv2.hue {
				if hsv1.saturation == hsv2.saturation {
					if hsv1.value == hsv2.value {
						return v1.alpha > v2.alpha
					} else {
						return hsv1.value > hsv2.value
					}
				} else {
					return hsv1.saturation > hsv2.saturation
				}
			} else {
				return hsv1.hue > hsv2.hue
			}
		}
		guard colours.count > 0 else {
			return .dummy
		}

		let width = Int(sqrt(Double(colours.count)))
		let height = (colours.count / width) + (colours.count % width == 0 ? 0 : 1)
		let image = XGImage(width: width, height: height, pixels: colours)

		return image
	}

	private let data: XGMutableData
	var rootNode = GoDStructData.staticString("Null")

	private var nodesCache = [Int: GoDStructData]()

	func validate(offset: Int) -> Bool {
		return offset > 0 && offset < data.length
	}

	func isNullData(offset: Int, length: Int) -> Bool {
		return !validate(offset: offset) || !validate(offset: offset + length) || data.getByteStreamFromOffset(offset, length: length).filter {
			$0 != 0
		}.count == 0
	}

	init(firstRootNodeOffset offset: Int, publicCount: Int, externCount: Int, data: XGMutableData) {
		self.data = data
		let rootNodesCount = publicCount + externCount
		let stringsOffset = offset + (rootNodesCount * 8)

		guard validate(offset: offset) else { return }

		var rootNodes = [GoDStructData]()

		var currentOffset = offset
		(0 ..< publicCount + externCount).forEach { (index) in
			rootNodes.append(rootNodeStructData(offset: currentOffset, stringsOffset: stringsOffset))
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

		self.rootNode =  GoDStructData(
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

	private func loadNode(offset: Int, function: (Int) -> GoDStructData) -> GoDStructData {
		guard validate(offset: offset) else { return .staticString("Error") }
		let node = nodesCache[offset] ?? function(offset)
		nodesCache[offset] = node
		return node
	}

	func rootNodeStructData(offset: Int, stringsOffset: Int) -> GoDStructData {
		guard validate(offset: offset) else { return .staticString("Error") }
		// Read them once without pointers to check the type of each node
		// Then read a second time with the names specified to get the specific struct for that node type
		let rootNodeStruct = GoDStruct(name: "Root Node", format: [
			.word(name: "Pointer", description: "", type: .pointer),
			.pointer(property: .string(name: "Node Type Name", description: "", maxCharacterCount: nil, charLength: .char), offsetBy: stringsOffset, isShort: false)
		])
		let rootNodeTypeData = GoDStructData(properties: rootNodeStruct, fileData: data, startOffset: offset)
		
		guard let typeName: String = rootNodeTypeData.get("Node Type Name"),
			  let pointer: Int = rootNodeTypeData.get("Pointer") else {
			return .null
		}

		let subStruct: GoDStructData
		switch typeName {
		case "scene_data": subStruct = loadNode(offset: pointer, function: sceneData)
		case "bound_box": subStruct = loadNode(offset: pointer, function: boundBox)
		default: return rootNodeTypeData
		}

		rootNodeTypeData.set("Pointer", to: .pointer(property: .subStruct(name: "Root Node \(typeName)", description: "", property: subStruct.properties), rawValue: pointer, value: subStruct))
		return rootNodeTypeData
	}

	func substructArray(offset: Int, count: Int?, entryLength: Int, propertyFunction: (Int) -> GoDStructData) -> GoDStructData {
		guard validate(offset: offset) else { return .staticString("Error") }
		var values = [GoDStructValues]()
		var counter = 0
		var currentOffset = offset
		var property: GoDStruct?

		while true {
			if let count = count, counter >= count {
				break
			}
			if !validate(offset: currentOffset) {
				break
			}
			if count == nil && isNullData(offset: currentOffset, length: entryLength) {
				break
			}

			let structData = loadNode(offset: currentOffset, function: propertyFunction)

			if property?.name == "Vertex", let attribute: Int = structData.get("Attribute"), attribute == 0xFF {
				break
			}

			property = structData.properties
			values.append(.subStruct(property: .subStruct(name: property!.name, description: "", property: property!), data: structData))

			currentOffset += entryLength
			counter += 1
		}

		return GoDStructData(fileData: data, startOffset: offset, properties: GoDStruct(name: (property?.name ?? "Empty") + " List", format: [
			.array(name: "Values", description: "", property: .subStruct(name: property?.name ?? "Empty", description: "", property: property ?? .dummy), count: values.count)
		]), values: [
			.array(property: .subStruct(name: (property?.name ?? "Empty") + " List", description: "", property: property ?? .dummy), rawValues: values)
		])
	}

	func sceneData(offset: Int) -> GoDStructData {
		func sceneDataStruct(modelSetsCount: Int? = nil) -> GoDStruct {
			return GoDStruct(name: "Scene Data", format: [
				.word(name: "Model Sets Array", description: "", type: .pointer),
				.word(name: "Camera Set", description: "", type: .pointer),
				.word(name: "Light Set", description: "", type: .pointer),
				.word(name: "Fog Data", description: "", type: .pointer)
			])
		}
		let sceneData = GoDStructData(properties: sceneDataStruct(), fileData: data, startOffset: offset)

		if let pointer: Int = sceneData.get("Model Sets Array") {
			let array = loadNode(offset: pointer, function: modelSetsArray)
			sceneData.set("Model Sets Array", to: .pointer(property: .subStruct(name: "Model Sets Array", description: "", property: array.properties), rawValue: pointer, value: array))
		}

		if let pointer: Int = sceneData.get("Camera Set") {
			let set = loadNode(offset: pointer, function: cameraSet)
			sceneData.set("Camera Set", to: .pointer(property: .subStruct(name: "Camera Set", description: "", property: set.properties), rawValue: pointer, value: set))
		}

		if let pointer: Int = sceneData.get("Light Set") {
			let set = loadNode(offset: pointer, function: lightSet)
			sceneData.set("Light Set", to: .pointer(property: .subStruct(name: "Light Set", description: "", property: set.properties), rawValue: pointer, value: set))
		}

		if let pointer: Int = sceneData.get("Fog Data") {
			let set = loadNode(offset: pointer, function: cameraSet)
			sceneData.set("Fog Data", to: .pointer(property: .subStruct(name: "Fog Data", description: "", property: set.properties), rawValue: pointer, value: set))
		}

		return sceneData
	}

	func boundBox(offset: Int) -> GoDStructData {
		return .staticString("Bound Box Not Implemented")
	}

	func cameraSet(offset: Int) -> GoDStructData {
		return .staticString("Camera Set Not Implemented")
	}

	func lightSet(offset: Int) -> GoDStructData {
		return .staticString("Light Set Not Implemented")
	}

	func fogData(offset: Int) -> GoDStructData {
		return .staticString("Fog Data Not Implemented")
	}

	func modelSetsArray(offset: Int) -> GoDStructData {
		let modelSetsArrayStruct = GoDStruct(name: "Model Sets Array", format: [
			.array(name: "Model Sets", description: "", property: .word(name: "Model Set Pointers", description: "", type: .pointer), count: nil)
		])
		let modelSetsArray = GoDStructData(properties: modelSetsArrayStruct, fileData: data, startOffset: offset)
		var modelSets = [GoDStructData]()
		if let pointers: [Int] = modelSetsArray.get("Model Sets") {
			pointers.forEach { (pointer) in
				let set = loadNode(offset: pointer, function: modelSet)
				modelSets.append(set)
			}
		}
		modelSetsArray.set("Model Sets", to: .array(property: modelSetsArrayStruct.format[0], rawValues: modelSets.map({ (set) -> GoDStructValues in
			return .pointer(property: .subStruct(name: "Model Set", description: "", property: set.properties), rawValue: set.startOffset, value: set)
		})))
		return modelSetsArray
	}

	func modelSet(offset: Int) -> GoDStructData {
		let modelSetStruct = GoDStruct(name: "Model Set", format: [
			.word(name: "Joint", description: "", type: .pointer),
			.word(name: "Animated Joint", description: "", type: .pointer),
			.word(name: "Animated Material Joint", description: "", type: .pointer),
			.word(name: "Animated Shape Joint", description: "", type: .pointer)
		])
		let modelSet = GoDStructData(properties: modelSetStruct, fileData: data, startOffset: offset)

		if let pointer: Int = modelSet.get("Joint") {
			let joint = loadNode(offset: pointer, function: jointData)
			modelSet.set("Joint", to: .pointer(property: .subStruct(name: "Joint", description: "", property: joint.properties), rawValue: pointer, value: joint))
		}

		if let pointer: Int = modelSet.get("Animated Joint") {
			let joint = loadNode(offset: pointer, function: animatedJoint)
			modelSet.set("Animated Joint", to: .pointer(property: .subStruct(name: "Animated Joint", description: "", property: joint.properties), rawValue: pointer, value: joint))
		}

		if let pointer: Int = modelSet.get("Animated Material Joint") {
			let joint = loadNode(offset: pointer, function: animatedMaterialJoint)
			modelSet.set("Animated Material Joint", to: .pointer(property: .subStruct(name: "Animated Material Joint", description: "", property: joint.properties), rawValue: pointer, value: joint))
		}

		if let pointer: Int = modelSet.get("Animated Shape Joint") {
			let joint = loadNode(offset: pointer, function: shapeAnimatedJoint)
			modelSet.set("Animated Shape Joint", to: .pointer(property: .subStruct(name: "Animated Shape Joint", description: "", property: joint.properties), rawValue: pointer, value: joint))
		}

		return modelSet
	}

	func animatedJoint(offset: Int) -> GoDStructData {
		return .staticString("Animated Joint Not Implemented")
	}

	func animatedMaterialJoint(offset: Int) -> GoDStructData {
		let matAnimJointStruct = GoDStruct(name: "Animated Material Joint", format: [
			.word(name: "Child", description: "", type: .pointer),
			.word(name: "Next", description: "", type: .pointer),
			.word(name: "Animated Material", description: "", type: .pointer)
		])
		let matAnimJoint = GoDStructData(properties: matAnimJointStruct, fileData: data, startOffset: offset)

		if let pointer: Int = matAnimJoint.get("Child") {
			let joint = loadNode(offset: pointer, function: animatedMaterialJoint)
			matAnimJoint.set("Child", to: .pointer(property: .subStruct(name: "Child", description: "", property: joint.properties), rawValue: pointer, value: joint))
		}

		if let pointer: Int = matAnimJoint.get("Next") {
			let joint = loadNode(offset: pointer, function: animatedMaterialJoint)
			matAnimJoint.set("Next", to: .pointer(property: .subStruct(name: "Next", description: "", property: joint.properties), rawValue: pointer, value: joint))
		}

		if let pointer: Int = matAnimJoint.get("Animated Material") {
			let mat = loadNode(offset: pointer, function: animatedMaterial)
			matAnimJoint.set("Animated Material", to: .pointer(property: .subStruct(name: "Animated Material", description: "", property: mat.properties), rawValue: pointer, value: mat))
		}

		return matAnimJoint
	}

	func animatedMaterial(offset: Int) -> GoDStructData {
		let matAnimStruct = GoDStruct(name: "Material Animated Joint", format: [
			.word(name: "Next", description: "", type: .pointer),
			.word(name: "Animated Object", description: "", type: .pointer),
			.word(name: "Animated Texture", description: "", type: .pointer),
			.word(name: "Animated Render", description: "", type: .pointer)
		])
		let matAnim = GoDStructData(properties: matAnimStruct, fileData: data, startOffset: offset)

		if let pointer: Int = matAnim.get("Next") {
			let anim = loadNode(offset: pointer, function: animatedMaterial)
			matAnim.set("Next", to: .pointer(property: .subStruct(name: "Next", description: "", property: anim.properties), rawValue: pointer, value: anim))
		}

		if let pointer: Int = matAnim.get("Animated Object") {
			let anim = loadNode(offset: pointer, function: animatedObject)
			matAnim.set("Animated Object", to: .pointer(property: .subStruct(name: "Animated Object", description: "", property: anim.properties), rawValue: pointer, value: anim))
		}

		if let pointer: Int = matAnim.get("Animated Texture") {
			let anim = loadNode(offset: pointer, function: animatedTexture)
			matAnim.set("Animated Texture", to: .pointer(property: .subStruct(name: "Animated Texture", description: "", property: anim.properties), rawValue: pointer, value: anim))
		}

		if let pointer: Int = matAnim.get("Animated Render") {
			let anim = loadNode(offset: pointer, function: animatedRender)
			matAnim.set("Animated Render", to: .pointer(property: .subStruct(name: "Animated Render", description: "", property: anim.properties), rawValue: pointer, value: anim))
		}

		return matAnim
	}

	func animatedObject(offset: Int) -> GoDStructData {
		return .staticString("Animated Object Not Implemented")
	}

	func animatedRender(offset: Int) -> GoDStructData {
		return .staticString("Animated Render Not Implemented")
	}

	func shapeAnimatedJoint(offset: Int) -> GoDStructData {
		return .staticString("Animated Shape Joint Not Implemented")
	}

	func jointData(offset: Int) -> GoDStructData {
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
			let child = loadNode(offset: pointer, function: jointData)
			joint.set("Child Joint", to: .pointer(property: .subStruct(name: "Joint", description: "", property: child.properties), rawValue: pointer, value: child))
		}

		if let pointer: Int = joint.get("Next Joint") {
			let next = loadNode(offset: pointer, function: jointData)
			joint.set("next Joint", to: .pointer(property: .subStruct(name: "Joint", description: "", property: next.properties), rawValue: pointer, value: next))
		}

		if let bitFields: [String: Bool] = joint.get("Flags"), let pointer: Int = joint.get("Variable Pointer")  {
			let subStruct: GoDStructData
			if bitFields["JOBJ_PTCL"] == true {
				subStruct = loadNode(offset: pointer, function: particles)
			} else if bitFields["JOBJ_SPLINE"] == true {
				subStruct = loadNode(offset: pointer, function: spline)
			} else {
				subStruct = loadNode(offset: pointer, function: mesh)
			}
			joint.set("Variable Pointer", to: .pointer(property: .subStruct(name: subStruct.properties.name, description: "", property: subStruct.properties), rawValue: pointer, value: subStruct))
		}

		return joint
	}

	func spline(offset: Int) -> GoDStructData {
		return .staticString("Spline Not Implemented")
	}

	func particles(offset: Int) -> GoDStructData {
		return .staticString("Particles Not Implemented")
	}

	func mesh(offset: Int) -> GoDStructData {
		let meshStruct = GoDStruct(name: "Mesh", format: [
			.pointer(property:
				.string(name: "Name", description: "", maxCharacterCount: nil, charLength: .char), offsetBy: 0, isShort: false),
			.word(name: "Next Mesh", description: "", type: .pointer),
			.word(name: "M Object", description: "", type: .pointer),
			.word(name: "P Object", description: "", type: .pointer)
		])
		let meshData = GoDStructData(properties: meshStruct, fileData: data, startOffset: offset)

		if let pointer: Int = meshData.get("Next Mesh") {
			let next = loadNode(offset: pointer, function: mesh)
			meshData.set("Next Mesh", to: .pointer(property: .subStruct(name: "Mesh", description: "", property: next.properties), rawValue: pointer, value: next))
		}

		if let pointer: Int = meshData.get("M Object") {
			let obj = loadNode(offset: pointer, function: mObj)
			meshData.set("M Object", to: .pointer(property: .subStruct(name: "M Object", description: "", property: obj.properties), rawValue: pointer, value: obj))
		}

		if let pointer: Int = meshData.get("P Object") {
			let obj = loadNode(offset: pointer, function: pObj)
			meshData.set("P Object", to: .pointer(property: .subStruct(name: "P Object", description: "", property: obj.properties), rawValue: pointer, value: obj))
		}

		return meshData
	}

	func pObj(offset: Int) -> GoDStructData {
		let pobjStruct = GoDStruct(name: "P Object", format: [
			.pointer(property:
				.string(name: "Name", description: "", maxCharacterCount: nil, charLength: .char), offsetBy: 0, isShort: false),
			.word(name: "Next P Object", description: "", type: .pointer),
			.word(name: "Vertices", description: "", type: .pointer),
			.short(name: "Flags", description: "", type: .bitMask),
			.short(name: "Disp List Size", description: "", type: .uint),
			.word(name: "Disp List", description: "", type: .pointer),
			.word(name: "Variable Object", description: "", type: .pointer)

		])
		let pobjData = GoDStructData(properties: pobjStruct, fileData: data, startOffset: offset)

		if let pointer: Int = pobjData.get("Next P Object") {
			let next = loadNode(offset: pointer, function: pObj)
			pobjData.set("Next P Object", to: .pointer(property: .subStruct(name: "P Object", description: "", property: next.properties), rawValue: pointer, value: next))
		}

		if let pointer: Int = pobjData.get("Vertices") {
			let vertices = substructArray(offset: pointer, count: nil, entryLength: vertextStruct.length, propertyFunction: vertex)
			pobjData.set("Vertices", to: .pointer(property: .subStruct(name: vertices.properties.name, description: "", property: vertices.properties), rawValue: pointer, value: vertices))
		}

		if let flags: Int = pobjData.get("Flags"), let pointer: Int = pobjData.get("Variable Pointer") {
			let type = (flags >> 12) & 3
			switch type {
			case 0:
				let joint = loadNode(offset: pointer, function: jointData)
				pobjData.set("Variable Object", to: .pointer(property: .subStruct(name: "Joint", description: "", property: joint.properties), rawValue: pointer, value: joint))
			case 1:
				let shapeSetData = loadNode(offset: pointer, function: shapeSet)
				pobjData.set("Variable Object", to: .pointer(property: .subStruct(name: "Shape Set", description: "", property: shapeSetData.properties), rawValue: pointer, value: shapeSetData))
			default:
				let envelopes = substructArray(offset: pointer, count: nil, entryLength: 8, propertyFunction: envelope)
				pobjData.set("Variable Object", to: .pointer(property: .subStruct(name: envelopes.properties.name, description: "", property: envelopes.properties), rawValue: pointer, value: envelopes))
			}
		}

		return pobjData
	}

	func mObj(offset: Int) -> GoDStructData {
		let mObjectStruct = GoDStruct(name: "M Object", format: [
			.pointer(property:
				.string(name: "Class Name", description: "", maxCharacterCount: nil, charLength: .char), offsetBy: 0, isShort: false),
			.word(name: "Render Mode", description: "", type: .uintHex),
			.word(name: "Texture", description: "", type: .pointer),
			.word(name: "Material", description: "", type: .pointer),
			.word(name: "Render Info", description: "", type: .pointer),
			.word(name: "PE Info", description: "", type: .pointer)
		])

		let mObjectData = GoDStructData(properties: mObjectStruct, fileData: data, startOffset: offset)

		if let pointer: Int = mObjectData.get("Material") {
			let mat = loadNode(offset: pointer, function: material)
			mObjectData.set("Material", to: .pointer(property: .subStruct(name: "Material", description: "", property: mat.properties), rawValue: pointer, value: mat))
		}

		if let pointer: Int = mObjectData.get("Render Info") {
			let render = loadNode(offset: pointer, function: renderInfo)
			mObjectData.set("Render Info", to: .pointer(property: .subStruct(name: "Render Info", description: "", property: render.properties), rawValue: pointer, value: render))
		}

		if let pointer: Int = mObjectData.get("PE Info") {
			let pe = loadNode(offset: pointer, function: peInfo)
			mObjectData.set("PE Info", to: .pointer(property: .subStruct(name: "Material", description: "", property: pe.properties), rawValue: pointer, value: pe))
		}

		if let pointer: Int = mObjectData.get("Texture") {
			let text = loadNode(offset: pointer, function: texture)
			mObjectData.set("Texture", to: .pointer(property: .subStruct(name: "Texture", description: "", property: text.properties), rawValue: pointer, value: text))
		}

		return mObjectData
	}

	func material(offset: Int) -> GoDStructData {
		return .staticString("Material Not Implemented")
	}

	func renderInfo(offset: Int) -> GoDStructData {
		return .staticString("Render Info Not Implemented")
	}

	func shapeSet(offset: Int) -> GoDStructData {
		let shapeSetStruct = GoDStruct(name: "Shape Set", format: [
			.short(name: "Flags", description: "", type: .bitMask),
			.short(name: "Shape Count", description: "", type: .uint),
			.word(name: "Vertex Index Count", description: "", type: .uint),
			.word(name: "Vertices", description: "", type: .pointer),
			.word(name: "Vertex Indices", description: "", type: .pointer),
			.word(name: "Normal Index Count", description: "", type: .uint),
			.word(name: "Normals", description: "", type: .pointer),
			.word(name: "Normal Indices", description: "", type: .pointer)
		])

		let shapeSetData = GoDStructData(properties: shapeSetStruct, fileData: data, startOffset: offset)

		if let pointer: Int = shapeSetData.get("Vertices") {
			let vertices = substructArray(offset: pointer, count: nil, entryLength: vertextStruct.length, propertyFunction: vertex)
			shapeSetData.set("Vertices", to: .pointer(property: .subStruct(name: vertices.properties.name, description: "", property: vertices.properties), rawValue: pointer, value: vertices))
		}

		if let pointer: Int = shapeSetData.get("Normals") {
			let vertices = substructArray(offset: pointer, count: nil, entryLength: vertextStruct.length, propertyFunction: vertex)
			shapeSetData.set("Normals", to: .pointer(property: .subStruct(name: vertices.properties.name, description: "", property: vertices.properties), rawValue: pointer, value: vertices))
		}

		return shapeSetData
	}

	func envelope(offset: Int) -> GoDStructData {
		let envelopeStruct = GoDStruct(name: "Envelope", format: [
			.word(name: "Joint", description: "", type: .pointer),
			.float(name: "Weight", description: "")
		])
		let envelopeData = GoDStructData(properties: envelopeStruct, fileData: data, startOffset: offset)

		if let pointer: Int = envelopeData.get("Joint") {
			let joint = loadNode(offset: pointer, function: jointData)
			envelopeData.set("Joint", to: .pointer(property: .subStruct(name: "Joint", description: "", property: joint.properties), rawValue: pointer, value: joint))
		}

		return envelopeData
	}

	func peInfo(offset: Int) -> GoDStructData {
		return .staticString("PE Info Not Implemented")
	}

	static let paletteStruct = GoDStruct(name: "Palette", format: [
		.word(name: "Palette Pointer", description: "", type: .pointer),
		.word(name: "Palette Format", description: "", type: .paletteFormat),
		.pointer(property:
			.string(name: "Name", description: "", maxCharacterCount: nil, charLength: .char), offsetBy: 0, isShort: false),
		.short(name: "Number Of Entries", description: "", type: .uint)
	])

	static let textureStruct = GoDStruct(name: "Texture", format: [
		.pointer(property:
			.string(name: "Class Name", description: "", maxCharacterCount: nil, charLength: .char), offsetBy: 0, isShort: false),
		.word(name: "Next", description: "", type: .pointer),
		.word(name: "Texture ID", description: "", type: .uint),
		.word(name: "Source", description: "", type: .uint),
		.vector(name: "Rotation", description: ""),
		.vector(name: "Scale", description: ""),
		.vector(name: "Translation", description: ""),
		.word(name: "Wrap S", description: "", type: .bool),
		.word(name: "Wrap T", description: "", type: .bool),
		.byte(name: "Repeat S", description: "", type: .bool),
		.byte(name: "Repeat T", description: "", type: .bool),
		.word(name: "Flag", description: "", type: .bitMask),
		.float(name: "Blending", description: ""),
		.word(name: "Mag Filter", description: "", type: .uint),
		.word(name: "Image", description: "", type: .pointer),
		.pointer(property: .subStruct(name: "Palette", description: "", property: paletteStruct), offsetBy: 0, isShort: false),
		.word(name: "Lod", description: "", type: .pointer),
		.word(name: "TEV", description: "", type: .pointer)
	])

	func texture(offset: Int) -> GoDStructData {
		let textureData = GoDStructData(properties: DATNodes.textureStruct, fileData: data, startOffset: offset)

		if let pointer: Int = textureData.get("Next") {
			let next = loadNode(offset: pointer, function: texture)
			textureData.set("Next", to: .pointer(property: .subStruct(name: "Texture", description: "", property: next.properties), rawValue: pointer, value: next))
		}

		if let pointer: Int = textureData.get("Lod") {
			let lod = loadNode(offset: pointer, function: lodInfo)
			textureData.set("Lod", to: .pointer(property: .subStruct(name: "Lod", description: "", property: lod.properties), rawValue: pointer, value: lod))
		}

		if let pointer: Int = textureData.get("TEV") {
			let tev = loadNode(offset: pointer, function: tevInfo)
			textureData.set("TEV", to: .pointer(property: .subStruct(name: "TEV", description: "", property: tev.properties), rawValue: pointer, value: tev))
		}

		if let pointer: Int = textureData.get("Image") {
			let pointedPalette: GoDStructData? = textureData.get("Palette")
			let imageData = image(offset: pointer, palette: pointedPalette?.get("Palette"))
			textureData.set("Image", to: .pointer(property: .subStruct(name: "Image", description: "", property: imageData.properties), rawValue: pointer, value: imageData))
		}

		return textureData
	}

	func animatedTexture(offset: Int) -> GoDStructData {
		let animatedTextureStruct = GoDStruct(name: "Texture", format: [
			.word(name: "Next", description: "", type: .pointer),
			.word(name: "ID", description: "", type: .uint),
			.word(name: "Animated Object", description: "", type: .pointer),
			.word(name: "Images", description: "", type: .pointer),
			.word(name: "Palettes", description: "", type: .pointer),
			.short(name: "Number Of Images", description: "", type: .uint),
			.short(name: "Number Of Palettes", description: "", type: .uint)
		])

		let animatedTextureData = GoDStructData(properties: animatedTextureStruct, fileData: data, startOffset: offset)

		if let pointer: Int = animatedTextureData.get("Next") {
			let next = loadNode(offset: pointer, function: animatedTexture)
			animatedTextureData.set("Next", to: .pointer(property: .subStruct(name: "Animated Texture", description: "", property: next.properties), rawValue: pointer, value: next))
		}

		if let pointer: Int = animatedTextureData.get("Animated Object") {
			let anim = loadNode(offset: pointer, function: animatedObject)
			animatedTextureData.set("Animated Object", to: .pointer(property: .subStruct(name: "Animated Object", description: "", property: anim.properties), rawValue: pointer, value: anim))
		}

		var palettesInfo: [GoDStructData]?
		if let pointer: Int = animatedTextureData.get("Palettes") {
			let paletteCount = animatedTextureData.get("Number Of Palettes") ?? 0
			let palettes = GoDStructData(
				properties: GoDStruct(name: "Palettes Array",
									  format: [.array(name: "Palettes", description: "", property:
													.pointer(property:
														.subStruct(name: "Palette", description: "", property: DATNodes.paletteStruct), offsetBy: 0, isShort: false), count: paletteCount)]),
				fileData: data,
				startOffset: pointer)
			palettesInfo = palettes.get("Palettes")
			animatedTextureData.set("Palettes", to: .pointer(property: .subStruct(name: "Palettes Array", description: "", property: palettes.properties), rawValue: pointer, value: palettes))
		}

		if let pointer: Int = animatedTextureData.get("Images") {
			let imagesCount: Int = animatedTextureData.get("Number Of Images") ?? 0
			let images = GoDStructData(
				properties: GoDStruct(name: "Images Array",
									  format: [.array(name: "Images Array", description: "", property:
													.word(name: "Image Pointer", description: "", type: .pointer), count: imagesCount)]),
				fileData: data,
				startOffset: pointer)
			let imagePointers: [Int] = images.get("Images Array") ?? []
			var imagesData = [GoDStructValues]()
			for i in 0 ..< imagePointers.count {
				let imagePointer = imagePointers[i]
				let paletteData: GoDStructData? = i < (palettesInfo?.count ?? 0) ? palettesInfo![i].get("Palette") : nil
				let imageData = image(offset: imagePointer, palette: paletteData)
				imagesData.append(.pointer(property: .word(name: "Image Pointer", description: "", type: .pointer), rawValue: imagePointer, value: imageData))
			}
			images.set("Images Array", to: .array(property: .array(name: "Images Array", description: "", property:
																.word(name: "Image Pointer", description: "", type: .pointer), count: imagesCount),
												  rawValues: imagesData))
			animatedTextureData.set("Images", to: .pointer(property: .subStruct(name: "Images Array", description: "", property: images.properties), rawValue: pointer, value: images))
		}

		return animatedTextureData
	}

	func lodInfo(offset: Int) -> GoDStructData {
		return .staticString("Lod Not Implemented")
	}

	func tevInfo(offset: Int) -> GoDStructData {
		return .staticString("TEV Info Not Implemented")
	}

	func image(offset: Int, palette: GoDStructData?) -> GoDStructData {
		if let imageData = nodesCache[offset] {
			return imageData
		}
		let imageStruct = GoDStruct(name: "Image", format: [
			.word(name: "Image Data Pointer", description: "", type: .pointer),
			.short(name: "Width", description: "", type: .uint),
			.short(name: "Height", description: "", type: .uint),
			.word(name: "Texture Format", description: "", type: .textureFormat),
			.word(name: "Mip Map", description: "", type: .uint),
			.float(name: "minLOD", description: ""),
			.float(name: "maxLOD", description: "")
		])

		let imageMetaData = GoDStructData(properties: imageStruct, fileData: data, startOffset: offset)

		if let imageDataPointer: Int = imageMetaData.get("Image Data Pointer") {
			if !textureDataOffsets.contains(imageDataPointer) {
				textureDataOffsets.append(imageDataPointer)
				textureHeaderOffsets.append(offset + 4)
				texturePalettes.append((format: palette?.get("Palette Format"),
										offset: palette?.get("Palette Pointer"),
										numberOfEntries: palette?.get("Number Of Entries") ?? 0))
			}
		}

		nodesCache[offset] = imageMetaData
		return imageMetaData
	}

	let vertextStruct = GoDStruct(name: "Vertex", format: [
		.word(name: "Attribute", description: "", type: .uint),
		.word(name: "Attribute Type", description: "", type: .uint),
		.word(name: "Component Count", description: "", type: .uint),
		.word(name: "Component Type", description: "", type: .uint),
		.byte(name: "Component Frac", description: "", type: .int),
		.short(name: "Stride", description: "", type: .uint),
		.word(name: "Data", description: "", type: .pointer)
	])

	func vertex(offset: Int) -> GoDStructData {
		let vertexData = GoDStructData(properties: vertextStruct, fileData: data, startOffset: offset)

		if let attribute: Int = vertexData.get("Attribute"),
		   let compType: Int = vertexData.get("Component Type"),
		   let stride: Int = vertexData.get("Stride"),
		   let pointer: Int = vertexData.get("Data"),
		   vertexColours[pointer] == nil,
		   validate(offset: pointer) {

			let format: ColourFormat
			if attribute == 11 || attribute == 12 {
				switch compType {
				case 1: format = .RGB8
				case 2: format = .RGBX8
				case 3: format = .RGBA4
				case 4: format = .RGBA6
				case 5: format = .RGBA8
				default: format = .RGB565
				}

				let colourData = colourList(offset: pointer, format: format, colourLength: stride)
				vertexData.set("Data", to: .pointer(property: .subStruct(name: "Vertex Colours", description: "", property: colourData.properties), rawValue: pointer, value: colourData))
			}
		}

		return vertexData
	}

	func colourList(offset: Int, format: ColourFormat, colourLength: Int) -> GoDStructData {
		guard validate(offset: offset) else { return .staticString("Error") }
		if let cached = nodesCache[offset] { return cached }
		var values = [GoDStructValues]()
		var currentOffset = offset
		var property: GoDStruct?

		while true {
			guard validate(offset: currentOffset), !isNullData(offset: currentOffset, length: 4) else {
				break
			}

			let colourData = colour(offset: currentOffset, format: format)

			property = colourData.properties
			values.append(.subStruct(property: .subStruct(name: property!.name, description: "", property: property!), data: colourData))

			currentOffset += colourLength
		}

		let listData = GoDStructData(fileData: data, startOffset: offset, properties: GoDStruct(name: (property?.name ?? "Empty") + " List", format: [
			.array(name: "Values", description: "", property: .subStruct(name: property?.name ?? "Empty", description: "", property: property ?? .dummy), count: values.count)
		]), values: [
			.array(property: .subStruct(name: (property?.name ?? "Empty") + " List", description: "", property: property ?? .dummy), rawValues: values)
		])

		nodesCache[offset] = listData
		return listData
	}

	func colour(offset: Int, format: ColourFormat) -> GoDStructData {
		guard validate(offset: offset) else { return .staticString("Error") }
		if let cached = nodesCache[offset] { return cached }

		let dataFormat: GoDStruct
		switch format {
		case .RGBA8:
			dataFormat = GoDStruct(name: "RGBA8 Colour", format: [
				.byte(name: "Red", description: "", type: .uintHex),
				.byte(name: "Green", description: "", type: .uintHex),
				.byte(name: "Blue", description: "", type: .uintHex),
				.byte(name: "Alpha", description: "", type: .uintHex)
			])
		case .RGBA6:
			dataFormat = GoDStruct(name: "RGBA6 Colour", format: [
				.bitMask(name: "Channels", description: "Last byte is unrelate to colour. Side effect of loading whole word at once.", length: .word, values: [
					(name: "Red", type: .uintHex, numberOfBits: 6, firstBitIndexLittleEndian: 26, mod: nil, div: nil, scale: 4),
					(name: "Green", type: .uintHex, numberOfBits: 6, firstBitIndexLittleEndian: 20, mod: nil, div: nil, scale: 4),
					(name: "Blue", type: .uintHex, numberOfBits: 6, firstBitIndexLittleEndian: 14, mod: nil, div: nil, scale: 4),
					(name: "Alpha", type: .uintHex, numberOfBits: 6, firstBitIndexLittleEndian: 8, mod: nil, div: nil, scale: 4),
					(name: "Rest of word", type: .uintHex, numberOfBits: 8, firstBitIndexLittleEndian: 0, mod: nil, div: nil, scale: nil),
				])
			])
		case .RGBA4:
			dataFormat = GoDStruct(name: "RGBA4 Colour", format: [
				.bitMask(name: "Channels", description: "", length: .short, values: [
					(name: "Red", type: .uintHex, numberOfBits: 4, firstBitIndexLittleEndian: 12, mod: nil, div: nil, scale: 16),
					(name: "Green", type: .uintHex, numberOfBits: 4, firstBitIndexLittleEndian: 8, mod: nil, div: nil, scale: 16),
					(name: "Blue", type: .uintHex, numberOfBits: 4, firstBitIndexLittleEndian: 4, mod: nil, div: nil, scale: 16),
					(name: "Alpha", type: .uintHex, numberOfBits: 4, firstBitIndexLittleEndian:  0, mod: nil, div: nil, scale: 16),
				])
			])
		case .RGBX8:
			dataFormat = GoDStruct(name: "RGBX8 Colour", format: [
				.byte(name: "Red", description: "", type: .uintHex),
				.byte(name: "Green", description: "", type: .uintHex),
				.byte(name: "Blue", description: "", type: .uintHex),
				.byte(name: "X", description: "", type: .uintHex)
			])
		case .RGB8:
			dataFormat = GoDStruct(name: "RGB8 Colour", format: [
				.byte(name: "Red", description: "", type: .uintHex),
				.byte(name: "Green", description: "", type: .uintHex),
				.byte(name: "Blue", description: "", type: .uintHex)
			])
		case .RGB565:
			dataFormat = GoDStruct(name: "RGB565 Colour", format: [
				.bitMask(name: "Channels", description: "", length: .short, values: [
					(name: "Red", type: .uintHex, numberOfBits: 5, firstBitIndexLittleEndian: 11, mod: nil, div: nil, scale: 8),
					(name: "Green", type: .uintHex, numberOfBits: 6, firstBitIndexLittleEndian: 5, mod: nil, div: nil, scale: 4),
					(name: "Blue", type: .uintHex, numberOfBits: 5, firstBitIndexLittleEndian: 0, mod: nil, div: nil, scale: 8)
				])
			])
		}

		let colourData = GoDStructData(properties: dataFormat, fileData: data, startOffset: offset)
		nodesCache[offset] = colourData
		let vertexColour = VertexColour(data: colourData)
		vertexColours[offset] = vertexColour
		return colourData
	}
}
