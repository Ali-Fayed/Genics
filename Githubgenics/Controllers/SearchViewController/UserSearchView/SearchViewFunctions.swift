//
//  SearchViewFunctions.swift
//  Githubgenics
//
//  Created by Ali Fayed on 01/02/2021.
//

import Foundation



extension SearchViewController {
    func fetchAndDisplaySearchViewUsers() {
            self.loadingIndicator.startAnimating()
        UsersRouter().fetchUserstoAvoidIndexError { [weak self] result in
            switch result {
            case .success(let users):
                self!.searchedUsers.append(contentsOf: users)
                self!.loadingIndicator.stopAnimating()
                DispatchQueue.main.async {
                    self!.tableView.reloadData()
                }
            case .failure(_):
             break
            }
     
        }
    }
    
    func fetchSearchedUsers (for query: String) {
        self.loadingIndicator.startAnimating()
        UsersRouter().searchUsers(query: query) { [weak self] result in
            switch result {
            case .success(let users):
                self!.searchedUsers.append(contentsOf: users)
                self!.loadingIndicator.stopAnimating()
                DispatchQueue.main.async {
                    self!.tableView.reloadData()
                }
                print("ok")
            case .failure(_):
                print("error")
             break
            }
     
        }
    }
}
