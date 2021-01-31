//
//  SearchBar.swift
//  Githubgenics
//
//  Created by Ali Fayed on 30/01/2021.
//

import Foundation
import UIKit

extension SearchViewController  : UISearchBarDelegate  {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard let query = searchBar.text else {
            return
        }
        self.loadingIndicator.startAnimating()
        UsersRouter().searchUsers(query: query) { (response) in
            self.searchedUsers = response
            self.loadingIndicator.stopAnimating()
            self.tableView.reloadData()
        }
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        DispatchQueue.main.async {
            self.SearchHistoryView.isHidden = true
            self.tableView.isHidden = false
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
        searchBar.text = ""
        self.searchedUsers.removeAll()
        self.tableView.reloadData()
        DispatchQueue.main.async {
            self.SearchHistoryView.isHidden = false
            self.tableView.isHidden = true
            self.Searchbaar.resignFirstResponder()
            self.loadingIndicator.stopAnimating()
        }
        let tv : RecentSearchViewController = self.children[0] as! RecentSearchViewController
        tv.tableView.reloadData()
        tv.viewDidAppear(true)
    }
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text, !text.isEmpty else { return }
        Save().searchKeywords(keyword: text)
    }
    
}
