//
//  APIClient.swift
//  NystagmuSense
//
//  Created by Rohan Sampath on 6/30/25.
//

import Foundation
struct TestResultDTO: Codable, Identifiable {
    var id: UUID, date: Date, score: Double, shadeLevel: Double, duration: Double
}
struct Page<T: Decodable>: Decodable { var data: [T]; var nextCursor: String? }

enum APIClient {
    private static let base = URL(string:"https://api.example.com")!
    private static let decoder = { () -> JSONDecoder in
        let d = JSONDecoder(); d.dateDecodingStrategy = .iso8601; return d }()
    private static let encoder = { () -> JSONEncoder in
        let e = JSONEncoder(); e.dateEncodingStrategy = .iso8601; return e }()

    static func upload(_ r: TestResult) async throws {
        let dto = TestResultDTO(id:r.id,date:r.date,score:r.score,
                                shadeLevel:r.shadeLevel,duration:r.duration)
        var req = URLRequest(url: base.appendingPathComponent("/results"))
        req.httpMethod = "POST"
        req.setValue("application/json", forHTTPHeaderField: "Content-Type")
        req.httpBody = try encoder.encode(dto)
        _ = try await URLSession.shared.data(for: req)
    }
}
