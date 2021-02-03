//
//  j.swift
//  Githubgenics
//
//  Created by Ali Fayed on 30/01/2021.
//

import Alamofire

class RepostoriesRouter {
    
    func fetchClickedRepositories(for repository: String ,Page: Int = 30, completion: @escaping (Result<[UserRepository],Error>) -> Void) {
        let url = "https://api.github.com/users/\(repository)/repos?per_page=\(Page)"
        DispatchQueue.global(qos: .background).async {
            AF.request(url).responseDecodable(of: [UserRepository].self) { response in
                guard let items = response.value else {
                    return 
                }
                completion(.success(items))
            }
        }
    }
    
    func searchRepositories(query: String, completion: @escaping (Result<[Repository],Error>) -> Void) {
        let url = "https://api.github.com/search/repositories"
        var queryParameters: [String: Any] = ["sort": "stars", "order": "desc", "page": 1]
        queryParameters["q"] = query
        DispatchQueue.global(qos: .background).async {
            AF.request(url, parameters: queryParameters).responseDecodable(of: Repositories.self) { response in
                guard let items = response.value else {
                    return
                }
                completion(.success(items.items))
            }
        }
    }
    
    func fetchCommits(for repository: String, completion: @escaping ([Commit]) -> Void) {
      let url = "https://api.github.com/repos/\(repository)/commits"
      AF.request(url)
        .responseDecodable(of: [Commit].self) { response in
          guard let commits = response.value else {
            return
          }
          completion(commits)
        }
    }
    
    func fetchPopularSwiftRepositories(completion: @escaping (Result<[Repository],Error>) -> Void) {
        searchRepositories(query: "language:Swift", completion: completion)
    }
    
}


