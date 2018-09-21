//
//  main.swift
//  ColosseumToolCL
//
//  Created by The Steez on 27/08/2018.
//


for file in XGFolders.Documents.files where file.fileName.contains("pkx") {
	file.fsysData.extractFilesToFolder(folder: .Documents)
}




