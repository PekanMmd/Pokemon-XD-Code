//
//  XGFileTypes.swift
//  GoD Tool
//
//  Created by The Steez on 18/11/2017.
//
//

import Foundation

enum XGFileTypes: Int, Codable, CaseIterable {
	case none = 0x00
	case rdat = 0x02 // room model in hal dat format. Also .dat files but considered different by the fsys headers
	case dat  = 0x04 // character model in hal dat format
	case col  = 0x06 // collision file
	case samp = 0x08 // sequenced music data
	case msg  = 0x0a // string table
	case fnt  = 0x0c // font
	case scd  = 0x0e // script data
	case dats = 0x10 // multiple .dat models in one archive
	case gtx  = 0x12 // texture
	case gpt1 = 0x14 // particle data
	case cam  = 0x18 // camera data
	case rel  = 0x1c // relocation table
	case pkx  = 0x1e // character battle model (same as dat with additional header information)
	case wzx  = 0x20 // move animation
	case isd  = 0x28 // audio file header
	case ish  = 0x2a // audio file
	case thh  = 0x2c // thp media header
	case thd  = 0x2e // thp media data
	case gsw  = 0x30 // multi texture
	case atx  = 0x32 // animated texture (official file extension is currently unknown)
	case bin  = 0x34 // binary data
	
	
	// all arbitrary values

	case dol  = 0x80
	case toc  = 0x82

	// These have ids of 0 for some reason
	// They are sound font data for sequenced music
	case proj = 0x84
	case sdir = 0x86
	case pool = 0x88

	case fsys = 0x90

	// these aren't refernced in .fsys archives or are only used by this tool
	case raw  = 0xf0
	case gci  = 0xf1
	case thp  = 0xf2
	case json = 0xf3
	case txt  = 0xf4
	case lzss = 0xf5
	case tpl  = 0xf6
	case bmp  = 0xf7
	case jpeg = 0xf8
	case png  = 0xf9
	case gif  = 0xfa
	case tex0 = 0xfb
	case xds  = 0xfc
	case ups  = 0xfd
	case iso  = 0xfe
	case nkit = 0xff
	case csv  = 0x100
	
	case unknown = 0xffff
	
	var index : Int {
		return self.rawValue / 2
	}
	
	var fileExtension: String {
		switch self {
		case .none: return ""
		case .rdat: return ".rdat"
		case .dat : return ".dat"
		case .col : return ".ccd"
		case .samp: return ".samp"
		case .sdir: return ".sdir"
		case .proj: return ".proj"
		case .pool: return ".pool"
		case .msg : return ".msg"
		case .fnt : return ".fnt"
		case .scd : return ".scd"
		case .dats: return ".dats"
		case .gtx : return ".gtx"
		case .gpt1: return ".gpt1"
		case .cam : return ".cam"
		case .rel : return ".rel"
		case .pkx : return ".pkx"
		case .wzx : return ".wzx"
		case .isd : return ".isd"
		case .ish : return ".ish"
		case .thh : return ".thh"
		case .thd : return ".thd"
		case .gsw : return ".gsw"
		case .atx : return ".atx"
		case .bin : return ".bin"
		case .fsys: return ".fsys"
		case .iso : return ".iso"
		case .xds : return game == .Colosseum ? ".cms" : ".xds"
		case .dol : return ".dol"
		case .toc : return ".toc"
		case .png : return ".png"
		case .gif : return ".gif"
		case .bmp : return ".bmp"
		case .jpeg: return ".jpg"
		case .tex0: return ".tex0"
		case .tpl : return ".tpl"
		case .lzss: return ".lzss"
		case .txt : return ".txt"
		case .json: return ".json"
		case .csv : return ".csv"
		case .thp : return ".thp"
		case .gci : return ".gci"
		case .raw : return ".raw"
		case .nkit: return ".nkit"
		case .ups : return ".ups"
		case .unknown: return ".bin"
		}
	}

