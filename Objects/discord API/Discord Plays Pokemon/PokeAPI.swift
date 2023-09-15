//
//  PokeAPI.swift
//  GoD Tool
//
//  Created by Stars Momodu on 11/10/2022.
//

import Foundation

enum PokeAPI {
	static let pokeAPI: [String: Any]? = {
		let file = XGFiles.json("pokeAPI")
		if !file.exists {
			XGResources.JSON("pokeAPI").copy(to: file)
		}
		let json = file.json as? [String: Any]
		return json
	}()
	
	static func getImageURL(for pokemonName: String) -> String? {
		var name = pokemonName.lowercased()
		guard name.count > 0 else {
			return nil
		}
		let prefixesToSuffixes = [
			("g ", "galar"),
			("a ", "alola"),
			("h ", "hisui"),
			("p ", "paldea")
		]
		for (pre, suf) in prefixesToSuffixes {
			if name.starts(with: pre) {
				name = name.substring(from: pre.count) + suf
			}
		}
		
		let charsToStrip = [" ", ".", ":", "-", "'", "`", ",", "(", ")", "%"]
		for charToStrip in charsToStrip {
			name = name.replacingOccurrences(of: charToStrip, with: "")
		}
		
		let replacements = [
			("alolan", "alola"),
			("galarian", "galar"),
			("paldean", "paldea"),
			("hisuian", "hisui"),
			("gmax", "gigantamax"),
			("emax", "eternamax"),
			(nil, "black"),
			(nil, "white"),
			(nil, "singlestrike"),
			(nil, "rapidstrike"),
			(nil, "east"),
			(nil, "west"),
			(nil, "altered"),
			(nil, "normal"),
			(nil, "attack"),
			(nil, "defense"),
			(nil, "speed"),
			(nil, "crowned"),
			(nil, "therian"),
			(nil, "incarnate"),
			(nil, "midday"),
			(nil, "midnight"),
			(nil, "duskwing"),
			(nil, "dawnwing"),
			(nil, "dusk"),
		]
		
		for (alt, origin) in replacements {
			if let alt = alt {
				name = name.replacingOccurrences(of: alt, with: origin)
			}
			if name.starts(with: origin) {
				name = name.substring(from: origin.count) + origin
			}
		}
		
		let abbreviations = [
			("giratina", "giratinaaltered"),
			("giratinaa", "giratinaaltered"),
			("giratinaalt", "giratinaaltered"),
			("giratinao", "giratinaorigin"),
			("deoxysd", "deoxysdefense"),
			("dd", "deoxysdefense"),
			("deoxysdefence", "deoxysdefense"),
			("deoxyss", "deoxysspeed"),
			("deoxysa", "deoxysattack"),
			("deoxysn", "deoxysnormal"),
			("deoxys", "deoxysnormal"),
			("urshifur", "urshifurapidstrike"),
			("urshifurs", "urshifurapidstrike"),
			("urshifus", "urshifusinglestrike"),
			("urshifuss", "urshifusinglestrike"),
			("zacianc", "zaciancrowned"),
			("zamazentac", "zamazentacrowned"),
			("tornadust", "tornadustherian"),
			("thundurust", "thundurustherian"),
			("landorust", "landorustherian"),
			("enamorust", "enamorustherian"),
			("tornadusi", "tornadusincarnate"),
			("thundurusi", "thundurusincarnate"),
			("landorusi", "landorusincarnate"),
			("enamorusi", "enamorusincarnate"),
			("tornadus", "tornadusincarnate"),
			("thundurus", "thundurusincarnate"),
			("landorus", "landorusincarnate"),
			("enamorus", "enamorusincarnate"),
			("lycanroc", "lycanrocmidday"),
			
		]
		
		for (abbreviation, full) in abbreviations {
			if name == abbreviation {
				name = full
			}
		}
		
		guard let result = pokeAPI?[name] as? [String: Any] else {
			return nil
		}
		
		guard let imageURL = result["imageURL"] else {
			return nil
		}
		
		return imageURL as? String
	}
}

