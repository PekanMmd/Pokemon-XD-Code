//
//  GoDOpenGL.swift
//  GoD Tool
//
//  Created by The Steez on 28/05/2018.
//

import Foundation
import OpenGL

typealias Radians = Float
let PI : Radians = Radians(Double.pi)
let PI_2 = PI / 2
let PI_4 = PI / 4

let degreesPerRadian = 180 / PI
let radiansPerDegree = PI / 180

struct Vector3 {
	
	var v0 = Float()
	var v1 = Float()
	var v2 = Float()
	
	init() {}
	
	init(v0: Float, v1: Float, v2: Float) {
		self.v0 = v0
		self.v1 = v1
		self.v2 = v2
	}
	
	func normalize() -> Vector3 {
		let length = sqrt(v0 * v0 + v1 * v1 + v2 * v2)
		
		return Vector3(v0: self.v0 / length, v1: self.v1 / length, v2: self.v2 / length)
	}
	
}

func +(lhs: Vector3, rhs: Vector3) -> Vector3 {
	return Vector3(v0: lhs.v0 + rhs.v0, v1: lhs.v1 + rhs.v1, v2: lhs.v2 + rhs.v2)
}


func -(lhs: Vector3, rhs: Vector3) -> Vector3 {
	return Vector3(v0: lhs.v0 - rhs.v0, v1: lhs.v1 - rhs.v1, v2: lhs.v2 - rhs.v2)
}


func *(lhs: Vector3, rhs: Vector3) -> Vector3 {
	return Vector3(v0: lhs.v0 * rhs.v0, v1: lhs.v1 * rhs.v1, v2: lhs.v2 * rhs.v2)
}
func *(lhs: Vector3, rhs: Float) -> Vector3 {
	return Vector3(v0: lhs.v0 * rhs, v1: lhs.v1 * rhs, v2: lhs.v2 * rhs)
	
}

struct Matrix4 {
	
	var m00 = Float(), m01 = Float(), m02 = Float(), m03 = Float()
	var m10 = Float(), m11 = Float(), m12 = Float(), m13 = Float()
	var m20 = Float(), m21 = Float(), m22 = Float(), m23 = Float()
	var m30 = Float(), m31 = Float(), m32 = Float(), m33 = Float()
	
	init() {
		
		m00 = 1.0
		m01 = Float()
		m02 = Float()
		m03 = Float()
		
		m10 = Float()
		m11 = 1.0
		m12 = Float()
		m13 = Float()
		
		m20 = Float()
		m21 = Float()
		m22 = 1.0
		m23 = Float()
		
		m30 = Float()
		m31 = Float()
		m32 = Float()
		m33 = 1.0
		
	}
	
	init(m00: Float, m01: Float, m02: Float, m03: Float,
		 m10: Float, m11: Float, m12: Float, m13: Float,
		 m20: Float, m21: Float, m22: Float, m23: Float,
		 m30: Float, m31: Float, m32: Float, m33: Float) {
		
		self.m00 = m00
		self.m01 = m01
		self.m02 = m02
		self.m03 = m03
		
		self.m10 = m10
		self.m11 = m11
		self.m12 = m12
		self.m13 = m13
		
		self.m20 = m20
		self.m21 = m21
		self.m22 = m22
		self.m23 = m23
		
		self.m30 = m30
		self.m31 = m31
		self.m32 = m32
		self.m33 = m33
		
	}
	
	init(fieldOfView fov: Float, aspect: Float, nearZ: Float, farZ: Float) {
		
		m00 = (1 / tan(fov * Float(.pi / 180.0) * 0.5)) / aspect
		m01 = 0.0
		m02 = 0.0
		m03 = 0.0
		
		m10 = 0.0
		m11 = 1 / tan(fov * Float(.pi / 180.0) * 0.5)
		m12 = 0.0
		m13 = 0.0
		
		m20 = 0.0
		m21 = 0.0
		m22 = (farZ + nearZ) / (nearZ - farZ)
		m23 = (2 * farZ * nearZ) / (nearZ - farZ)
		
		m30 = 0.0
		m31 = 0.0
		m32 = -1.0
		m33 = 0.0
		
	}
	
