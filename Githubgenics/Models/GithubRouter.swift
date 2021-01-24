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
    
    func searchRepositories(query: String, completion: @escaping ([Repository]) -> Void) {
      let url = "https://api.github.com/search/repositories"
      var queryParameters: [String: Any] = ["sort": "stars", "order": "desc", "page": 1]
      queryParameters["q"] = query
      AF.request(url, parameters: queryParameters)
        .responseDecodable(of: Repositories.self) { response in
          guard let items = response.value else {
            return completion([])
          }
          completion(items.items)
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
    
    func fetchPopularSwiftRepositories(completion: @escaping ([Repository]) -> Void) {
      searchRepositories(query: "language:Swift", completion: completion)
    }
    
    private var Users : [UsersStruct] = []
    var isPaginating = false

     func MainFetchFunctions(pagination: Bool = false, since : Int , page : Int , complete: @escaping (Result<[UsersStruct], Error>) -> Void ) {

        if pagination {
            isPaginating = true
        }
        DispatchQueue.global().asyncAfter(deadline: .now() + (pagination ? 3 : 2)) {
         let url = "https://api.github.com/users?since=\(since)&per_page=\(page)"

         AF.request(url , method: .get).responseJSON { (response) in
                do {
                    let users = try JSONDecoder().decode([UsersStruct].self, from: response.data!)
                    self.Users = users

                 print("Main Fetch")
                } catch {
                    let error = error
                    print(error.localizedDescription)
                }
            }
            complete(.success( pagination ? self.Users : self.Users ))

            if pagination {
                self.isPaginating = false
            }
        }
    }
    
    
    
}
