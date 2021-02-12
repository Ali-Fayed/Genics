//
//  RepostoiresSearchBar.swift
//  Githubgenics
//
//  Created by Ali Fayed on 30/01/2021.
//

import UIKit

extension RepositoriesViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard let query = searchBar.text else {
            return
        }
        searchRepositories(query: query)
        repositories.removeAll()
        searchBar.showsCancelButton = true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = nil
        DispatchQueue.main.async {
            self.tabBarController?.navigationItem.titleView = nil
            self.tabBarController?.navigationItem.title = Titles.RepositoriesViewTitle
            self.listSearchBar.resignFirstResponder()
            self.tableView.tableHeaderView = self.listSearchBar2
            self.tabBarController?.tabBar.isHidden = false
        }
        renderAndDisplayUserRepositories()
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
