////
////  GithubRouter.swift
////  Githubgenics
////
////  Created by Ali Fayed on 24/01/2021.
////
//
//

import Alamofire

class UsersRouter {
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
    
    func listUsers(query: String, completion: @escaping (Result<[items],Error>) -> Void) {
        let url = "https://api.github.com/search/users"
        var queryParameters: [String: Any] = ["sort": "repositories", "order": "desc", "page": 1]
        queryParameters["q"] = query
        DispatchQueue.global(qos: .background).async {
            AF.request(url, parameters: queryParameters)
                .responseDecodable(of: SearchedUsers.self) { response in
                    guard let items = response.value else {
                        return
                    }
                    completion(.success(items.items))
                }
        }
    }

    func searchUsers(query: String, completion: @escaping (Result<[items],Error>) -> Void) {
        let url = "https://api.github.com/search/users"
        var queryParameters: [String: Any] = ["sort": "repositories", "order": "desc", "page": 1]
        queryParameters["q"] = query
        DispatchQueue.global(qos: .background).async {
            AF.request(url, parameters: queryParameters)
                .responseDecodable(of: SearchedUsers.self) { response in
                    guard let items = response.value else {
                        return
                    }
                    completion(.success(items.items))
                }
        }
    }
    
    func fetchUserstoAvoidIndexError(completion: @escaping (Result<[items],Error>) -> Void) {
        searchUsers(query: "a", completion: completion)
    }
    func fetchAccessToken(accessCode: String, completion: @escaping (Bool) -> Void) {
        AF.request(GitRouter.fetchAccessToken(accessCode))
        .responseDecodable(of: GitHubAccessToken.self) { response in
          guard let token = response.value else {
            return completion(false)
          }
          TokenManager.shared.saveAccessToken(gitToken: token)
          completion(true)
        }
    }
}



extension UsersListViewController {
    
    
     func MainFetchFunctions(query: String, pagination: Bool = false, completion: @escaping (Result<[items],Error>) -> Void ) {
         if pagination {
             isPaginating = true
         }
         DispatchQueue.global(qos: .userInteractive).asyncAfter(deadline: .now() + (pagination ? 3 : 2)) {
            let url = "https://api.github.com/search/users"
            var queryParameters: [String: Any] = ["sort": "repositories", "order": "desc", "page": 2]
            queryParameters["q"] = query
            DispatchQueue.global(qos: .background).async {
                self.sessionManager.request(url, parameters: queryParameters)
                    .responseDecodable(of: SearchedUsers.self) { response in
                        guard let items = response.value else {
                            return
                        }
                        completion(.success(items.items))
                        completion(.success( pagination ? self.moreUsers : self.users ))
                        
             if pagination {
                 self.isPaginating = false
             }
         }
     }
         
    }
     
 
}
}

