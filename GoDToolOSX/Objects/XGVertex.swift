//
//  XGVertex.swift
//  GoDToolCL
//
//  Created by The Steez on 03/09/2018.
//

import Cocoa
import OpenGL.GL3
import GLKit
import Darwin

let kVBOBufferSize = 4096
let kGLFloatSize   = 4
let kXGVertexSize  = XGVertex().rawData.count * kGLFloatSize
let kVertexesPerBuffer = kVBOBufferSize / kXGVertexSize

class XGVertex : NSObject {
	var x : GLfloat = 0.0
	var y : GLfloat = 0.0
	var z : GLfloat = 0.0
	var type : GLfloat = 0.0
	var index : GLfloat = 0.0
	var isInteractable = false
	var interactionIndex : GLfloat = 0.0
	
	// normal
	var nx : GLfloat = 0.0
	var ny : GLfloat = 0.0
	var nz : GLfloat = 0.0
	
	var rawData : [GLfloat] {
		var data = [GLfloat]()
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
		
		return data
	}
	
	func scale(maxD : GLfloat, magnification: GLfloat) {
		
		self.x /= maxD
		self.y /= maxD
		self.z /= maxD
		
		self.x *= magnification
		self.y *= magnification
		self.z *= magnification
	}
}
