//
//  HeroesStat.swift
//  Githubgenicsk
//
//  Created by Ali Fayed on 21/12/2020.
//
struct Commit {
  let authorName: String
  let message: String

  enum CodingKeys: String, CodingKey {
    case authorName = "name"
    case message
    case commit
    case author
  }
}

struct UsersStruct: Codable {
    
    let login: String
    let html_url: String
    let avatar_url: String
    let repos_url: String
    
    enum CodingKeys: String, CodingKey {
        
        case login
        case html_url
        case avatar_url
        case repos_url
    }
}

struct repositoriesParameters: Codable {
    
    let name: String
    let description:String
    let html_url: String
    let stargazers_count: Int
    let language: String
    
    enum CodingKeys: String, CodingKey {
        
        case name
        case description
        case html_url
        case stargazers_count
        case language
        
    }
}

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

struct Repositories: Decodable {
  let items: [Repository]
    
}
struct Repository {
  let name: String
  let fullName: String
  let description: String?
    let stargazers_count: Double?
    let language: String?
    let html_url:String?


  enum CodingKeys: String, CodingKey {
    case name
    case description
    case fullName = "full_name"
    case stargazers_count
    case language
    case html_url

  }
}

extension Repository: Decodable {
  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    name = try container.decode(String.self, forKey: .name)
    fullName = try container.decode(String.self, forKey: .fullName)
    description = try? container.decode(String.self, forKey: .description)
    stargazers_count = try! container.decode(Double.self, forKey: .stargazers_count)
    language = try? container.decode(String.self, forKey: .language)
    html_url = try? container.decode(String.self, forKey: .html_url)

  }
}
extension Commit: Decodable {
  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    let commit = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .commit)
    message = try commit.decode(String.self, forKey: .message)
    let author = try commit.nestedContainer(keyedBy: CodingKeys.self, forKey: .author)
    authorName = try author.decode(String.self, forKey: .authorName)
  }
}

