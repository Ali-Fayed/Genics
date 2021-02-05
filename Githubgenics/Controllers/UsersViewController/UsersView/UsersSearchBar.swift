//
//  File.swift
//  Githubgenics
//
//  Created by Ali Fayed on 01/02/2021.
//
import Foundation
import UIKit

extension UsersListViewController  : UISearchBarDelegate  {
    
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard let query = searchBar.text else {
            return
        }
        self.users.removeAll()

        fetchSearchedUsers(query: query)
        self.tableView.isHidden = false
        self.tableView.reloadData()
        if self.searchBar.text == "" {
            loadingIndicator.stopAnimating()
        }
    }
    
    
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
        self.users.removeAll()
        searchBar.text = nil
        fetchUsersData()
        DispatchQueue.main.async {
            self.tableView.reloadData()
            self.tableView.isHidden = false
            self.tabBarController?.navigationItem.titleView = nil
            self.tableView.tableHeaderView = self.listSearchBar
            self.listSearchBar.resignFirstResponder()
            self.loadingIndicator.stopAnimating()
        }
    }
    
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text, !text.isEmpty else { return }
        Save().searchKeywords(keyword: text)
    }
    
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        DispatchQueue.main.async {
            self.tableView.isHidden = true
            self.searchBar.showsCancelButton = true
            self.tabBarController?.navigationItem.titleView = self.searchBar
            self.tableView.tableHeaderView = nil
            self.tabBarController?.navigationItem.leftBarButtonItem = nil
            self.searchBar.becomeFirstResponder()
        }
        
//        self.tableView.sectionHeaderHeight = 0
    }
    
    
}
