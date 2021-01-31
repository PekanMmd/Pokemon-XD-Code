//
//  XGCollisionData.swift
//  GoD Tool
//
//  Created by The Steez on 28/05/2018.
//

import Foundation

var types = [Int]()
class XGCollisionData: NSObject {
	
	var file : XGFiles!
	var mapRel : XGMapRel!
	var interactableIndexes = [Int]()
	var numberOfInteractableRegions : Int {
		return interactableIndexes.count
	}
	var sectionIndexes = [Int]()
	var numberOfSections : Int {
		return sectionIndexes.count
	}
	
	var vertexes = [XGVertex]()
	var rawVertexBuffer: [Float] {
		var buffer = [Float]()
		
		for vertex in self.vertexes {
			buffer += vertex.rawData
		}
		
		return buffer
	}
	
	private func addVertex(_ vertex: XGVertex) {
		for i in 0 ..< self.vertexes.count {
			let compare = self.vertexes[i]
			if compare.x == vertex.x && compare.y == vertex.y && compare.z == vertex.z {
				if compare.nx == vertex.nx && compare.ny == vertex.ny && compare.nz == vertex.nz {
					if !compare.isInteractable && vertex.isInteractable {
						self.vertexes[i].isInteractable = true
						self.vertexes[i].interactionIndex = vertex.interactionIndex
						self.vertexes[i].sectionIndex2 = vertex.sectionIndex
						return
					}
				}
			}
		}
		self.vertexes.append(vertex)
	}
	
	private func addVertices(_ vertices: [XGVertex]) {
		for vertex in vertices {
			self.addVertex(vertex)
		}
	}
	
	init(file: XGFiles) {
		super.init()
		
		self.file = file
		
		guard let data = file.data else {
			XGFolders.nameAndFolder("Test", .Documents).createDirectory()
			return
		}
		
		let relFile = XGFiles.typeAndFsysName(.rel, self.file.fileName.removeFileExtensions())
		if relFile.exists {
			mapRel = XGMapRel(file: relFile, checkScript: false)
		}
		
		let list_start  = data.getWordAtOffset(0x0).int
		let entry_count = data.getWordAtOffset(0x4).int
		
		var maxD : Float = 0
		var currentSectionIndex = -1
		
		for i in 0 ..< entry_count {
			
			let entry_size = 0x40;
			var o = 0x24
			let offset = list_start + (entry_size * i)
			
			while o < entry_size {
				
				let a_o = data.getWordAtOffset(offset + o).int
				if  a_o > 0 {
					var isInteractable = false
					if o == 0x2c || o == 0x30 {
						// this is a warp point, door, pc, etc.
						isInteractable = true
					}
					
					
					let data_start = data.getWordAtOffset(a_o).int
					let num = data.getWordAtOffset(a_o + 0x4).int
					let face_size = 0x34
					
					if num > 0 {
						currentSectionIndex += 1
						self.sectionIndexes.append(currentSectionIndex)
					}
					
					for s in 0 ..< num {
						let s_o = data_start + (s * face_size)
						var triangle = [XGVertex]()
						
						let typeOffset = o == 0x30 ? 0x32 : 0x30
						let indexOffset = o == 0x30 ? 0x30 : 0x32
						
						let type = data.get2BytesAtOffset(s_o + typeOffset)
						let interactionIndex = data.get2BytesAtOffset(s_o + indexOffset)
						if isInteractable {
							interactableIndexes.addUnique(interactionIndex)
						}
						
						for c in 0 ..< 3 { // 4th element is normal vector
							
							let vx = data.getWordAtOffset( s_o + (c * 0xc) + 0x0 ).hexToSignedFloat()
							let vy = data.getWordAtOffset( s_o + (c * 0xc) + 0x4).hexToSignedFloat()
							let vz = data.getWordAtOffset( s_o + (c * 0xc) + 0x8).hexToSignedFloat()
							let v = XGVertex()
							// may need to some axes depending on rendering engine
							v.x = vx
							v.y = vy
							v.z = vz
							v.index = Float(self.vertexes.count + c)
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
							v.nx = nx
							v.ny = ny
							v.nz = nz
							v.type = Float(type)
							v.isInteractable = isInteractable
							v.interactionIndex = Float(interactionIndex)
							v.sectionIndex = Float(currentSectionIndex)
							v.sectionIndex2 = v.sectionIndex
						}
						if !types.contains(type) {
							types.append(type)
						}
						self.addVertices(triangle)
					}
				}
				
				o += 4
			}
		}
		
		let mag : Float = 1
		for v in self.vertexes {
			v.scale(maxD: maxD, magnification: mag)
		}
	}
	
}














