//
//  XGFileTypes.swift
//  GoD Tool
//
//  Created by The Steez on 18/11/2017.
//
//

import Foundation

enum XGFileTypes: Int, CaseIterable {
	case none = 0x00
	
	case bin  = 0x02 // binary data
	case sdr  = 0x04 // 3d model. PBR model format is documented in online forums and tool to convert to .obj exists
	case odr  = 0x06 // contains multiple textures
	case mdr  = 0x08 // contains multiple textures

	case gpd  = 0x0a // particle effects?
	case gtx  = 0x0c // texture

	case scd  = 0x12 // script data

	case fnt  = 0x16 // sometimes .fnt, sometimes .f3d (3d font)
	case msg  = 0x18 // string table
	case mnr  = 0x1a // menu textures
	case thh  = 0x20 // thp header (.esq in pbr)
	case thd  = 0x22
	case gfl  = 0x24 // lighting effects?

	// decks officially use .bin extension
	case dckp = 0x28 // pokemon deck
	case dckt = 0x2a // trainer deck
	case dcka = 0x2e // ai deck
	
	// all arbitrary values
	case dol  = 0x80

	// archive formats
	case fsys = 0x90
	case narc = 0x91
	case arc  = 0x92
	
	// compression formats
	case szs  = 0x93
	case yaz0 = 0x94
	case lzss = 0x95

	case raw  = 0xf0
	case gci  = 0xf1
	case thp  = 0xf2
	case json = 0xf3
	case txt  = 0xf4
	case tpl  = 0xf5
	case bmp  = 0xf6
	case jpeg = 0xf7
	case png  = 0xf8
	case tex0 = 0xf9
	case xds  = 0xfa
	case toc  = 0xfb
	case ups  = 0xfc
	case iso  = 0xfd
	case nkit = 0xfe
	case csv  = 0xff
	
	case unknown = 0xffff

	// for gamecube compatibility
	case gsw = -2
	case atx = -4
	case rdat = -6
	case ccd = -8
	case dats = -10
	case gpt1 = -12
	case cam = -14
	case f3d = -16
	case pkx = -18
	case dat = -20

	
	var index : Int {
		return self.rawValue / 2
	}
	
	var fileExtension : String {
		switch self {
		case .none: return ".bin"
		case .bin: return ".bin"
		case .sdr : return ".sdr"
		case .odr : return ".odr"
		case .mdr : return ".mdr"
		case .gfl : return ".gfl"
		case .dckp: return ".pbin"
		case .dckt: return ".tbin"
		case .dcka: return ".abin"
		case .ccd : return ".ccd"
		case .msg : return ".msg"
		case .mnr: return ".mnr"
		case .fnt : return ".fnt"
		case .f3d : return ".f3d"
		case .scd : return ".scd"
		case .dats: return ".dats"
		case .gtx : return ".gtx"
		case .gpt1: return ".gpt1"
		case .cam : return ".cam"
		case .gpd : return ".gpd"
		case .thh : return ".esq"
		case .thd : return ".thd"
		case .fsys: return ".fsys"
		case .iso : return ".iso"
		case .xds : return ".xds"
		case .dol : return ".dol"
		case .toc : return ".toc"
		case .png : return ".png"
		case .bmp : return ".bmp"
		case .jpeg: return ".jpeg"
		case .tex0: return ".tex0"
		case .lzss: return ".lzss"
		case .txt : return ".txt"
		case .json: return ".json"
		case .rdat: return ".rdat"
		case .gsw : return ".gsw"
		case .atx : return ".atx"
		case .pkx : return ".pkx"
		case .dat : return ".dat"
		case .thp : return ".thp"
		case .unknown: return ".bin"
		case .raw: return ".raw"
		case .gci: return ".gci"
		case .tpl: return ".tpl"
		case .nkit: return ".nkit"
		case .ups : return ".ups"
		case .csv: return ".csv"
		case .arc : return ".arc"
		case .narc: return ".narc"
		case .szs : return ".szs"
		case .yaz0: return ".yaz0"
		}
	}

