//
//  RepostoiresSearchBar.swift
//  Githubgenics
//
//  Created by Ali Fayed on 30/01/2021.
//

import UIKit

extension RepositoriesViewController: UISearchBarDelegate {
    
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        UIView.animate(withDuration: 0.5, animations: {
            self.tableView.alpha = 0.0
            self.searchLabel.alpha = 1.0
            self.searchLabel.isHidden = false
        })
        DispatchQueue.main.async {
            self.tabBarController?.navigationItem.titleView = self.reposSearchBar
            self.reposSearchBar.text = nil
            self.tableView.tableHeaderView = nil
            self.reposSearchBar.showsCancelButton = true
            self.tabBarController?.tabBar.isHidden = true
            self.reposSearchBar.becomeFirstResponder()
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard let query = searchBar.text else {
            return
        }
        searchRepositories(query: query)
        publicRepositories.removeAll()
        searchBar.showsCancelButton = true
        UIView.animate(withDuration: 0.5, animations: {
            self.tableView.alpha = 1.0
            self.searchLabel.isHidden = true
            if searchBar.text?.isEmpty == true {
                self.tableView.alpha = 0.0
            }
        })
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        UIView.animate(withDuration: 0.5, animations: {
            self.tableView.alpha = 1.0
            self.searchLabel.alpha = 0.0
            self.searchLabel.isHidden = true
        })
        DispatchQueue.main.async {
            self.tabBarController?.navigationItem.titleView = nil
            self.tabBarController?.navigationItem.title = Titles.RepositoriesViewTitle
            self.reposSearchBar.resignFirstResponder()
            self.tableView.tableHeaderView = self.repoSearchBarHeader
            self.repoSearchBarHeader.text = nil
            self.tabBarController?.tabBar.isHidden = false
        }
        renderAndDisplayBestSwiftRepositories()
    }
    
}
