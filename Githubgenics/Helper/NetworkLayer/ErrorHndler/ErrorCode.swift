//
//  ErrorCode.swift
//  Githubgenics
//
//  Created by Ali Fayed on 16/10/2021.
//

import Foundation
enum ErrorCode: String, Codable {
    case noConnetion
    case general
}
extension ErrorCode {
    var errorDescription: String? {
        switch self {
        case .noConnetion:
            return ""
        case .general:
            return ""
        }
    }
}
