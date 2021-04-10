//
//  ISS Searchbar.swift
//  Githubgenics
//
//  Created by Ali Fayed on 08/04/2021.
//

import UIKit

extension IssuesViewController: UISearchBarDelegate {
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        
        UIView.animate(withDuration: 0.0, animations: {
            self.tableView.alpha = 0.0
            self.conditionLabel.alpha = 1.0
        })
        
        DispatchQueue.main.async {
            self.tableView.isHidden = false
            self.conditionLabel.isHidden = false
            self.searchController.searchBar.becomeFirstResponder()
            self.pageNo = 1
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard let query = searchBar.text else { return }
        viewModel.searchIssues(view: view, tableView: tableView, loadingSpinner: loadingSpinner, query: query, page: pageNo)
        self.tableView.isHidden = false
        UIView.animate(withDuration: 0.5, animations: {
            self.tableView.alpha = 1.0
            self.conditionLabel.isHidden = true
            if searchBar.text?.isEmpty == true {
                self.tableView.alpha = 0.0
                self.loadingSpinner.dismiss()
            }
        })
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        UIView.animate(withDuration: 0.0, animations: {
            self.tableView.alpha = 1.0
            self.conditionLabel.alpha = 0.0
        })
        DispatchQueue.main.async {
            self.searchController.searchBar.resignFirstResponder()
            self.searchController.searchBar.text = nil
            self.conditionLabel.isHidden = true
            self.tableView.isHidden = false
        }
    }

    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        navigationItem.hidesSearchBarWhenScrolling = true
    }
}

