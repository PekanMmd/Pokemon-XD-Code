//
//  main.swift
//  XGCommandLineTools
//
//  Created by StarsMmd on 13/11/2015.
//  Copyright © 2015 StarsMmd. All rights reserved.
//
//

XGFiles.common_rel.writeScriptData()

////Auto add pov code to all scripts in XDS folder
//for file in  XGFolders.XDS.files where file.fileType == .xds {
//	var text = file.text
//	text = text.replacingOccurrences(of: "// Macro defintions\n", with: "// Macro defintions\ndefine #enablePOVFlag 983\n")
//	text = text.replacingOccurrences(of: "\nfunction @preprocess() {\n", with: "global enablePOV = NO\n\nfunction @preprocess() {\n\tenablePOV = getFlag(#enablePOVFlag)\n")
//	text = text.replacingOccurrences(of: "function @hero_main() {\n", with: """
//	function @hero_main() {
//
//	\tcameraXRotation = 0.0
//	\tcurrentCameraBounce = 0.0
//	\tcameraBounceRadius = 0.5
//	\tcameraBounceFramesPerCycle = 0
//	\tcameraBounceMINFramesPerCycle = 15.0
//	\tcameraHeight = 12.0
//	\tfieldOfView = 60
//	\tcameraXRotationPerFrameDegrees = 5.0
//	\tcameraRadius = 5 // how far away the camera should be so it isn't inside michael
//
//
//	""")
//
//	let cameraControlText = """
//	\n\nif (Controller.isZButtonPressed() = YES) {
//		enablePOV = enablePOV ^ YES
//		if (enablePOV = NO) {
//			Camera.reset()
//			setFlagToFalse(#enablePOVFlag)
//		}
//
//		if (enablePOV = YES) {
//			setFlagToTrue(#enablePOVFlag)
//		}
//	}
//
//	if (enablePOV = YES) {
//		position = #player.getPosition()
//		angle = #player.getRotation()
//		pi = 3.141592
//		angleRadians = -((((180 - angle) * 2) * pi) / 360.0)
//
//		cameraXRotationPerFrameRadians = ((cameraXRotationPerFrameDegrees * 2) * pi) / 360.0
//
//		playerSpeed = #player.getMovementSpeed()
//		isWalking = playerSpeed > 0.0
//
//		if (isWalking = YES) {
//			cameraBounceFramesPerCycle = cameraBounceMINFramesPerCycle / playerSpeed
//			if (cameraBounceFramesPerCycle > 0) {
//				currentCameraBounce = currentCameraBounce + (360.0 / cameraBounceFramesPerCycle)
//			}
//		}
//
//		if (isWalking = NO) {
//			currentCameraBounce = 0
//		}
//		if (currentCameraBounce > 360) {
//			currentCameraBounce = currentCameraBounce - 360
//		}
//
//		cameraBounceSinDisplacement = sin(currentCameraBounce)
//		currentCameraBounceAdjusted = cameraBounceRadius * cameraBounceSinDisplacement
//
//		if ((Controller.isRButtonPressed()) and (cameraXRotation <= (pi / 2))) {
//			cameraXRotation = cameraXRotation + cameraXRotationPerFrameRadians
//		}
//		if ((Controller.isLButtonPressed()) and (cameraXRotation >= -((pi / 2)))) {
//			cameraXRotation = cameraXRotation - cameraXRotationPerFrameRadians
//		}
//		//if (Controller.isZButtonPressed()) {  // maybe use a d-pad button here for resetting the camera
//		//   cameraXRotation = 0
//		//}
//
//		// Use trig to figure out how far away the camera should be from michael in the x and z axes
//		if (angle < 90) {
//			vx = cameraRadius * sin(angle)
//			vz = cameraRadius * cos(angle)
//			goto @angleEnd
//		}
//		if (angle < 180) {
//			vx = cameraRadius * sin((180 - angle))
//			vz = 0 - (cameraRadius * cos((180 - angle)))
//			goto @angleEnd
//		}
//		if (angle < 270) {
//			vx = 0 - (cameraRadius * sin((angle - 180)))
//			vz = 0 - (cameraRadius * cos((angle - 180)))
//			goto @angleEnd
//		}
//		vx = -(cameraRadius * sin((360 - angle)))
//		vz = cameraRadius * cos((360 - angle))
//		@angleEnd
//
//		Camera.function48()  // don't know what this does yet
//		Camera.setPosition2((getvx(position) + vx) ((getvy(position) + cameraHeight) + currentCameraBounceAdjusted) (getvz(position) + vz))
//		Camera.setRotationAboutAxesRadians(cameraXRotation angleRadians 0)
//		Camera.setFieldOfView(fieldOfView)
//	}
//
//	Player.processEvents()
//	yield(1)
//	""".replacingOccurrences(of: "\n", with: "\n    ")
//
//	text = text.replacingOccurrences(of:
//	"\n    Player.processEvents()\n    yield(1)", with: cameraControlText)
//
//	text = text.replacingOccurrences(of:
//		"\n    var_1.Player.processEvents()\n    yield(1)", with: cameraControlText.replacingOccurrences(of: "Player.processEvents()", with: "var_1.Player.processEvents()"))
//
//	XGUtility.saveString(text, toFile: file)
//}

