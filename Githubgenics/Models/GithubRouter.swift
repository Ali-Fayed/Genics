//
//  GithubRouter.swift
//  Githubgenics
//
//  Created by Ali Fayed on 24/01/2021.
//

import UIKit
import Alamofire

class GithubRouter {
    
    static let shared = GithubRouter()
    
    func listUsers(completion: @escaping ([UsersStruct]) -> Void) {
        let url = "https://api.github.com/users"
        AF.request(url).responseDecodable(of: [UsersStruct].self) { response in
            guard let items = response.value else {
                return Alerts.shared.showUsersListErrorAlert()
            }
            completion(items)
          }
        }

    func fetchClickedRepositories(for repository: String ,Page: Int = 30, completion: @escaping ([repositoriesParameters]) -> Void) {
        let url = "https://api.github.com/users/\(repository)/repos?per_page=\(Page)"
      AF.request(url).responseDecodable(of: [repositoriesParameters].self) { response in
          guard let items = response.value else {
            return Alerts.shared.showUserRepositoryFetchErrorAlert()
          }
          completion(items)
        }
    }
    
    func searchUsers(query: String, completion: @escaping ([items]) -> Void) {
      let url = "https://api.github.com/search/users"
      var queryParameters: [String: Any] = ["sort": "repositories", "order": "desc", "page": 1]
      queryParameters["q"] = query
      AF.request(url, parameters: queryParameters)
        .responseDecodable(of: UsersQResults.self) { response in
          guard let items = response.value else {
            return Alerts.shared.showSearchUsersErrorAlert()
            
          }
          completion(items.items)
        }
    }
    
    func searchRepositories(query: String, completion: @escaping ([Repository]) -> Void) {
      let url = "https://api.github.com/search/repositories"
      var queryParameters: [String: Any] = ["sort": "stars", "order": "desc", "page": 1]
      queryParameters["q"] = query
      AF.request(url, parameters: queryParameters).responseDecodable(of: Repositories.self) { response in
          guard let items = response.value else {
            return Alerts.shared.showSearchRepositoriesErrorAlert()
          }
          completion(items.items)
        }
    }
    
    func fetchPopularSwiftRepositories(completion: @escaping ([Repository]) -> Void) {
      searchRepositories(query: "language:Swift", completion: completion)
    }
    
    func fetchUserstoAvoidIndexError(completion: @escaping ([items]) -> Void) {
        searchUsers(query: "language:Swift", completion: completion)
    }
    
    func fetchCommits(for repository: String, completion: @escaping ([Commit]) -> Void) {
      let url = "https://api.github.com/repos/\(repository)/commits"
      AF.request(url).responseDecodable(of: [Commit].self) { response in
          guard let commits = response.value else {
            return Alerts.shared.showSearchUsersErrorAlert()
          }
          completion(commits)
        }
      }
    
    
}
