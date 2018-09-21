//
//  GoDMatrix4.swift
//  GoD Tool
//
//  Created by The Steez on 03/09/2018.
//

import Cocoa
import GLKit

class GoDMatrix4: NSObject {
	
	var glkmatrix = GLKMatrix4Identity

	class func makePerspective(angleRad : Float, aspectRatio: Float, nearZ: Float, farZ: Float) -> GoDMatrix4 {
		let matrix = GoDMatrix4()
		matrix.glkmatrix = GLKMatrix4MakePerspective(angleRad, aspectRatio, nearZ, farZ);
		return matrix;
	}
	
	var copy : GoDMatrix4 {
		let newM = GoDMatrix4()
		newM.glkmatrix = self.glkmatrix
		return newM
	}
	
	var raw : (Float, Float, Float, Float, Float, Float, Float, Float, Float, Float, Float, Float, Float, Float, Float, Float) {
		let r = self.glkmatrix.m
		return r
	}
	
	func rawArray() -> [Float] {
		var r = [Float]()
		let rawData = self.raw
		r.append(rawData.0)
		r.append(rawData.1)
		r.append(rawData.2)
		r.append(rawData.3)
		r.append(rawData.4)
		r.append(rawData.5)
		r.append(rawData.6)
		r.append(rawData.7)
		r.append(rawData.8)
		r.append(rawData.9)
		r.append(rawData.10)
		r.append(rawData.11)
		r.append(rawData.12)
		r.append(rawData.13)
		r.append(rawData.14)
		r.append(rawData.15)
		return r
	}
	
	func scale(x: Float, y: Float, z: Float) {
		self.glkmatrix = GLKMatrix4Scale(self.glkmatrix, x, y, z)
	}
	
	func rotate(xRadians x: Float, yRadians y: Float, zRadians z: Float) {
		self.glkmatrix = GLKMatrix4RotateX(self.glkmatrix, x)
		self.glkmatrix = GLKMatrix4RotateY(self.glkmatrix, y)
		self.glkmatrix = GLKMatrix4RotateZ(self.glkmatrix, z)
	}
	
	func rotate(vector_degrees v: Vector3) {
		let z = GoDMatrix4.degreesToRadians(v.v0)
		let y = GoDMatrix4.degreesToRadians(v.v1)
		let x = GoDMatrix4.degreesToRadians(v.v2)
		self.rotate(xRadians: x, yRadians: y, zRadians: z)
	}
	
	func translate(x: Float, y: Float, z: Float) {
		self.glkmatrix = GLKMatrix4Translate(self.glkmatrix, x, y, z)
	}
	
	func translate(vector: Vector3) {
		self.translate(x: vector.v0, y: vector.v1, z: vector.v2)
	}
	
	func multiplyLeft(withMatrix matrix: GoDMatrix4) {
		self.glkmatrix = GLKMatrix4Multiply(matrix.glkmatrix, self.glkmatrix)
	}
	
	func transpose() {
		self.glkmatrix = GLKMatrix4Transpose(self.glkmatrix)
	}
	
	class func degreesToRadians(_ degrees: Float) -> Float {
		return GLKMathDegreesToRadians(degrees)
	}
	
	static var numberOfElements : Int {
		return 16;
	}
	
}
