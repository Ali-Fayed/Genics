//
//  UserRepostoryAPI.swift
//  Githubgenics
//
//  Created by Ali Fayed on 30/01/2021.
//

import Foundation

struct UserRepository {
    let repositoryName: String?
    let repositoryDescription:String?
    let repositoryURL: String?
    let repositoryStars: Int?
    let fullName: String
    let repositoryLanguage: String?
    var done: Bool = false
    
    enum userRpositoryCodingKeys: String, CodingKey {
        case repositoryName = "name"
        case repositoryDescription = "description"
        case repositoryURL = "html_url"
        case repositoryStars = "stargazers_count"
        case fullName = "full_name"
        case repositoryLanguage = "language"
    }
}

extension UserRepository: Decodable {
  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: userRpositoryCodingKeys.self)
    repositoryName = try container.decode(String.self, forKey: .repositoryName)
    repositoryDescription = try? container.decode(String.self, forKey: .repositoryDescription)
    repositoryStars = try! container.decode(Int.self, forKey: .repositoryStars)
    repositoryLanguage = try? container.decode(String.self, forKey: .repositoryLanguage)
    repositoryURL = try? container.decode(String.self, forKey: .repositoryURL)
    fullName = try container.decode(String.self, forKey: .fullName)

  }
}
