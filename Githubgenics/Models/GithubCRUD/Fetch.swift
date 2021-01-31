//
//  CoreData.swift
//  Githubgenics
//
//  Created by Ali Fayed on 30/01/2021.
//
import UIKit

class Fetch {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var usersDataBase = [UsersDataBase]()
    var savedRepositories = [SavedRepositories]()
    var lastSearch = [LastSearch]()
    var searchHistory = [SearchHistory]()
    
    func users(completion: @escaping ([UsersDataBase]) -> Void) {
        do {
            usersDataBase = try context.fetch(UsersDataBase.fetchRequest())
            completion(usersDataBase)
        } catch {
            //error
        }
    }
    
    func repository(completion: @escaping ([SavedRepositories]) -> Void) {
        do {
            savedRepositories = try context.fetch(SavedRepositories.fetchRequest())
            completion(savedRepositories)
        } catch {
            //error
        }
    }
    
    func lastSearch(completion: @escaping ([LastSearch]) -> Void) {
        do {
            lastSearch = try context.fetch(LastSearch.fetchRequest())
            completion(lastSearch)
        } catch {
            //error
        }
    }
    
    func searchHistory(completion: @escaping ([SearchHistory]) -> Void) {
        do {
            searchHistory = try context.fetch(SearchHistory.fetchRequest())
            completion(searchHistory)
        } catch {
            //error
        }
    }

}
