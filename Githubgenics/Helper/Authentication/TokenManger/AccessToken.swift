//
//  AccessToken.swift
//  Githubgenics
//
//  Created by Ali Fayed on 30/12/2020.
//

struct AccessToken: Decodable {
  let accessToken: String
  let tokenType: String

  enum CodingKeys: String, CodingKey {
    case accessToken = "access_token"
    case tokenType = "token_type"
  }
}
