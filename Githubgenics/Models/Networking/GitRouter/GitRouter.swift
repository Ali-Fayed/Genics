//
//  GitRouter.swift
//  Githubgenics
//
//  Created by Ali Fayed on 18/01/2021.
//

import Alamofire

enum GitRouter {
    
    case fetchAccessToken(String)
    case fetchUsers(Int, String)
    case fetchUsersRepositories(String)
    case fetchAuthorizedUserRepositories
    case searchPublicRepositories(String)
    case fetchCommits(String)
    
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
        case .fetchAccessToken:
            return "/login/oauth/access_token"
        case .fetchUsers:
            return "/search/users"
        case .fetchUsersRepositories(let user):
            return "/users/\(user)/repos"
        case .fetchAuthorizedUserRepositories:
            return "/user/repos"
        case .searchPublicRepositories:
            return "/search/repositories"
        case .fetchCommits(let repository):
            return "/repos/\(repository)/commits"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .fetchAccessToken:
            return .post
        case .fetchUsers:
            return .get
        case .fetchUsersRepositories:
            return .get
        case .fetchAuthorizedUserRepositories:
            return .get
        case .searchPublicRepositories:
            return .get
        case .fetchCommits:
            return .get
        }
    }
    
    var parameters: [String: String]? {
        switch self {
        case .fetchAccessToken(let accessToken):
            return [
                "client_id": GitHubConstants.clientID,
                "client_secret": GitHubConstants.clientSecret,
                "code": accessToken
            ]
        case .fetchUsers(let page, let query):
            return ["sort": "repositories", "order": "desc", "page": "\(page)" , "q": query]
        case.fetchUsersRepositories:
            return ["per_page": "50"]
        case .fetchAuthorizedUserRepositories:
            return ["per_page": "50"]
        case .searchPublicRepositories(let query):
            return ["sort": "stars", "order": "desc", "page": "1", "q": query]
        case .fetchCommits:
            return nil
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
