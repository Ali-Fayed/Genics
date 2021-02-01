//
//  RepostoriesAPI.swift
//  Githubgenics
//
//  Created by Ali Fayed on 30/01/2021.
//

struct Repositories: Decodable {
    let items: [Repository]
}

struct Repository {
    let repositoryName: String
    let repositoryDescription: String?
    let repositoryStars: Int
    let repositoryLanguage: String?
    let repositoryURL:String
    
    enum repositoriesCodingKeys: String, CodingKey {
        case repositoryName = "name"
        case repositoryDescription = "description"
        case repositoryStars = "stargazers_count"
        case repositoryLanguage = "language"
        case repositoryURL = "html_url"
    }
}

extension Repository: Decodable {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: repositoriesCodingKeys.self)
        repositoryName = try! container.decode(String.self, forKey: .repositoryName)
        repositoryDescription = try? container.decode(String.self, forKey: .repositoryDescription)
        repositoryStars = try! container.decode(Int.self, forKey: .repositoryStars)
        repositoryLanguage = try? container.decode(String.self, forKey: .repositoryLanguage)
        repositoryURL = try! container.decode(String.self, forKey: .repositoryURL)
    }
}
