//
//  RVC SearchBar.swift
//  Githubgenics
//
//  Created by Ali Fayed on 30/01/2021.
//

import UIKit

extension RepositoriesViewController: UISearchBarDelegate {
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        
        UIView.animate(withDuration: 0.0, animations: {
            self.tableView.alpha = 0.0
            self.searchLabel.alpha = 1.0
        })
        
        DispatchQueue.main.async {
            self.reposSearchBar.text = nil
            self.searchLabel.isHidden = false
            self.reposSearchBar.becomeFirstResponder()
            self.pageNo = 1
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        guard let query = searchBar.text else {
            return
        }
        searchRepositories(query: query, page: pageNo)
        
        UIView.animate(withDuration: 0.5, animations: {
            self.tableView.alpha = 1.0
            self.searchLabel.isHidden = true
            if searchBar.text?.isEmpty == true {
                self.tableView.alpha = 0.0
                self.spinner.dismiss()
            }
        })
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
        UIView.animate(withDuration: 0.0, animations: {
            self.tableView.alpha = 1.0
            self.searchLabel.alpha = 0.0
        })
        
        DispatchQueue.main.async {
            self.reposSearchBar.resignFirstResponder()
            self.reposSearchBar.text = nil
            self.searchLabel.isHidden = true

        }
        renderAndDisplayBestSwiftRepositories()
    }
    
}
