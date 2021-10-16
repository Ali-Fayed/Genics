//
//  APIError.swift
//  Githubgenics
//
//  Created by Ali Fayed on 16/10/2021.
//

import Foundation
struct ApiError: Error, Equatable, Codable {
    var message: String?
    var code: ErrorCode?
    var statusCode: Int?
    var details: [ErrorDetails]?
    init(_ code: ErrorCode?) {
        self.code = code
    }
    init(_ message: String, code: ErrorCode?) {
        self.message = message
        self.code = code
    }
    enum CodingKeys: String, CodingKey {
        case message
        case code
        case statusCode
        case details
    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        message = try? values.decode(String.self, forKey: .message)
        code = try? values.decode(ErrorCode.self, forKey: .code)
        statusCode = try? values.decode(Int.self, forKey: .statusCode)
        details = try? values.decode([ErrorDetails].self, forKey: .details)
    }
}
struct ErrorDetails: Equatable, Codable {
    var name: String?
    var type: ErrorCode?
    var value: String?
    var message: String?
    var minCount: Int?
    var max: String?
    var min: String?
    enum CodingKeys: String, CodingKey {
        case name
        case type
        case value
        case message
        case minCount
        case max
        case min
    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        name = try? values.decode(String.self, forKey: .name)
        type = try? values.decode(ErrorCode.self, forKey: .type)
        value = try? values.decode(String.self, forKey: .value)
        message = try? values.decode(String.self, forKey: .message)
        minCount = try? values.decode(Int.self, forKey: .minCount)
        max = try? values.decode(String.self, forKey: .max)
        min = try? values.decode(String.self, forKey: .min)
    }
}