	var info: String? {
		switch self {
		case .none: return nil
		case .rdat: return "A `dat`/`hsd` 3d model format used specifically for map models rather than characters. The format is the same as `.dat` for all intents and purposes."
		case .dat : return "A `dat`/`hsd` 3d model in the same format used in games like Super Smash Bros. Melee. There is a blender plugin which can import these into blender and will soon be able to take models in blender and export them as `.dat` models. http://wiki.tockdom.com/wiki/HAL_DAT_(File_Format) https://github.com/StarsMmd/Blender-Addon-Gamecube-Models"
		case .col : return "A 3d mesh which determines which parts of the map the player can or can't walk on/through for collision detection. Also marks special regions which can trigger script events like doors, warps and textboxes. Has an associated `.rdat` file. The Mac GUI version of \(toolName) can be used to view these as 3d meshes and highlight where the special regions are."
		case .samp: return "Contains data for sequenced music. Can be loaded using programs like Musyx along with `.sdir`, `.proj`, and `.pool` files."
		case .sdir: return "Contains data for sequenced music. Can be loaded using programs like Musyx along with `.samp`, `.proj`, and `.pool` files."
		case .proj: return "Contains data for sequenced music. Can be loaded using programs like Musyx along with `.sdir`, `.samp`, and `.pool` files."
		case .pool: return "Contains data for sequenced music. Can be loaded using programs like Musyx along with `.sdir`, `.proj`, and `.samp` files."
		case .msg : return "Files containing game text. Each piece of text has an associated id which can be used to look it up in one of the msg files. The search will look through msg files one at a time until it finds the one containing the id it needs the text for. `\(toolName)` can automatically convert these to/from human readable `.json` files."
		case .fnt : return "Font files containing the data for how to display each character in this font."
		case .scd : return "Script files which are used to trigger events in the overworld like displaying dialog, moving the camera, starting battles, etc. `\(toolName)` can decompile these into human readable `\(game == .Colosseum ? ".CMS" : ".XDS")` text files."
		case .dats: return "Models with numbered variants such as the PokeSnack wheel which can have between 0 and 10 visible slices. Usually contained within `.rdat` models and modified via scripts."
		case .gtx : return "Image files used for textures. There are many different types of formats for these files which have different levels of colour detail and compression. `\(toolName)` can automatically convert these to/from `.png` files. Note: Some texture formats have limited palette sizes, e.g. C8 textures can only use up to 256 unique colours. When replacing textures make sure you may want to double check the format to see if you need to limit the colours in your image or change the textures format to one without a limit."
		case .gpt1: return "Files containing particle data. These currently haven't been reverse engineered."
		case .cam : return "Contains data used to control the in game camera. Used for special camera movements like sweeping through a new area the first time the player sees it."
		case .rel : return "Relocatable modules. Contain game code and data like `.dol` files but are linked dynamically at run time. Contains a lot of important data tables like pokemon stats, move stats, overworld item boxes, game text, etc. http://wiki.tockdom.com/wiki/REL_(File_Format) https://www.metroid2002.com/retromodding/wiki/REL_(File_Format)"
		case .pkx : return "Contains a `.dat` model as well as some extra header information needed for the models to be used in battles. The header contains info such as which parameters to use for the filter when loading the model as a shiny as well as which animations in the model should be used for certain situations like contact moves if it's a pokemon or throwing a pokeball if it's a trainer. `\(toolName)` can automatically extract the `.dat` model contained in the `.pkx` file but the blender plugin for `.dat` models also supports importing `.pkx` models directly. https://github.com/StarsMmd/Blender-Addon-Gamecube-Models"
		case .wzx : return "Contains data for move animations. There are multiple sections which can contain sub files like `.dat` models or particle effects. Not much has currently been reverse engineered about these."
		case .isd : return "Contains streamed music data. Has an associated `.ish` file. These can be converted to/from .dsp files using a tool and those can be converted to/from general formats like `.wav` and `.mp3`"
		case .ish : return "The header for streamed music data. Has an associated `.isd` file."
		case .thh : return "The header for a `.thp` file. Has an associated `.thd` file."
		case .thd : return "Contains video data for a `.thp` file. Has an associated .thh header file. `\(toolName)` can automatically combine the `.thh` and `.thd` files into the `.thp` video by updating the relevant parts."
		case .gsw : return "Files containing multiple textures and data for animating them. Used for things like animating XD's title screen. `\(toolName)` can automatically find and extract the textures as well as import them back into the `.gsw` file."
		case .atx : return "Similar to `.gtx` files. These contain multiple frames of an animated texture, a bit like a `.gif` file. \(toolName) can convert these to/from `.png` files."
		case .bin : return "A generic file extension used for any file type without a specific file type. Could contain anything really.\(game != .XD ? "" : " In XD there are `.bin` files containing 'deck' files. These are the data for trainers and trainer pokemon as well as shadow pokemon.")"
		case .fsys: return "An archive format which contains multiple compressed files inside it. The files are compressed using the `LZSS` compression format (though in rare occasions the contained files aren't compressed). It's similar to formats like `.zip` and `.rar`. You can use \(toolName) to extract the files contained in `.fsys` archives and to import edited files back into them. You can also use this standalone python script to extract the files: https://discord.com/channels/753272785286987897/753692449846591679/753718707146194944"
		case .iso : return "The main `ROM` file which contains all the data that is contained on a Gamecube/Wii disc."
		case .xds : return "A script file decompiled using `\(toolName)`. These can be opened up and edited in any text editor. The language is a custom language designed for modding these games specifically but is designed to look like a generic, weakly typed programming language such as javascript.\(game == .XD ? "" : " `\(toolName)` doesn't yet support importing edited scripts back into the game but it is being worked on.")"
		case .dol : return "The main executable file containing most of the game's assembly code. https://wiibrew.org/wiki/DOL"
		case .toc : return "The file which specifies the file layout of the iso. Used to link filenames to their offsets in the iso."
		case .png : return "A common image format used outside of the game."
		case .gif : return "A common animated image format used outside of the game."
		case .bmp : return "A common image format used outside of the game."
		case .jpeg: return "A common image format used outside of the game."
		case .tex0: return "An image file format used in other games. It's similar to `.gtx` so `\(toolName)` converts `.gtx` files to `.tex0` as an intermediate step before converting the `.tex0` into `.png` using an external tool. http://wiki.tockdom.com/wiki/TEX0_(File_Format) https://szs.wiimm.de/wimgt/"
		case .tpl : return "A texture format used in other games. http://wiki.tockdom.com/wiki/TPL_(File_Format)"
		case .lzss: return "A common compression format. https://en.wikipedia.org/wiki/Lempel%E2%80%93Ziv%E2%80%93Storer%E2%80%93Szymanski"
		case .txt : return "A common format used for storing plain text."
		case .json: return "A common format which comes from JavaScript. Used by programmers to represent data in a human readable way. The tool can output various types of information as `.json` files which can either be edited by hand or input into other people's programs and tools for editing. https://en.wikipedia.org/wiki/JSON"
		case .csv : return "A common format used for storing simple spreadsheets. `\(toolName)` dumps various data tables as these kinds of spreadsheets which can be imported into Microsoft Excel or Google Sheets for editing. https://en.wikipedia.org/wiki/Comma-separated_values"
		case .thp : return "A video format which is commonly used in older games. It's not very efficient but there are many tools which can view and create them. http://wiki.tockdom.com/wiki/THP_(File_Format)"
		case .gci : return "A save file format used for gamecube games. https://surugi.com/projects/gcifaq.html"
		case .raw : return "This file format has a lot of different uses in other contexts. It is commonly used as the format for save file data that has been extracted from `.gci` save files or memory card data."
		case .nkit: return "A compressed gamecube/wii `.iso` file which has unnecessary data scrubbed to make the file size smaller. These files usually have a file type of `.nkit.iso`. They aren't supported by \(toolName) so you should convert them to a regular iso using this tool first: https://vimm.net/vault/?p=nkit\nDrag and drop the `.nkit` iso onto the program called `ConvertToIso` and you'll find the converted `iso` in the folder called `Processed`."
		case .ups: return """
			A patch format which is used to edit the data in a predetermined file. It's useful for distributing ROM hacks as you don't need to distribute any copy righted data. The patching program takes the original game and the modded game and calculates the difference between them. The player can apply the patch file to their own copy of the original game to apply the same differences to it and as a result recreate the mod.
			To apply a ups patch to a file you can use this website: https://www.marcrobledo.com/RomPatcher.js/
			Or you can use this program on windows: https://www.romhacking.net/utilities/606/
			"""
		case .unknown: return nil
		}
	}

	var identifier: Int {
		return rawValue < XGFileTypes.fsys.rawValue ? rawValue : 0
	}

	#if canImport(Cocoa)
	static let imageFormats: [XGFileTypes] = [.png, .jpeg, .bmp, .gif]
	#else
	static let imageFormats: [XGFileTypes] = [.png]
	#endif

	static let textureFormats: [XGFileTypes] = [.gtx, .atx]
	static let modelFormats: [XGFileTypes] = [.dat, .rdat /*.dats can't remember what these are so not adding for now*/]
	static let textureContainingFormats: [XGFileTypes] = [.dat, .rdat, .gsw] // gsw once implemented and models
	static let modelContainingFormats: [XGFileTypes] = [.pkx, .wzx] // gsw once implemented and models

	static func fileTypeForExtension(_ ext: String) -> XGFileTypes? {
		return XGFileTypes.allCases.first(where: {
			$0.fileExtension.replacingOccurrences(of: ".", with: "") == ext.replacingOccurrences(of: ".", with: "")
		})
	}
}


















