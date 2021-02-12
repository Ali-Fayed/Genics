//
//  GitUsersRouter.swift
//  Githubgenics
//
//  Created by Ali Fayed on 18/01/2021.
//

import Alamofire

class GitUsersRouter {
    
    var isPaginating = false
    
    func fetchUsers(query: String, page: Int, pagination: Bool = false, completion: @escaping ([items]) -> Void ) {
        if pagination {
            isPaginating = true
        }
        DispatchQueue.global(qos: .background).asyncAfter(deadline: .now() + (pagination ? 2 : 0)) {
            session.request(GitRouter.fetchUsers(page, query))
                .responseDecodable(of: SearchedUsers.self) { response in
                    guard let items = response.value else {
                        return
                    }
                    completion(items.items)
                    if pagination {
                        self.isPaginating = false
                    }
                }
        }
    }
    
    func fetchAuthorizedUserRepositories(completion: @escaping ([Repository]) -> Void) {
        DispatchQueue.global(qos: .background).async {
            session.request(GitRouter.fetchAuthorizedUserRepositories)
                .responseDecodable(of: [Repository].self) { response in
                    guard let repositories = response.value else {
                        return completion([])
                    }
                    completion(repositories)
                }
        }
    }
    
    func fetchAccessToken(accessToken: String, completion: @escaping (Bool) -> Void) {
        session.request(GitRouter.fetchAccessToken(accessToken))
            .responseDecodable(of: GitHubAccessToken.self) { response in
                guard let token = response.value else {
                    return completion(false)
                }
                TokenManager.shared.saveAccessToken(gitToken: token)
                completion(true)
            }
    }
}
