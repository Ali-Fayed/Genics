//
//  GitRouter.swift
//  Githubgenics
//
//  Created by Ali Fayed on 18/01/2021.
//

import Alamofire

enum GitRequestRouter {
    
    case gitAccessToken(String)
    case gitAuthenticatedUser
    case gitAuthenticatedUserRepositories
    case gitAuthenticatedUserStarred
    case gitAuthenticatedUserOrgs
    case gitSearchUsers(Int, String)
    case gitUsersList(Int)
    case gitPublicUserInfo(String)
    case gitPublicRepositories(Int, String)
    case gitRepositoriesCommits(Int, String)
    case gitPublicUsersRepositories(Int, String)
    case gitPublicUsersStarred(Int, String)
    case gitPublicUsersOrgs(String)
    case gitPublicUserFollowers(String)
    case gitPublicUserFollowing(String)
    
    
    var baseURL: String {
        switch self {
        case .gitAuthenticatedUserRepositories, .gitPublicRepositories, .gitRepositoriesCommits , .gitPublicUsersRepositories, .gitSearchUsers , .gitAuthenticatedUser, .gitAuthenticatedUserStarred, .gitAuthenticatedUserOrgs , .gitPublicUsersStarred , .gitPublicUsersOrgs, .gitPublicUserFollowers ,.gitPublicUserFollowing, .gitPublicUserInfo, .gitUsersList:
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
        case .gitSearchUsers:
            return "/search/users"
        case .gitUsersList:
            return "/users"
        case .gitPublicRepositories:
            return "/search/repositories"
        case .gitPublicUserInfo(let user):
            return "/users/\(user)"
        case .gitPublicUsersRepositories(_, let user):
            return "/users/\(user)/repos"
        case .gitPublicUserFollowers(let user):
            return "/users/\(user)/followers"
        case .gitPublicUserFollowing(let user):
            return "/users/\(user)/following"
        case .gitPublicUsersStarred(_,let user):
            return "/users/\(user)/starred"
        case .gitPublicUsersOrgs(let user):
            return "/users/\(user)/orgs"
        case .gitRepositoriesCommits(_,let repository):
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
        case .gitSearchUsers:
            return .get
        case .gitPublicUserInfo:
            return .get
        case .gitUsersList:
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
            return ["per_page": "50"]
        case .gitAuthenticatedUserOrgs:
            return ["per_page": "50"]
        case .gitAuthenticatedUserRepositories:
            return ["per_page": "50"]
        case .gitSearchUsers(let page, let query):
            return ["per_page": "30" ,"sort": "repositories", "order": "desc", "page": "\(page)" , "q": query]
        case .gitPublicUserInfo:
            return nil
        case .gitUsersList(let page):
            return ["page": "\(page)"]
        case .gitPublicRepositories(let page, let query):
            return ["per_page": "30", "sort": "stars", "order": "desc", "page": "\(page)" , "q": query]
        case.gitPublicUsersRepositories(let page, _):
            return ["per_page": "30" , "page": "\(page)"]
        case.gitPublicUsersStarred(let page,_):
            return ["per_page": "30" ,"page": "\(page)"]
        case.gitPublicUsersOrgs:
            return ["per_page": "30", "page": "1"]
        case .gitRepositoriesCommits(let page,_):
            return ["per_page": "30", "page": "\(page)"]
        case.gitPublicUserFollowers:
            return ["per_page": "30"]
        case.gitPublicUserFollowing:
            return ["per_page": "30"]
        }
    }
}

// MARK: - URLRequestConvertible

extension GitRequestRouter: URLRequestConvertible {
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
