/// Copyright (c) 2020 Razeware LLC
/// 
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
/// 
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
/// 
/// Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
/// distribute, sublicense, create a derivative work, and/or sell copies of the
/// Software in any work that is designed, intended, or marketed for pedagogical or
/// instructional purposes related to programming, coding, application development,
/// or information technology.  Permission for such use, copying, modification,
/// merger, publication, distribution, sublicensing, creation of derivative works,
/// or sale is expressly withheld.
/// 
/// This project and source code may use libraries or frameworks that are
/// released under various Open-Source licenses. Use of those libraries and
/// frameworks are governed by their own individual licenses.
///
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.

import Foundation
import Alamofire

class GitAPIManager {
    
  static let shared = GitAPIManager()
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
    

  func fetchPopularSwiftRepositories(completion: @escaping ([Repository]) -> Void) {
    searchRepositories(query: "language:Swift", completion: completion)
  }

  func fetchCommits(for repository: String, completion: @escaping ([Commit]) -> Void) {
    sessionManager.request(GitRouter.fetchCommits(repository))
      .responseDecodable(of: [Commit].self) { response in
        guard let commits = response.value else {
          return
        }
        completion(commits)
      }
  }
    


  func searchRepositories(query: String, completion: @escaping ([Repository]) -> Void) {
    self.sessionManager.request(GitRouter.searchRepositories(query))
      .responseDecodable(of: Repositories.self) { response in
        guard let repositories = response.value else {
          return completion([])
        }
        completion(repositories.items)
      }
  }


  func fetchAccessToken(accessCode: String, completion: @escaping (Bool) -> Void) {
    self.sessionManager.request(GitRouter.fetchAccessToken(accessCode))
      .responseDecodable(of: GitHubAccessToken.self) { response in
        guard let token = response.value else {
          return completion(false)
        }
        TokenManager.shared.saveAccessToken(gitToken: token)
        completion(true)
      }
  }
    


  func fetchUserRepositories(completion: @escaping ([Repository]) -> Void) {
    self.sessionManager.request(GitRouter.fetchUserRepositories)
      .responseDecodable(of: [Repository].self) { response in
        guard let repositories = response.value else {
          return completion([])
        }
        completion(repositories)
      }
  }
    
    func fetchUsers(query: String,page: Int , pagination: Bool = false, completion: @escaping (Result<[items],Error>) -> Void ) {
        if pagination {
            isPaginating = true
        }
        DispatchQueue.global(qos: .userInteractive).asyncAfter(deadline: .now() + (pagination ? 2 : 0)) {
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
    func fetchClickedRepositories(for repository: String , completion: @escaping (Result<[UserRepository],Error>) -> Void) {
        sessionManager.request(GitRouter.fetchClickedRepositories(repository))
            .responseDecodable(of: [UserRepository].self) { response in
                guard let repository = response.value else {
                    return
                }
                completion(.success(repository))
            }
    }
    
}
