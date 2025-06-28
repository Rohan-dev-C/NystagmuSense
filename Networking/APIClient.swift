//
//  APIClient.swift
//  
//
//  Created by Rohan Sampath on 6/28/25.
//
import Foundation

struct TestResultDTO: Codable, Identifiable {
    var id: UUID
    var date: Date
    var score: Double       
    var shadeLevel: Double    
    var duration: Double 
}

struct PaginatedResponse<T: Decodable>: Decodable {
    var data: [T]
    var nextCursor: String?    
}

fileprivate enum Route {
    static let base = URL(string: "https://api.your-backend.com")!   

    case list(cursor: String?)
    case upload

    var urlRequest: URLRequest {
        switch self {
        case .list(let cursor):
            var comps = URLComponents(url: Self.base.appendingPathComponent("/results"),
                                      resolvingAgainstBaseURL: false)!
            if let cursor { comps.queryItems = [.init(name: "cursor", value: cursor)] }
            var req = URLRequest(url: comps.url!)
            req.httpMethod = "GET"
            return req

        case .upload:
            var req = URLRequest(url: Self.base.appendingPathComponent("/results"))
            req.httpMethod = "POST"
            req.setValue("application/json", forHTTPHeaderField: "Content-Type")
            return req
        }
    }
}

enum APIClient {
    private static let decoder: JSONDecoder = {
        let d = JSONDecoder(); d.dateDecodingStrategy = .iso8601; return d
    }()
    private static let encoder: JSONEncoder = {
        let e = JSONEncoder(); e.dateEncodingStrategy = .iso8601; return e
    }()

    @MainActor
    static func fetchResults(cursor: String? = nil) async throws
      -> PaginatedResponse<TestResultDTO>
    {
        let (data, resp) = try await URLSession.shared.data(for: Route.list(cursor: cursor).urlRequest)
        guard (resp as? HTTPURLResponse)?.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
        return try decoder.decode(PaginatedResponse<TestResultDTO>.self, from: data)
    }

    @MainActor
    static func upload(_ result: TestResult) async throws {
        let dto = TestResultDTO(
            id        : UUID(),          
            date      : result.date,
            score     : result.score,
            shadeLevel: result.shadeLevel,
            duration  : result.duration
        )
        var req = Route.upload.urlRequest
        req.httpBody = try encoder.encode(dto)

        let (_, resp) = try await URLSession.shared.data(for: req)
        guard (resp as? HTTPURLResponse)?.statusCode == 201 else {
            throw URLError(.cannotWriteToFile)  
        }
    }
}