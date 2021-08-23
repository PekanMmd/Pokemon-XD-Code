//
//  EcardCoder.swift
//  GoD Tool
//
//  Created by Stars Momodu on 23/08/2021.
//

import Foundation
extension Bool {
	var asInt: Int {
		return self ? 1 : 0
	}

	var asUInt: UInt32 {
		return self ? 1 : 0
	}
}

class EcardCoder {

	// These are data/constants found in various places in RAM which the decoder reference
	private static var globalData = [
		0x268dc0: 0x00,
		0x268dc4: 0x04,
		0x268dc8: 0x01,

		0x269120: 0x48,
		0x269124: 0x04,
		0x269128: 0x01,
	]

	private static let globalArrayR13Minus7ed8 = XGMutableData(byteStream: [0x80, 0x40, 0x20, 0x10, 0x08, 0x04, 0x02, 0x01, 0x01, 0x02, 0x04, 0x08, 0x01, 0x02, 0x03, 0x00])

	static func decode(file: XGFiles) -> XGMutableData? {
		guard let data = file.data else { return nil }
		return decode(data: data)
	}

	// Default "key" value is the one used in Colosseum
	static func decode(data: XGMutableData, key: Int = 4160) -> XGMutableData? {
		let output = XGMutableData(length: 0x814) // Card itelf is 0x810. Extra 4 bytes at start.
		output.file = .nameAndFolder(data.file.fileName.removeFileExtensions() + "-decoded.bin", data.file.folder)

		// This code is a port of a decomp produced using ghidra so the variable names are generic
		let uVar4: UInt32 = 0
		let bVar5 = true

		var uVar16: UInt32 = 0
		var iVar18 = 0x268dc0

		let local_a28 = XGMutableData(length: 256) // confirm type
		let local_828 = XGMutableData(length: 256) // confirm type
		let local_628 = XGMutableData(length: 256) // confirm type
		let local_428 = XGMutableData(length: 256) // confirm type
		let local_228 = XGMutableData(length: 256) // confirm type

		unknown_240c(output: output, param1: 0, param2: 0xb20)
		var iVar6 = globalData[0x268dc4]!
		var iVar17 = globalData[0x268dc8]!
		var local_a2c = 0
//		var outputPosition = 0 // local_a38
//		var inputPosition = 0 // local_a34
		var keyValue = key // local_a30

		if (globalData[0x268dc4]! < 0x10) {
			for i in 0 ..< iVar17 {
				uVar16 = 0
				var iVar7 = local_a2c + iVar6
				var iVar11 = iVar6
				var uVar13 = local_a2c.unsigned
				if local_a2c < iVar7 {
					repeat {
						let bVar1 = uVar13.int32 < 0
						let uVar10 = uVar13 & 7
						iVar7 = uVar13.int32 >> 3
						let uVar14 = uVar13 & 7
						uVar13 += 1
						uVar16 = (uVar16 & 0x7fff) << 1 |
							((globalArrayR13Minus7ed8.getCharAtOffset(uVar14.int32) &
								data.getCharAtOffset(iVar7 + (bVar1 && uVar10 != 0).asInt)) != 0).asUInt
						iVar11 -= 1
					} while iVar11 != 0
				}
				local_a2c += iVar6
				unknown_7e02c(output: output, globalPointer: 0x268dc0, param3: 0xffffffff, param4: uVar16, param5: nil, param6: i)
			}
		} else {
			var bufferPosition = 0 // puVar9
			let buffer = local_228
			uVar16 = 0

			while iVar6 > 0x10 {
				var uVar13: UInt32 = 0
				var uVar12: UInt32 = 0
				iVar17 = ((uVar16 + 0x10) - uVar16).int32 // u wot m8???
				var uVar10 = uVar16

				if (uVar16.int32 < (uVar16 + 0x10).int32) {
					repeat {
						let bVar1 = uVar10.int32 < 0
						let uVar14 = uVar10 & 7
						let iVar15 = uVar10.int32 >> 3
						let uVar3 = uVar10 & 7
						uVar10 += 1
						uVar13 = (uVar13 & 0x7fff) << 1 |
							((globalArrayR13Minus7ed8.getCharAtOffset(uVar3.int32) &
								data.getCharAtOffset(iVar15 + (bVar1 && uVar14 != 0).asInt)) != 0).asUInt
						uVar12 = uVar13 & 0xFFFF
						iVar17 -= 1
					} while iVar17 != 0
				}
				buffer.replace2BytesAtOffset(bufferPosition, withBytes: uVar12.int)
				bufferPosition += 2
				uVar16 += 0x10
				iVar6 -= 0x10
			}
			if iVar6 != 0 {
				var uVar13: UInt32 = 0
				var uVar12: UInt32 = 0
				iVar17 = ((uVar16 + 0x10) - uVar16).int32

				if (uVar16.int32 < (uVar16.int32 + iVar6)) {
					repeat {
						let bVar1 = uVar16.int32 < 0
						let uVar10 = uVar16 & 7
						iVar6 = uVar16.int32 >> 3
						let uVar14 = uVar16 & 7
						uVar16 += 1
						uVar13 = (uVar13 & 0x7fff) << 1 |
							((globalArrayR13Minus7ed8.getCharAtOffset(uVar14.int32) &
								data.getCharAtOffset(iVar6 + (bVar1 && uVar10 != 0).asInt)) != 0).asUInt
						uVar12 = uVar13 & 0xFFFF
						iVar17 -= 1
					} while iVar17 != 0
				}
				buffer.replace2BytesAtOffset(bufferPosition, withBytes: uVar12.int)
				bufferPosition += 2
			}
			buffer.replace2BytesAtOffset(bufferPosition, withBytes: 0)
			local_a2c = globalData[0x268dc4]!
			unknown_7e02c(output: output, globalPointer: 0x268dc0, param3: 0xffffffff, param4: 0, param5: local_228, param6: 0xffffffff)
		}

		uVar16 = 0
		local_a2c = 0
		iVar6 = output.get4BytesAtOffset(0)
		if iVar6 == 1 {
			iVar6 = 0x269120
			repeat {
				iVar17 = globalData[iVar6 + 4]!
				var bVar1 = true
				if iVar17 < 0x10 {
					for i in 0 ..< globalData[iVar6 + 8]! {
						var uVar13: UInt32 = 0
						iVar18 = local_a2c + globalData[iVar6 + 4]!
						var iVar15 = iVar18 - local_a2c
						var uVar10 = local_a2c
						if local_a2c < iVar18 {
							repeat {
								let bVar2 = uVar10 < 0
								let uVar14 = uVar10 & 7
								iVar18 = uVar10 >> 3
								let uVar3 = uVar10 & 7
								uVar10 += 1
								uVar13 = (uVar13 & 0x7fff) << 1 |
									((globalArrayR13Minus7ed8.getCharAtOffset(uVar3) &
										data.getCharAtOffset(iVar18 + (bVar2 && uVar14 != 0).asInt)) != 0).asUInt
								iVar15 -= 1
							} while iVar15 != 0
						}
						local_a2c = local_a2c + globalData[iVar6 + 4]!
						let cVar8 = unknown_7e02c(output: output, globalPointer: iVar6, param3: 0xffffffff, param4: uVar13, param5: nil, param6: iVar17)
						if cVar8 == 0 {
							bVar1 = false
						}
					}
				} else {

				}
			} while uVar16 < 3
		}
//		uVar16 = 0;
//		local_a2c = 0;
//		iVar6 = *param_1;
//		if (iVar6 == 1) {
//			iVar6 = -0x7fd96ee0;
//			do {
//				iVar17 = *(int *)(iVar6 + 4);
//				bVar1 = true;
//				if (iVar17 < 0x10) {
//					for (iVar17 = 0; iVar17 < *(int *)(iVar6 + 8); iVar17 = iVar17 + 1) {
//						...
//					}
//				}
//				else {
//					puVar9 = local_a28;
//					uVar13 = local_a2c;
//					for (; 0x10 < iVar17; iVar17 = iVar17 + -0x10) {
//						uVar10 = 0;
//						uVar12 = 0;
//						iVar15 = (uVar13 + 0x10) - uVar13;
//						uVar14 = uVar13;
//						if ((int)uVar13 < (int)(uVar13 + 0x10)) {
//							do {
//								bVar2 = (int)uVar14 < 0;
//								uVar3 = uVar14 & 7;
//								iVar18 = (int)uVar14 >> 3;
//								uVar4 = uVar14 & 7;
//								uVar14 = uVar14 + 1;
//								uVar10 = (uVar10 & 0x7fff) << 1 |
//									(uint)((*(byte *)(unaff_r13 + -0x7ed8 + uVar4) &
//												*(byte *)(local_a34 + iVar18 + (uint)(bVar2 && uVar3 != 0))) != 0);
//								uVar12 = (undefined2)uVar10;
//								iVar15 = iVar15 + -1;
//							} while (iVar15 != 0);
//						}
//						*puVar9 = uVar12;
//						puVar9 = puVar9 + 1;
//						uVar13 = uVar13 + 0x10;
//					}
//					if (iVar17 != 0) {
//						uVar10 = 0;
//						uVar12 = 0;
//						iVar15 = (uVar13 + iVar17) - uVar13;
//						if ((int)uVar13 < (int)(uVar13 + iVar17)) {
//							do {
//								bVar2 = (int)uVar13 < 0;
//								uVar14 = uVar13 & 7;
//								iVar17 = (int)uVar13 >> 3;
//								uVar3 = uVar13 & 7;
//								uVar13 = uVar13 + 1;
//								uVar10 = (uVar10 & 0x7fff) << 1 |
//									(uint)((*(byte *)(unaff_r13 + -0x7ed8 + uVar3) &
//												*(byte *)(local_a34 + iVar17 + (uint)(bVar2 && uVar14 != 0))) != 0);
//								uVar12 = (undefined2)uVar10;
//								iVar15 = iVar15 + -1;
//							} while (iVar15 != 0);
//						}
//						*puVar9 = uVar12;
//						puVar9 = puVar9 + 1;
//					}
//					iVar17 = *(int *)(iVar6 + 4);
//					*puVar9 = 0;
//					local_a2c = local_a2c + iVar17;
//					cVar8 = FUN_0007e02c(&local_a38,iVar6,0xffffffff,0,local_a28,0xffffffff);
//					if (cVar8 == '\0') {
//						bVar1 = false;
//					}
//				}
//				if (!bVar1) {
//					bVar5 = false;
//				}
//				iVar6 = iVar6 + 0xc;
//				uVar16 = uVar16 + 1;
//			} while (uVar16 < 3);
//		}
//		else {
//			if ((iVar6 < 1) && (-1 < iVar6)) {
//				uVar16 = 0;
//				do {
//					iVar6 = *(int *)(iVar18 + 4);
//					bVar1 = true;
//					if (iVar6 < 0x10) {
//						for (iVar6 = 0; iVar6 < *(int *)(iVar18 + 8); iVar6 = iVar6 + 1) {
//							uVar13 = 0;
//							iVar15 = local_a2c + *(int *)(iVar18 + 4);
//							iVar17 = iVar15 - local_a2c;
//							uVar10 = local_a2c;
//							if ((int)local_a2c < iVar15) {
//								do {
//									bVar2 = (int)uVar10 < 0;
//									uVar14 = uVar10 & 7;
//									iVar15 = (int)uVar10 >> 3;
//									uVar3 = uVar10 & 7;
//									uVar10 = uVar10 + 1;
//									uVar13 = (uVar13 & 0x7fff) << 1 |
//										(uint)((*(byte *)(unaff_r13 + -0x7ed8 + uVar3) &
//													*(byte *)(local_a34 + iVar15 + (uint)(bVar2 && uVar14 != 0))) != 0);
//									iVar17 = iVar17 + -1;
//								} while (iVar17 != 0);
//							}
//							local_a2c = local_a2c + *(int *)(iVar18 + 4);
//							cVar8 = FUN_0007e02c(&local_a38,iVar18,0xffffffff,uVar13,0,iVar6);
//							if (cVar8 == '\0') {
//								bVar1 = false;
//							}
//						}
//					}
//					else {
//						puVar9 = local_428;
//						uVar13 = local_a2c;
//						for (; 0x10 < iVar6; iVar6 = iVar6 + -0x10) {
//							uVar10 = 0;
//							uVar12 = 0;
//							iVar17 = (uVar13 + 0x10) - uVar13;
//							uVar14 = uVar13;
//							if ((int)uVar13 < (int)(uVar13 + 0x10)) {
//								do {
//									bVar2 = (int)uVar14 < 0;
//									uVar3 = uVar14 & 7;
//									iVar15 = (int)uVar14 >> 3;
//									uVar4 = uVar14 & 7;
//									uVar14 = uVar14 + 1;
//									uVar10 = (uVar10 & 0x7fff) << 1 |
//										(uint)((*(byte *)(unaff_r13 + -0x7ed8 + uVar4) &
//													*(byte *)(local_a34 + iVar15 + (uint)(bVar2 && uVar3 != 0))) != 0);
//									uVar12 = (undefined2)uVar10;
//									iVar17 = iVar17 + -1;
//								} while (iVar17 != 0);
//							}
//							*puVar9 = uVar12;
//							puVar9 = puVar9 + 1;
//							uVar13 = uVar13 + 0x10;
//						}
//						if (iVar6 != 0) {
//							uVar10 = 0;
//							uVar12 = 0;
//							iVar17 = (uVar13 + iVar6) - uVar13;
//							if ((int)uVar13 < (int)(uVar13 + iVar6)) {
//								do {
//									bVar2 = (int)uVar13 < 0;
//									uVar14 = uVar13 & 7;
//									iVar6 = (int)uVar13 >> 3;
//									uVar3 = uVar13 & 7;
//									uVar13 = uVar13 + 1;
//									uVar10 = (uVar10 & 0x7fff) << 1 |
//										(uint)((*(byte *)(unaff_r13 + -0x7ed8 + uVar3) &
//													*(byte *)(local_a34 + iVar6 + (uint)(bVar2 && uVar14 != 0))) != 0);
//									uVar12 = (undefined2)uVar10;
//									iVar17 = iVar17 + -1;
//								} while (iVar17 != 0);
//							}
//							*puVar9 = uVar12;
//							puVar9 = puVar9 + 1;
//						}
//						iVar6 = *(int *)(iVar18 + 4);
//						*puVar9 = 0;
//						local_a2c = local_a2c + iVar6;
//						cVar8 = FUN_0007e02c(&local_a38,iVar18,0xffffffff,0,local_428,0xffffffff);
//						if (cVar8 == '\0') {
//							bVar1 = false;
//						}
//					}
//					if (!bVar1) {
//						bVar5 = false;
//					}
//					iVar18 = iVar18 + 0xc;
//					uVar16 = uVar16 + 1;
//				} while (uVar16 < 0x28);
//				iVar6 = 0;
//				do {
//					iVar17 = -0x7fd97060;
//					uVar16 = 0;
//					do {
//						iVar15 = *(int *)(iVar17 + 4);
//						bVar1 = true;
//						if (iVar15 < 0x10) {
//							for (iVar15 = 0; iVar15 < *(int *)(iVar17 + 8); iVar15 = iVar15 + 1) {
//								uVar13 = 0;
//								iVar11 = local_a2c + *(int *)(iVar17 + 4);
//								iVar18 = iVar11 - local_a2c;
//								uVar10 = local_a2c;
//								if ((int)local_a2c < iVar11) {
//									do {
//										bVar2 = (int)uVar10 < 0;
//										uVar14 = uVar10 & 7;
//										iVar11 = (int)uVar10 >> 3;
//										uVar3 = uVar10 & 7;
//										uVar10 = uVar10 + 1;
//										uVar13 = (uVar13 & 0x7fff) << 1 |
//											(uint)((*(byte *)(unaff_r13 + -0x7ed8 + uVar3) &
//														*(byte *)(local_a34 + iVar11 + (uint)(bVar2 && uVar14 != 0))) != 0
//											);
//										iVar18 = iVar18 + -1;
//									} while (iVar18 != 0);
//								}
//								local_a2c = local_a2c + *(int *)(iVar17 + 4);
//								cVar8 = FUN_0007e02c(&local_a38,iVar17,iVar6,uVar13,0,iVar15);
//								if (cVar8 == '\0') {
//									bVar1 = false;
//								}
//							}
//						}
//						else {
//							puVar9 = local_628;
//							uVar13 = local_a2c;
//							for (; 0x10 < iVar15; iVar15 = iVar15 + -0x10) {
//								uVar10 = 0;
//								uVar12 = 0;
//								iVar18 = (uVar13 + 0x10) - uVar13;
//								uVar14 = uVar13;
//								if ((int)uVar13 < (int)(uVar13 + 0x10)) {
//									do {
//										bVar2 = (int)uVar14 < 0;
//										uVar3 = uVar14 & 7;
//										iVar11 = (int)uVar14 >> 3;
//										uVar4 = uVar14 & 7;
//										uVar14 = uVar14 + 1;
//										uVar10 = (uVar10 & 0x7fff) << 1 |
//											(uint)((*(byte *)(unaff_r13 + -0x7ed8 + uVar4) &
//														*(byte *)(local_a34 + iVar11 + (uint)(bVar2 && uVar3 != 0))) != 0)
//										;
//										uVar12 = (undefined2)uVar10;
//										iVar18 = iVar18 + -1;
//									} while (iVar18 != 0);
//								}
//								*puVar9 = uVar12;
//								puVar9 = puVar9 + 1;
//								uVar13 = uVar13 + 0x10;
//							}
//							if (iVar15 != 0) {
//								uVar10 = 0;
//								uVar12 = 0;
//								iVar18 = (uVar13 + iVar15) - uVar13;
//								if ((int)uVar13 < (int)(uVar13 + iVar15)) {
//									do {
//										bVar2 = (int)uVar13 < 0;
//										uVar14 = uVar13 & 7;
//										iVar15 = (int)uVar13 >> 3;
//										uVar3 = uVar13 & 7;
//										uVar13 = uVar13 + 1;
//										uVar10 = (uVar10 & 0x7fff) << 1 |
//											(uint)((*(byte *)(unaff_r13 + -0x7ed8 + uVar3) &
//														*(byte *)(local_a34 + iVar15 + (uint)(bVar2 && uVar14 != 0))) != 0
//											);
//										uVar12 = (undefined2)uVar10;
//										iVar18 = iVar18 + -1;
//									} while (iVar18 != 0);
//								}
//								*puVar9 = uVar12;
//								puVar9 = puVar9 + 1;
//							}
//							iVar15 = *(int *)(iVar17 + 4);
//							*puVar9 = 0;
//							local_a2c = local_a2c + iVar15;
//							cVar8 = FUN_0007e02c(&local_a38,iVar17,iVar6,0,local_628,0xffffffff);
//							if (cVar8 == '\0') {
//								bVar1 = false;
//							}
//						}
//						if (!bVar1) {
//							bVar5 = false;
//						}
//						iVar17 = iVar17 + 0xc;
//						uVar16 = uVar16 + 1;
//					} while (uVar16 < 8);
//					iVar6 = iVar6 + 1;
//				} while (iVar6 < 9);
//				iVar6 = 0;
//				do {
//					iVar17 = -0x7fd97000;
//					uVar16 = 0;
//					do {
//						iVar15 = *(int *)(iVar17 + 4);
//						bVar1 = true;
//						if (iVar15 < 0x10) {
//							for (iVar15 = 0; iVar15 < *(int *)(iVar17 + 8); iVar15 = iVar15 + 1) {
//								uVar13 = 0;
//								iVar11 = local_a2c + *(int *)(iVar17 + 4);
//								iVar18 = iVar11 - local_a2c;
//								uVar10 = local_a2c;
//								if ((int)local_a2c < iVar11) {
//									do {
//										bVar2 = (int)uVar10 < 0;
//										uVar14 = uVar10 & 7;
//										iVar11 = (int)uVar10 >> 3;
//										uVar3 = uVar10 & 7;
//										uVar10 = uVar10 + 1;
//										uVar13 = (uVar13 & 0x7fff) << 1 |
//											(uint)((*(byte *)(unaff_r13 + -0x7ed8 + uVar3) &
//														*(byte *)(local_a34 + iVar11 + (uint)(bVar2 && uVar14 != 0))) != 0
//											);
//										iVar18 = iVar18 + -1;
//									} while (iVar18 != 0);
//								}
//								local_a2c = local_a2c + *(int *)(iVar17 + 4);
//								cVar8 = FUN_0007e02c(&local_a38,iVar17,iVar6,uVar13,0,iVar15);
//								if (cVar8 == '\0') {
//									bVar1 = false;
//								}
//							}
//						}
//						else {
//							puVar9 = local_828;
//							uVar13 = local_a2c;
//							for (; 0x10 < iVar15; iVar15 = iVar15 + -0x10) {
//								uVar10 = 0;
//								uVar12 = 0;
//								iVar18 = (uVar13 + 0x10) - uVar13;
//								uVar14 = uVar13;
//								if ((int)uVar13 < (int)(uVar13 + 0x10)) {
//									do {
//										bVar2 = (int)uVar14 < 0;
//										uVar3 = uVar14 & 7;
//										iVar11 = (int)uVar14 >> 3;
//										uVar4 = uVar14 & 7;
//										uVar14 = uVar14 + 1;
//										uVar10 = (uVar10 & 0x7fff) << 1 |
//											(uint)((*(byte *)(unaff_r13 + -0x7ed8 + uVar4) &
//														*(byte *)(local_a34 + iVar11 + (uint)(bVar2 && uVar3 != 0))) != 0)
//										;
//										uVar12 = (undefined2)uVar10;
//										iVar18 = iVar18 + -1;
//									} while (iVar18 != 0);
//								}
//								*puVar9 = uVar12;
//								puVar9 = puVar9 + 1;
//								uVar13 = uVar13 + 0x10;
//							}
//							if (iVar15 != 0) {
//								uVar10 = 0;
//								uVar12 = 0;
//								iVar18 = (uVar13 + iVar15) - uVar13;
//								if ((int)uVar13 < (int)(uVar13 + iVar15)) {
//									do {
//										bVar2 = (int)uVar13 < 0;
//										uVar14 = uVar13 & 7;
//										iVar15 = (int)uVar13 >> 3;
//										uVar3 = uVar13 & 7;
//										uVar13 = uVar13 + 1;
//										uVar10 = (uVar10 & 0x7fff) << 1 |
//											(uint)((*(byte *)(unaff_r13 + -0x7ed8 + uVar3) &
//														*(byte *)(local_a34 + iVar15 + (uint)(bVar2 && uVar14 != 0))) != 0
//											);
//										uVar12 = (undefined2)uVar10;
//										iVar18 = iVar18 + -1;
//									} while (iVar18 != 0);
//								}
//								*puVar9 = uVar12;
//								puVar9 = puVar9 + 1;
//							}
//							iVar15 = *(int *)(iVar17 + 4);
//							*puVar9 = 0;
//							local_a2c = local_a2c + iVar15;
//							cVar8 = FUN_0007e02c(&local_a38,iVar17,iVar6,0,local_828,0xffffffff);
//							if (cVar8 == '\0') {
//								bVar1 = false;
//							}
//						}
//						if (!bVar1) {
//							bVar5 = false;
//						}
//						iVar17 = iVar17 + 0xc;
//						uVar16 = uVar16 + 1;
//					} while (uVar16 < 0x18);
//					iVar6 = iVar6 + 1;
//				} while (iVar6 < 0x24);
//			}
//			else {
//				bVar5 = false;
//			}
//		}
//		if (bVar5) {
//			uVar16 = (local_a30 * 8 | ~local_a2c) - (local_a30 * 8 - local_a2c >> 1) >> 0x1f;
//		}
//		else {
//			uVar16 = 0;
//		}
//		return uVar16;
		return uVar16 == 0 ? nil : output
	}

	private static func unknown_240c(output: XGMutableData, param1: Int, param2: Int) {

	}


	// TODO: confirm type of param 5, same as local_228 in main function
	private static func unknown_7e02c(output: XGMutableData, globalPointer: Int, param3: UInt32, param4: UInt32, param5: XGMutableData?, param6: Int) -> UInt8 {

	}
}
