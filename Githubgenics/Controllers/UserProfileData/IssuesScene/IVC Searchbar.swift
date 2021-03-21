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
            self.noContentLabel.alpha = 1.0
        })
        
        DispatchQueue.main.async {
            self.tableView.isHidden = false
            self.noContentLabel.isHidden = false
            self.searchController.searchBar.becomeFirstResponder()
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
            self.searchController.searchBar.resignFirstResponder()
            self.searchController.searchBar.text = nil
            self.noContentLabel.isHidden = true
            self.tableView.isHidden = false


        }
    }

}
