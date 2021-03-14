//
//  GitRouter.swift
//  Githubgenics
//
//  Created by Ali Fayed on 18/01/2021.
//

import Alamofire

enum GitRequsetRouter {
    
    case gitAccessToken(String)
    case gitAuthenticatedUser
    case gitAuthenticatedUserRepositories
    case gitAuthenticatedUserStarred
    case gitAuthenticatedUserOrgs
    case gitPublicUsers(Int, String)
    case gitPublicRepositories(String)
    case gitRepositoriesCommits(String)
    case gitPublicUsersRepositories(String)
    case gitPublicUsersStarred(String)
    case gitPublicUsersOrgs(String)
    case gitPublicUserFollowers(String)
    case gitPublicUserFollowing(String)

    
    var baseURL: String {
        switch self {
        case .gitAuthenticatedUserRepositories, .gitPublicRepositories, .gitRepositoriesCommits , .gitPublicUsersRepositories, .gitPublicUsers , .gitAuthenticatedUser, .gitAuthenticatedUserStarred, .gitAuthenticatedUserOrgs , .gitPublicUsersStarred , .gitPublicUsersOrgs, .gitPublicUserFollowers ,.gitPublicUserFollowing:
            return "https://api.github.com"
        case .gitAccessToken:
            return "https://github.com"
        }
    }
    
    var path: String {
        switch self {
        case .gitAccessToken:
            return "/login/oauth/access_token"
        case .gitAuthenticatedUser:
            return "/user"
        case .gitAuthenticatedUserRepositories:
            return "/user/repos"
        case .gitAuthenticatedUserStarred:
            return "/user/starred"
        case .gitAuthenticatedUserOrgs:
            return "/user/orgs"
        case .gitPublicUsers:
            return "/search/users"
        case .gitPublicUsersRepositories(let user):
            return "/users/\(user)/repos"
        case .gitPublicUserFollowers(let user):
            return "/users/\(user)/followers"
        case .gitPublicUserFollowing(let user):
                return "/users/\(user)/following"
        case .gitPublicUsersStarred(let user):
            return "/users/\(user)/starred"
        case .gitPublicUsersOrgs(let user):
                return "/users/\(user)/orgs"
        case .gitPublicRepositories:
            return "/search/repositories"
        case .gitRepositoriesCommits(let repository):
            return "/repos/\(repository)/commits"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .gitAccessToken:
            return .post
        case .gitAuthenticatedUser:
            return .get
        case .gitAuthenticatedUserStarred:
            return .get
        case .gitAuthenticatedUserOrgs:
            return .get
        case .gitPublicUsers:
            return .get
        case .gitPublicUsersRepositories:
            return .get
        case .gitPublicUsersStarred:
            return .get
        case .gitPublicUserFollowers:
            return .get
        case .gitPublicUserFollowing:
            return .get
        case .gitPublicUsersOrgs:
                return .get
        case .gitAuthenticatedUserRepositories:
            return .get
        case .gitPublicRepositories:
            return .get
        case .gitRepositoriesCommits:
            return .get
        }
    }
    
    var parameters: [String: String]? {
        switch self {
        case .gitAccessToken(let accessToken):
            return [
                "client_id": GitHubConstants.clientID,
                "client_secret": GitHubConstants.clientSecret,
                "code": accessToken
            ]
        case .gitAuthenticatedUser:
            return nil
        case .gitAuthenticatedUserStarred:
            return nil
        case .gitAuthenticatedUserOrgs:
        return nil
        case .gitPublicUsers(let page, let query):
            return ["sort": "repositories", "order": "desc", "page": "\(page)" , "q": query]
        case.gitPublicUsersRepositories:
            return ["per_page": "50"]
        case.gitPublicUserFollowers:
            return ["per_page": "99"]
        case.gitPublicUserFollowing:
            return ["per_page": "99"]
        case.gitPublicUsersStarred:
            return ["per_page": "30"]
        case.gitPublicUsersOrgs:
            return nil
        case .gitAuthenticatedUserRepositories:
            return ["per_page": "50"]
        case .gitPublicRepositories(let query):
            return ["sort": "stars", "order": "desc", "page": "1", "q": query]
        case .gitRepositoriesCommits:
            return nil
        }
    }
}

// MARK: - URLRequestConvertible

extension GitRequsetRouter: URLRequestConvertible {
    func asURLRequest() throws -> URLRequest {
        let url = try baseURL.asURL().appendingPathComponent(path)
        var request = URLRequest(url: url)
        request.method = method
        if method == .get {
            request = try URLEncodedFormParameterEncoder().encode(parameters, into: request)
        } else if method == .post {
            request = try JSONParameterEncoder().encode(parameters, into: request)
            request.setValue("application/json", forHTTPHeaderField: "Accept")
        }
        return request
    }
}


