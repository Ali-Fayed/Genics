//
//  RepositoriesViewMethods.swift
//  Githubgenics
//
//  Created by Ali Fayed on 11/02/2021.
//

import UIKit

extension RepositoriesViewController {
    
    //MARK:- Fetch Methods
    
    func searchRepositories (query: String) {
        GitReposRouter().searchPublicRepositories(query: query) { [self] repositories in
            self.repositories = repositories
            loadingIndicator.stopAnimating()
            tableView.reloadData()
        }
    }
    
    //MARK:- UI Methods
    
    func renderAndDisplayUserRepositories() {
      loadingIndicator.startAnimating()
        GitUsersRouter().fetchAuthorizedUserRepositories { [self] repositories in
        self.repositories = repositories
        loadingIndicator.stopAnimating()
        tableView.reloadData()
      }
    }
    
    func renderSearchBar() {
        listSearchBar.searchBarStyle = UISearchBar.Style.prominent
        listSearchBar.placeholder = "Search Repositories ..."
        listSearchBar.sizeToFit()
        listSearchBar.isTranslucent = false
        listSearchBar.delegate = self
        listSearchBar2.searchBarStyle = UISearchBar.Style.prominent
        listSearchBar2.placeholder = "Search Repositories ..."
        listSearchBar2.sizeToFit()
        listSearchBar2.isTranslucent = false
        listSearchBar2.delegate = self
    }
    // MARK: - Handling Segue
        
        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if segue.identifier == "CommitSegue" {
                guard let commitsViewController = segue.destination as? CommitsViewController else {
                    return
                }
                commitsViewController.repository = selectedRepository
            }
        }
}
