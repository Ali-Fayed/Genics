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
            self.searchBar.becomeFirstResponder()
            self.searchLabel.isHidden = false
        }
        UIView.animate(withDuration: 0.0, animations: {
            self.searchLabel.alpha = 1.0
            self.tableView.alpha = 0.0
        })
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.searchLabel.isHidden = true
        searchFromDB ()
        UIView.animate(withDuration: 0.0, animations: {
            self.tableView.alpha = 1.0
            self.searchLabel.alpha = 0.0
        })
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        renderViewData ()
        DispatchQueue.main.async {
            self.searchBar.text = nil
            self.searchLabel.isHidden = true
        }
        UIView.animate(withDuration: 0.0, animations: {
            self.tableView.alpha = 1.0
            self.searchLabel.alpha = 0.0
        })
    }
}
