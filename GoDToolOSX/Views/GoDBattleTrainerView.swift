//
//  GoDBattleTrainerView.swift
//  GoD Tool
//
//  Created by Stars Momodu on 12/09/2020.
//

import Cocoa

class GoDBattleTrainerView: NSView {

	var trainerImageView = NSImageView()
	var pokemonImageViews = [NSImageView]()

	override init(frame frameRect: NSRect) {
		super.init(frame: frameRect)
		setUpSubViews()
	}

	required init?(coder: NSCoder) {
		super.init(coder: coder)
		setUpSubViews()
	}

	func setupForTrainer(_ trainer: XGTrainer) {
		let trainerImage = trainer.trainerModel.image
		trainerImageView.image = trainerImage

		for i in 0 ..< 6 {
			pokemonImageViews[i].image = nil
			pokemonImageViews[i].layer?.borderColor = GoDDesign.colourBlack().cgColor
			if (i < trainer.pokemon.count) {
				let mon = trainer.pokemon[i]
				pokemonImageViews[i].image = mon.data.species.face
				if mon.isShadow {
					pokemonImageViews[i].layer?.borderColor = GoDDesign.colourPurple().cgColor
				}
			}
		}
	}

	private func setUpSubViews() {
		translatesAutoresizingMaskIntoConstraints = false
		layer?.borderWidth = 1
		layer?.cornerRadius = 10
		setBackgroundColour(GoDDesign.colourLightGrey())
		for _ in 0 ..< 6 {
			let pokemonView = NSImageView()
			pokemonView.translatesAutoresizingMaskIntoConstraints = false
			pokemonView.pinHeight(as: 30)
			pokemonView.pinWidth(as: 30)
			pokemonView.layer?.cornerRadius = 15
			pokemonView.layer?.borderWidth = 2
			pokemonView.setBackgroundColour(GoDDesign.colourDarkGrey())
			pokemonImageViews.append(pokemonView)
			addSubview(pokemonView)
		}
		trainerImageView.pinHeight(as: 50)
		trainerImageView.pinWidth(as: 50)
		trainerImageView.layer?.cornerRadius = 25
		trainerImageView.layer?.borderWidth = 2
		trainerImageView.translatesAutoresizingMaskIntoConstraints = false
		addSubview(trainerImageView)
		layoutSubviews()
	}

	private func layoutSubviews() {
		trainerImageView.pinTop(to: self, padding: 10)
		pokemonImageViews[1].pinTopToBottom(of: trainerImageView, padding: 10)
		pokemonImageViews[4].pinTopToBottom(of: pokemonImageViews[1], padding: 10)
		pokemonImageViews[4].pinBottom(to: self, padding: 10)
		trainerImageView.pinCenterX(to: self)
		pokemonImageViews[1].pinCenterX(to: self)
		pokemonImageViews[4].pinCenterX(to: self)

		for i in [0,2] {
			pokemonImageViews[i].pinLeading(to: self, padding: 10)
			pokemonImageViews[i + 1].pinLeadingToTrailing(of: pokemonImageViews[i], padding: 10)
			pokemonImageViews[i + 2].pinLeadingToTrailing(of: pokemonImageViews[i + 1], padding: 10)
			pokemonImageViews[i + 2].pinTrailing(to: self, padding: 10)
			pokemonImageViews[i].pinCenterY(to: pokemonImageViews[i + 1])
			pokemonImageViews[i + 2].pinCenterY(to: pokemonImageViews[i + 1])
		}
	}

}