	func inverse() -> Matrix4 {
		
		// Capture the current matrix
		let m = self
		
		// Calculate the minors of self
		let minors = Matrix4(
			m00: (m.m11 * (m.m22 * m.m33 - m.m23 * m.m32)) - (m.m12 * (m.m21 * m.m33 - m.m23 * m.m31)) + (m.m13 * (m.m21 * m.m32 - m.m22 * m.m31)),
			m01: (m.m10 * (m.m22 * m.m33 - m.m23 * m.m32)) - (m.m12 * (m.m20 * m.m33 - m.m23 * m.m30)) + (m.m13 * (m.m20 * m.m32 - m.m22 * m.m30)),
			m02: (m.m10 * (m.m21 * m.m33 - m.m23 * m.m31)) - (m.m11 * (m.m20 * m.m33 - m.m23 * m.m30)) + (m.m13 * (m.m20 * m.m31 - m.m21 * m.m30)),
			m03: (m.m10 * (m.m21 * m.m32 - m.m22 * m.m31)) - (m.m11 * (m.m20 * m.m32 - m.m22 * m.m30)) + (m.m12 * (m.m20 * m.m31 - m.m21 * m.m30)),
			
			m10: (m.m01 * (m.m22 * m.m33 - m.m23 * m.m32)) - (m.m02 * (m.m21 * m.m33 - m.m23 * m.m31)) + (m.m03 * (m.m21 * m.m32 - m.m22 * m.m31)),
			m11: (m.m00 * (m.m22 * m.m33 - m.m23 * m.m32)) - (m.m02 * (m.m20 * m.m33 - m.m23 * m.m30)) + (m.m03 * (m.m20 * m.m32 - m.m22 * m.m30)),
			m12: (m.m00 * (m.m21 * m.m33 - m.m23 * m.m31)) - (m.m01 * (m.m20 * m.m33 - m.m23 * m.m30)) + (m.m03 * (m.m20 * m.m31 - m.m21 * m.m30)),
			m13: (m.m00 * (m.m21 * m.m32 - m.m22 * m.m31)) - (m.m01 * (m.m20 * m.m32 - m.m22 * m.m30)) + (m.m02 * (m.m20 * m.m31 - m.m21 * m.m30)),
			
			m20: (m.m01 * (m.m12 * m.m33 - m.m13 * m.m32)) - (m.m02 * (m.m11 * m.m33 - m.m13 * m.m31)) + (m.m03 * (m.m11 * m.m32 - m.m12 * m.m31)),
			m21: (m.m00 * (m.m12 * m.m33 - m.m13 * m.m32)) - (m.m02 * (m.m10 * m.m33 - m.m13 * m.m30)) + (m.m03 * (m.m10 * m.m32 - m.m12 * m.m30)),
			m22: (m.m00 * (m.m11 * m.m33 - m.m13 * m.m31)) - (m.m01 * (m.m10 * m.m33 - m.m13 * m.m30)) + (m.m03 * (m.m10 * m.m31 - m.m11 * m.m30)),
			m23: (m.m00 * (m.m11 * m.m32 - m.m12 * m.m31)) - (m.m01 * (m.m10 * m.m32 - m.m12 * m.m30)) + (m.m02 * (m.m10 * m.m31 - m.m11 * m.m30)),
			
			m30: (m.m01 * (m.m12 * m.m23 - m.m13 * m.m22)) - (m.m02 * (m.m11 * m.m23 - m.m13 * m.m21)) + (m.m03 * (m.m11 * m.m22 - m.m12 * m.m21)),
			m31: (m.m00 * (m.m12 * m.m23 - m.m13 * m.m22)) - (m.m02 * (m.m10 * m.m23 - m.m13 * m.m20)) + (m.m03 * (m.m10 * m.m22 - m.m12 * m.m20)),
			m32: (m.m00 * (m.m11 * m.m23 - m.m13 * m.m21)) - (m.m01 * (m.m10 * m.m23 - m.m13 * m.m20)) + (m.m03 * (m.m10 * m.m21 - m.m11 * m.m20)),
			m33: (m.m00 * (m.m11 * m.m22 - m.m12 * m.m21)) - (m.m01 * (m.m10 * m.m22 - m.m12 * m.m20)) + (m.m02 * (m.m10 * m.m21 - m.m11 * m.m20)))
		
		// Calculate the inverse determinant by multiplying the elements of the first row
		//   of self by the elements of the first row of minors then get the reciprocal
		let invDeterminant = 1 / (m.m00 * minors.m00 - m.m01 * minors.m01 + m.m02 * minors.m02 - m.m03 * minors.m03)
		
		// Apply the + - sign pattern, transpose the matrix, then multiply by the invDeterminant
		let im = Matrix4(
			m00: +minors.m00 * invDeterminant,
			m01: -minors.m10 * invDeterminant,
			m02: +minors.m20 * invDeterminant,
			m03: -minors.m30 * invDeterminant,
			
			m10: -minors.m01 * invDeterminant,
			m11: +minors.m11 * invDeterminant,
			m12: -minors.m21 * invDeterminant,
			m13: +minors.m31 * invDeterminant,
			
			m20: +minors.m02 * invDeterminant,
			m21: -minors.m12 * invDeterminant,
			m22: +minors.m22 * invDeterminant,
			m23: -minors.m32 * invDeterminant,
			
			m30: -minors.m03 * invDeterminant,
			m31: +minors.m13 * invDeterminant,
			m32: -minors.m23 * invDeterminant,
			m33: +minors.m33 * invDeterminant)
		
		return im
		
	}
	
