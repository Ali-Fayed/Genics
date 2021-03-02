//
//  File.swift
//  Githubgenics
//
//  Created by Ali Fayed on 01/02/2021.
//

import UIKit

extension UsersListViewController  : UISearchBarDelegate  {
    
    // animation when click on search bar and push searchBar to navbar headerView
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        UIView.animate(withDuration: 0.3, animations: {
            self.tableView.alpha = 0.0
            self.historyView.alpha = 1.0
            self.searchBar.alpha = 1.0
            self.searchLabel.alpha = 1.0
        })
        
        DispatchQueue.main.async { 
            self.searchBar.showsCancelButton = true
            self.tableView.tableHeaderView = nil
            self.searchBar.becomeFirstResponder()
            self.tabBarController?.tabBar.isHidden = true
            self.tabBarController?.navigationItem.titleView = self.searchBar
            if ((searchBar.text?.isEmpty) == true) {
                self.spinner.dismiss()
            }
            if self.historyView.isHidden == false {
                self.searchLabel.isHidden = true
            } else {
                self.searchLabel.isHidden = false
            }
        }
    }
    
    // Save Search Keyword If Click Button Search
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text, !text.isEmpty else { return }
        let history = SearchHistory(context: self.context)
            history.keyword = text
            try! self.context.save()
    }
    
    // Automatic Search When Change Text with Some Animations
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard let query = searchBar.text else {
            return
        }
        searchUser(query: query)
        UIView.animate(withDuration: 0.5, animations: {
            self.tableView.alpha = 1.0
            self.historyView.alpha = 0.0
            self.tableView.reloadData()
            self.searchLabel.isHidden = true
            self.searchLabel.alpha = 0.0
        })
    }
    // canel and return to man view and return searchBar to tableHeader
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
        self.usersModel.removeAll()
        searchBar.text = nil
        renderUsersList ()
        DispatchQueue.main.async {
            self.tableView.reloadData()
            self.tableView.isHidden = false
            self.tabBarController?.navigationItem.titleView = nil
            self.tableView.tableHeaderView = self.usersListViewSearchBar
            self.usersListViewSearchBar.resignFirstResponder()
            self.spinner.dismiss()
            self.historyView.isHidden = false
            self.tabBarController?.tabBar.isHidden = false
        }
        // Reload Recent View to Update Table realtime
        let VC : RecentSearchViewController = self.children[0] as! RecentSearchViewController
        VC.tableView.reloadData()
        VC.viewDidAppear(true)
        // Some animations when cancel
        UIView.animate(withDuration: 0.3, animations: {
            self.tableView.alpha = 1.0
            self.historyView.alpha = 0.0
            self.searchBar.alpha = 0.0
            self.searchLabel.isHidden = true
            self.searchLabel.alpha = 0.0
        })
    }
        
}
