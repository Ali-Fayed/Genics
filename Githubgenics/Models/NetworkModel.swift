//
//  HeroesStat.swift
//  Githubgenicsk
//
//  Created by Ali Fayed on 21/12/2020.
//
//MARK:- User List Network Data Model

struct Users {
    let login: String?
    let html_url: String?
    let avatar_url: String?
    let repos_url: String?
    
    enum CodingKeys: String, CodingKey {
        case login
        case html_url
        case avatar_url
        case repos_url
    }
}

extension Users: Decodable {
  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    login = try container.decode(String.self, forKey: .login)
    avatar_url = try? container.decode(String.self, forKey: .avatar_url)
    repos_url = try? container.decode(String.self, forKey: .repos_url)
    html_url = try? container.decode(String.self, forKey: .html_url)

  }
}

//MARK:- UserRepository Network Data Model

struct UserRepository {
    let name: String?
    let description:String?
    let html_url: String?
    let stargazers_count: Int?
    let language: String?
    
    enum CodingKeys: String, CodingKey {
        case name
        case description
        case html_url
        case stargazers_count
        case language
    }
}

extension UserRepository: Decodable {
  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    name = try container.decode(String.self, forKey: .name)
    description = try? container.decode(String.self, forKey: .description)
    stargazers_count = try! container.decode(Int.self, forKey: .stargazers_count)
    language = try? container.decode(String.self, forKey: .language)
    html_url = try? container.decode(String.self, forKey: .html_url)
  }
}

//MARK:- SearchedUsers Network Data Model

struct SearchedUsers: Decodable {
    let items: [items]
}

struct items {
    let login: String?
    let avatar_url: String?
    let html_url: String?

     enum CodingKeys: String, CodingKey {
        case login
        case avatar_url
        case html_url
    }
}

extension items: Decodable {
  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    login = try? container.decode(String.self, forKey: .login)
    avatar_url = try? container.decode(String.self, forKey: .avatar_url)
    html_url = try? container.decode(String.self, forKey: .html_url)

  }
}

//MARK:- RepositroySearch Network Data Model

struct Repositories: Decodable {
  let items: [Repository]
    
}
struct Repository {
  let name: String
  let fullName: String
  let description: String
    let stargazers_count: Int
    let language: String
    let html_url:String


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
    description = try! container.decode(String.self, forKey: .description)
    stargazers_count = try! container.decode(Int.self, forKey: .stargazers_count)
    language = try! container.decode(String.self, forKey: .language)
    html_url = try! container.decode(String.self, forKey: .html_url)

  }
}