	func translate(x: Float, y: Float, z: Float) -> Matrix4 {
		
		var m = Matrix4()
		
		m.m03 += m.m00 * x + m.m01 * y + m.m02 * z
		m.m13 += m.m10 * x + m.m11 * y + m.m12 * z
		m.m23 += m.m20 * x + m.m21 * y + m.m22 * z
		m.m33 += m.m30 * x + m.m31 * y + m.m32 * z
		
		return self * m
		
	}
	
	func rotate(radians angle: Float, alongAxis axis: Vector3) -> Matrix4 {
		
		let cosine = cos(angle)
		let inverseCosine = 1.0 - cosine
		let sine = sin(angle)
		
		return self * Matrix4(
			m00: cosine + inverseCosine * axis.v0 * axis.v0,
			m01: inverseCosine * axis.v0 * axis.v1 + axis.v2 * sine,
			m02: inverseCosine * axis.v0 * axis.v2 - axis.v1 * sine,
			m03: 0.0,
			
			m10: inverseCosine * axis.v0 * axis.v1 - axis.v2 * sine,
			m11: cosine + inverseCosine * axis.v1 * axis.v1,
			m12: inverseCosine * axis.v1 * axis.v2 + axis.v0 * sine,
			m13: 0.0,
			
			m20: inverseCosine * axis.v0 * axis.v2 + axis.v1 * sine,
			m21: inverseCosine * axis.v1 * axis.v2 - axis.v0 * sine,
			m22: cosine + inverseCosine * axis.v2 * axis.v2,
			m23: 0.0,
			
			m30: 0.0,
			m31: 0.0,
			m32: 0.0,
			m33: 1.0)
		
	}
	
	func rotateAlongXAxis(radians: Float) -> Matrix4 {
		
		var m = Matrix4()
		
		m.m11 = cos(radians)
		m.m12 = sin(radians)
		m.m21 = -sin(radians)
		m.m22 = cos(radians)
		
		return self * m
		
	}
	
