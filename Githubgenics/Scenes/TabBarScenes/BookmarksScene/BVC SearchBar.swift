//
//  BookmarksSearchBar.swift
//  Githubgenics
//
//  Created by Ali Fayed on 30/01/2021.
//

import UIKit

extension BookmarksViewController : UISearchBarDelegate {
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        DispatchQueue.main.async {
            self.tabBarController?.navigationItem.titleView = self.searchRepositoriesBar
            self.tableView.tableHeaderView = nil
            self.searchRepositoriesBar.showsCancelButton = true
            self.tabBarController?.tabBar.isHidden = true
            self.searchRepositoriesBar.becomeFirstResponder()
        }
        UIView.animate(withDuration: 0.5, animations: {
            self.searchLabel.isHidden = false
            self.searchLabel.alpha = 1.0
            self.tableView.alpha = 0.0
        })
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchFromDB ()
        UIView.animate(withDuration: 0.5, animations: {
            self.tableView.alpha = 1.0
            self.searchLabel.isHidden = true
            self.searchLabel.alpha = 0.0
        })
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        renderViewData ()
        DispatchQueue.main.async {
            self.tabBarController?.navigationItem.titleView = nil
            self.tabBarController?.navigationItem.title = Titles.BookmarksViewTitle
            self.searchRepositoriesBar.resignFirstResponder()
            self.tableView.tableHeaderView = self.searchBarHeader
            self.tabBarController?.tabBar.isHidden = false
            self.searchRepositoriesBar.text = nil
        }
        UIView.animate(withDuration: 0.5, animations: {
            self.tableView.alpha = 1.0
            self.searchLabel.isHidden = true
            self.searchLabel.alpha = 0.0
        })
    }
}
