//
//  GoDOpenGLView.swift
//  GoDToolCL
//
//  Created by The Steez on 28/05/2018.
//
// following tutorial @ http://buggyworks.blogspot.co.uk/
//

import Cocoa
import OpenGL.GL3
import GLKit
import Darwin


enum XGShaders {
	case vertex
	case fragment
	
	var value : GLenum {
		switch self {
		case .vertex:
			return GLenum(GL_VERTEX_SHADER)
		case .fragment:
			return GLenum(GL_FRAGMENT_SHADER)
		}
	}
	
	var filename : String {
		switch self {
		case .vertex:
			return "vertex"
		case .fragment:
			return "fragment"
		}
	}
	
	var sourceCode : String {
		return XGResources.shader(filename).data.string
	}
}

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
		
		// padding so vertexes forming triangle align to same vbo buffer
		data.append(0.0)
		data.append(0.0)
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

enum KeyCodeName: UInt16 {
	case W		= 13
	case A		= 0
	case S		= 1
	case D		= 2
	case i		= 34
	case enter	= 36
	case space  = 49
	case one	= 18
	case two	= 19
	case three	= 20
	case four	= 21
	case five	= 23
	case six	= 22
	case seven	= 26
	case eight	= 28
	case nine	= 25
	case zero	= 29
	case plus	= 24
	case minus	= 27
	case up		= 126
	case down	= 125
	case left	= 123
	case right	= 124
	case tab	= 48
	case delete	= 51
	case lessthan = 43
	case morethan = 47
	
	static var allKeys : [KeyCodeName] {
		var keys = [KeyCodeName]()
		for i : UInt16 in 0 ... 255 {
			if let key = KeyCodeName(rawValue: i) {
				keys.append(key)
			}
		}
		return keys
	}
	
	static var dictionaryOfKeys : [KeyCodeName: Bool] {
		var keys = [KeyCodeName: Bool]()
		
		for key in allKeys {
			keys[key] = false
		}
		
		return keys
	}
}

class GoDOpenGLView: NSOpenGLView {
	
	var dictionaryOfKeys : [KeyCodeName : Bool] = KeyCodeName.dictionaryOfKeys
	override var acceptsFirstResponder: Bool { return true }
	
	//  The handle to our shader
	private var programID :  GLuint  =  0
	private var depthID   :  GLuint  =  0
	private var renderID  :  GLuint  =  0
	private var vaoIDs    : [GLuint] = [0]
	private var vboIDs    : [GLuint] = [0]
	
	
	var lightPosition : Vector3 = Vector3(v0: 0.0, v1: 0.0, v2: 2.0)
	var ambientLight :  GLfloat  = 0.25
	var specular : GLfloat = 1.0
	var shininess : GLfloat = 32
	
	var defaultCameraPosition = Vector3(v0: 0.0, v1: -0.15, v2: -2.0)
	var cameraPosition : Vector3!
	var defaultCameraOrientation = Vector3(v0: 0.0, v1: 0.0, v2: 0.0)
	var cameraOrientation : Vector3!
	
	var invertRotation = true
	
	var cameraSpeed : Float = 2.0 {
		didSet {
			cameraSpeed = max(cameraSpeed, 0.1)
		}
	}
	
	var previousTime : Float = 0
	
	private var view = Matrix4()
	private var projection = Matrix4()
	var defaultProjection : Matrix4 {
		return Matrix4(fieldOfView: 90, aspect: Float(bounds.size.width) / Float(bounds.size.height), nearZ: 0.001, farZ: 1000)
	}
	
	var background = GoDDesign.colourWhite()
	
	private var timer = Timer()
	
