//
//  GoDNetworkingManager.swift
//  GoD Tool
//
//  Created by Stars Momodu on 06/10/2021.
//

import Foundation

class GoDNetworkingManager {
	private enum HTTPMethods: String {
		case GET, POST
	}

	private struct Dummy: Codable {}

	static func get(_ urlString: String) -> Data? {
		guard let url = URL(string: urlString) else { return nil }
		return try? Data(contentsOf: url)
	}

	static func get<T: Codable>(_ url: String, json: Encodable? = nil, completion: ((T?) -> Void)?) {
		request(method: .GET, urlString: url, json: nil, completion: completion)
	}

	static func post(_ url: String, json: Encodable) {
		request(method: .POST, urlString: url, json: json)
	}

	static func post<T: Codable>(_ url: String, json: Encodable, completion: ((T?) -> Void)?) {
		request(method: .POST, urlString: url, json: json, completion: completion)
	}

	private static func request(method: HTTPMethods, urlString: String, json: Encodable?) {
		#warning("TODO: Find a cleaner alternative")
		request(method: method, urlString: urlString, json: json, completion: {(dummy: Dummy?) in return })
	}

	private static func request<T: Codable>(method: HTTPMethods, urlString: String, json: Encodable?, completion: ((T?) -> Void)?) {

		guard let url = URL(string: urlString) else { completion?(nil); return }
		var request = URLRequest(url: url)
		request.httpMethod = method.rawValue
		request.httpBody = try? json?.JSONRepresentation()

		let task = URLSession.shared.dataTask(with: request) { data, response, error in
			guard let data = data, error == nil else {
				printg("Failed to make \(method.rawValue) request to:", urlString)
				if XGSettings.current.verbose {
					printg(error?.localizedDescription ?? "No data")
				}
				completion?(nil)
				return
			}
			let responseJSON = try? T.fromJSON(data: data)
			completion?(responseJSON)
		}

		task.resume()
	}
}
