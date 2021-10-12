//
//  GoDCountDownViewController.swift
//  GoD Tool
//
//  Created by Stars Momodu on 09/10/2021.
//

import Cocoa

class GoDCountDownViewController: GoDViewController {

	@IBOutlet weak var backgroundView: NSImageView!
	@IBOutlet weak var timerContainer: NSImageView!
	@IBOutlet weak var countDownField: NSTextField!

	var endDate: Date = .distantPast
	var onFinish: ((GoDCountDownViewController?) -> Void)?
	var shouldCancel = false

	private var timer: Timer?
	private var useFullScreen: Bool = false
	private var closeOnFinish: Bool = true

	static func launch(endDate: Date,
					   image: XGFiles?,
					   isFullScreen: Bool = false,
					   closeOnFinish: Bool = true,
					   onFinish: ((GoDCountDownViewController?) -> Void)? = nil) {

		guard endDate.timeIntervalSinceNow > 0 else {
			onFinish?(nil)
			return
		}

		let bundle = Bundle(for: GoDCountDownViewController.self)
		let storyboard = NSStoryboard(name: "CountDown", bundle: bundle)
		if let countdown = storyboard.instantiateInitialController() as? GoDCountDownViewController {
			appDelegate.show(countdown)
			countdown.endDate = endDate
			countdown.backgroundView.image = image?.image
			countdown.backgroundView.animates = true
			countdown.onFinish = onFinish
			countdown.useFullScreen = isFullScreen
			countdown.closeOnFinish = closeOnFinish
			countdown.start()
		}
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		title = "Countdown"
		setup()
	}

	override func viewWillAppear() {
		super.viewWillAppear()
		updateLabel()
	}

	func start() {
		updateLabel()

		if useFullScreen {
			enterFullScreen()
		}
		timer = Timer(timeInterval: 1, target: self, selector: #selector(onTick), userInfo: nil, repeats: true)
		if let t = timer {
			RunLoop.current.add(t, forMode: .common)
		}
	}

	func stop() {
		shouldCancel = true
	}

	private func setup() {
		backgroundView.imageScaling = .scaleProportionallyDown
		countDownField.alignment = .center
		countDownField.isEditable = false
		countDownField.backgroundColor = .clear
		countDownField.layer?.borderColor = NSColor.controlTextColor.cgColor
		countDownField.layer?.borderWidth = 1
		countDownField.layer?.cornerRadius = 8
		timerContainer.layer?.cornerRadius = countDownField.layer?.cornerRadius ?? 0
		timerContainer.setBackgroundColour(.controlBackgroundColor)
		timerContainer.alphaValue = 0.5
	}

	@objc
	private func onTick() {
		guard !shouldCancel,
			  endDate.timeIntervalSinceNow > 0 else {
			timer?.invalidate()
			timer = nil
			if !shouldCancel {
				if closeOnFinish {
					view.window?.close()
				}
				onFinish?(self)
			}
			return
		}
		updateLabel()
	}

	private func updateLabel() {
		var timeRemaining = endDate.timeIntervalSinceNow
		let secondsPerMinute = 60.0
		let secondsPerHour = 60 * secondsPerMinute
		let secondsPerDay = 24 * secondsPerHour

		let daysRemaining = floor(timeRemaining / secondsPerDay)
		timeRemaining -= daysRemaining * secondsPerDay
		let hoursRemaining = floor(timeRemaining / secondsPerHour)
		timeRemaining -= hoursRemaining * secondsPerHour
		let minutesRemaining = floor(timeRemaining / secondsPerMinute)
		timeRemaining -= minutesRemaining * secondsPerMinute
		let secondsRemaining = floor(timeRemaining)

		let days = daysRemaining > 0 ? String(format: "%02d:", Int(daysRemaining)) : ""
		let hours = String(format: "%02d", Int(hoursRemaining))
		let minutes = String(format: "%02d", Int(minutesRemaining))
		let seconds = String(format: "%02d", Int(secondsRemaining))

		countDownField.stringValue = "\(days)\(hours):\(minutes):\(seconds)"
	}
}
