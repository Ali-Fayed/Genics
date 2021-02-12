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
            self.searchBar.showsCancelButton = true
        }
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == "" {
            searchBar.becomeFirstResponder()
        }
        searchFromDB ()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.searchBar.resignFirstResponder()
        self.searchBar.text = nil
        renderDB ()
        DispatchQueue.main.async {
            self.tableView.reloadData()
            self.searchBar.showsCancelButton = false
        }
    }
}
