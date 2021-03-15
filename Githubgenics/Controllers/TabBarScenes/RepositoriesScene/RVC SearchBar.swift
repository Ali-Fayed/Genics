//
//  RVC SearchBar.swift
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
        })
        
        DispatchQueue.main.async {
            self.navigationItem.titleView = self.reposSearchBar
            self.reposSearchBar.text = nil
            self.tableView.tableHeaderView = nil
            self.reposSearchBar.showsCancelButton = true
            self.searchLabel.isHidden = false
            self.reposSearchBar.becomeFirstResponder()
            self.navigationItem.largeTitleDisplayMode = .never
            self.navigationController?.navigationBar.prefersLargeTitles = false
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
        
        UIView.animate(withDuration: 0.5, animations: {
            self.tableView.alpha = 1.0
            self.searchLabel.alpha = 0.0
        })
        
        DispatchQueue.main.async {
            self.navigationItem.titleView = nil
            self.title = Titles.repositoriesViewTitle
            self.navigationItem.largeTitleDisplayMode = .always
            self.navigationController?.navigationBar.prefersLargeTitles = true
            self.reposSearchBar.resignFirstResponder()
            self.tableView.tableHeaderView = self.repoSearchBarHeader
            self.repoSearchBarHeader.text = nil
            self.searchLabel.isHidden = true

        }
        renderAndDisplayBestSwiftRepositories()
    }
    
}
