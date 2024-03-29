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
    case gitListOrgs(Int, Int)
    case gitSearchUsers(Int, String)
    case gitUsersList(Int)
    case gitPublicUserInfo(String)
    case gitPublicRepositories(Int, String)
    case gitSearchIssues(Int, String)
    case gitSearchCommits(Int, String)
    case gitRepositoriesCommits(Int, String)
    case gitPublicUsersRepositories(Int, String)
    case gitPublicUsersStarred(Int, String)
    case gitPublicUsersOrgs(String)
    case gitPublicUserFollowers(String)
    case gitPublicUserFollowing(String)
    case gitProjectRepo
    
    var baseURL: String {
        switch self {
        case .gitAuthenticatedUserRepositories, .gitPublicRepositories, .gitRepositoriesCommits , .gitPublicUsersRepositories, .gitSearchUsers , .gitAuthenticatedUser, .gitAuthenticatedUserStarred, .gitAuthenticatedUserOrgs , .gitPublicUsersStarred , .gitPublicUsersOrgs, .gitPublicUserFollowers ,.gitPublicUserFollowing, .gitPublicUserInfo, .gitUsersList , .gitSearchIssues, .gitListOrgs, .gitSearchCommits, .gitProjectRepo:
            return "https://api.github.com"
        case .gitAccessToken:
            return "https://github.com"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .gitAccessToken:
            return .post
        case .gitAuthenticatedUserRepositories, .gitPublicRepositories, .gitRepositoriesCommits , .gitPublicUsersRepositories, .gitSearchUsers , .gitAuthenticatedUser, .gitAuthenticatedUserStarred, .gitAuthenticatedUserOrgs , .gitPublicUsersStarred , .gitPublicUsersOrgs, .gitPublicUserFollowers ,.gitPublicUserFollowing, .gitPublicUserInfo, .gitUsersList , .gitSearchIssues, .gitListOrgs, .gitSearchCommits, .gitProjectRepo:
            return .get
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
        case .gitListOrgs:
            return "/organizations"
        case .gitSearchUsers:
            return "/search/users"
        case .gitSearchCommits:
            return "/search/commits"
        case .gitUsersList:
            return "/users"
        case .gitPublicRepositories:
            return "/search/repositories"
        case .gitSearchIssues:
            return "/search/issues"
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
        case .gitProjectRepo:
            return "/repos/Ali-Fayed/Githubgenics"
        }
    }
    
    var parameters: [String: String]? {
        switch self {
        case .gitAccessToken(let accessToken):
            return [
                "client_id": Constants.clientID,
                "client_secret": Constants.clientSecret,
                "code": accessToken
            ]
        case .gitSearchUsers(let page, let query):
            return ["per_page": "30" ,"sort": "repositories", "order": "desc", "page": "\(page)" , "q": query]
        case .gitSearchIssues(let page, let query):
            return ["per_page": "30" ,"sort": "reactions", "order": "desc", "page": "\(page)" , "q": query]
        case .gitSearchCommits(let page, let query):
            return ["per_page": "30" ,"sort": "author-date", "order": "desc", "page": "\(page)" , "q": query]
        case .gitUsersList(let page):
            return ["page": "\(page)"]
        case .gitPublicRepositories(let page, let query):
            return ["per_page": "30", "sort": "stars", "order": "desc", "page": "\(page)" , "q": query]
        case .gitListOrgs(let perPage, let since):
            return ["per_page": "\(perPage)", "since": "\(since)"]
        case .gitAuthenticatedUser, .gitPublicUserInfo, .gitProjectRepo, .gitPublicUsersOrgs:
            return nil
        case .gitAuthenticatedUserStarred, .gitAuthenticatedUserOrgs, .gitAuthenticatedUserRepositories, .gitPublicUserFollowers, .gitPublicUserFollowing:
            return ["per_page": "30"]
        case.gitPublicUsersRepositories(let page, _), .gitPublicUsersStarred(let page,_), .gitRepositoriesCommits(let page,_):
            return ["per_page": "30" , "page": "\(page)"]
        }
    }
}

// MARK: - URLRequestConvertible

extension GitRequestRouter: URLRequestConvertible {
    func asURLRequest() throws -> URLRequest {
        let requestURL = try baseURL.asURL().appendingPathComponent(path)
        var request = URLRequest(url: requestURL)
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
