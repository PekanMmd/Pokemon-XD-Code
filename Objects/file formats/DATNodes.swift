//
//  DATNodes.swift
//  GoD Tool
//
//  Created by Stars Momodu on 02/04/2021.
//

import Foundation

class DATNodes {
	var textureHeaderOffsets = [Int]()
	var textureDataOffsets = [Int]()
	var texturePalettes = [(format: Int?, offset: Int?, numberOfEntries: Int)]()

	private let data: XGMutableData
	var rootNode = GoDStructData.staticString("Null")

	private var previouslySeenNodes = [Int]()

	func validate(offset: Int) -> Bool {
		return offset > 0 && offset < data.length
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

	func rootNodeStructData(offset: Int, stringsOffset: Int) -> GoDStructData {
		guard validate(offset: offset) else { return .staticString("Error") }
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
		case "scene_data": subStruct = sceneData(offset: pointer)
		case "bound_box": subStruct = boundBox(offset: pointer)
		default: return rootNodeTypeData
		}

		rootNodeTypeData.set("Pointer", to: .pointer(property: .subStruct(name: "Root Node \(typeName)", description: "", property: subStruct.properties), rawValue: pointer, value: subStruct))
		return rootNodeTypeData
	}

	func sceneData(offset: Int) -> GoDStructData {
		guard validate(offset: offset) else { return .staticString("Error") }
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
			let array = modelSetsArray(offset: pointer)
			sceneData.set("Model Sets Array", to: .pointer(property: .subStruct(name: "Model Sets Array", description: "", property: array.properties), rawValue: pointer, value: array))
		}

		if let pointer: Int = sceneData.get("Camera Set") {
			let set = cameraSet(offset: pointer)
			sceneData.set("Camera Set", to: .pointer(property: .subStruct(name: "Camera Set", description: "", property: set.properties), rawValue: pointer, value: set))
		}

		if let pointer: Int = sceneData.get("Light Set") {
			let set = lightSet(offset: pointer)
			sceneData.set("Light Set", to: .pointer(property: .subStruct(name: "Light Set", description: "", property: set.properties), rawValue: pointer, value: set))
		}

		if let pointer: Int = sceneData.get("Fog Data") {
			let set = cameraSet(offset: pointer)
			sceneData.set("Fog Data", to: .pointer(property: .subStruct(name: "Fog Data", description: "", property: set.properties), rawValue: pointer, value: set))
		}

