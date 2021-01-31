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
    
    func listUsers(completion: @escaping ([Users]) -> Void) {
        let url = "https://api.github.com/users"
        DispatchQueue.global(qos: .background).async {
            AF.request(url).responseDecodable(of: [Users].self) { response in
                guard let items = response.value else {
                    return AlertsModel.shared.showUsersListErrorAlert()
                }
                completion(items)
            }
        }
    }
    
    func searchUsers(query: String, completion: @escaping ([items]) -> Void) {
        let url = "https://api.github.com/search/users"
        var queryParameters: [String: Any] = ["sort": "repositories", "order": "desc", "page": 1]
        queryParameters["q"] = query
        DispatchQueue.global(qos: .background).async {
            AF.request(url, parameters: queryParameters)
                .responseDecodable(of: SearchedUsers.self) { response in
                    guard let items = response.value else {
                        return
                    }
                    completion(items.items)
                }
        }
    }
    
    func fetchUserstoAvoidIndexError(completion: @escaping ([items]) -> Void) {
        searchUsers(query: "a", completion: completion)
    }
    
}

extension UsersListViewController {
    
    
     func MainFetchFunctions(pagination: Bool = false, since : Int , page : Int , complete: @escaping (Result<[Users],Error>) -> Void ) {
         if pagination {
             isPaginating = true
         }
         DispatchQueue.global(qos: .userInteractive).asyncAfter(deadline: .now() + (pagination ? 3 : 2)) {
          let url = "https://api.github.com/users?since=\(since)&per_page=\(page)"
             AF.request(url).responseDecodable(of: [Users].self) { response in
                 guard let users = response.value else {
                   return
                 }
                 complete(.success(users))
                 complete(.success( pagination ? self.moreUsers : self.users ))
             if pagination {
                 self.isPaginating = false
             }
         }
     }
         
    }
     
     func FetchMoreUsers () {
         guard !isPaginating else {
             return
         }
          MainFetchFunctions(pagination: true, since: Int.random(in: 40 ... 5000 ), page: 10 ) { [weak self] result in
             DispatchQueue.main.async {
                 self?.tableView.tableFooterView = nil
             }
             switch result {
             case .success(let moreUsers):
                 self?.users.append(contentsOf: moreUsers)
                 DispatchQueue.main.async {
                     self?.tableView.reloadData()
                 }
             case .failure(_):
                 AlertsModel.shared.showPaginationErrorAlert()
             break
             }
         }
     }
}
