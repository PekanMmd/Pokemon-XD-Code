//
//  GoDMetalView.swift
//  GoDToolCL
//
//  Created by The Steez on 03/09/2018.
//

import Cocoa
import Metal

let metalManager = GoDMetalManager()
class GoDMetalManager : NSObject {
	
	var device : MTLDevice!
	var metalLayer : CAMetalLayer!
	var pipelineState : MTLRenderPipelineState!
	var depthState : MTLDepthStencilState!
	var commandQueue : MTLCommandQueue!
	
	var uniformBuffer: MTLBuffer!
	var vertexBuffer: MTLBuffer!
	var vertexCount = 0
	
	var interactionIndexToHighlight = -1  {
		didSet {
			createUniformBuffer()
		}
	}
	
	var sectionIndexToHighlight = -1  {
		didSet {
			createUniformBuffer()
		}
	}
	
	var projectionMatrix = GoDMatrix4() {
		didSet {
			createUniformBuffer()
		}
	}
	
	var cameraPosition = Vector3(v0: 0.0, v1: 0.0, v2: 0.0)  {
		didSet {
			createUniformBuffer()
		}
	}
	var cameraOrientation = Vector3(v0: 0.0, v1: 0.0, v2: 0.0)  {
		didSet {
			createUniformBuffer()
		}
	}
	
	var viewMatrix : GoDMatrix4 {
		let m = GoDMatrix4()
		m.translate(vector: cameraPosition)
		m.rotate(vector_degrees: cameraOrientation)
		return m
	}
	
	var lightPosition : Vector3 = Vector3(v0: 0.0, v1: -1.0, v2: -0.3)
	var ambientLight :  Float  = 0.35
	var specular : Float = 1.0
	var shininess : Float = 32
	
	var clearColour = GoDDesign.isDarkModeEnabled ? GoDDesign.colourDarkGrey() : GoDDesign.colourLightGrey()
	
	override init() {
		super.init()
		
		device = MTLCreateSystemDefaultDevice()
		
		metalLayer = CAMetalLayer()
		metalLayer.device = device
		metalLayer.pixelFormat = .bgra8Unorm
		metalLayer.framebufferOnly = true
		
		let defaultLibrary = device.makeDefaultLibrary()!
		let vertexProgram = defaultLibrary.makeFunction(name: "shader_vertex")
		let fragmentProgram = defaultLibrary.makeFunction(name: "shader_fragment")
		
		let pipelineStateDescriptor = MTLRenderPipelineDescriptor()
		pipelineStateDescriptor.vertexFunction = vertexProgram
		pipelineStateDescriptor.fragmentFunction = fragmentProgram
		pipelineStateDescriptor.colorAttachments[0].pixelFormat = .bgra8Unorm
		pipelineStateDescriptor.depthAttachmentPixelFormat = .depth32Float
		self.pipelineState = try! device.makeRenderPipelineState(descriptor: pipelineStateDescriptor)
		
		let depth = MTLDepthStencilDescriptor()
		depth.isDepthWriteEnabled = true
		depth.depthCompareFunction = .less
		self.depthState = self.device.makeDepthStencilState(descriptor: depth)
		
		self.commandQueue = device.makeCommandQueue()
		
	}
	
	func createVertexBuffer(collisionData data: XGCollisionData) {
		
		let vertexData = data.rawVertexBuffer as [Float]
		guard vertexData.count > 0 else {
			vertexCount = 0
			return
		}
		let dataSize = vertexData.count * MemoryLayout.size(ofValue: vertexData[0])
		
		vertexBuffer = device.makeBuffer(bytes: vertexData, length: dataSize, options: [])
		vertexCount = data.vertexes.count
		
	}
	
