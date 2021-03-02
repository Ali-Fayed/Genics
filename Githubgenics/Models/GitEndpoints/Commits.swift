//
//  Commits.swift
//  Githubgenics
//
//  Created by Ali Fayed on 02/02/2021.
//

struct Commit {
  let authorName: String
  let message: String
    let html_url: String

  enum CodingKeys: String, CodingKey {
    case authorName = "name"
    case message
    case commit
    case author
    case html_url = "html_url"
  }
}

extension Commit: Decodable {
  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    let commit = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .commit)
    message = try commit.decode(String.self, forKey: .message)
    let author = try commit.nestedContainer(keyedBy: CodingKeys.self, forKey: .author)
    authorName = try author.decode(String.self, forKey: .authorName)
    html_url = try container.decode(String.self, forKey: .html_url)

  }
}
