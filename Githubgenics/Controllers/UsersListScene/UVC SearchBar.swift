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
            self.pageNo = 1
            self.tableView.reloadData()
            self.recentSearchTable.reloadData()
            if self.searchController.searchBar.text?.isEmpty == true {
                self.tableView.isHidden = true
            } else {
                self.tableView.isHidden = false
                self.noContentLabel.isHidden = true
            }
            if self.lastSearch.isEmpty == true {
                self.recentSearchTable.isHidden = true
            } else {
                self.recentSearchTable.isHidden = false
            }
            if self.searchController.searchBar.text?.isEmpty == true , self.lastSearch.isEmpty == true {
                self.noContentLabel.isHidden = false
            } else {
                self.noContentLabel.isHidden = true
            }
            self.spinner.dismiss()
            self.recentSearchData ()
        }
    }
        
    // Automatic Search When Change Text with Some Animations
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.noContentLabel.isHidden = true
        guard let query = searchBar.text else { return }
        GitAPIcaller.shared.makeRequest(returnType: Users.self, requestData: GitRequestRouter.gitSearchUsers(1, query)) { [weak self] (searchedUsers) in
            DispatchQueue.main.async {
                self?.usersModel = searchedUsers.items
                self?.tableView.reloadData()
                self?.tableView.isHidden = false
            }
        }
        UIView.animate(withDuration: 0.0, animations: {
            self.tableView.alpha = 1.0
            self.recentSearchTable.alpha = 0.0
        })
    }
    
    // canel and return to man view and return searchBar to tableHeader
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
        DispatchQueue.main.async {
            self.searchController.searchBar.text = nil
            self.recentSearchTable.isHidden = true
            self.tableView.isHidden = false
            self.spinner.dismiss()
            self.recentSearchTable.reloadData()
            self.collectionView.reloadData()
            self.tableView.reloadData()
            self.noContentLabel.isHidden = true
        }
        
        UIView.animate(withDuration: 0.0, animations: {
            self.tableView.alpha = 1.0
            self.recentSearchTable.alpha = 1.0
        })
    }
    
    // Save Search Keyword If Click Button Search
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text else { return }
        let history = SearchHistory(context: self.context)
            history.keyword = text
            try! self.context.save()
        self.recentSearchData ()

    }
    
}