	var file : XGFiles! {
		didSet {
			
			cameraPosition = defaultCameraPosition
			cameraOrientation = defaultCameraOrientation
			
			for i in 0 ..< vboIDs.count {
				glDeleteVertexArrays(1, &vaoIDs[i])
				glDeleteBuffers(1, &vboIDs[i])
			}
			glDeleteBuffers(1, &depthID)
			glDeleteBuffers(1, &renderID)
			
			let data = XGCollisionData(file: self.file).vertexes
			
			let vertexCount = data.count
			let vboCount : GLsizei = GLsizei(vertexCount / kVertexesPerBuffer) + 1
			vboIDs = [GLuint]()
			vaoIDs = [GLuint]()
			var vbos = [[GLfloat]]()
			for _ in 0 ..< vboCount {
				vboIDs.append(0)
				vaoIDs.append(0)
			}
			var currentVertexIndex = 0
			for _ in 0 ..< vboCount {
				var vbo = [GLfloat]()
				
				while (vbo.count * kGLFloatSize / kXGVertexSize) < kVertexesPerBuffer && currentVertexIndex < vertexCount {
					vbo += data[currentVertexIndex].rawData
					currentVertexIndex += 1
				}
				
				vbos.append(vbo)
			}
			
			
			for i in 0 ..< vbos.count {
				glGenBuffers(1, &vboIDs[i])
				glBindBuffer(GLenum(GL_ARRAY_BUFFER), vboIDs[i])
				
				// load data into vbo
				glBufferData(GLenum(GL_ARRAY_BUFFER), vbos[i].count * kGLFloatSize, vbos[i], GLenum(GL_STATIC_DRAW))
				
				glGenVertexArrays(1, &vaoIDs[i])
				glBindVertexArray(vaoIDs[i])
				
				glVertexAttribPointer(0, 3, GLenum(GL_FLOAT), GLboolean(GL_FALSE), GLsizei(kXGVertexSize), UnsafePointer<GLuint>(bitPattern: 0))
				glEnableVertexAttribArray(0)    //  Enable the attribute (otherwise it won't accept data)
				
				glVertexAttribPointer(1, 1, GLenum(GL_FLOAT), GLboolean(GL_FALSE), GLsizei(kXGVertexSize), UnsafePointer<GLuint>(bitPattern: 12))
				glEnableVertexAttribArray(1)
				
				glVertexAttribPointer(2, 1, GLenum(GL_FLOAT), GLboolean(GL_FALSE), GLsizei(kXGVertexSize), UnsafePointer<GLuint>(bitPattern: 16))
				glEnableVertexAttribArray(2)
				
				glVertexAttribPointer(3, 3, GLenum(GL_FLOAT), GLboolean(GL_FALSE), GLsizei(kXGVertexSize), UnsafePointer<GLuint>(bitPattern: 20))
				glEnableVertexAttribArray(3)
				
				glBindVertexArray(0)    //  Ensure no further changes are made to the VAO.
				
			}
			
//			glGenRenderbuffers(1, &depthID)
//			glBindRenderbuffer(GLenum(GL_RENDERBUFFER), depthID)
//			glRenderbufferStorage(GLenum(GL_RENDERBUFFER), GLenum(GL_DEPTH_COMPONENT16), GLsizei(self.frame.size.width), GLsizei(self.frame.size.height))
			
		}
	}
	
	required init?(coder: NSCoder) {
		super.init(coder: coder)
		
		let attrs: [NSOpenGLPixelFormatAttribute] = [
			UInt32(NSOpenGLPFAAccelerated),            //  Use accelerated renderers
			UInt32(NSOpenGLPFAColorSize), UInt32(32),  //  Use 32-bit color
			UInt32(NSOpenGLPFAOpenGLProfile),          //  Use version's >= 3.2 core
			UInt32( NSOpenGLProfileVersion3_2Core),
			UInt32(0)                                  //  C API's expect to end with 0
		]
		if let pixelFormat = NSOpenGLPixelFormat(attributes: attrs) {
			self.pixelFormat = pixelFormat
		} else {
			printg("pixelFormat could not be constructed")
			return
		}
		if let context = NSOpenGLContext(format: self.pixelFormat!, share: nil) {
			self.openGLContext = context
		} else {
			printg("context could not be constructed")
			return
		}
		
	}
	
	override func prepareOpenGL() {
		super.prepareOpenGL()
		
		self.timer = Timer(timeInterval: 0.001, target: self, selector: #selector(redraw), userInfo: nil, repeats: true)
		RunLoop.current.add(self.timer, forMode: RunLoopMode.defaultRunLoopMode)
		RunLoop.current.add(self.timer, forMode: RunLoopMode.eventTrackingRunLoopMode)
		
		// set clear view colour
		let bg = background.vec3
		glClearColor(bg[0], bg[1], bg[2], 1.0)
		
		programID = glCreateProgram()
		
		// load shaders
		let vs = loadShader(shader: .vertex)
		let fs = loadShader(shader: .fragment)
		glAttachShader(programID, vs)
		glAttachShader(programID, fs)
		
		glLinkProgram(programID)
		
		var linked: GLint = 0
		glGetProgramiv(programID, UInt32(GL_LINK_STATUS), &linked)
		if linked <= 0 {
			printg("Could not link shaders.")
		}
		
		glDeleteShader(vs)
		glDeleteShader(fs)
		
		if let context = self.openGLContext {
			context.makeCurrentContext()
		}
		
		previousTime = Float(CACurrentMediaTime())
	}
	
	func loadShader(shader: XGShaders) -> GLuint {
		func getPointer <T> (_ pointer: UnsafePointer<T>)->UnsafePointer<T> { return pointer }
		let newShader = glCreateShader(shader.value)
		let sdata = shader.sourceCode
		if var ss = sdata.cString(using: String.Encoding.ascii) {
			var ssptr : UnsafePointer<GLchar>? = getPointer(&ss)
			glShaderSource(newShader, 1, &ssptr, nil)
			glCompileShader(newShader)
			
			var compiled: GLint = 0
			glGetShaderiv(newShader, GLbitfield(GL_COMPILE_STATUS), &compiled)
			if compiled <= 0 {
				printg("Could not compile \(shader.filename) shader.")
			}
		}
		return newShader
	}
	
	func redraw() {
		projection = defaultProjection
		
		self.display()
	}
	
	override func viewDidEndLiveResize() {
		super.viewDidEndLiveResize()
		self.setBoundsSize(self.frame.size)
		self.setBoundsOrigin(self.frame.origin)
		self.redraw()
	}

    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
		render()
    }
	
