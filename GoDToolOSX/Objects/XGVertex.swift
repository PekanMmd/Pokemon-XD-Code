//
//  XGVertex.swift
//  GoDToolCL
//
//  Created by The Steez on 03/09/2018.
//

import Foundation

let kVBOBufferSize = 4096
let kFloatSize     = 4
let kXGVertexSize  = XGVertex().rawData.count * kFloatSize
let kVertexesPerBuffer = kVBOBufferSize / kXGVertexSize

class XGVertex : NSObject {
	var x : Float = 0.0
	var y : Float = 0.0
	var z : Float = 0.0
	var type : Float = 0.0
	var index : Float = 0.0
	var isInteractable = false
	var interactionIndex : Float = 0.0
	var sectionIndex : Float = 0.0
	
	// sometimes interactable vertices overlap with regular ones and only one can be displayed at a time
	var sectionIndex2 : Float = 0.0
	
	// normal
	var nx : Float = 0.0
	var ny : Float = 0.0
	var nz : Float = 0.0
	
	var rawData : [Float] {
		var data = [Float]()
		data.append(x)
		data.append(y)
		data.append(z)
		data.append(type)
		data.append(index)
		data.append(nx)
		data.append(ny)
		data.append(nz)
		data.append(isInteractable ? 1.0 : 0.0)
		data.append(interactionIndex)
		data.append(sectionIndex)
		data.append(sectionIndex2)
		
		return data
	}
	
	func scale(maxD : Float, magnification: Float) {
		
		self.x /= maxD
		self.y /= maxD
		self.z /= maxD
		
		self.x *= magnification
		self.y *= magnification
		self.z *= magnification
	}
}
