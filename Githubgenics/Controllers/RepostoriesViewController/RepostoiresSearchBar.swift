//
//  exSearchBar.swift
//  Githubgenics
//
//  Created by Ali Fayed on 30/01/2021.
//

import UIKit

// MARK: - UISearchBarDelegate
extension RepositoriesViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard let query = searchBar.text else {
            return
        }
        GitAPIManager.shared.searchRepositories(query: query) { [self] repositories in
            self.repositories = repositories
            loadingIndicator.stopAnimating()
            tableView.reloadData()
        }
        repositories.removeAll()
        searchBar.showsCancelButton = true
    }
    
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = nil
        DispatchQueue.main.async {
            self.tabBarController?.navigationItem.titleView = nil
            self.tabBarController?.navigationItem.title = "Repositories".localized()
//            self.searchBar.resignFirstResponder()
            self.listSearchBar.resignFirstResponder()
            self.tableView.tableHeaderView = self.listSearchBar2
            self.tabBarController?.tabBar.isHidden = false

        }
    
        fetchAndDisplayUserRepositories()
        
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        DispatchQueue.main.async {
            self.tabBarController?.navigationItem.titleView = self.listSearchBar
            self.tableView.tableHeaderView = nil
            self.listSearchBar.showsCancelButton = true
            self.tabBarController?.tabBar.isHidden = true
            self.listSearchBar.becomeFirstResponder()
        }
    }
    
}
