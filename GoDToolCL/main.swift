//
//  main.swift
//  XGCommandLineTools
//
//  Created by StarsMmd on 13/11/2015.
//  Copyright © 2015 StarsMmd. All rights reserved.
//

loadAllStrings()
let lovrina = allStrings.filter { (xs) -> Bool in
	return xs.containsSubstring("Sylvia")
}

let snattle = allStrings.filter { (xs) -> Bool in
	return xs.containsSubstring("Blaine")
}

let gorigan = allStrings.filter { (xs) -> Bool in
	return xs.containsSubstring("Bruce")
}

let wakin = allStrings.filter { (xs) -> Bool in
	return xs.containsSubstring("Nick")
}

let biden = allStrings.filter { (xs) -> Bool in
	return xs.containsSubstring("Ryder")
}

let gonzap = allStrings.filter { (xs) -> Bool in
	return xs.containsSubstring("Gonzap")
}

let ardos = allStrings.filter { (xs) -> Bool in
	return xs.containsSubstring("Troy")
}

let eldes = allStrings.filter { (xs) -> Bool in
	return xs.containsSubstring("Des")
}

let greevil = allStrings.filter { (xs) -> Bool in
	return xs.containsSubstring("Tyrion")
}

let verich = allStrings.filter { (xs) -> Bool in
	return xs.containsSubstring("Mr. Banks")
}

let justy = allStrings.filter { (xs) -> Bool in
	return xs.containsSubstring("Jesse")
}

let vander = allStrings.filter { (xs) -> Bool in
	return xs.containsSubstring("Mick")
}

let krane = allStrings.filter { (xs) -> Bool in
	return xs.containsSubstring("Prof. Pine")
}

let jovi = allStrings.filter { (xs) -> Bool in
	return xs.containsSubstring("eva")
}

let kaminko = allStrings.filter { (xs) -> Bool in
	return xs.containsSubstring("Clarke")
}

let naps = allStrings.filter { (xs) -> Bool in
	return xs.containsSubstring("Mark")
}

let exol = allStrings.filter { (xs) -> Bool in
	return xs.containsSubstring("Ray")
}

let smarton = allStrings.filter { (xs) -> Bool in
	return xs.containsSubstring("Dexter")
}

let trudly = allStrings.filter { (xs) -> Bool in
	return xs.containsSubstring("Danny")
}

let folly = allStrings.filter { (xs) -> Bool in
	return xs.containsSubstring("Mac")
}

let trest = allStrings.filter { (xs) -> Bool in
	return xs.containsSubstring("Brian")
}

let eagun = allStrings.filter { (xs) -> Bool in
	return xs.containsSubstring("Ash")
}

for strings in [lovrina,snattle,gorigan,wakin,biden,gonzap,ardos,eldes,greevil,verich,justy,vander,krane,jovi,kaminko,naps,exol,smarton,trudly,folly,trest,eagun] {
	print("\n\n---------------------------------------------")
	for s in strings {
		s.stringPlusIDAndFile.println()
	}
}

//XGUtility.importTextures()
//XGUtility.exportTextures()


//let bingotex = XGFiles.texture("uv_str_bingo_00.fdat")
//XGFiles.nameAndFolder("bingo_menu.fsys", .MenuFSYS).fsysData.replaceFile(file: bingotex.compress())
//
//let bodies = XGFolders.Textures.files.filter { (file) -> Bool in
//	return file.fileName.contains("body")
//}
//for body in bodies {
//	let fsys = XGFiles.fsys("poke_body.fsys").fsysData
//	fsys.replaceFile(file: body)
//}
//
//let faces = XGFolders.Textures.files.filter { (file) -> Bool in
//	return file.fileName.contains("face")
//}
//for face in faces {
//	let fsys = XGFiles.fsys("poke_face.fsys").fsysData
//	fsys.replaceFile(file: face)
//}
//
//let dancers = ["kongpang","ootachi"]
//for dancer in dancers {
//	let file1 = XGFiles.texture(dancer + ".fdat")
//	let file2 = XGFiles.texture(dancer + "_c.fdat")
//	let fsys = XGFiles.fsys("poke_dance.fsys").fsysData
//	fsys.replaceFile(file: file1)
//	fsys.replaceFile(file: file2)
//}


//XGUtility.compileMainFiles()
//XGUtility.compileForRelease(XG: true)


