	func render() {
		
		guard self.openGLContext != nil else {
			return
		}
		
		self.openGLContext!.setValues([1], for: .swapInterval)
		
		guard self.file != nil else {
			return
		}
		
		let time = Float(CACurrentMediaTime())
		updateViewMatrix(atTime: time)
		
		previousTime = time
		
		//  clear context
		glClear(GLbitfield(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT))
		
		//  Choose the shader to draw with
		glUseProgram(programID)
		
		glEnable(GLenum(GL_CULL_FACE))
		glEnable(GLenum(GL_DEPTH_TEST))
		
		glUniform3fv(glGetUniformLocation(programID, "lightColor"), 1, GoDDesign.colourWhite().vec3)
		glUniform3fv(glGetUniformLocation(programID, "lightPosition"), 1, [lightPosition.v0,lightPosition.v1,lightPosition.v2])
		glUniform1f(glGetUniformLocation(programID, "lightAmbient"), ambientLight)
		glUniform1f(glGetUniformLocation(programID, "k_specular"), 1.0)
		glUniform1f(glGetUniformLocation(programID, "shininess"), 32)
		
		projection = defaultProjection
		
		glUniformMatrix4fv(glGetUniformLocation(programID, "view"), 1, GLboolean(GL_FALSE), view.asArray())
		glUniformMatrix4fv(glGetUniformLocation(programID, "projection"), 1, GLboolean(GL_FALSE), projection.asArray())
		
		for i in 0 ..< vaoIDs.count {
			
			//  Choose the model to draw with
			glBindBuffer(GLenum(GL_ARRAY_BUFFER), vboIDs[i])
			glBindVertexArray(vaoIDs[i])
			glFramebufferRenderbuffer(GLenum(GL_FRAMEBUFFER), GLenum(GL_DEPTH_ATTACHMENT), GLenum(GL_RENDERBUFFER), depthID)
			
			// Draw
			glDrawArrays(GLenum(GL_TRIANGLES), 0, GLsizei(kVertexesPerBuffer))
		}
		glBindBuffer(GLenum(GL_ARRAY_BUFFER), 0)
		glBindVertexArray(0)
		
		//  output to screen
		glFlush()
	}
	
	deinit {
		
		//  The ampersand is used because the function asks for an UnsafePointer<GLuint>
		for i in 0 ..< vboIDs.count {
			glDeleteVertexArrays(1, &vaoIDs[i])
			glDeleteBuffers(1, &vboIDs[i])
		}
		glDeleteProgram(programID)
		self.timer.invalidate()
		
	}
	
