//
//  UVC SearchBar.swift
//  Githubgenics
//
//  Created by Ali Fayed on 01/02/2021.
//

import UIKit

extension UsersViewController  : UISearchBarDelegate  {
    
    // animation when click on search bar and push searchBar to navbar headerView
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        
        DispatchQueue.main.async {
            self.searchBar.text = nil
            self.pageNo = 1
            if ((searchBar.text?.isEmpty) == true) {
                self.spinner.dismiss()
            }
            if self.historyView.alpha == 0.0
                {
                self.searchLabel.alpha = 1.0
            } else {
                self.searchLabel.alpha = 0.0
            }
        }
        
        UIView.animate(withDuration: 0.3, animations: {
            self.tableView.alpha = 0.0
            self.historyView.alpha = 1.0
//            self.searchBar.alpha = 1.0
            self.searchLabel.alpha = 1.0
        })
        
    }
        
    // Automatic Search When Change Text with Some Animations
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        guard let query = searchBar.text else { return }
        GitAPIcaller.shared.makeRequest(returnType: Users.self, requestData: GitRequestRouter.gitSearchUsers(1, query)) { [weak self] (searchedUsers) in
            DispatchQueue.main.async {
                self?.usersModel = searchedUsers.items
                self?.tableView.reloadData()
                self?.searchLabel.isHidden = true
            }
        }
        
        UIView.animate(withDuration: 0.0, animations: {
            self.tableView.alpha = 1.0
            self.historyView.alpha = 0.0
            self.searchLabel.alpha = 0.0
        })
    }
    
    // canel and return to man view and return searchBar to tableHeader
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
        DispatchQueue.main.async {
            self.searchBar.text = nil
            self.searchBar.resignFirstResponder()
            self.searchLabel.isHidden = true
            self.historyView.isHidden = false
            self.spinner.dismiss()
            // Reload Recent View to Update Table realtime
            let VC : RecentSearchViewController = self.children[0] as! RecentSearchViewController
            VC.tableView.reloadData()
            VC.collectionView.reloadData()
            VC.viewDidAppear(true)
        }
        
        // Some animations when cancel
        UIView.animate(withDuration: 0.0, animations: {
            self.tableView.alpha = 1.0
            self.historyView.alpha = 0.0
            self.searchLabel.alpha = 0.0
        })
    }
    
    // Save Search Keyword If Click Button Search
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text, !text.isEmpty else { return }
        let history = SearchHistory(context: self.context)
            history.keyword = text
            try! self.context.save()
    }
    
}
