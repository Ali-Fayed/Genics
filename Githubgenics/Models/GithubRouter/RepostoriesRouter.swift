//
//  j.swift
//  Githubgenics
//
//  Created by Ali Fayed on 30/01/2021.
//

import Alamofire

class RepostoriesRouter {
    
    func fetchClickedRepositories(for repository: String ,Page: Int = 30, completion: @escaping ([UserRepository]) -> Void) {
        let url = "https://api.github.com/users/\(repository)/repos?per_page=\(Page)"
        DispatchQueue.global(qos: .background).async {
            AF.request(url).responseDecodable(of: [UserRepository].self) { response in
                guard let items = response.value else {
                    return AlertsModel.shared.showUserRepositoryFetchErrorAlert()
                }
                completion(items)
            }
        }
    }
    
    func searchRepositories(query: String, completion: @escaping ([Repository]) -> Void) {
        let url = "https://api.github.com/search/repositories"
        var queryParameters: [String: Any] = ["sort": "stars", "order": "desc", "page": 1]
        queryParameters["q"] = query
        DispatchQueue.global(qos: .background).async {
            AF.request(url, parameters: queryParameters).responseDecodable(of: Repositories.self) { response in
                guard let items = response.value else {
                    return
                }
                completion(items.items)
            }
        }
    }
    
    func fetchPopularSwiftRepositories(completion: @escaping ([Repository]) -> Void) {
        searchRepositories(query: "language:Swift", completion: completion)
    }
    
}
