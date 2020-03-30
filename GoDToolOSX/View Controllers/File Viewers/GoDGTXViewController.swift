//
//  GoDGTXViewController.swift
//  GoD Tool
//
//  Created by Stars Momodu on 24/02/2020.
//

import Cocoa

class GoDGTXViewController: NSViewController {
    let imageView = NSImageView()
    var texture: GoDTexture? {
        didSet {
            imageView.image = texture?.image
        }
    }
    
    override func loadView() {
        self.view = NSView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "GTX"

        view.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.imageScaling = .scaleProportionallyDown
        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: imageView.topAnchor),
            view.bottomAnchor.constraint(equalTo: imageView.bottomAnchor),
            view.leadingAnchor.constraint(equalTo: imageView.leadingAnchor),
            view.trailingAnchor.constraint(equalTo: imageView.trailingAnchor),
            view.widthAnchor.constraint(lessThanOrEqualToConstant: 800),
            view.heightAnchor.constraint(lessThanOrEqualToConstant: 800)
        ])
//        imageView.image = texture?.image
    }
}
