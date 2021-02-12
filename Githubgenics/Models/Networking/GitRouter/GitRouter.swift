//
//  GitRouter.swift
//  Githubgenics
//
//  Created by Ali Fayed on 18/01/2021.
//

import Alamofire

enum GitRouter {
  case fetchAuthorizedUserRepositories
  case searchPublicRepositories(String)
  case fetchCommits(String)
  case fetchAccessToken(String)
  case fetchUsersRepositories(String)
  case fetchUsers(Int, String)
    
  var baseURL: String {
    switch self {
    case .fetchAuthorizedUserRepositories, .searchPublicRepositories, .fetchCommits , .fetchUsersRepositories, .fetchUsers:
      return "https://api.github.com"
    case .fetchAccessToken:
      return "https://github.com"
    }
  }

  var path: String {
    switch self {
    case .fetchAuthorizedUserRepositories:
      return "/user/repos"
    case .searchPublicRepositories:
      return "/search/repositories"
    case .fetchCommits(let repository):
      return "/repos/\(repository)/commits"
    case .fetchAccessToken:
      return "/login/oauth/access_token"
    case .fetchUsersRepositories(let user):
    return "/users/\(user)/repos"
    case .fetchUsers:
    return "/search/users"
    }
  }

  var method: HTTPMethod {
    switch self {
    case .fetchAuthorizedUserRepositories:
      return .get
    case .searchPublicRepositories:
      return .get
    case .fetchCommits:
      return .get
    case .fetchAccessToken:
      return .post
    case .fetchUsersRepositories:
    return   .get
    case .fetchUsers:
        return .get
    }
  }

  var parameters: [String: String]? {
    switch self {
    case .fetchUsers(let page, let query):
    return ["sort": "repositories", "order": "desc", "page": "\(page)" , "q": query]
    case .fetchAuthorizedUserRepositories:
      return ["per_page": "100"]
    case.fetchUsersRepositories:
        return ["per_page": "10"]
    case .searchPublicRepositories(let query):
      return ["sort": "stars", "order": "desc", "page": "1", "q": query]
    case .fetchCommits:
      return nil
    case .fetchAccessToken(let accessToken):
      return [
        "client_id": GitHubConstants.clientID,
        "client_secret": GitHubConstants.clientSecret,
        "code": accessToken
      ]
    }
  }
}

// MARK: - URLRequestConvertible

extension GitRouter: URLRequestConvertible {
  func asURLRequest() throws -> URLRequest {
    let url = try baseURL.asURL().appendingPathComponent(path)
    var request = URLRequest(url: url)
    request.method = method
    if method == .get {
      request = try URLEncodedFormParameterEncoder()
        .encode(parameters, into: request)
    } else if method == .post {
      request = try JSONParameterEncoder().encode(parameters, into: request)
      request.setValue("application/json", forHTTPHeaderField: "Accept")
    }
    return request
  }
}