	func createUniformBuffer() {
		let uniformData = projectionMatrix.rawArray() + viewMatrix.rawArray() + [Float(interactionIndexToHighlight)] + [Float(sectionIndexToHighlight)]
		// hard code because either compiler is being dumb or I'm being dumb
		let dataSize = 148 //uniformData.count * MemoryLayout.size(ofValue: uniformData[0])
		
		uniformBuffer = device.makeBuffer(bytes: uniformData, length: dataSize, options: [])
	}
	
	func render() {
		if let drawable = metalLayer.nextDrawable() {
			self.render(commandQueue: commandQueue, pipelineState: pipelineState, drawable: drawable, clearColor: nil)
		}
	}
	
	func render(commandQueue: MTLCommandQueue, pipelineState: MTLRenderPipelineState, drawable: CAMetalDrawable, clearColor: MTLClearColor?){
		
		guard vertexBuffer != nil else {
			return
		}
		
		let renderPassDescriptor = MTLRenderPassDescriptor()
		renderPassDescriptor.colorAttachments[0].texture = drawable.texture
		renderPassDescriptor.colorAttachments[0].loadAction = .clear
		renderPassDescriptor.colorAttachments[0].clearColor = MTLClearColor(red: Double(self.clearColour.redComponent), green: Double(self.clearColour.greenComponent), blue: Double(self.clearColour.blueComponent), alpha: 1.0)
		renderPassDescriptor.colorAttachments[0].storeAction = .store
		
		let depth = MTLTextureDescriptor.texture2DDescriptor(pixelFormat: .depth32Float, width: Int(metalLayer.frame.width), height: Int(metalLayer.frame.height), mipmapped: false)
		depth.resourceOptions = .storageModePrivate
		depth.usage = .renderTarget
		renderPassDescriptor.depthAttachment.clearDepth = 1000
		renderPassDescriptor.depthAttachment.loadAction = .clear
		renderPassDescriptor.depthAttachment.storeAction = .store
		renderPassDescriptor.depthAttachment.texture = self.device.makeTexture(descriptor: depth)
		
		let commandBuffer = commandQueue.makeCommandBuffer()!
		
		let renderEncoder = commandBuffer.makeRenderCommandEncoder(descriptor: renderPassDescriptor)!
		renderEncoder.setRenderPipelineState(self.pipelineState)
		renderEncoder.setDepthStencilState(self.depthState)
//		renderEncoder.setCullMode(MTLCullMode.front)
		renderEncoder.setVertexBuffer(vertexBuffer , offset: 0, index: 0)
		renderEncoder.setVertexBuffer(uniformBuffer, offset: 0, index: 1)
		renderEncoder.drawPrimitives(type: .triangle, vertexStart: 0, vertexCount: vertexCount,
									 instanceCount: vertexCount/3)
		renderEncoder.endEncoding()
		
		commandBuffer.present(drawable)
		commandBuffer.commit()
	}
}

class GoDMetalView: NSView {
	
	var file : XGFiles? {
		didSet {
			if let f = file {
				let data = f.collisionData
				metalManager.createVertexBuffer(collisionData: data)
				self.interactionIndexes = data.interactableIndexes
				self.sectionIndexes = data.sectionIndexes
				setDefaultPositions()
				metalManager.interactionIndexToHighlight = -1
				metalManager.sectionIndexToHighlight = -1
			}
		}
	}
	
	required init?(coder decoder: NSCoder) {
		super.init(coder: decoder)
	}
	
	var popup = GoDPopUpButton()
	var interactionIndexes : [Int]! {
		didSet {
			var titles = ["-"]
			for i in interactionIndexes {
				titles.append("interactable region \(i)")
			}
			popup.setTitles(values: titles)
		}
	}
	
	var popup2 = GoDPopUpButton()
	var sectionIndexes : [Int]! {
		didSet {
			var titles = ["-"]
			for i in sectionIndexes {
				titles.append("section \(i)")
			}
			popup2.setTitles(values: titles)
		}
	}
	
