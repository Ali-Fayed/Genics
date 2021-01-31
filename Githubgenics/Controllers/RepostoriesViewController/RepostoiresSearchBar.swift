//
//  exSearchBar.swift
//  Githubgenics
//
//  Created by Ali Fayed on 30/01/2021.
//

import UIKit

extension RepositoriesListViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard let query = searchBar.text else {
          return
        }
        loadingIndicator.startAnimating()
        RepostoriesRouter().searchRepositories(query: query) { repositories in
          self.fetchedRepositories = repositories
          self.loadingIndicator.stopAnimating()
          self.tableView.reloadData()
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
      searchBar.text = nil
      searchBar.resignFirstResponder()
        fetchAndDisplayPopularSwiftRepositories()
        loadingIndicator.stopAnimating()
      }
    
    func fetchAndDisplayPopularSwiftRepositories() {
      loadingIndicator.startAnimating()
        RepostoriesRouter().fetchPopularSwiftRepositories { repositories in
        self.fetchedRepositories = repositories
        self.loadingIndicator.stopAnimating()
        self.tableView.reloadData()
      }
    }
    }
