//
//  j.swift
//  Githubgenics
//
//  Created by Ali Fayed on 30/01/2021.
//

import Alamofire

class RepostoriesRouter {
    let sessionManager: Session = {
      let configuration = URLSessionConfiguration.af.default
      configuration.requestCachePolicy = .returnCacheDataElseLoad
      let responseCacher = ResponseCacher(behavior: .modify { _, response in
        let userInfo = ["date": Date()]
        return CachedURLResponse(
          response: response.response,
          data: response.data,
          userInfo: userInfo,
          storagePolicy: .allowed)
      })

      let networkLogger = GitNetworkLogger()
      let interceptor = GitRequestInterceptor()

      return Session(
        configuration: configuration,
        interceptor: interceptor,
        cachedResponseHandler: responseCacher,
        eventMonitors: [networkLogger])
    }()
    func fetchClickedRepositories(for repository: String ,Page: Int = 30, completion: @escaping (Result<[UserRepository],Error>) -> Void) {
        let url = "https://api.github.com/users/\(repository)/repos?per_page=\(Page)"
            self.sessionManager.request(url).responseDecodable(of: [UserRepository].self) { response in
                guard let items = response.value else {
                    return 
                }
                completion(.success(items))
            }
        
    }
    
    func searchRepositories(query: String, completion: @escaping ([Repository]) -> Void) {
      sessionManager.request(GitRouter.searchRepositories(query))
        .responseDecodable(of: Repositories.self) { response in
          guard let repositories = response.value else {
            return completion([])
          }
          completion(repositories.items)
        }
    }
    
    func fetchCommits(for repository: String, completion: @escaping ([Commit]) -> Void) {
      let url = "https://api.github.com/repos/\(repository)/commits"
        sessionManager.request(url)
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
    
}


