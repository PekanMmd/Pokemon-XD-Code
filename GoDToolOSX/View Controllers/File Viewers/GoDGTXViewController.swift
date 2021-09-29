//
//  GoDGTXViewController.swift
//  GoD Tool
//
//  Created by Stars Momodu on 24/02/2020.
//

import Cocoa

class GoDGTXViewController: NSViewController {
    let imageView = NSImageView()
	let saveButton = NSButton()
    var texture: GoDTexture? {
        didSet {
			imageView.image = texture?.image.nsImage
        }
    }
    
    override func loadView() {
        self.view = NSView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "GTX"

		saveButton.title = "Save as PNG"
		saveButton.target = self
		saveButton.action = #selector(saveImageAsPNG)

        view.addSubview(imageView)
		view.addSubview(saveButton)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.imageScaling = .scaleProportionallyDown
		saveButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
			view.widthAnchor.constraint(lessThanOrEqualToConstant: 800),
			view.widthAnchor.constraint(greaterThanOrEqualToConstant: 480),
			view.heightAnchor.constraint(lessThanOrEqualToConstant: 800),
			view.heightAnchor.constraint(greaterThanOrEqualToConstant: 360),
            view.leadingAnchor.constraint(lessThanOrEqualTo: imageView.leadingAnchor),
            view.trailingAnchor.constraint(greaterThanOrEqualTo: imageView.trailingAnchor),
			imageView.topAnchor.constraint(equalTo: view.topAnchor),
			imageView.bottomAnchor.constraint(equalTo: saveButton.topAnchor),
			imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			saveButton.bottomAnchor.constraint(equalTo: view.bottomAnchor),
			saveButton.widthAnchor.constraint(equalToConstant: 200),
			saveButton.heightAnchor.constraint(equalToConstant: 80),
			saveButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
		imageView.image = texture?.image.nsImage
    }

	@objc func saveImageAsPNG() {
		if let gtxFile = texture?.file {
			texture?.writePNGData(toFile: .nameAndFolder(gtxFile.fileName + XGFileTypes.png.fileExtension, gtxFile.folder))
		}
	}
}
