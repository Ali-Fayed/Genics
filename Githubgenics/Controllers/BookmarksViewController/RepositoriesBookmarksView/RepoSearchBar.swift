//
//  daaa.swift
//  Githubgenics
//
//  Created by Ali Fayed on 30/01/2021.
//

import UIKit
import CoreData


extension ReposBookmarksController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == "" {
            searchBar.becomeFirstResponder()
        }
        guard let searchText = searchBar.text else { return }
        if searchText.isEmpty {
            Fetch().repository { (result) in
                self.savedRepositories = result
            }
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        } else {
            let request : NSFetchRequest<SavedRepositories> = SavedRepositories.fetchRequest()
            request.predicate = NSPredicate(format: "name CONTAINS [cd] %@", searchText)
            request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
            do {
                savedRepositories = try context.fetch(request)
            } catch {
                print(error)
            }
            tableView.reloadData()
        }
    }
    
}