	func updateViewMatrix(atTime time: Float) {
		//  The speed at which we desire to travel in units (or meters) per second
		//  Here we state we want to travel 10 m/s
		let amplitude = cameraSpeed * Float((time - previousTime))
		
		//  Find the new position by first pointing ourselves in the current direction
		//  Instead of using matrices, we'll use trigonometry to calculate the direction
		//    we are looking.  This calculated vector is then normalized before applying
		//    the amplitude value.  This "displacement" vector is then added to the
		//    camera's position vectors according to the key's currently being pressed
		let directionX = (sin(cameraOrientation.v1) * cos(cameraOrientation.v2))
		//  Moving off of the y = 0 plane is as easy as adding the y values (instead of
		//    multiplying) them together, otherwise looking up while moving forward does
		//    not affect the elevation of the viewer.  Give it a try.
		//  In order to get the camera to pitch up when you look up, negate the y value
		let directionY = -(sin(cameraOrientation.v0) + sin(cameraOrientation.v2))
		let directionZ = (cos(cameraOrientation.v0) * cos(cameraOrientation.v1))
		
		//  Create a vector, normalize it, and apply the amplitude value
		let displacement = Vector3(v0: directionX, v1: directionY, v2: directionZ).normalize() * amplitude
		
		//  For strafing, calculate the vector perpendicular to the current forward and up
		//    vectors by rotating the normalized X vector (1.0, 0.0, 0.0) according to current
		//    orientation, then re-normalize before applying the amplitude value
		let rightVector = Matrix4().rotateAlongXAxis(radians: cameraOrientation.v0).rotateAlongYAxis(radians: cameraOrientation.v1).inverse() * Vector3(v0: 1.0, v1: 0.0, v2: 0.0)
		
		let strafe = rightVector.normalize() * amplitude
		
		let elevation  = Vector3(v0: 0.0, v1: 1.0, v2: 0.0) * amplitude
//		let horizontal = Vector3(v0: 1.0, v1: 0.0, v2: 0.0) * amplitude
//		let depth = Vector3(v0: 0.0, v1: 0.0, v2: 1.0) * amplitude
		
		//  Cycle through the direction keys and apply displacement accordingly
		//  The switch statement allows us to test for conditions in which keys are pressed
		for direction in dictionaryOfKeys {
			switch direction {
			case (KeyCodeName.W, true):
				cameraPosition = Vector3(v0: cameraPosition.v0 + displacement.v0, v1: cameraPosition.v1 + displacement.v1, v2: cameraPosition.v2 + displacement.v2)
			case (KeyCodeName.S, true):
				//  Moving backwards is done by adding a negative displacement vector
				cameraPosition = Vector3(v0: cameraPosition.v0 - displacement.v0, v1: cameraPosition.v1 - displacement.v1, v2: cameraPosition.v2 - displacement.v2)
			case (KeyCodeName.A, true):
				cameraPosition = Vector3(v0: cameraPosition.v0 + strafe.v0, v1: cameraPosition.v1 - strafe.v1, v2: cameraPosition.v2 + strafe.v2)
			case (KeyCodeName.D, true):
				//  Strafing to the right is done with a negative strafe vector
				cameraPosition = Vector3(v0: cameraPosition.v0 - strafe.v0, v1: cameraPosition.v1 + strafe.v1, v2: cameraPosition.v2 - strafe.v2)
			case (KeyCodeName.space, true):
				cameraPosition = defaultCameraPosition
				cameraOrientation = defaultCameraOrientation
			case (KeyCodeName.zero, true):
				cameraPosition = Vector3(v0:0.0, v1:0.01, v2:0.0)
				cameraOrientation = Vector3(v0:0.0, v1:0.0, v2:0.0)
			case (KeyCodeName.one, true):
				cameraPosition = Vector3(v0:0.0, v1:0.0, v2:-2.0)
				cameraOrientation = Vector3(v0:0.0, v1:0.0, v2:0.0)
			case (KeyCodeName.three, true):
				cameraPosition = Vector3(v0:0.0, v1:2.0, v2:0.0)
				cameraOrientation = Vector3(v0:0.0, v1:0.0, v2:0.0)
				rotateCamera(pitch: 270.0, yaw: 0.0)
			case (KeyCodeName.two, true):
				cameraPosition = Vector3(v0:0.0, v1:-2.0, v2:0.0)
				cameraOrientation = Vector3(v0:0.0, v1:0.0, v2:0.0)
				rotateCamera(pitch: 90.0, yaw: 0.0)
			case (KeyCodeName.plus, true):
				cameraSpeed += 0.1
			case (KeyCodeName.minus, true):
				cameraSpeed -= 0.1
			case (KeyCodeName.up, true):
				cameraPosition = Vector3(v0: cameraPosition.v0 + elevation.v0, v1: cameraPosition.v1 - elevation.v1, v2: cameraPosition.v2 + elevation.v2)
			case (KeyCodeName.down, true):
				cameraPosition = Vector3(v0: cameraPosition.v0 + elevation.v0, v1: cameraPosition.v1 + elevation.v1, v2: cameraPosition.v2 + elevation.v2)
			case (KeyCodeName.left, true):
				rotateCamera(pitch: 0.0, yaw: -amplitude * 100)
			case (KeyCodeName.right, true):
				rotateCamera(pitch: 0.0, yaw: amplitude * 100)
			case (KeyCodeName.four, true):
				lightPosition = Vector3(v0: 0.0, v1: 0.01, v2: 0.0)
			case (KeyCodeName.five, true):
				lightPosition = Vector3(v0: 0.0, v1: 2.0, v2: 0.0)
			case (KeyCodeName.six, true):
				lightPosition = Vector3(v0: 0.0, v1: 0.0, v2: 2.0)
			case (KeyCodeName.seven, true):
				lightPosition = cameraPosition
			case (KeyCodeName.tab, true):
				circumnavigate(x: cameraPosition.v2, y: 0.0)
			case (KeyCodeName.delete, true):
				circumnavigate(x: -cameraPosition.v2, y: 0.0)
			case (KeyCodeName.morethan, true):
				rotateCamera(pitch: -amplitude * 100, yaw: 0.0)
			case (KeyCodeName.lessthan, true):
				rotateCamera(pitch: amplitude * 100, yaw: 0.0)
			case (KeyCodeName.enter, true):
				rotateCamera(pitch: -cameraOrientation.v1 * degreesPerRadian, yaw: -cameraOrientation.v0 * degreesPerRadian)
			default:
				break;
			}
		}
		
		//  Update the view Matrix with our new position--use the translate function
		view = Matrix4().rotateAlongXAxis(radians: cameraOrientation.v0).rotateAlongYAxis(radians: cameraOrientation.v1).translate(x: cameraPosition.v0, y: cameraPosition.v1, z: cameraPosition.v2)
	}
	
