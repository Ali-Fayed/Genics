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
            if self.searchController.searchBar.text?.isEmpty == true {
                self.tableView.alpha = 0.0
                self.noContentLabel.alpha = 1.0
            } else {
                self.tableView.alpha = 1.0
                self.noContentLabel.alpha = 0.0
            }
        })
        DispatchQueue.main.async {
            self.reposSearchBar.text = nil
            self.noContentLabel.isHidden = false
            self.pageNo = 1
            self.tableView.isHidden = false
        }
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        guard let query = searchBar.text else {
            return
        }
        DispatchQueue.main.async {
            self.tableView.reloadData()
            self.searchRepositories(query: query, page: self.pageNo)
            self.tableView.isHidden = false

        }
        UIView.animate(withDuration: 0.5, animations: {
            self.tableView.alpha = 1.0
            self.noContentLabel.isHidden = true
            if searchBar.text?.isEmpty == true {
                self.tableView.alpha = 0.0
                self.spinner.dismiss()
            }
        })
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
        UIView.animate(withDuration: 0.0, animations: {
            self.tableView.alpha = 1.0
            self.noContentLabel.alpha = 0.0
        })
        
        DispatchQueue.main.async {
            self.reposSearchBar.resignFirstResponder()
            self.reposSearchBar.text = nil
            self.noContentLabel.isHidden = true
            self.tableView.isHidden = false

        }
        renderAndDisplayBestSwiftRepositories()
    }
    
    func didPresentSearchController(searchController: UISearchController) {
        DispatchQueue.main.async {
            self.searchController.searchBar.becomeFirstResponder()

        }
    }
    
}
