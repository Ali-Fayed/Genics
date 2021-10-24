//
//  UsersUseCase.swift
//  Githubgenics
//
//  Created by Ali Fayed on 19/10/2021.
//

import UIKit
import CoreData

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
    func fetchLastSearch(completion: @escaping ([LastSearch]) -> Void) {
        DataBaseManger.shared.fetch(returnType: LastSearch.self) { result in
            completion(result)
        }
    }
    func fetchSearchHistory(completion: @escaping ([SearchHistory]) -> Void) {
        DataBaseManger.shared.fetch(returnType: SearchHistory.self) { result in
            completion(result)
        }
    }
    func saveSearchHistory(context: NSManagedObjectContext, text: String) {
        let history = SearchHistory(context: context)
        history.keyword = text
        do {
            try context.save()
        } catch {
            //
        }
    }
    func saveToLastSearch(context: NSManagedObjectContext, model: User) {
        let items = LastSearch(context: context)
        items.userName = model.userName
        items.userAvatar = model.userAvatar
        items.userURL = model.userURL
        do {
            try context.save()
        } catch {
            //
        }
    }
    func saveUserToBookmarks(context: NSManagedObjectContext, model: User) {
        let items = UsersDataBase(context: context)
        items.userName = model.userName
        items.userAvatar = model.userAvatar
        items.userURL = model.userURL
        do {
            try context.save()
        } catch {
            //
        }
    }
    func excuteDataBase(context: NSManagedObjectContext, completion: @escaping () -> Void) {
        let resetSearchHistory = NSFetchRequest<NSFetchRequestResult>(entityName: Entities.searchHistoryEntity)
        let resetLastSearch = NSFetchRequest<NSFetchRequestResult>(entityName: Entities.lastSearchEntity)
        let resetHistory = NSBatchDeleteRequest(fetchRequest: resetSearchHistory)
        let resetLast = NSBatchDeleteRequest(fetchRequest: resetLastSearch)
        do {
            try context.execute(resetHistory)
            try context.execute(resetLast)
            try context.save()
            DispatchQueue.main.async {
                completion()
            }
        } catch {
            //
        }
    }
    
}