		return sceneData
	}

	func boundBox(offset: Int) -> GoDStructData {
		guard validate(offset: offset) else { return .staticString("Error") }
		return .staticString("Bound Box Not Implemented")
	}

	func cameraSet(offset: Int) -> GoDStructData {
		guard validate(offset: offset) else { return .staticString("Error") }
		return .staticString("Camera Set Not Implemented")
	}

	func lightSet(offset: Int) -> GoDStructData {
		guard validate(offset: offset) else { return .staticString("Error") }
		return .staticString("Light Set Not Implemented")
	}

	func fogData(offset: Int) -> GoDStructData {
		guard validate(offset: offset) else { return .staticString("Error") }
		return .staticString("Fog Data Not Implemented")
	}

	func modelSetsArray(offset: Int) -> GoDStructData {
		guard validate(offset: offset) else { return .staticString("Error") }
		let modelSetsArrayStruct = GoDStruct(name: "Model Sets Array", format: [
			.array(name: "Model Sets", description: "", property: .word(name: "Model Set Pointers", description: "", type: .pointer), count: nil)
		])
		let modelSetsArray = GoDStructData(properties: modelSetsArrayStruct, fileData: data, startOffset: offset)
		var modelSets = [GoDStructData]()
		if let pointers: [Int] = modelSetsArray.get("Model Sets") {
			pointers.forEach { (pointer) in
				let set = modelSet(offset: pointer)
				modelSets.append(set)
			}
		}
		modelSetsArray.set("Model Sets", to: .array(property: modelSetsArrayStruct.format[0], rawValues: modelSets.map({ (set) -> GoDStructValues in
			return .pointer(property: .subStruct(name: "Model Set", description: "", property: set.properties), rawValue: set.startOffset, value: set)
		})))
		return modelSetsArray
	}

	func modelSet(offset: Int) -> GoDStructData {
		guard validate(offset: offset) else { return .staticString("Error") }
		let modelSetStruct = GoDStruct(name: "Model Set", format: [
			.word(name: "Joint", description: "", type: .pointer),
			.word(name: "Animated Joint", description: "", type: .pointer),
			.word(name: "Animated Material Joint", description: "", type: .pointer),
			.word(name: "Animated Shape Joint", description: "", type: .pointer)
		])
		let modelSet = GoDStructData(properties: modelSetStruct, fileData: data, startOffset: offset)

		if let pointer: Int = modelSet.get("Joint") {
			let joint = jointData(offset: pointer)
			modelSet.set("Joint", to: .pointer(property: .subStruct(name: "Joint", description: "", property: joint.properties), rawValue: pointer, value: joint))
		}

		if let pointer: Int = modelSet.get("Animated Joint") {
			let joint = animatedJoint(offset: pointer)
			modelSet.set("Animated Joint", to: .pointer(property: .subStruct(name: "Animated Joint", description: "", property: joint.properties), rawValue: pointer, value: joint))
		}

		if let pointer: Int = modelSet.get("Animated Material Joint") {
			let joint = animatedMaterialJoint(offset: pointer)
			modelSet.set("Animated Material Joint", to: .pointer(property: .subStruct(name: "Animated Material Joint", description: "", property: joint.properties), rawValue: pointer, value: joint))
		}

		if let pointer: Int = modelSet.get("Animated Shape Joint") {
			let joint = shapeAnimatedJoint(offset: pointer)
			modelSet.set("Animated Shape Joint", to: .pointer(property: .subStruct(name: "Animated Shape Joint", description: "", property: joint.properties), rawValue: pointer, value: joint))
		}

		return modelSet
	}

	func animatedJoint(offset: Int) -> GoDStructData {
		guard validate(offset: offset) else { return .staticString("Error") }
		return .staticString("Animated Joint Not Implemented")
	}

	func animatedMaterialJoint(offset: Int) -> GoDStructData {
		guard validate(offset: offset) else { return .staticString("Error") }
		let matAnimJointStruct = GoDStruct(name: "Animated Material Joint", format: [
			.word(name: "Child", description: "", type: .pointer),
			.word(name: "Next", description: "", type: .pointer),
			.word(name: "Animated Material", description: "", type: .pointer)
		])
		let matAnimJoint = GoDStructData(properties: matAnimJointStruct, fileData: data, startOffset: offset)

		if let pointer: Int = matAnimJoint.get("Child") {
			let joint = animatedMaterialJoint(offset: pointer)
			matAnimJoint.set("Child", to: .pointer(property: .subStruct(name: "Child", description: "", property: joint.properties), rawValue: pointer, value: joint))
		}

		if let pointer: Int = matAnimJoint.get("Next") {
			let joint = animatedMaterialJoint(offset: pointer)
			matAnimJoint.set("Next", to: .pointer(property: .subStruct(name: "Next", description: "", property: joint.properties), rawValue: pointer, value: joint))
		}

		if let pointer: Int = matAnimJoint.get("Animated Material") {
			let mat = animatedMaterial(offset: pointer)
			matAnimJoint.set("Animated Material", to: .pointer(property: .subStruct(name: "Animated Material", description: "", property: mat.properties), rawValue: pointer, value: mat))
		}

		return matAnimJoint
	}

	func animatedMaterial(offset: Int) -> GoDStructData {
		guard validate(offset: offset) else { return .staticString("Error") }
		let matAnimStruct = GoDStruct(name: "Material Animated Joint", format: [
			.word(name: "Next", description: "", type: .pointer),
			.word(name: "Animated Object", description: "", type: .pointer),
			.word(name: "Animated Texture", description: "", type: .pointer),
			.word(name: "Animated Render", description: "", type: .pointer)
		])
		let matAnim = GoDStructData(properties: matAnimStruct, fileData: data, startOffset: offset)

		if let pointer: Int = matAnim.get("Next") {
			let anim = animatedMaterial(offset: pointer)
			matAnim.set("Next", to: .pointer(property: .subStruct(name: "Next", description: "", property: anim.properties), rawValue: pointer, value: anim))
		}

		if let pointer: Int = matAnim.get("Animated Object") {
			let anim = animatedObject(offset: pointer)
			matAnim.set("Animated Object", to: .pointer(property: .subStruct(name: "Animated Object", description: "", property: anim.properties), rawValue: pointer, value: anim))
		}

		if let pointer: Int = matAnim.get("Animated Texture") {
			let anim = animatedTexture(offset: pointer)
			matAnim.set("Animated Texture", to: .pointer(property: .subStruct(name: "Animated Texture", description: "", property: anim.properties), rawValue: pointer, value: anim))
		}

		if let pointer: Int = matAnim.get("Animated Render") {
			let anim = animatedRender(offset: pointer)
			matAnim.set("Animated Render", to: .pointer(property: .subStruct(name: "Animated Render", description: "", property: anim.properties), rawValue: pointer, value: anim))
		}

		return matAnim
	}

	func animatedObject(offset: Int) -> GoDStructData {
		guard validate(offset: offset) else { return .staticString("Error") }
		return .staticString("Animated Object Not Implemented")
	}

	func animatedRender(offset: Int) -> GoDStructData {
		guard validate(offset: offset) else { return .staticString("Error") }
		return .staticString("Animated Render Not Implemented")
	}

	func shapeAnimatedJoint(offset: Int) -> GoDStructData {
		guard validate(offset: offset) else { return .staticString("Error") }
		return .staticString("Animated Shape Joint Not Implemented")
	}

	func jointData(offset: Int) -> GoDStructData {
		guard validate(offset: offset) else { return .staticString("Error") }
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

		if let pointer: Int = joint.get("Child Joint"), !previouslySeenNodes.contains(pointer) {
			previouslySeenNodes.addUnique(pointer)
			let child = jointData(offset: pointer)
			joint.set("Child Joint", to: .pointer(property: .subStruct(name: "Joint", description: "", property: child.properties), rawValue: pointer, value: child))
		}

		if let pointer: Int = joint.get("Next Joint"), !previouslySeenNodes.contains(pointer) {
			previouslySeenNodes.addUnique(pointer)
			let next = jointData(offset: pointer)
			joint.set("next Joint", to: .pointer(property: .subStruct(name: "Joint", description: "", property: next.properties), rawValue: pointer, value: next))
		}

		if let bitFields: [String: Bool] = joint.get("Flags"), let pointer: Int = joint.get("Variable Pointer")  {
			let subStruct: GoDStructData
			if bitFields["JOBJ_PTCL"] == true {
				subStruct = particles(offset: pointer)
			} else if bitFields["JOBJ_SPLINE"] == true {
				subStruct = spline(offset: pointer)
			} else {
				subStruct = mesh(offset: pointer)
			}
			joint.set("Variable Pointer", to: .pointer(property: .subStruct(name: subStruct.properties.name, description: "", property: subStruct.properties), rawValue: pointer, value: subStruct))
		}

		return joint
	}

	func spline(offset: Int) -> GoDStructData {
		guard validate(offset: offset) else { return .staticString("Error") }
		return .staticString("Spline Not Implemented")
	}

	func particles(offset: Int) -> GoDStructData {
		guard validate(offset: offset) else { return .staticString("Error") }
		return .staticString("Particles Not Implemented")
	}

	func mesh(offset: Int) -> GoDStructData {
		guard validate(offset: offset) else { return .staticString("Error") }
		let meshStruct = GoDStruct(name: "Mesh", format: [
			.pointer(property:
				.string(name: "Name", description: "", maxCharacterCount: nil, charLength: .char), offsetBy: 0, isShort: false),
			.word(name: "Next Mesh", description: "", type: .pointer),
			.word(name: "M Object", description: "", type: .pointer),
			.word(name: "P Object", description: "", type: .pointer)
		])
		let meshData = GoDStructData(properties: meshStruct, fileData: data, startOffset: offset)

		if let pointer: Int = meshData.get("Next Mesh") {
			let next = mesh(offset: pointer)
			meshData.set("Next Mesh", to: .pointer(property: .subStruct(name: "Mesh", description: "", property: next.properties), rawValue: pointer, value: next))
		}

		if let pointer: Int = meshData.get("M Object") {
			let obj = mObj(offset: pointer)
			meshData.set("M Object", to: .pointer(property: .subStruct(name: "M Object", description: "", property: obj.properties), rawValue: pointer, value: obj))
		}

		if let pointer: Int = meshData.get("P Object") {
			let obj = pObj(offset: pointer)
			meshData.set("P Object", to: .pointer(property: .subStruct(name: "P Object", description: "", property: obj.properties), rawValue: pointer, value: obj))
		}

		return meshData
	}

	func pObj(offset: Int) -> GoDStructData {
		guard validate(offset: offset) else { return .staticString("Error") }
		return .staticString("P Object Not Implemented")
	}

	func mObj(offset: Int) -> GoDStructData {
		guard validate(offset: offset) else { return .staticString("Error") }
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
			let mat = material(offset: pointer)
			mObjectData.set("Material", to: .pointer(property: .subStruct(name: "Material", description: "", property: mat.properties), rawValue: pointer, value: mat))
		}

		if let pointer: Int = mObjectData.get("Render Info") {
			let render = renderInfo(offset: pointer)
			mObjectData.set("Render Info", to: .pointer(property: .subStruct(name: "Render Info", description: "", property: render.properties), rawValue: pointer, value: render))
		}

		if let pointer: Int = mObjectData.get("PE Info") {
			let pe = peInfo(offset: pointer)
			mObjectData.set("PE Info", to: .pointer(property: .subStruct(name: "Material", description: "", property: pe.properties), rawValue: pointer, value: pe))
		}

		if let pointer: Int = mObjectData.get("Texture") {
			let text = texture(offset: pointer)
			mObjectData.set("Texture", to: .pointer(property: .subStruct(name: "Texture", description: "", property: text.properties), rawValue: pointer, value: text))
		}

		return mObjectData
	}

	func material(offset: Int) -> GoDStructData {
		guard validate(offset: offset) else { return .staticString("Error") }
		return .staticString("Material Not Implemented")
	}

	func renderInfo(offset: Int) -> GoDStructData {
		guard validate(offset: offset) else { return .staticString("Error") }
		return .staticString("Render Info Not Implemented")
	}

	func peInfo(offset: Int) -> GoDStructData {
		guard validate(offset: offset) else { return .staticString("Error") }
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
		guard validate(offset: offset) else { return .staticString("Error") }
		let textureData = GoDStructData(properties: DATNodes.textureStruct, fileData: data, startOffset: offset)

		if let pointer: Int = textureData.get("Next") {
			let next = texture(offset: pointer)
			textureData.set("Next", to: .pointer(property: .subStruct(name: "Texture", description: "", property: next.properties), rawValue: pointer, value: next))
		}

		if let pointer: Int = textureData.get("Lod") {
			let lod = lodInfo(offset: pointer)
			textureData.set("Lod", to: .pointer(property: .subStruct(name: "Lod", description: "", property: lod.properties), rawValue: pointer, value: lod))
		}

		if let pointer: Int = textureData.get("TEV") {
			let tev = tevInfo(offset: pointer)
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
		guard validate(offset: offset) else { return .staticString("Error") }
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
			let next = animatedTexture(offset: pointer)
			animatedTextureData.set("Next", to: .pointer(property: .subStruct(name: "Animated Texture", description: "", property: next.properties), rawValue: pointer, value: next))
		}

		if let pointer: Int = animatedTextureData.get("Animated Object") {
			let anim = animatedObject(offset: pointer)
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
		guard validate(offset: offset) else { return .staticString("Error") }
		return .staticString("Lod Not Implemented")
	}

	func tevInfo(offset: Int) -> GoDStructData {
		guard validate(offset: offset) else { return .staticString("Error") }
		return .staticString("TEV Info Not Implemented")
	}

	func image(offset: Int, palette: GoDStructData?) -> GoDStructData {
		guard validate(offset: offset) else { return .staticString("Error") }
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

		return imageMetaData
	}

}