	var info: String? {
		switch self {
		case .none: return nil
		case .msg : return "Files containing game text. Each piece of text has an associated id which can be used to look it up in one of the msg files. The search will look through msg files one at a time until it finds the one containing the id it needs the text for. `\(toolName)` can automatically convert these to/from human readable `.json` files."
		case .fnt : return "Font files containing the data for how to display each character in this font."
		case .scd : return "Script files which are used to trigger events in the overworld like displaying dialog, moving the camera, starting battles, etc. `\(toolName)` can decompile these into human readable `\(game == .Colosseum ? ".CMS" : ".XDS")` text files."
		case .gtx : return "Image files used for textures. There are many different types of formats for these files which have different levels of colour detail and compression. `\(toolName)` can automatically convert these to/from .png files."
		case .gpt1: return "Files containing particle data. These currently haven't been reverse engineered."
		case .thh : return "The header for a `.thp` file. Has an associated `.thd` file."
		case .thd : return "Contains video data for a `.thp` file. Has an associated `.thh` header file. \(toolName) can automatically combine the `.thh` and `.thd` files into the `.thp` video by updating the relevant parts."
		case .gsw : return "Files containing multiple textures and data for animating them. Used for things like animating XD's title screen. `\(toolName)` can automatically find and extract the textures as well as import them back into the `.gsw` file."
		case .atx : return "Similar to `.gtx` files. These contain multiple frames of an animated texture, a bit like a `.gif` file. \(toolName) can convert these to/from `.png` files."
		case .bin : return "A generic file extension used for any file type without a specific file type. Could contain anything really."
		case .fsys: return "An archive format which contains multiple compressed files inside it. The files are compressed using the `LZSS` compression format (though in rare occasions the contained files aren't compressed). It's similar to formats like `.zip` and `.rar`. You can use `\(toolName)` to extract the files contained in `.fsys` archives and to import edited files back into them. You can also use this standalone python script to extract the files: https://discord.com/channels/753272785286987897/753692449846591679/753718707146194944"
		case .iso : return "The main `ROM` file which contains all the data that is contained on a Gamecube/Wii disc."
		case .xds : return "A script file decompiled using `\(toolName)`. These can be opened up and edited in any text editor. The language is a custom language designed for modding these games specifically but is designed to look like a generic, weakly typed programming language such as javascript.\(game == .XD ? "" : " `\(toolName)` doesn't yet support importing edited scripts back into the game but it is being worked on.")"
		case .dol : return "The main executable file containing most of the game's assembly code. https://wiibrew.org/wiki/DOL"
		case .toc : return "The file which specifies the file layout of the `iso`. Used to link `.fsys` filenames to their reference ids."
		case .png : return "A common image format used outside of the game."
		case .bmp : return "A common image format used outside of the game."
		case .jpeg: return "A common image format used outside of the game."
		case .tex0: return "An image file format used in other games. It's similar to `.gtx` so `\(toolName)` converts `.gtx` files to `.tex0` as an intermediate step before converting the `.tex0` into `.png` using an external tool. http://wiki.tockdom.com/wiki/TEX0_(File_Format) https://szs.wiimm.de/wimgt/"
		case .tpl : return "A texture format used in other games. http://wiki.tockdom.com/wiki/TPL_(File_Format)"
		case .lzss: return "A common compression format. https://en.wikipedia.org/wiki/Lempel%E2%80%93Ziv%E2%80%93Storer%E2%80%93Szymanski"
		case .txt : return "A common format used for storing plain text."
		case .json: return "A common format which comes from JavaScript. Used by programmers to represent data in a human readable way. The tool can output various types of information as `.json` files which can either be edited by hand or input into other people's programs and tools for editing. https://en.wikipedia.org/wiki/JSON"
		case .csv : return "A common format used for storing simple spreadsheets. `\(toolName)` dumps various data tables as these kinds of spreadsheets which can be imported into Microsoft Excel or Google Sheets for editing. https://en.wikipedia.org/wiki/Comma-separated_values"
		case .thp : return "A video format which is commonly used. It's not very efficient but there are many tools which can view and create them. http://wiki.tockdom.com/wiki/THP_(File_Format)"
		case .nkit: return "A compressed gamecube/wii `.iso` file which has unnecessary data scrubbed to make the file size smaller. These files usually have a file type of `.nkit.iso`. They aren't supported by `\(toolName)` so you should convert them to a regular iso using this tool first: https://gbatemp.net/download/nkit.36157/download\nDrag and drop the `.nkit` iso onto the program called `ConvertToIso` and you'll find the converted `iso` in the folder called `Processed`."
		case .unknown: return nil
		case .sdr: return "A custom 3d model format specific to PBR. There is a blender plugin for importing these files to blender and exporting models in blender to `.sdr` files: https://github.com/bgsamm/pbr-models-import-export"
		case .odr: return "A custom 3d model format specific to PBR. Similar to `.sdr` but only containing some object data. Used for things like accessories for trainer customisation. There is a blender plugin for importing these files to blender: https://github.com/bgsamm/pbr-models-import-export"
		case .mdr: return "A custom 3d model format specific to PBR. Similar to `.sdr` but only containing some material data (texture and lighting data). There is a blender plugin for importing these files to blender: https://github.com/bgsamm/pbr-models-import-export"
		case .gpd: return "Contains data used in special effects like move animations. Thesse files haven't been reverse engineered yet so not much is known about them."
		case .mnr: return "Data used to layout images and buttons on menus. \(toolName) can export the textures they contain and replace them."
		case .gfl: return "Unknown data. Possible related to lighting or particle effects."
		case .dckp: return "Files containing data for trainer pokemon such as their moves, EVs, IVs and nature."
		case .dckt: return "Files containing data for trainers."
		case .dcka: return "Contains AI data used to create different types of NPC trainer AI."
		case .f3d: return "A font format used for 3d text."
		case .ups: return """
			A patch format which is used to edit the data in a predetermined file. It's useful for distributing ROM hacks as you don't need to distribute any copy righted data. The patching program takes the original game and the modded game and calculates the difference between them. The player can apply the patch file to their own copy of the original game to apply the same differences to it and as a result recreate the mod.
			To apply a ups patch to a file you can use this website: https://www.marcrobledo.com/RomPatcher.js/
			Or you can use this program on windows: https://www.romhacking.net/utilities/606/
			"""
		case .arc, .narc: return """
			An archive format containing multiple files a bit like a .zip file.
			The contents may optionally be compressed.
			"""
		case .yaz0, .szs: return """
			A compression format commonly used in Nintendo games.
			"""
		case .pkx, .dat, .rdat, .ccd, .gci, .raw, .dats, .cam: return nil
		}
	}

	var identifier: Int {
		return rawValue < XGFileTypes.fsys.rawValue ? rawValue : 0
	}

	#if canImport(Cocoa)
	static let imageFormats: [XGFileTypes] = [.png, .jpeg, .bmp]
	#else
	static let imageFormats: [XGFileTypes] = [.png]
	#endif

	static let textureFormats: [XGFileTypes] = [.gtx]
	static let modelFormats: [XGFileTypes] = [.sdr, .odr, .mdr]
	static let textureContainingFormats: [XGFileTypes] = [.sdr, .odr, .mdr, .mnr, .gpd, .gfl]

	static func fileTypeForExtension(_ ext: String) -> XGFileTypes? {
		return XGFileTypes.allCases.first(where: {
			$0.fileExtension.replacingOccurrences(of: ".", with: "") == ext.replacingOccurrences(of: ".", with: "")
		})
	}
}


















