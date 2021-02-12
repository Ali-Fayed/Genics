//
//  Delete.swift
//  Githubgenics
//
//  Created by Ali Fayed on 31/01/2021.
//

import UIKit

class Delete: Fetch {
    
    func user(item: UsersDataBase , completion: @escaping ([UsersDataBase]) -> Void) {
        context.delete(item)
        do {
            try context.save()
            Fetch().users { (result) in
                self.usersDataBase = result
            }
            completion(usersDataBase)
        } catch {
            Alerts.shared.showErrorAlert()
        }
    }
    
    func searchHistory (item: SearchHistory , completion: @escaping ([SearchHistory]) -> Void) {
        context.delete(item)
        do {
            try context.save()
            Fetch().searchHistory { (result) in
                self.searchHistory = result
            }
            completion(searchHistory)
        } catch {
            Alerts.shared.showErrorAlert()
        }
    }
    
    func repository(item: SavedRepositories , completion: @escaping ([SavedRepositories]) -> Void) {
        context.delete(item)
        do {
            try context.save()
            Fetch().repository { (result) in
                self.savedRepositories = result
            }
            completion(savedRepositories)
        } catch {
            Alerts.shared.showErrorAlert()
        }
    }
    
    func lastSearch(item: LastSearch , completion: @escaping ([LastSearch]) -> Void) {
        context.delete(item)
        do {
            try context.save()
            Fetch().lastSearch { (result) in
                self.lastSearch = result
            }
            completion(lastSearch)
        } catch {
            Alerts.shared.showErrorAlert()
        }
    }
}
