//
//  XGCollisionData.swift
//  GoD Tool
//
//  Created by The Steez on 28/05/2018.
//

import Cocoa
import Metal

var types = [Int]()
class XGCollisionData: NSObject {
	
	var file : XGFiles!
	var mapRel : XGMapRel!
	var warpIndexes = [Int]()
	var numberOfWarps : Int {
		return warpIndexes.count
	}
	
	var vertexes = [XGVertex]()
	var rawVertexBuffer : [GLfloat] {
		var buffer = [GLfloat]()
		
		for vertex in self.vertexes {
			buffer += vertex.rawData
		}
		
		return buffer
	}
	
	init(file: XGFiles) {
		super.init()
		
		self.file = file
		
		let data = file.data!
		
		let relFile = XGFiles.rel(self.file.fileName.removeFileExtensions())
		if relFile.exists {
			mapRel = XGMapRel(file: relFile, checkScript: false)
		}
		
		let list_start  = data.getWordAtOffset(0x0).int
		let entry_count = data.getWordAtOffset(0x4).int
		
		var maxD : GLfloat = 0
		
		for i in 0 ... entry_count {
			// add an extra  loop for data not pointed to but comes straight after pointer table
			
			let entry_size = 0x40;
			var o = i == entry_count ? 0x0 : 0x24
			let offset = list_start + (entry_size * i)
			
			while o < ( i == entry_count ? 0x4 : entry_size ) {
				
				let a_o = data.getWordAtOffset(offset + o).int
				if  a_o > 0 {
					var isWarp = false
					if o == 0x2c {
						// this is a warp point
						isWarp = true
					}
					
					let data_start = i == entry_count ? a_o : data.getWordAtOffset(a_o).int
					let num = i == entry_count ? data.getWordAtOffset(offset + o + 4).int : data.getWordAtOffset(a_o + 0x4).int
					let face_size = 0x34
					
					for s in 0 ..< num {
						let s_o = data_start + (s * face_size)
						var triangle = [XGVertex]()
						
						let type = data.get2BytesAtOffset(s_o + 0x30)
						let interactionIndex = data.get2BytesAtOffset(s_o + 0x32)
						if isWarp {
							warpIndexes.addUnique(interactionIndex)
						}
						
						for c in 0 ..< 3 { // 4th element is normal vector
							
							let vx = data.getWordAtOffset( s_o + (c * 0xc) + 0x0 ).hexToSignedFloat()
							let vy = data.getWordAtOffset( s_o + (c * 0xc) + 0x4).hexToSignedFloat()
							let vz = data.getWordAtOffset( s_o + (c * 0xc) + 0x8).hexToSignedFloat()
							let v = XGVertex()
							// may need to some axes depending on rendering engine
							v.x = vx.gl
							v.y = vy.gl
							v.z = vz.gl
							v.index = GLfloat(self.vertexes.count + c)
							triangle.append(v)
							
							maxD = max(maxD, abs(vx))
							maxD = max(maxD, abs(vy))
							maxD = max(maxD, abs(vz))
						}
						// get normal
						let nx = data.getWordAtOffset( s_o + (3 * 0xc) + 0x0 ).hexToSignedFloat()
						let ny = data.getWordAtOffset( s_o + (3 * 0xc) + 0x4).hexToSignedFloat()
						let nz = data.getWordAtOffset( s_o + (3 * 0xc) + 0x8).hexToSignedFloat()
						
						for v in triangle {
							v.nx = nx.gl
							v.ny = ny.gl
							v.nz = nz.gl
							v.type = GLfloat(type)
							v.isWarp = isWarp
							v.interactionIndex = GLfloat(interactionIndex)
						}
						if !types.contains(type) {
							types.append(type)
						}
						self.vertexes += triangle
					}
				}
				
				o += 4
			}
		}
		
		let mag : GLfloat = 1
		for v in self.vertexes {
			v.scale(maxD: maxD, magnification: mag)
		}
	}
	
}
















