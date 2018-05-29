//
//  XGCollisionData.swift
//  GoD Tool
//
//  Created by The Steez on 28/05/2018.
//

import Cocoa

var types = [GLfloat]()
class XGCollisionData: NSObject {
	
	var file : XGFiles!
	var mapRel : XGMapRel!
	
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
		
		let data = file.data
		
		let relFile = XGFiles.rel(self.file.fileName.removeFileExtensions() + ".rel")
		if relFile.exists {
			mapRel = XGMapRel(file: relFile, checkScript: false)
		}
		
		let list_start  = data.get4BytesAtOffset(0x0).int
		let entry_count = data.get4BytesAtOffset(0x4).int
		let entry_size = 0x40;
		
		var maxD : GLfloat = 0
		
		for i in 0 ..< entry_count {
			
			let offset = list_start + (entry_size * i)
			var o = 0x24
			while o < entry_size {
				
				let a_o = data.get4BytesAtOffset(offset + o).int
				if  a_o > 0 {
					let data_start = data.get4BytesAtOffset(a_o).int
					let num = data.get4BytesAtOffset(a_o + 0x4).int
					let face_size = 0x34
					
					for s in 0 ..< num {
						let s_o = data_start + (s * face_size)
						var triangle = [XGVertex]()
						
						var type = GLfloat(data.get2BytesAtOffset(s_o + 0x30))
						
						for c in 0 ..< 3 { // 4th element is normal vector
							
							let vx = data.get4BytesAtOffset( s_o + (c * 0xc) + 0x0 ).hexToSignedFloat()
							let vy = data.get4BytesAtOffset( s_o + (c * 0xc) + 0x4).hexToSignedFloat()
							let vz = data.get4BytesAtOffset( s_o + (c * 0xc) + 0x8).hexToSignedFloat()
							let v = XGVertex()
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
						let nx = data.get4BytesAtOffset( s_o + (3 * 0xc) + 0x0 ).hexToSignedFloat()
						let ny = data.get4BytesAtOffset( s_o + (3 * 0xc) + 0x4).hexToSignedFloat()
						let nz = data.get4BytesAtOffset( s_o + (3 * 0xc) + 0x8).hexToSignedFloat()
						
						if triangle[0].y == triangle[1].y && triangle[1].y == triangle[2].y {
							type = 100
						}
						
						for v in triangle {
							v.nx = nx.gl
							v.ny = ny.gl
							v.nz = nz.gl
							v.type = type
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
		printg("types found so far:", types)
		let mag : GLfloat = 1
		for v in self.vertexes {
			v.scale(maxD: maxD, magnification: mag)
		}
	}
	
}
















