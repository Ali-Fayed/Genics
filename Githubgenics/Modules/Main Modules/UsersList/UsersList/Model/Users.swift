//
//  Users.swift
//  Githubgenics
//
//  Created by Ali Fayed on 30/01/2021.
//

struct Users: Decodable {
    let items: [User]
}

struct User {
    let userName: String
    let userURL: String
    let userAvatar: String
    let userFollowing: String
    let userFollowers: String
    
    enum UsersCodingKeys: String, CodingKey {
        case userName = "login"
        case userURL = "html_url"
        case userAvatar = "avatar_url"
        case userFollowing = "following_url"
        case userFollowers = "followers_url"
    }
}

extension User: Decodable {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: UsersCodingKeys.self)
        userName = try container.decode(String.self, forKey: .userName)
        userURL = try container.decode(String.self, forKey: .userURL)
        userAvatar = try container.decode(String.self, forKey: .userAvatar)
        userFollowing = try container.decode(String.self, forKey: .userFollowing)
        userFollowers = try container.decode(String.self, forKey: .userFollowers)
    }
}
