//
//  main.swift
//  XGCommandLineTools
//
//  Created by StarsMmd on 13/11/2015.
//  Copyright © 2015 StarsMmd. All rights reserved.
//
//


//XGUtility.documentXDS()

for name in ["esaba_C", "D7_out"] {
	printg("script test: \(name)")
	XGFiles.script(name + ".scd").scriptData.getXDSScript().save(toFile: .nameAndFolder(name + ".xds", .Resources))
	XGFiles.script(name + ".scd").scriptData.description.save(toFile: .nameAndFolder(name + "_old.scd.txt", .Resources))
	
	let script = XGFiles.nameAndFolder(name + ".xds", .Resources).data.string
	if !XDSScriptCompiler.compile(text: script, toFile: .nameAndFolder(name + ".scd", .Resources)) {
		XDSScriptCompiler.error.println()
	}
	let newscript = XGFiles.nameAndFolder(name + ".scd", .Resources).scriptData
	newscript.description.save(toFile: .nameAndFolder(name + "_new.scd.txt", .Resources))
	newscript.getXDSScript().save(toFile: .nameAndFolder(name + "_new.xds", .Resources))
	printg("script test complete.")
}
XGUtility.documentXDS()


//XGFiles.nameAndFolder("pkx_usohachi.fsys", .Documents).fsysData.extractFilesToFolder(folder: .Documents)

//func convertFromPKXToOverWorldModel(pkx: XGMutableData) -> XGMutableData {
//
//	//	let rawData = pkx.charStream
//	let modelHeader = 0xE60
//	let modelStart = 0xE80
//	var modelEndPaddingCounter = 0
//
//	// get number of padding 0s at end
//	var index = pkx.length - 4
//	var current = pkx.get4BytesAtOffset(index)
//
//	while current == 0 {
//		modelEndPaddingCounter += 4
//		index -= 4
//		current = pkx.get4BytesAtOffset(index)
//	}
//	modelEndPaddingCounter = pkx.length - (index + 4)
//
//	let skipStart = Int(pkx.get4BytesAtOffset(pkx.length - modelEndPaddingCounter - 0x1C)) + modelStart
//	let skipEnd = Int(pkx.get4BytesAtOffset(modelHeader + 4)) + modelStart
//
//	let part2 = pkx.getCharStreamFromOffset(modelStart, length: skipStart - modelStart)
//	let part3 = pkx.getCharStreamFromOffset(skipEnd, length: pkx.length - modelEndPaddingCounter - 0x1C - skipEnd)
//	let part4 : [UInt8] = [0x73, 0x63, 0x65, 0x6E, 0x65, 0x5F, 0x64, 0x61, 0x74, 0x61, 0x00]
//	var rawBytes = part2 + part3 + part4
//
//	let newLength = rawBytes.count + 0x20
//	let header4 = [newLength, skipStart - modelStart, Int(pkx.get4BytesAtOffset(modelHeader + 8)), 0x01]
//	var header = [UInt8]()
//	for h in header4 {
//		header.append(UInt8(h >> 24))
//		header.append(UInt8((h & 0xFF0000) >> 16))
//		header.append(UInt8((h & 0xFF00) >> 8))
//		header.append(UInt8(h % 0x100))
//	}
//	for _ in 0 ..< 0x10 {
//		header.append(0)
//	}
//
//	rawBytes = header + rawBytes
//
//	return XGMutableData(byteStream: rawBytes, file: .nameAndFolder("", .Documents))
//}



XGAssembly.ASMfreeSpacePointer().hexString().println()


//XGUtility.compileDol()
//XGUtility.compileCommonRel()
//XGUtility.compileMainFiles()
//XGUtility.compileAllFiles()
//XGUtility.compileForRelease(XG: true)
//XGUtility.documentISO(forXG: true)






//XGAssembly.getWordAtRamOffsetFromR13(offset: -0x74b0).hexString().println() //number battle types

//let cd = item("Battle CD 01")
//let locations = XGUtility.getItemLocations()
//for i in 1 ... 50 {
//	let cd = XGBattleCD(index: i)
//	let location = locations[cd.getItem().index]
//	printg(i, location.count > 0 ? location[0] : "-", "\n", cd.cdDescription, "\n", cd.conditions, "\n")
//}


