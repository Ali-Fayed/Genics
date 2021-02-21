//
//  GitUsersRouter.swift
//  Githubgenics
//
//  Created by Ali Fayed on 18/01/2021.
//

import Alamofire

class GitAPIManger {
    
    var isPaginating = false
    
    //MARK:- Any API Call in App
    
    func APIcall<T: Decodable>(returnType: T.Type, requestData: GitRouter, pagination pagi: Bool = false, completion: @escaping ([T]) -> Void) {
        if pagi {
            isPaginating = true
        }
        DispatchQueue.global(qos: .background).async {
        session.request(requestData)
            .responseDecodable(of: [T].self) { response in
                guard let results = response.value else {
                    return
                }
                completion(results)
                if pagi {
                    self.isPaginating = false
                }
            }
        }
    }
    
    //MARK:- Search For users or repository
    
    func fetchUsers(query: String, page: Int, pagination: Bool = false, completion: @escaping ([items]) -> Void ) {
        if pagination {
            isPaginating = true
        }
        DispatchQueue.global(qos: .background).asyncAfter(deadline: .now() + (pagination ? 2 : 0)) {
            session.request(GitRouter.fetchUsers(page, query))
                .responseDecodable(of: SearchedUsers.self) { response in
                    guard let users = response.value?.items else {
                        return
                    }
                    completion(users)
                    if pagination {
                        self.isPaginating = false
                    }
                }
        }
    }
   

    func searchPublicRepositories(query: String, completion: @escaping ([Repository]) -> Void) {
        DispatchQueue.global(qos: .background).async {
            session.request(GitRouter.searchPublicRepositories(query))
                .responseDecodable(of: Repositories.self) { response in
                    guard let repositories = response.value?.items else {
                        return
                    }
                    completion(repositories)
                }
        }
    }

        
    func fetchPopularSwiftRepositories(completion: @escaping ([Repository]) -> Void) {
        searchPublicRepositories(query: "language:Swift", completion: completion)
    }

}
