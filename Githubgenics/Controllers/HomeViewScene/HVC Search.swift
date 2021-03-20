//
//  HVC Search.swift
//  Githubgenics
//
//  Created by Ali Fayed on 17/03/2021.
//

import UIKit


extension HomeViewController: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        
        DispatchQueue.main.async {
            if self.search.searchBar.text?.isEmpty == true {
                self.tableView.isHidden = true
                if self.searchHistory.isEmpty {
                    self.searchLabel.isHidden = false
                    self.historyTable.isHidden = true
                } else {
                    self.historyTable.isHidden = false
                    self.searchLabel.isHidden = true
                }
                self.searchFieldsTable.isHidden = true
            } else {
                self.tableView.isHidden = true
                self.historyTable.isHidden = true
                self.searchFieldsTable.isHidden = false
            }
            self.historyTable.reloadData()
            self.searchFieldsTable.reloadData()
        }
        
        UIView.animate(withDuration: 0.3, animations: {
      
        })
        
    }
    
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        DataBaseManger().Fetch(returnType: SearchHistory.self) { [weak self] (result) in
            self?.searchHistory = result
        }
        DispatchQueue.main.async {
            self.tableView.isHidden = false
            self.historyTable.isHidden = true
            self.searchFieldsTable.isHidden = true
            self.searchLabel.isHidden = true
            self.historyTable.reloadData()
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        DispatchQueue.main.async {
            self.searchFieldsTable.reloadData()
            self.searchLabel.isHidden = true
            if searchText.isEmpty {
                self.searchFieldsTable.isHidden = true
                self.historyTable.isHidden = false
            } else {
                self.searchFieldsTable.isHidden = false
                self.historyTable.isHidden = true
            }
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text else { return }
        let history = SearchHistory(context: self.context)
            history.keyword = text
            try! self.context.save()

    }
}
