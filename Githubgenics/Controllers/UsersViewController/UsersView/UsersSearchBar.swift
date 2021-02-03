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
        self.searchBar.showsSearchResultsButton = true
        
    }
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        self.searchBar.showsCancelButton = true
        return true
    }
    
    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        self.searchBar.showsCancelButton = false
        return true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
        print("cancel")
        self.searchBar.text = ""
        self.users.removeAll()
        self.tableView.reloadData()
        self.searchBar.resignFirstResponder()
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
        self.tableView.reloadData()

        }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text, !text.isEmpty else { return }
        Save().searchKeywords(keyword: text)
    }
    
    func searchBarResultsListButtonClicked(_ searchBar: UISearchBar) {
//        historyView.isHidden = false
//        tableView.isHidden = true
        if tableView.isHidden == false {
            tableView.isHidden = true
            resignFirstResponder()
            self.searchBar.showsSearchResultsButton = false
        } else {
            tableView.isHidden = false
        }
       
        
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        tableView.isHidden = false
    }
    
//    let tv : RecentSearchViewController = self.children[0] as! RecentSearchViewController
//    tv.tableView.reloadData()
//    tv.viewDidAppear(true)
    
}
