//
//  BookmarksSearchBar.swift
//  Githubgenics
//
//  Created by Ali Fayed on 30/01/2021.
//

import UIKit
import CoreData


extension SavedUsersController : UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == "" {
            searchBar.becomeFirstResponder()
        }
        
        guard let searchText = searchBar.text else { return }
        if searchText.isEmpty {
            Fetch().users { (result) in
                self.bookmarkedUsers = result
            }
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        } else {
            let request : NSFetchRequest<UsersDataBase> = UsersDataBase.fetchRequest()
            request.predicate = NSPredicate(format: "login CONTAINS [cd] %@", searchText)
            request.sortDescriptors = [NSSortDescriptor(key: "login", ascending: true)]
            do {
                bookmarkedUsers = try context.fetch(request)
            } catch {
                print(error)
            }
            tableView.reloadData()
        }
        
        
    }
}
