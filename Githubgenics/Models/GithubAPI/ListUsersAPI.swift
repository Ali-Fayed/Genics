//
//  HeroesStat.swift
//  Githubgenicsk
//
//  Created by Ali Fayed on 21/12/2020.
//

struct Users {
    let userName: String
    let userURL: String
    let userAvatar: String
    let userRepositoriesURL: String
    let userID: Int
    
    enum usersCodingKeys: String, CodingKey {
        case userName = "login"
        case userURL = "html_url"
        case userAvatar = "avatar_url"
        case userRepositoriesURL = "repos_url"
        case userID = "id"
    }
}

extension Users: Decodable {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: usersCodingKeys.self)
        userName = try! container.decode(String.self, forKey: .userName)
        userAvatar = try! container.decode(String.self, forKey: .userAvatar)
        userRepositoriesURL = try! container.decode(String.self, forKey: .userRepositoriesURL)
        userURL = try! container.decode(String.self, forKey: .userURL)
        userID = try! container.decode(Int.self, forKey: .userID)
    }
}





