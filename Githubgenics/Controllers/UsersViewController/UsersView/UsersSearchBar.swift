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
        UIView.animate(withDuration: 0.5, animations: {
            self.tableView.alpha = 1.0
            self.historyView.alpha = 0.0
            self.tableView.reloadData()

        })
    
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
            self.tabBarController?.navigationItem.leftBarButtonItem = self.signOutButton
            self.historyView.isHidden = false
            self.tabBarController?.tabBar.isHidden = false


            
        }
        let tv : RecentSearchViewController = self.children[0] as! RecentSearchViewController
        tv.tableView.reloadData()
        tv.viewDidAppear(true)
        UIView.animate(withDuration: 0.3, animations: {
            self.tableView.alpha = 1.0
            self.historyView.alpha = 0.0
            self.searchBar.alpha = 0.0
        })
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text, !text.isEmpty else { return }
        Save().searchKeywords(keyword: text)
    }
    
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        UIView.animate(withDuration: 0.3, animations: {
            self.tableView.alpha = 0.0
            self.historyView.alpha = 1.0
            self.searchBar.alpha = 1.0
        })
        
        DispatchQueue.main.async {
            self.searchBar.showsCancelButton = true
            self.tabBarController?.navigationItem.titleView = self.searchBar
            self.tableView.tableHeaderView = nil
            self.tabBarController?.navigationItem.leftBarButtonItem = nil
            self.searchBar.becomeFirstResponder()
            self.loadingIndicator.stopAnimating()
            if ((searchBar.text?.isEmpty) == true) {
                self.loadingIndicator.stopAnimating()
            }
            self.tabBarController?.tabBar.isHidden = true



        }
            }
    
    

    

}
