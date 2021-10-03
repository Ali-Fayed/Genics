//
//  BVC Searchbar.swift
//  Githubgenics
//
//  Created by Ali Fayed on 08/04/2021.
//

import UIKit

extension BookmarksViewController : UISearchBarDelegate {
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        DispatchQueue.main.async {
            self.searchController.searchBar.becomeFirstResponder()
            self.searchLabel.isHidden = false
        }
        UIView.animate(withDuration: 0.0, animations: {
            self.searchLabel.alpha = 1.0
            self.tableView.alpha = 0.0
        })
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.searchLabel.isHidden = true
        viewModel.searchFromDB(tableView: tableView, searchController: searchController)
        UIView.animate(withDuration: 0.0, animations: {
            self.tableView.alpha = 1.0
            self.searchLabel.alpha = 0.0
        })
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        viewModel.renderViewData(tableView: tableView)
        DispatchQueue.main.async {
            self.searchController.searchBar.text = nil
            self.searchLabel.isHidden = true
        }
        UIView.animate(withDuration: 0.0, animations: {
            self.tableView.alpha = 1.0
            self.searchLabel.alpha = 0.0
        })
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
                navigationItem.hidesSearchBarWhenScrolling = true
    }
}
