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
                self.conditionLabel.alpha = 1.0
            } else {
                self.tableView.alpha = 1.0
                self.conditionLabel.alpha = 0.0
            }
        })
        DispatchQueue.main.async {
            self.searchController.searchBar.text = nil
            self.conditionLabel.isHidden = false
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
            self.viewModel.searchRepositories(tableView: self.tableView, loadingSpinner: self.loadingSpinner, query: query, page: self.pageNo)
            self.tableView.isHidden = false
        }
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
            self.pageNo = 1
        }
        viewModel.renderAndDisplayBestSwiftRepositories(view: view, tableView: tableView, loadingSpinner: loadingSpinner)
    }
    
    func didPresentSearchController(searchController: UISearchController) {
        DispatchQueue.main.async {
            self.searchController.searchBar.becomeFirstResponder()

        }
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
                navigationItem.hidesSearchBarWhenScrolling = true
    }
    
}
