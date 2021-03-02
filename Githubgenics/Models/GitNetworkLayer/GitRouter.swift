//
//  GitRouter.swift
//  Githubgenics
//
//  Created by Ali Fayed on 18/01/2021.
//

import Alamofire

enum GitRouter {
    
    case fetchAccessToken(String)
    case gitAuthUser
    case gitStartedReposUser
    case gitOrgs
    case fetchUsers(Int, String)
    case fetchUsersRepository(String)
    case fetchUsersStartted(String)
    case fetchUsersOrgs(String)
    case fetchPublicUserFollowers(String)
    case fetchPublicUserFollowing(String)
    case fetchAuthorizedUserRepositories
    case searchPublicRepositories(String)
    case fetchCommits(String)
    
    var baseURL: String {
        switch self {
        case .fetchAuthorizedUserRepositories, .searchPublicRepositories, .fetchCommits , .fetchUsersRepository, .fetchUsers , .gitAuthUser, .gitStartedReposUser, .gitOrgs , .fetchUsersStartted , .fetchUsersOrgs, .fetchPublicUserFollowers ,.fetchPublicUserFollowing:
            return "https://api.github.com"
        case .fetchAccessToken:
            return "https://github.com"
        }
    }
    
    var path: String {
        switch self {
        case .fetchAccessToken:
            return "/login/oauth/access_token"
        case .gitAuthUser:
            return "/user"
        case .fetchAuthorizedUserRepositories:
            return "/user/repos"
        case .gitStartedReposUser:
            return "/user/starred"
        case .gitOrgs:
            return "/user/orgs"
        case .fetchUsers:
            return "/search/users"
        case .fetchUsersRepository(let user):
            return "/users/\(user)/repos"
        case .fetchPublicUserFollowers(let user):
            return "/users/\(user)/followers"
        case .fetchPublicUserFollowing(let user):
                return "/users/\(user)/following"
        case .fetchUsersStartted(let user):
            return "/users/\(user)/starred"
        case .fetchUsersOrgs(let user):
                return "/users/\(user)/orgs"
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
        case .gitAuthUser:
            return .get
        case .gitStartedReposUser:
            return .get
        case .gitOrgs:
            return .get
        case .fetchUsers:
            return .get
        case .fetchUsersRepository:
            return .get
        case .fetchUsersStartted:
            return .get
        case .fetchPublicUserFollowers:
            return .get
        case .fetchPublicUserFollowing:
            return .get
        case .fetchUsersOrgs:
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
        case .gitAuthUser:
            return nil
        case .gitStartedReposUser:
            return nil
        case .gitOrgs:
        return nil
        case .fetchUsers(let page, let query):
            return ["sort": "repositories", "order": "desc", "page": "\(page)" , "q": query]
        case.fetchUsersRepository:
            return ["per_page": "30"]
        case.fetchPublicUserFollowers:
            return nil
        case.fetchPublicUserFollowing:
            return nil
        case.fetchUsersStartted:
            return ["per_page": "20"]
        case.fetchUsersOrgs:
            return nil
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


