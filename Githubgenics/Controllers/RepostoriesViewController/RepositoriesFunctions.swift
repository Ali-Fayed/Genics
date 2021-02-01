//
//  RepositoriesFunctions.swift
//  Githubgenics
//
//  Created by Ali Fayed on 01/02/2021.
//

import Foundation


extension RepositoriesListViewController {
    
    func fetchAndDisplayPopularSwiftRepositories() {
        loadingIndicator.startAnimating()
        RepostoriesRouter().fetchPopularSwiftRepositories { result in
            switch result {
            case .success(let repositories):
                self.fetchedRepositories.append(contentsOf: repositories)
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            case .failure(_):
                break
            }
            
        }
    }
    
    func fetchSearchedRepositories (for query: String) {
        loadingIndicator.startAnimating()
        RepostoriesRouter().searchRepositories(query: query) { result in
            switch result {
            case .success(let users):
                self.fetchedRepositories.append(contentsOf: users)
                self.loadingIndicator.stopAnimating()
                self.tableView.reloadData()
                print("okkkkk")
            case .failure(_):
                let error = Error.self
                print(error)
            }
        }
    }
}
