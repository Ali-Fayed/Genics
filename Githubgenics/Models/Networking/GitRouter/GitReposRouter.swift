//
//  GitReposRouter.swift
//  Githubgenics
//
//  Created by Ali Fayed on 18/01/2021.
//

import Alamofire

class GitReposRouter {
    
    var isPaginating = false
    
    func fetchUsersRepositories(for repository: String , completion: @escaping ([UserRepository]) -> Void) {
        DispatchQueue.global(qos: .background).async {
            session.request(GitRouter.fetchUsersRepositories(repository))
                .responseDecodable(of: [UserRepository].self) { response in
                    guard let repository = response.value else {
                        return
                    }
                    completion(repository)
                }
        }
    }
    
    func searchPublicRepositories(query: String, completion: @escaping ([Repository]) -> Void) {
        DispatchQueue.global(qos: .background).async {
            session.request(GitRouter.searchPublicRepositories(query))
                .responseDecodable(of: Repositories.self) { response in
                    guard let repositories = response.value else {
                        return completion([])
                    }
                    completion(repositories.items)
                }
        }
    }
    
    func fetchCommits(for repository: String, completion: @escaping ([Commit]) -> Void) {
        DispatchQueue.global(qos: .background).async {
            session.request(GitRouter.fetchCommits(repository))
                .responseDecodable(of: [Commit].self) { response in
                    guard let commits = response.value else {
                        return
                    }
                    completion(commits)
                }
        }
    }
    
    func fetchPopularSwiftRepositories(completion: @escaping ([Repository]) -> Void) {
        searchPublicRepositories(query: "language:Swift", completion: completion)
    }
}
