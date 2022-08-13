//
//  GoDNetworkingManager.swift
//  GoD Tool
//
//  Created by Stars Momodu on 06/10/2021.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

enum NetworkingErrors: Error {
	case badRequestURL
	case badRequestJSON
	case requestFailed(Error)
	case unknownRequestFailure
	case failedToDecodeJSON
}

class GoDNetworkingManager {
	private enum HTTPMethods: String {
		case GET, POST
	}
	
	static func get(_ urlString: String) -> Data? {
		guard let url = URL(string: urlString) else { return nil }
		return try? Data(contentsOf: url)
	}

	static func get<T: Decodable>(_ url: String, json: Encodable? = nil, completion: ((Result<T, NetworkingErrors>) -> Void)?) {
		request(method: .GET, urlString: url, json: json, completion: completion)
	}

	static func post(_ url: String, json: Encodable) {
		request(method: .POST, urlString: url, json: json)
	}

	static func post<T: Decodable>(_ url: String, json: Encodable, completion: ((Result<T, NetworkingErrors>) -> Void)?) {
		request(method: .POST, urlString: url, json: json, completion: completion)
	}

	private static func request(method: HTTPMethods, urlString: String, json: Encodable?) {
		request(method: method, urlString: urlString, json: json, completion: { (result: Result<Int, NetworkingErrors>) -> Void in return })
	}

	private static func request<T: Decodable>(method: HTTPMethods, urlString: String, json: Encodable?, completion: ((Result<T, NetworkingErrors>) -> Void)?) {

		guard let url = URL(string: urlString) else {
			completion?(.failure(.badRequestURL)); return
		}
		var request = URLRequest(url: url)
		request.httpMethod = method.rawValue
		if let json = json {
			guard let jsonData = try? json.JSONRepresentation() else {
				completion?(.failure(.badRequestJSON))
				return
			}
			request.httpBody = jsonData
		}

		let task = URLSession.shared.dataTask(with: request) { data, response, error in
			guard let data = data, error == nil else {
				if let error = error {
					completion?(.failure(.requestFailed(error)))
				} else {
					completion?(.failure(.unknownRequestFailure))
				}
				return
			}
			if let responseJSON = try? T.fromJSON(data: data) {
				completion?(.success(responseJSON))
			} else {
				completion?(.failure(.failedToDecodeJSON))
			}
		}

		task.resume()
	}
}
