//
//  WebService.swift
//  Vorratsheld
//
//  Created by Ali Chehab on 18.10.26.
//

import Foundation

class WebService {

    static let shared: WebService = WebService()

    private init() {}

    func get<DataType: Codable>(urlString: String) async throws -> DataType {
        guard let url = URL(string: urlString) else {
            throw HTTPError.invalidURL
        }
        var request = URLRequest(url: url)
        // Open Food Facts möchte wissen, welche App fragt
        request.setValue("Vorratsheld-iOS/\(PlatformInfo.appVersion)", forHTTPHeaderField: "User-Agent")

        let (data, _) = try await URLSession.shared.data(for: request)
        return try JSONDecoder().decode(DataType.self, from: data)
    }

    func post<Body: Codable>(urlString: String, body: Body) async throws {
        guard let url = URL(string: urlString) else {
            throw HTTPError.invalidURL
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try JSONEncoder().encode(body)

        let (_, response) = try await URLSession.shared.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse, (200..<300).contains(httpResponse.statusCode) else {
            throw HTTPError.fetchFailed
        }
    }
}
