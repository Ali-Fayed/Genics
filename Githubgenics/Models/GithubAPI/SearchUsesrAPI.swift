//
//  UserAPI.swift
//  Githubgenics
//
//  Created by Ali Fayed on 30/01/2021.
//

struct SearchedUsers: Decodable {
    let items: [items]
}

struct items {
    let userName: String?
    let userURL: String?
    let userAvatar: String?
    
    enum searchedUsersCodingKeys: String, CodingKey {
        case userName = "login"
        case userURL = "html_url"
        case userAvatar = "avatar_url"
    }
}

extension items: Decodable {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: searchedUsersCodingKeys.self)
        userName = try? container.decode(String.self, forKey: .userName)
        userURL = try? container.decode(String.self, forKey: .userURL)
        userAvatar = try? container.decode(String.self, forKey: .userAvatar)
    }
}