	var dictionaryOfKeys : [KeyCodeName : Bool] = KeyCodeName.dictionaryOfKeys
	override var acceptsFirstResponder: Bool { return true }
	
	var timer: Timer?
	var previousTime : Float = 0
	var cameraSpeed : Float = 1.0
	
	var defaultProjectionMatrix : GoDMatrix4 {
		return GoDMatrix4.makePerspective(angleRad: GoDMatrix4.degreesToRadians(85.0), aspectRatio: Float(self.frame.size.width / self.frame.size.height), nearZ: 0.001, farZ: 1000.0)
	}
	var zoomedProjectionMatrix : GoDMatrix4 {
		return GoDMatrix4.makePerspective(angleRad: GoDMatrix4.degreesToRadians(45.0), aspectRatio: Float(self.frame.size.width / self.frame.size.height), nearZ: 0.001, farZ: 1000.0)
	}
	
	var defaultCameraPosition : Vector3 {
		return Vector3(v0: 0.0, v1: -0.3, v2: -2.0)
	}
	var defaultCameraOrientation : Vector3 {
		return Vector3(v0: 0.0, v1: 0.0, v2: 0.0)
	}
	
	var defaultLightPosition : Vector3 {
		return Vector3(v0: 0.0, v1: -1.0, v2: -0.5)
	}
	
	func setDefaultPositions() {
		metalManager.projectionMatrix = defaultProjectionMatrix
		metalManager.cameraPosition = defaultCameraPosition
		metalManager.cameraOrientation = defaultCameraOrientation
		metalManager.lightPosition = defaultLightPosition
	}

	var isSetup: Bool = false

