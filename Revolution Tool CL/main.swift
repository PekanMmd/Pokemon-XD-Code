//
//  main.swift
//  Revolution Tool
//
//  Created by The Steez on 24/12/2018.
//

import Foundation

loadISO(exitOnFailure: true)

//let args = "extract --raw \(XGFiles.iso.path.escapedPath) \(XGFolders.ISODump.path.escapedPath)"
//let process = GoDShellManager.runAsync(.wit, args: args, shouldReturnProcess: true)
//process?.readVirtualMemory(at: 0, length: 0x4000)?.writeToFile(.nameAndFolder("vm_test.bin", .Documents))
//process?.await()

//func getPokemonCountOffsetsTable(file: XGFiles, startOffset: Int, endOffset: Int) -> [Int] {
//	guard let data = file.data else { return [] }
//
//	var countOffsets = [Int]()
//
//	var currentOffset = startOffset
//
//	while currentOffset < endOffset {
//		let instruction = data.getWordAtOffset(currentOffset)
//		let instructionType = instruction >> 26
//		let param = instruction & 0xFFFF
//
//		if param == 493 || param == 494 || param == 495 || param == 601,
//		   instructionType == 10 || instructionType == 11 || instructionType  == 14 {
//			countOffsets.append(currentOffset + 2)
//		}
//		currentOffset += 4
//	}
//
//	return countOffsets
//}
//
//let eu493 = [
//	// 493
//	0x012ae6,
//	0x0143fa,
//	0x014576,
//	0x014606,
//	0x014892,
//	0x0148d2,
//	0x0149a6,
//	0x014a1a,
//	0x0159d6,
//	0x015a3e,
//	0x015aa6,
//	0x015b0e,
//	0x015b76,
//	0x01a6f2,
//	0x01cc8e,
//	0x01f4be,
//	0x01f592,
//	0x01f666,
//	0x01f73a,
//	0x01f80e,
//	0x01f8e2,
//	0x01f99e,
//	0x02142e,
//	0x02149a,
//	0x021506,
//	0x021572,
//	0x0215de,
//	0x024762,
//	0x0247ee,
//	0x0248ba,
//]
//let eu494 = [
//	0x05ca92,
//	0x05ca96,
//	0x05cbde,
//	0x05cc0e,
//	0x05cdb6,
//	0x05cc0e,
//	0x05cd82,
//	0x05cdb6,
//	0x0aa152,
//	0x102452,
//	0x10254a,
//	0x3b032a,
//	0x3b0476,
//	0x3b057a,
//	0x3b065e,
//	0x3b28ca,
//	0x3b2992,
//	0x3b2a72,
//	0x3b5a0a,
//	0x3b5b02,
//	0x3b7cca,
//	0x3b98b2,
//	0x3b99ae,
//	0x3b9a1a,
//	0x3b9af6,
//	0x3d2396,
//	0x3d256e,
//	0x3d29f6,
//	0x3d4a6a,
//	0x3d4b66,
//	0x3d6162,
//	0x3d61f2,
//	0x3d6292,
//	0x3d6d1e,
//	0x3d6df2,
//	0x3db0b2,
//	0x3db0da,
//	0x3dbe2a,
//	0x3dce5e,
//]
//let eu495 = [
//	0x056c86,
//	0x05b7aa,
//	0x05ba86,
//	0x05bdbe,
//	0x05c142,
//	0x05c416,
//	0x05c6fa,
//	0x10244a,
//	0x102542,
//	0x3db2c6,
//	0x3db322,
//]
//let eu601 = [
//	0x0247f6,
//	0x0248c2,
//	0x16d442, // unsure if sub
//	0x16d44a, // also unsure
//]
//
//let euDol = XGFiles.dol
//let usDol = XGFiles.nameAndFolder("main US.dol", .Documents)
//let jpDol = XGFiles.nameAndFolder("main JP.dol", .Documents)
//
//func start() {
//	guard let euData = euDol.data,
//		  let usData = usDol.data,
//		  let jpData = jpDol.data else {
//		return
//	}
//
//	var euTable = getPokemonCountOffsetsTable(file: euDol, startOffset: euData.get4BytesAtOffset(4), endOffset: euData.get4BytesAtOffset(0x1c))
//	euTable.remove(at: 6) // not in us table
//	let usTable = getPokemonCountOffsetsTable(file: usDol, startOffset: usData.get4BytesAtOffset(4), endOffset: usData.get4BytesAtOffset(0x1C))
////	let jpTable = getPokemonCountOffsetsTable(file: jpDol, startOffset: jpData.get4BytesAtOffset(4), endOffset: jpData.get4BytesAtOffset(0x1C))
//
//	var lastUSOffset = 0
//	var lastEUOffset = 0
//	for i in 0 ..< euTable.count {
//		let euOffset = euTable[i] + kDolToRAMOffsetDifference
//		let usOffset = i < usTable.count ? usTable[i] + kDolToRAMOffsetDifference : 0
//
//		let euDifference = euOffset - lastEUOffset
//		let usDifference = usOffset - lastUSOffset
//		printg("\(i) \(euOffset.hexString()) \(usOffset.hexString()) \(euDifference) \(usDifference)")
//		lastEUOffset = euOffset
//		lastUSOffset = usOffset
//	}
//
//	var usArrayString = "[\n"
////	var jpArrayString = "[\n"
//	for offset in eu493 {
//		let fileOffset = offset - kDolToRAMOffsetDifference
//		let offsetIndex = euTable.firstIndex(of: fileOffset)!
//		let usOffset = usTable[offsetIndex] + kDolToRAMOffsetDifference
////		let jpOffset = jpTable[offsetIndex] + kDolToRAMOffsetDifference
//		usArrayString += "\(usOffset.hexString().lowercased()), "
//		//		jpArrayString += "\(jpOffset.hexString().lowercased()), "
//
//	}
//	usArrayString += "\n]"
////	jpArrayString += "\n]"
//	printg("\nUS 493")
//	printg(usArrayString)
////	printg("\nJP 493")
////	printg(jpArrayString)
//
//	usArrayString = "[\n"
////	jpArrayString = "[\n"
//	for offset in eu494 {
//		let fileOffset = offset - kDolToRAMOffsetDifference
//		let offsetIndex = euTable.firstIndex(of: fileOffset)!
//		let usOffset = usTable[offsetIndex] + kDolToRAMOffsetDifference
////		let jpOffset = jpTable[offsetIndex] + kDolToRAMOffsetDifference
//		usArrayString += "\(usOffset.hexString().lowercased()), "
//		//		jpArrayString += "\(jpOffset.hexString().lowercased()), "
//
//	}
//	usArrayString += "\n]"
////	jpArrayString += "\n]"
//	printg("\nUS 494")
//	printg(usArrayString)
////	printg("\nJP 494")
////	printg(jpArrayString)
//
//	usArrayString = "[\n"
////	jpArrayString = "[\n"
//	for offset in eu495 {
//		let fileOffset = offset - kDolToRAMOffsetDifference
//		let offsetIndex = euTable.firstIndex(of: fileOffset)!
//		let usOffset = usTable[offsetIndex] + kDolToRAMOffsetDifference
////		let jpOffset = jpTable[offsetIndex] + kDolToRAMOffsetDifference
//		usArrayString += "\(usOffset.hexString().lowercased()), "
//		//		jpArrayString += "\(jpOffset.hexString().lowercased()), "
//
//	}
//	usArrayString += "\n]"
////	jpArrayString += "\n]"
//	printg("\nUS 495")
//	printg(usArrayString)
////	printg("\nJP 495")
////	printg(jpArrayString)
//
//	usArrayString = "[\n"
////	jpArrayString = "[\n"
//	for offset in eu601 {
//		let fileOffset = offset - kDolToRAMOffsetDifference
//		let offsetIndex = euTable.firstIndex(of: fileOffset)!
//		let usOffset = usTable[offsetIndex] + kDolToRAMOffsetDifference
////		let jpOffset = jpTable[offsetIndex] + kDolToRAMOffsetDifference
//		usArrayString += "\(usOffset.hexString().lowercased()), "
//		//		jpArrayString += "\(jpOffset.hexString().lowercased()), "
//
//	}
//	usArrayString += "\n]"
////	jpArrayString += "\n]"
//	printg("\nUS 601")
//	printg(usArrayString)
////	printg("\nJP 601")
////	printg(jpArrayString)
//
//}
//
//start()

//PDADumper.dumpData()
//PDADumper.dumpFiles(writeTextures: false)
//PDADumper.dumpMSG()

