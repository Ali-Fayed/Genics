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
    
    var isPaginating = false
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

    func fetchUsers(query: String,page: Int , pagination: Bool = false, completion: @escaping (Result<[items],Error>) -> Void ) {
        if pagination {
            isPaginating = true
        }
        DispatchQueue.global(qos: .userInteractive).asyncAfter(deadline: .now() + (pagination ? 2 : 0)) {
//           let url = "https://api.github.com/search/users"
//           var queryParameters: [String: Any] = ["sort": "repositories", "order": "desc", "page": page]
//           queryParameters["q"] = query
           DispatchQueue.global(qos: .background).async {
            self.sessionManager.request(GitRouter.fetchUsers(page, query))
                   .responseDecodable(of: SearchedUsers.self) { response in
                       guard let items = response.value else {
                           return
                       }
                       completion(.success(items.items))
            if pagination {
                self.isPaginating = false
            }
        }
    }
   }
}
    

}





