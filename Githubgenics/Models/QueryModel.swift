//
//  SearchModel.swift
//  Githubgenics
//
//  Created by Ali Fayed on 21/01/2021.
//

import Foundation

struct UsersQResults: Codable {
    let items: [items]
}

struct items: Codable {
    let login: String
    let avatar_url: String
    let html_url: String
    


    private enum CodingKeys: String, CodingKey {
        case login, avatar_url, html_url
    }
}
