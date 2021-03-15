//
//  BVC SearchBar.swift
//  Githubgenics
//
//  Created by Ali Fayed on 30/01/2021.
//

import UIKit

extension BookmarksViewController : UISearchBarDelegate {
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        
        DispatchQueue.main.async {
            self.navigationItem.titleView = self.searchRepositoriesBar
            self.tableView.tableHeaderView = nil
            self.searchRepositoriesBar.showsCancelButton = true
            self.searchRepositoriesBar.becomeFirstResponder()
            self.searchLabel.isHidden = false
            self.navigationItem.largeTitleDisplayMode = .never
            self.navigationController?.navigationBar.prefersLargeTitles = false
        }
        
        UIView.animate(withDuration: 0.5, animations: {
            self.searchLabel.alpha = 1.0
            self.tableView.alpha = 0.0
        })
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        self.searchLabel.isHidden = true
        searchFromDB ()
        UIView.animate(withDuration: 0.5, animations: {
            self.tableView.alpha = 1.0
            self.searchLabel.alpha = 0.0
        })
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
        renderViewData ()
        DispatchQueue.main.async {
            self.navigationItem.titleView = nil
            self.title = Titles.bookmarksViewTitle
            self.tableView.tableHeaderView = self.searchBarHeader
            self.searchRepositoriesBar.text = nil
            self.searchLabel.isHidden = true
            self.navigationItem.largeTitleDisplayMode = .always
            self.navigationController?.navigationBar.prefersLargeTitles = true
        }
        UIView.animate(withDuration: 0.5, animations: {
            self.tableView.alpha = 1.0
            self.searchLabel.alpha = 0.0
        })
    }
}
