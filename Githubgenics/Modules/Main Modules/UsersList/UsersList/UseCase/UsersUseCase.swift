//
//  UsersUseCase.swift
//  Githubgenics
//
//  Created by Ali Fayed on 19/10/2021.
//

import UIKit
import JGProgressHUD

class UserUseCase {
    func fetchUsersList(page: Int, query : String, completion: @escaping (Result<[User], Error>) -> Void) {
        let data = GitRequestRouter.gitSearchUsers(page, query)
        NetworkingManger.shared.performRequest(dataModel: Users.self, requestData: data) { (result) in
            switch result {
            case .success(let result):
                completion(.success(result.items))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
