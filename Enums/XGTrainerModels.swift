//
//  XGTrainerModels.swift
//  XG Tool
//
//  Created by The Steez on 31/05/2015.
//  Copyright (c) 2015 Ovation International. All rights reserved.
//

import UIKit

enum XGTrainerModels : Int {
	
	case None						= 0x00
	
	case Michael1WithoutSnagMachine	= 0x01
	case Michael2WithSnagMachine	= 0x02
	case Michael2WithoutSnagMachine	= 0x03
	
	case MayEM						= 0x04
	case BrendanEM					= 0x05
	case Green						= 0x06
	case Red						= 0x07
	case MayRS						= 0x08
	case BrendanRS					= 0x09
	
	case NoTrainer					= 0x0A
	
	case CipherPeonFemale			= 0x0B
	case CipherPeonMale1			= 0x0C
	case CipherPeonMale2			= 0x0D
	case CipherPeonMale3			= 0x0E
	case Resix						= 0x0F
	case Blusix						= 0x10
	case Browsix					= 0x11
	case Yellosix					= 0x12
	case Purpsix					= 0x13
	case Greesix					= 0x14
	case Lovrina					= 0x15
	
	case Sailor						= 0x16
	case Zook						= 0x17
	case Ardos						= 0x18
	case Matron						= 0x19
	case Greevil					= 0x1A
	case Newscaster					= 0x1B
	case Eldes						= 0x1C
	case Gorigan					= 0x1D
	case Gonzap						= 0x1E
	
	case SuperTrainerFemale1		= 0x1F
	case SuperTrainerFemale2		= 0x20
	case SuperTrainerMale1			= 0x21
	case SuperTrainerMale2			= 0x22
	case SuperTrainerMale3			= 0x23
	
	case Hunter						= 0x24
	case Beauty						= 0x25
	case CasualDude					= 0x26
	case FunOldMan					= 0x27
	case Curmudgeon					= 0x28
	case Eagun						= 0x29
	case RoboGroudon				= 0x2A
	case MirorB						= 0x2B
	case BodyBuilderFemale			= 0x2C
	case BodyBuilderMale			= 0x2D
	case Battlus					= 0x2E
	
	case CasualGuy					= 0x2F
	case Researcher					= 0x30
	case Rider						= 0x31
	case Navigator					= 0x32
	case Justy						= 0x33
	case SnagemGrunt1				= 0x34
	case SnagemGrunt2				= 0x35
	case Chobin						= 0x36
	
	case ChaserFemale1				= 0x37
	case ChaserFemale2				= 0x38
	case ChaseMale					= 0x39
	case Cail						= 0x3A
	case CoolTrainerFemale			= 0x3B
	case CoolTrainerMale			= 0x3C
	case Snattle					= 0x3D
	case Willie						= 0x3E
	case Worker						= 0x3F
	case Krane						= 0x40
	
	case Greevil2					= 0x41
	case Michael3WithSnagMachine	= 0x42
	case Michael3WithoutSnagMachine	= 0x43
	
	
	
	var image : UIImage {
		
		return XGFiles.TrainerFace(self.rawValue).image
		
	}
	
}
















