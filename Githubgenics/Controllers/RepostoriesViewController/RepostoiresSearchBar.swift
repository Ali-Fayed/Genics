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
        fetchSearchedRepositories(for: query)
        self.fetchedRepositories.removeAll()
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = nil
        searchBar.resignFirstResponder()
        fetchAndDisplayPopularSwiftRepositories()
        loadingIndicator.stopAnimating()
    }
    
}
}
