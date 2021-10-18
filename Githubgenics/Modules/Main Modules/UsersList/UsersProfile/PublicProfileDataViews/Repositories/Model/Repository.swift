//
//  Repositories.swift
//  Githubgenics
//
//  Created by Ali Fayed on 30/01/2021.
//

struct Repositories: Decodable {
    let items: [Repository]
}

/// this model used to parse startted repos/repos/userrepos/search
struct Repository {
    let repositoryName: String
    let repositoryDescription: String?
    let repositoryStars: Int?
    let repoFullName: String
    let repositoryLanguage: String?
    let repositoryURL:String
    let repoOwnerName:String
    let repoOwnerAvatarURL:String
    
enum RepositoriesCodingKeys: String, CodingKey {
        case repositoryName = "name"
        case repositoryDescription = "description"
        case repositoryStars = "stargazers_count"
        case repositoryLanguage = "language"
        case repoFullName = "full_name"
        case repositoryURL = "html_url"
        case repoOwner = "owner"
        case repoOwnerName = "login"
        case repoOwnerAvatarURL = "avatar_url"
    }
}

extension Repository: Decodable {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: RepositoriesCodingKeys.self)
        let owner = try container.nestedContainer(keyedBy: RepositoriesCodingKeys.self, forKey: .repoOwner)
        repositoryName = try container.decode(String.self, forKey: .repositoryName)
        repositoryDescription = try? container.decode(String.self, forKey: .repositoryDescription)
        repositoryStars = try? container.decode(Int.self, forKey: .repositoryStars)
        repositoryLanguage = try? container.decode(String.self, forKey: .repositoryLanguage)
        repositoryURL = try container.decode(String.self, forKey: .repositoryURL)
        repoFullName = try container.decode(String.self, forKey: .repoFullName)
        repoOwnerName = try owner.decode(String.self, forKey: .repoOwnerName)
        repoOwnerAvatarURL = try owner.decode(String.self, forKey: .repoOwnerAvatarURL)
    }
}
