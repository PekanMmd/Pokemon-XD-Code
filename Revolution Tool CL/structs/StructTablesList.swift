//
//  StructTablesList.swift
//  GoD Tool
//
//  Created by Stars Momodu on 18/03/2021.
//

import Foundation

let structTablesList: [GoDStructTableFormattable] = {
	var tables: [GoDStructTableFormattable] = [

	]

	return tables.sorted { (t1, t2) -> Bool in
		t1.properties.name < t2.properties.name
	}
}()

let otherTableFormatsList: [GoDCodable.Type] = {
	var tables: [GoDCodable.Type] = [

	]

	return tables.sorted { (t1, t2) -> Bool in
		t1.className < t2.className
	}
}()