	func mouseEvent(deltaX x: Float, deltaY y: Float) {
		circumnavigate(x: x/100 * cameraSpeed, y: y/100 * cameraSpeed)
	}
	
	func circumnavigate(x: Float, y: Float) {
		
		let oldPosition = cameraPosition!
		
		// x^2 + y^2 + z^2 = r^2
		let r2 = cameraPosition.v0.raisedToPower(2) + cameraPosition.v1.raisedToPower(2) + cameraPosition.v2.raisedToPower(2)
		let zIsNegative = cameraPosition.v2 < 0
		
		let newX = cameraPosition.v0 + x
		let newY = cameraPosition.v1 + y
		var newZ = (r2 - (newX.raisedToPower(2) + newY.raisedToPower(2))).squareRoot()
		newZ = zIsNegative ? -newZ : newZ
		
		let dx = abs(x)
		let dy = abs(y)
		let dz = abs(oldPosition.v2 - newZ)
		
		let dxz = (dx.raisedToPower(2) + dz.raisedToPower(2)).squareRoot()
		let dyz = (dy.raisedToPower(2) + dz.raisedToPower(2)).squareRoot()
		
		let rxz = (cameraPosition.v0.raisedToPower(2) + cameraPosition.v2.raisedToPower(2)).squareRoot()
		let ryz = (cameraPosition.v1.raisedToPower(2) + cameraPosition.v2.raisedToPower(2)).squareRoot()
		
		// sohcahtoa
		let sinthetaxz = (dxz / 2) / rxz
		let sinthetayz = (dyz / 2) / ryz
		
		var anglexz = asin(sinthetaxz) * 2 * (x < 0 ? -1 : 1)
		var angleyz = asin(sinthetayz) * 2 * (x < 0 ? -1 : 1)
		
		if y == 0 { angleyz = 0}
		if x == 0 { anglexz = 0}
		
		cameraPosition = Vector3(v0: newX, v1: newY, v2: newZ)
		
		rotateCamera(pitch: angleyz * degreesPerRadian, yaw: anglexz * degreesPerRadian)
	}
	
	func rotateCamera(pitch xR: Float, yaw yR: Float) {
		
		let xRotation = invertRotation ? xR : -xR
		let yRotation = invertRotation ? yR : -yR
		
		//  Retrieve the number of degrees to add to the current camera rotation on the x axis
		//    Consider xRotation to be in degrees--convert to radians
		let xRadians = cameraOrientation.v0 + -xRotation * radiansPerDegree
		
		//  Constrain radians to be within 2 Pi
		if 0 <= xRadians || xRadians <= Float(M_2_PI) {
			cameraOrientation.v0 = xRadians
		} else if xRadians > Float(M_2_PI) {
			//  Set rotation to the excess
			cameraOrientation.v0 = xRadians - Float(M_2_PI)
		} else {
			//  Essentially subtracts the negative overflow from the top end rotation (2 Pi)
			cameraOrientation.v0 = xRadians + Float(M_2_PI)
		}
		
		let yRadians = cameraOrientation.v1 + -yRotation * radiansPerDegree
		
		if 0 <= yRadians || yRadians <= Float(M_2_PI) {
			cameraOrientation.v1 = yRadians
		} else if yRadians > Float(M_2_PI) {
			cameraOrientation.v1 = yRadians - Float(M_2_PI)
		} else {
			cameraOrientation.v1 = yRadians + Float(M_2_PI)
		}
		
		
	}
    
}















