//
//  IVC Searchbar.swift
//  Githubgenics
//
//  Created by Ali Fayed on 17/03/2021.
//

import UIKit

extension IssuesViewController: UISearchBarDelegate {
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        
        UIView.animate(withDuration: 0.0, animations: {
            self.tableView.alpha = 0.0
            self.searchLabel.alpha = 1.0
        })
        
        DispatchQueue.main.async {
            self.tableView.isHidden = false
            self.searchLabel.isHidden = false
            self.search.searchBar.becomeFirstResponder()
            self.pageNo = 1
        }
    }
    
    // Fetch Methods
    func searchRepositories (query: String, page: Int) {
        if issuesData.isEmpty {
            spinner.show(in: view)
        }
        GitAPIcaller.shared.makeRequest(returnType: Issues.self, requestData: GitRequestRouter.gitSearchIssues(page, query)) { [weak self] (repositories) in
            self?.issuesData = repositories.items
            self?.spinner.dismiss()
            self?.tableView.reloadData()
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        guard let query = searchBar.text else {
            return
        }
        searchRepositories(query: query, page: pageNo)
        self.tableView.isHidden = false
        
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
            self.search.searchBar.resignFirstResponder()
            self.search.searchBar.text = nil
            self.searchLabel.isHidden = true
            self.tableView.isHidden = false


        }
    }

}