	func startTimer() {
		guard timer == nil else { return }
		previousTime = Float(CACurrentMediaTime())
		let fps : TimeInterval = 12.0
		let frameTime = TimeInterval(1.0) / fps
		timer = Timer.scheduledTimer(timeInterval: frameTime, target: self, selector: #selector(render), userInfo: nil, repeats: true)
	}

	func stopTimer() {
		timer?.invalidate()
		timer = nil
	}
	
	func setup() {
		self.wantsLayer = true
		self.layer!.frame = NSMakeRect(0.0, 0.0, self.frame.width, self.frame.height)
		metalManager.metalLayer.frame = self.layer!.frame
		self.layer!.addSublayer(metalManager.metalLayer)
		
		setDefaultPositions()
		
		startTimer()
		
		popup.setTitles(values: ["Interactable Region Picker"])
		popup.action = #selector(setInteraction)
		popup.target = self
		popup.translatesAutoresizingMaskIntoConstraints = false
		self.addSubview(popup)
		self.addConstraintAlignTopEdges(view1: self, view2: popup)
		self.addConstraintAlignLeftEdges(view1: self, view2: popup)
		self.addConstraintSize(view: popup, height: 20, width: 120)
		
		popup2.setTitles(values: ["Section Picker"])
		popup2.action = #selector(setSection)
		popup2.target = self
		popup2.translatesAutoresizingMaskIntoConstraints = false
		self.addSubview(popup2)
		self.addConstraintAlignTopEdges(view1: self, view2: popup2)
		self.addConstraintAlignRightEdges(view1: self, view2: popup2)
		self.addConstraintSize(view: popup2, height: 20, width: 120)

		isSetup = true
	}
	
	override func viewDidEndLiveResize() {
		super.viewDidEndLiveResize()
		self.wantsLayer = true
		self.layer!.frame = NSMakeRect(0.0, 0.0, self.frame.width, self.frame.height)
		metalManager.metalLayer.frame = self.layer!.frame
		
		setDefaultPositions()
	}
	
	@objc func setInteraction(sender: GoDPopUpButton) {
		let index = sender.indexOfSelectedItem - 1
		metalManager.interactionIndexToHighlight = index == -1 ? index : interactionIndexes[index]
		metalManager.render()
	}
	
	@objc func setSection(sender: GoDPopUpButton) {
		let index = sender.indexOfSelectedItem - 1
		metalManager.sectionIndexToHighlight = index == -1 ? index : sectionIndexes[index]
		metalManager.render()
	}

	@objc func render() {
		
		if file != nil {
			let time = Float(CACurrentMediaTime())
			updateViewMatrix(atTime: time)
			previousTime = time
		}
	}

	var isRendering = false
	
	func updateViewMatrix(atTime time: Float) {
		guard !isRendering else {
			return
		}
		isRendering = true

		//  The speed at which we desire to update
		let timeDelta = time - previousTime
		let amplitude = cameraSpeed * timeDelta
		let rotationAmp = amplitude * 10_000
		
		for key in dictionaryOfKeys {
			switch key {
				
			// Update camera position
			case (KeyCodeName.W, true):
				metalManager.cameraPosition.v2 += amplitude
			case (KeyCodeName.S, true):
				metalManager.cameraPosition.v2 -= amplitude
			case (KeyCodeName.A, true):
				metalManager.cameraPosition.v0 += amplitude
			case (KeyCodeName.D, true):
				metalManager.cameraPosition.v0 -= amplitude
			case (KeyCodeName.up, true):
				metalManager.cameraPosition.v1 -= amplitude
			case (KeyCodeName.down, true):
				metalManager.cameraPosition.v1 += amplitude
				
			// reset camera position and orientation
			case (KeyCodeName.space, true):
				setDefaultPositions()
			case (KeyCodeName.enter, true):
				metalManager.projectionMatrix = zoomedProjectionMatrix
				
			// set interactable region to highlight
			case (KeyCodeName.zero, true):
				metalManager.interactionIndexToHighlight = 0
				self.popup.selectItem(at: 1)
			case (KeyCodeName.one, true):
				metalManager.interactionIndexToHighlight = 1
				self.popup.selectItem(at: 2)
			case (KeyCodeName.two, true):
				metalManager.interactionIndexToHighlight = 2
				self.popup.selectItem(at: 3)
			case (KeyCodeName.three, true):
				metalManager.interactionIndexToHighlight = 3
				self.popup.selectItem(at: 4)
			case (KeyCodeName.four, true):
				metalManager.interactionIndexToHighlight = 4
				self.popup.selectItem(at: 5)
			case (KeyCodeName.five, true):
				metalManager.interactionIndexToHighlight = 5
				self.popup.selectItem(at: 6)
			case (KeyCodeName.six, true):
				metalManager.interactionIndexToHighlight = 6
				self.popup.selectItem(at: 7)
			case (KeyCodeName.seven, true):
				metalManager.interactionIndexToHighlight = 7
				self.popup.selectItem(at: 8)
			case (KeyCodeName.eight, true):
				metalManager.interactionIndexToHighlight = 8
				self.popup.selectItem(at: 9)
			case (KeyCodeName.nine, true):
				metalManager.interactionIndexToHighlight = 9
				self.popup.selectItem(at: 10)
			
			// change camera speed
			case (KeyCodeName.plus, true):
				cameraSpeed *= 1.33
			case (KeyCodeName.minus, true):
				cameraSpeed /= 1.33
				
			
			// rotate camera
			case (KeyCodeName.left, true):
				rotateCamera(pitch_degrees: 0.0, yaw_degrees: rotationAmp, roll_degrees: 0.0)
			case (KeyCodeName.right, true):
				rotateCamera(pitch_degrees: 0.0, yaw_degrees: -rotationAmp, roll_degrees: 0.0)
			case (KeyCodeName.morethan, true):
				rotateCamera(pitch_degrees: -rotationAmp, yaw_degrees: 0.0, roll_degrees: 0.0)
			case (KeyCodeName.lessthan, true):
				rotateCamera(pitch_degrees: rotationAmp, yaw_degrees: 0.0, roll_degrees: 0.0)
			case (KeyCodeName.tab, true):
				rotateCamera(pitch_degrees: 0.0, yaw_degrees: 0.0, roll_degrees: rotationAmp)
			case (KeyCodeName.delete, true):
				rotateCamera(pitch_degrees: 0.0, yaw_degrees: 0.0, roll_degrees: -rotationAmp)
				
			default:
				break;
			}
		}
		if dictionaryOfKeys.values.contains(true) {
			metalManager.render()
		}
		isRendering = false
	}
	
	func mouseEvent(deltaX x: Float, deltaY y: Float) {
		guard !isRendering else {
			return
		}
		isRendering = true
		circumnavigate(x: -x/100 * cameraSpeed, y: y/100 * cameraSpeed)
		metalManager.render()
		isRendering = false
	}
	
	func circumnavigate(x: Float, y: Float) {
		
		let oldPosition = metalManager.cameraPosition
		
		// x^2 + y^2 + z^2 = r^2
		let r2 = oldPosition.v0.raisedToPower(2) + oldPosition.v1.raisedToPower(2) + oldPosition.v2.raisedToPower(2)
		let zIsNegative = metalManager.cameraPosition.v2 < 0
		
		let newX = oldPosition.v0 + x
		let newY = oldPosition.v1 + y
		var newZ = (r2 - (newX.raisedToPower(2) + newY.raisedToPower(2))).squareRoot()
		newZ = zIsNegative ? -newZ : newZ
		
		let dx = abs(x)
		let dy = abs(y)
		let dz = abs(oldPosition.v2 - newZ)
		
		let dxz = (dx.raisedToPower(2) + dz.raisedToPower(2)).squareRoot()
		let dyz = (dy.raisedToPower(2) + dz.raisedToPower(2)).squareRoot()
		
		let rxz = (oldPosition.v0.raisedToPower(2) + oldPosition.v2.raisedToPower(2)).squareRoot()
		let ryz = (oldPosition.v1.raisedToPower(2) + oldPosition.v2.raisedToPower(2)).squareRoot()
		
		// sohcahtoa
		// needs fixing
		let sinthetaxz = (dxz / 2) / rxz
		let sinthetayz = (dyz / 2) / ryz
		
		var anglexz = asin(sinthetaxz) * 2 * (x < 0 ? -1 : 1)
		var angleyz = asin(sinthetayz) * 2 * (x < 0 ? -1 : 1)
		
		if y == 0 { angleyz = 0}
		if x == 0 { anglexz = 0}
		
		metalManager.cameraPosition = Vector3(v0: newX, v1: newY, v2: newZ)
		rotateCamera(pitch_degrees: angleyz * degreesPerRadian, yaw_degrees: anglexz * degreesPerRadian, roll_degrees: 0.0)
	}
	
	func rotateCamera(pitch_degrees: Float, yaw_degrees: Float, roll_degrees: Float) {
		// in degrees
		
		var roll  = metalManager.cameraOrientation.v0 - GoDMatrix4.degreesToRadians(roll_degrees)
		var yaw   = metalManager.cameraOrientation.v1 - GoDMatrix4.degreesToRadians(yaw_degrees)
		var pitch = metalManager.cameraOrientation.v2 - GoDMatrix4.degreesToRadians(pitch_degrees)
		
		roll = roll > Float(M_2_PI) ? roll - Float(M_2_PI) : (roll < 0 ? roll + Float(M_2_PI) : roll)
		yaw = yaw > Float(M_2_PI) ? yaw - Float(M_2_PI) : (yaw < 0 ? yaw + Float(M_2_PI) : yaw)
		pitch = pitch > Float(M_2_PI) ? pitch - Float(M_2_PI) : (pitch < 0 ? pitch + Float(M_2_PI) : pitch)
		
		metalManager.cameraOrientation.v0 = roll
		metalManager.cameraOrientation.v1 = yaw
		metalManager.cameraOrientation.v2 = pitch
	}
    
}





