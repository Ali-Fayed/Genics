/// Copyright (c) 2020 Razeware LLC
/// 
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
/// 
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
/// 
/// Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
/// distribute, sublicense, create a derivative work, and/or sell copies of the
/// Software in any work that is designed, intended, or marketed for pedagogical or
/// instructional purposes related to programming, coding, application development,
/// or information technology.  Permission for such use, copying, modification,
/// merger, publication, distribution, sublicensing, creation of derivative works,
/// or sale is expressly withheld.
/// 
/// This project and source code may use libraries or frameworks that are
/// released under various Open-Source licenses. Use of those libraries and
/// frameworks are governed by their own individual licenses.
///
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.

import Foundation
import Alamofire

enum GitRouter {
    
  case fetchUserRepositories
  case searchRepositories(String)
  case fetchCommits(String)
  case fetchAccessToken(String)
  case fetchClickedRepositories(String)
  case fetchUsers(Int, String)
    
  var baseURL: String {
    switch self {
    case .fetchUserRepositories, .searchRepositories, .fetchCommits , .fetchClickedRepositories, .fetchUsers:
      return "https://api.github.com"
    case .fetchAccessToken:
      return "https://github.com"
    }
  }

  var path: String {
    switch self {
    case .fetchUserRepositories:
      return "/user/repos"
    case .searchRepositories:
      return "/search/repositories"
    case .fetchCommits(let repository):
      return "/repos/\(repository)/commits"
    case .fetchAccessToken:
      return "/login/oauth/access_token"
    case .fetchClickedRepositories(let user):
    return "/users/\(user)/repos"
    case .fetchUsers:
    return "/search/users"
    }
 
  }

  var method: HTTPMethod {
    switch self {
    case .fetchUserRepositories:
      return .get
    case .searchRepositories:
      return .get
    case .fetchCommits:
      return .get
    case .fetchAccessToken:
      return .post
    case .fetchClickedRepositories:
    return   .get
    case .fetchUsers:
        return .get
    }
  }

  var parameters: [String: String]? {
    switch self {
    case .fetchUsers(let page, let query):
    return ["sort": "repositories", "order": "desc", "page": "\(page)" , "q": query]
    case .fetchUserRepositories:
      return ["per_page": "100"]
    case.fetchClickedRepositories:
        return ["per_page": "10"]
    case .searchRepositories(let query):
      return ["sort": "stars", "order": "desc", "page": "1", "q": query]
    case .fetchCommits:
      return nil
    case .fetchAccessToken(let accessCode):
      return [
        "client_id": GitHubConstants.clientID,
        "client_secret": GitHubConstants.clientSecret,
        "code": accessCode
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
