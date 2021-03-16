//
//  Issues.swift
//  Githubgenics
//
//  Created by Ali Fayed on 16/03/2021.
//

struct Issues: Decodable {
    let items: [Issue]
}

struct Issue {
    let issueTitle: String
    let issueURL: String
    let issueState: String

    
    enum IssuesCodingKeys: String, CodingKey {
        case issueTitle = "title"
        case issueURL = "url"
        case issueState = "state"
    }
}

extension Issue: Decodable {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: IssuesCodingKeys.self)
        issueTitle = try container.decode(String.self, forKey: .issueTitle)
        issueURL = try container.decode(String.self, forKey: .issueURL)
        issueState = try container.decode(String.self, forKey: .issueState)
    }
}