//XGDolPatcher.zeroForeignStringTables()
//let freeSpacePointer = XGAssembly.ASMfreeSpacePointer()
//printg(freeSpacePointer.hexString())
//XGScriptClass.createCustomClass(withIndex: 34, atRAMOffset: freeSpacePointer, numberOfFunctions: 256)

//// Make sure to add these after code above is run before adding the class functions
//let jumpTableRAMOffset = 0x80B99390
//let customClassReturnOffset: UInt32 = 0x80B99378
//
//// Add custom class functions for reading from z, r and l triggers
//for i in 0 ... 2 {
//	let freeSpacePointer2 = XGAssembly.ASMfreeSpacePointer()
//	let p1PadButtonPressMaskOffset: UInt32 = 0x80444b20
//	let buttonMask: UInt32 = UInt32(1 << (i + 4))
//
//	XGScriptClass.addASMFunctionToCustomClass(jumpTableRAMOffset: jumpTableRAMOffset, functionIndex: i, codeOffsetInRAM: freeSpacePointer2, code: [
//		XGASM.loadImmediateShifted32bit(register: .r3, value: p1PadButtonPressMaskOffset).0,
//		XGASM.loadImmediateShifted32bit(register: .r3, value: p1PadButtonPressMaskOffset).1,
//		.lha(.r3, .r3, 0),
//		.andi_(.r3, .r3, buttonMask),
//		.srawi(.r3, .r3, UInt32(i) + 4),
//		.stw(.r3, .r4, 4),
//		.li(.r3, 1),
//		.sth(.r3, .r4, 0),
//		XGASM.loadImmediateShifted32bit(register: .r4, value: customClassReturnOffset).0,
//		XGASM.loadImmediateShifted32bit(register: .r4, value: customClassReturnOffset).1,
//		.mr(.r0, .r4),
//		.mtctr(.r0),
//		.bctr
//	])
//}

//XGUtility.compileMainFiles()

// Don't forget to update the custom script classes JSON to include the new class and functions before compiling scripts

//for file in XGFolders.XDS.files where file.fileType == .xds {
//	printg("Compiling script:", file.fileName)
//	XDSScriptCompiler.compile(textFile: file, toFile: .scd(file.fileName.removeFileExtensions()))
//}
//
//XGUtility.compileAllMapFsys()





//XGUtility.saveMewTutorMovePairs()
//print((XGDemoStarterPokemon(index: 1).startOffset + kDolToRAMOffsetDifference + 0x92).hexString())

//XGDecks.DeckDarkPokemon.allDeckPokemon.forEach { (mon) in
//    if mon.data.species.catchRate != mon.data.shadowCatchRate {
//        print(mon.data.species.name, mon.data.species.catchRate, mon.data.shadowCatchRate)
//    }
//}
//XGUtility.documentISO()

