//
//  BookmarksViewModel.swift
//  Githubgenics
//
//  Created by Ali Fayed on 08/04/2021.
//

import UIKit
import CoreData

class BookmarksViewModel {
    
    // data models
    var savedRepositories = [SavedRepositories]()
    var bookmarkedUsers = [UsersDataBase]()
    var passedRepo : SavedRepositories?
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    
    var numberOfReposCells: Int {
        return savedRepositories.count
    }
    var numberOfUsersCells: Int {
        return bookmarkedUsers.count
    }

    
    func getReposViewModel( at indexPath: IndexPath ) -> SavedRepositories {
        return savedRepositories[indexPath.row]
    }
    
    func getUsersViewModel( at indexPath: IndexPath ) -> UsersDataBase {
        return bookmarkedUsers[indexPath.row]
    }
    
    // fetch
    func renderViewData (tableView: UITableView) {
        DataBaseManger.shared.Fetch(returnType: UsersDataBase.self) { [weak self] (users) in
            self?.bookmarkedUsers = users
            tableView.reloadData()
        }
        DataBaseManger.shared.Fetch(returnType: SavedRepositories.self) {  [weak self] (reps) in
            self?.savedRepositories = reps
            tableView.reloadData()
        }
    }
    
    // excute
    func searchFromDB (tableView: UITableView ,searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text else { return }
        if searchText.isEmpty {
            renderViewData(tableView: tableView)
            DispatchQueue.main.async {
                tableView.reloadData()
            }
        } else {
            let request : NSFetchRequest<UsersDataBase> = UsersDataBase.fetchRequest()
            request.predicate = NSPredicate(format: "userName CONTAINS [cd] %@", searchText)
            request.sortDescriptors = [NSSortDescriptor(key: "userName", ascending: true)]
            let request2 : NSFetchRequest<SavedRepositories> = SavedRepositories.fetchRequest()
            request2.predicate = NSPredicate(format: "repoName CONTAINS [cd] %@", searchText)
            request2.sortDescriptors = [NSSortDescriptor(key: "repoName", ascending: true)]
            do {
                bookmarkedUsers = try context.fetch(request)
                savedRepositories = try context.fetch(request2)
                
            } catch {
                print(error)
            }
            tableView.reloadData()
        }
    }
}