	func rotateAlongYAxis(radians: Float) -> Matrix4 {
		
		var m = Matrix4()
		
		m.m00 = cos(radians)
		m.m02 = -sin(radians)
		m.m20 = sin(radians)
		m.m22 = cos(radians)
		
		return self * m
		
	}
	
	func asArray() -> [Float] {
		return [self.m00, self.m10, self.m20, self.m30,
				self.m01, self.m11, self.m21, self.m31,
				self.m02, self.m12, self.m22, self.m32,
				self.m03, self.m13, self.m23, self.m33]
	}
}

func *(lhs: Matrix4, rhs: Matrix4) -> Matrix4 {
	
	return Matrix4(
		m00: lhs.m00 * rhs.m00 + lhs.m01 * rhs.m10 + lhs.m02 * rhs.m20 + lhs.m03 * rhs.m30,
		m01: lhs.m00 * rhs.m01 + lhs.m01 * rhs.m11 + lhs.m02 * rhs.m21 + lhs.m03 * rhs.m31,
		m02: lhs.m00 * rhs.m02 + lhs.m01 * rhs.m12 + lhs.m02 * rhs.m22 + lhs.m03 * rhs.m32,
		m03: lhs.m00 * rhs.m03 + lhs.m01 * rhs.m13 + lhs.m02 * rhs.m23 + lhs.m03 * rhs.m33,
		
		m10: lhs.m10 * rhs.m00 + lhs.m11 * rhs.m10 + lhs.m12 * rhs.m20 + lhs.m13 * rhs.m30,
		m11: lhs.m10 * rhs.m01 + lhs.m11 * rhs.m11 + lhs.m12 * rhs.m21 + lhs.m13 * rhs.m31,
		m12: lhs.m10 * rhs.m02 + lhs.m11 * rhs.m12 + lhs.m12 * rhs.m22 + lhs.m13 * rhs.m32,
		m13: lhs.m10 * rhs.m03 + lhs.m11 * rhs.m13 + lhs.m12 * rhs.m23 + lhs.m13 * rhs.m33,
		
		m20: lhs.m20 * rhs.m00 + lhs.m21 * rhs.m10 + lhs.m22 * rhs.m20 + lhs.m23 * rhs.m30,
		m21: lhs.m20 * rhs.m01 + lhs.m21 * rhs.m11 + lhs.m22 * rhs.m21 + lhs.m23 * rhs.m31,
		m22: lhs.m20 * rhs.m02 + lhs.m21 * rhs.m12 + lhs.m22 * rhs.m22 + lhs.m23 * rhs.m32,
		m23: lhs.m20 * rhs.m03 + lhs.m21 * rhs.m13 + lhs.m22 * rhs.m23 + lhs.m23 * rhs.m33,
		
		m30: lhs.m30 * rhs.m00 + lhs.m31 * rhs.m10 + lhs.m32 * rhs.m20 + lhs.m33 * rhs.m30,
		m31: lhs.m30 * rhs.m01 + lhs.m31 * rhs.m11 + lhs.m32 * rhs.m21 + lhs.m33 * rhs.m31,
		m32: lhs.m30 * rhs.m02 + lhs.m31 * rhs.m12 + lhs.m32 * rhs.m22 + lhs.m33 * rhs.m32,
		m33: lhs.m30 * rhs.m03 + lhs.m31 * rhs.m13 + lhs.m32 * rhs.m23 + lhs.m33 * rhs.m33)
	
}

func *(lhs: Matrix4, rhs: Vector3) -> Vector3 {
	
	return Vector3(v0: lhs.m00 * rhs.v0 + lhs.m01 * rhs.v1 + lhs.m02 * rhs.v2,
				   v1: lhs.m10 * rhs.v0 + lhs.m11 * rhs.v1 + lhs.m12 * rhs.v2,
				   v2: lhs.m20 * rhs.v0 + lhs.m21 * rhs.v1 + lhs.m22 * rhs.v2)
	
}



















