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
        print("\(searchText)")
        guard let query = searchBar.text else {
            return
        }
        self.loadingIndicator.startAnimating()
        UsersRouter().listUsers(query:query) { [weak self] result in
            switch result {
            case .success(let users):
                self!.users.append(contentsOf: users)
                self!.loadingIndicator.stopAnimating()
                DispatchQueue.main.async {
                    self!.tableView.reloadData()
                }
            case .failure(_):
             break
            }
        }
        self.users.removeAll()
        self.tableView.reloadData()
        tableView.isHidden = false
        
    }
    
//    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
//        self.tableView.tableHeaderView = searchBar
//    }
//    
//    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
//        self.tableView.tableHeaderView = searchBar
//return true
//    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
        print("cancel")
        self.users.removeAll()
        searchBar.text = nil
        
            UsersRouter().fetchUserstoAvoidIndexError { [weak self] result in
                switch result {
                case .success(let users):
                    self!.users.append(contentsOf: users)
                    DispatchQueue.main.async {
                        self!.tableView.reloadData()
                    }
                case .failure(_):
                 break
                }
         
            }
        tableView.tableHeaderView = self.searchBar
        self.tableView.isHidden = false
        self.tabBarController?.navigationItem.titleView = nil
//        self.searchBar.showsCancelButton = false
//        self.searchBar.resignFirstResponder()
          

        }
        
        
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text, !text.isEmpty else { return }
        Save().searchKeywords(keyword: text)
    }
    

    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        tableView.isHidden = true
        self.tableView.tableHeaderView = nil
        self.searchBar.showsCancelButton = true
        self.tabBarController?.navigationItem.titleView = self.searchBar
        self.tabBarController?.navigationItem.leftBarButtonItem = nil
        self.searchBar.becomeFirstResponder()

    }
    
    
}
