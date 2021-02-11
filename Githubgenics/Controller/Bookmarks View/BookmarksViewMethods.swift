//
//  BookmarksViewMethods.swift
//  Githubgenics
//
//  Created by Ali Fayed on 11/02/2021.
//

import CoreData

extension BookmarksViewController {
    
    func renderDB () {
        Fetch().users { (result) in
            self.bookmarkedUsers = result
            self.tableView.reloadData()
        }
        Fetch().repository { (result) in
            self.savedRepositories = result
            self.tableView.reloadData()
        }
    }
    
    func searchFromDB () {
        guard let searchText = searchBar.text else { return }
        if searchText.isEmpty {
            Fetch().users { (result) in
                self.bookmarkedUsers = result
            }
            Fetch().repository { (result) in
                self.savedRepositories = result
            }
            DispatchQueue.main.async {
                self.tableView.reloadData()
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
