//
//  UVC SearchBar.swift
//  Githubgenics
//
//  Created by Ali Fayed on 01/02/2021.
//

import UIKit
import SafariServices

extension UsersViewController  : UISearchBarDelegate  {
    
    // animation when click on search bar and push searchBar to navbar headerView
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {

        DispatchQueue.main.async {
            self.viewModel.pageNo = 1
            self.tableView.reloadData()
            self.recentSearchTable.reloadData()
            if self.searchController.searchBar.text?.isEmpty == true {
                self.tableView.isHidden = true
            } else {
                self.tableView.isHidden = false
                self.conditionLabel.isHidden = true
            }
            if self.viewModel.searchHistory.isEmpty == true {
                self.recentSearchTable.isHidden = true
            } else {
                self.recentSearchTable.isHidden = false
            }
            if self.searchController.searchBar.text?.isEmpty == true , self.viewModel.lastSearch.isEmpty == true , self.viewModel.searchHistory.isEmpty == true{
                self.conditionLabel.isHidden = false
            } else {
                self.conditionLabel.isHidden = true
            }
            self.loadingSpinner.dismiss()
            self.viewModel.recentSearchData(collectionView: self.collectionView, tableView: self.recentSearchTable)
        }
    }
        
    // Automatic Search When Change Text with Some Animations
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.conditionLabel.isHidden = true
        self.tableView.reloadData()
        guard let query = searchBar.text else { return }
        viewModel.fetchUsers(tableView: tableView, searchController: searchController, loadingIndicator: loadingSpinner, query: query)
        UIView.animate(withDuration: 0.0, animations: {
            self.tableView.alpha = 1.0
            self.recentSearchTable.alpha = 0.0
        })
    }
    
    // canel and return to man view and return searchBar to tableHeader
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        viewModel.fetchUsers(tableView: tableView, searchController: searchController, loadingIndicator: loadingSpinner, query: "a")
        DispatchQueue.main.async {
            self.searchController.searchBar.text = nil
            self.recentSearchTable.isHidden = true
            self.tableView.isHidden = false
            self.loadingSpinner.dismiss()
            self.recentSearchTable.reloadData()
            self.collectionView.reloadData()
            self.conditionLabel.isHidden = true
        }
        
        UIView.animate(withDuration: 0.0, animations: {
            self.tableView.alpha = 1.0
            self.recentSearchTable.alpha = 1.0
        })
    }
    
    // Save Search Keyword If Click Button Search
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text else { return }
        viewModel.saveSearchWord(text: text)
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
      navigationItem.hidesSearchBarWhenScrolling = true
    }
}