//XGTrainerClasses.documentEnumerationData()
//XGUtility.encodeISO()
//
//var shouldEnd = false
//while !shouldEnd {
//	if let input = readLine(), input.contains("c") {
//		XGUtility.cancelEncoding()
//		shouldEnd = true
//	}
//}
//
//for id in [20, 83, 18] {
//	let mon = XGTrainerPokemon(DeckData: .ddpk(id))
//	mon.shadowAlwaysFlee = 0
//	mon.save()
//}
//
//for id in [31, 16, 22] {
//	let mon = XGTrainerPokemon(DeckData: .ddpk(id))
//	mon.shadowAlwaysFlee = 1
//	mon.save()
//}
//XGUtility.compileAllFiles()
//
//for mon in XGDecks.DeckDarkPokemon.allPokemon {
//	print(mon.deckData.index,mon.species.name, mon.shadowAlwaysFlee)
//}

//XGUtility.printOccurencesOfMove(search: move("bounce"))
//XGUtility.documentISO()

//let imageFile = XGFiles.nameAndFolder("uv_icn_type_big_00.gtx.png", .Import)
//let image = imageFile.image
//for texture in GoDTextureImporter.getMultiFormatTextureData(image: image) {
//	let fileName = imageFile.fileName.removeFileExtensions() + "_" + texture.format.name + ".gtx"
//	texture.file = .nameAndFolder(fileName, .Documents)
//	texture.save()
//	texture.saveImage(file: .nameAndFolder(fileName + ".png", .Documents))
//}

//XGUtility.exportTextures()
//
//let filename = "types"
//let image = XGFiles.nameAndFolder(filename + ".png", .Import).image
//let t = GoDTextureImporter.getTextureData(image: image)
//t.file = .nameAndFolder(filename + ".gtx", .TextureImporter)
//t.save()
//t.saveImage(file: .nameAndFolder(filename + ".png", .TextureImporter))


//for image in XGFolders.Import.files where image.fileType == .png {
//	let texture = GoDTextureImporter.getTextureData(image: image.image)
//	let filename = image.fileName + "_" + texture.format.name
//	texture.file = .nameAndFolder(filename + ".gtx", .TextureImporter)
//	texture.save()
//	texture.saveImage(file: .nameAndFolder(filename + ".png", .TextureImporter))
//}


//let count = CommonIndexes.NumberBGM.value
//let start = CommonIndexes.BGM.startOffset
////let rel = XGFiles.common_rel.data!
//
//printg(count)
//for i in 0 ..< count {
//	let offset = start + (i * 12)
//	let fsysID = rel.get2BytesAtOffset(offset + 2)
//	if let fsys = ISO.getFSYSNameWithGroupID(fsysID) {
//		printg(i, fsys)
//	}
//}

//let p = common.allPointers()
//for i in 0 ..< p.count {
//	printg(i, p[i].hexString())
//}

//for i in 0 ..< CommonIndexes.NumberOfInteractionPoints.value {
//	let p = XGInteractionPointData(index: i)
//	switch p.info {
//	case .Script(let scriptIndex, let parameter):
//		if parameter != 0 {
//			printg(i, p.roomID, scriptIndex)
//		}
//	default: break
//	}
//}


//let folder = XGFolders.ISOExport("pkx_usohachi")
//let bonsly = XGFiles.nameAndFolder("usohachi.pkx", folder).data!
//let munchlax = XGFiles.nameAndFolder("gonbe_0100.fdat", folder).data!
//
//let munchSize = munchlax.get4BytesAtOffset(0)
//let bonSize = bonsly.get4BytesAtOffset(0)
//
//var paddedMunchSize = munchSize
//paddedMunchSize += (16 - paddedMunchSize % 16)
//
//bonsly.replace4BytesAtOffset(0, withBytes: munchSize)
//bonsly.replaceBytesFromOffset(0xE60, withByteStream: [Int](repeating: 0, count: paddedMunchSize))
//bonsly.replaceData(data: munchlax, atOffset: 0xE60)
//bonsly.deleteBytes(start: paddedMunchSize + 0xe60, count: bonSize - paddedMunchSize - 0xe60)
//
//bonsly.save()

//XGUtility.compileCommonRel()
//CommonIndexes.Doors.startOffset.hexString().println()

//let cd = item("Battle CD 01")
//let locations = XGUtility.getItemLocations()
//for i in 1 ... 50 {
//	let cd = XGBattleCD(index: i)
//	let location = locations[cd.getItem().index]
//	printg(i, location.count > 0 ? location[0] : "-", "\n", cd.cdDescription, "\n", cd.conditions, "\n")
//}


