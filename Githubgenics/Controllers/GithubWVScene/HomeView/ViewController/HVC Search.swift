//
//  HVC Search.swift
//  Githubgenics
//
//  Created by Ali Fayed on 17/03/2021.
//

import UIKit

extension HomeViewController: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        
        DispatchQueue.main.async { [self] in
            if searchController.searchBar.text?.isEmpty == true {
                homeTableView.isHidden = true
                searchOptionsTableView.isHidden = true
                reloadTableViewData(tableView: self.searchHistoryTableView, tableView1: self.searchOptionsTableView, tableView2: nil)

                switch viewModel.searchHistory.isEmpty {
                case true:
                    searchHistoryTableView.isHidden = true
                    conditionLabel.isHidden = false
                default:
                    searchHistoryTableView.isHidden = false
                    conditionLabel.isHidden = true
                }
                
            } else {
                homeTableView.isHidden = true
                searchHistoryTableView.isHidden = true
                searchOptionsTableView.isHidden = false
            }
        }
                
    }
    
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        DataBaseManger().Fetch(returnType: SearchHistory.self) { [weak self] (result) in
            self?.viewModel.searchHistory = result
        }
        DispatchQueue.main.async { [weak self] in
            self?.homeTableView.isHidden = false
            self?.searchHistoryTableView.isHidden = true
            self?.searchOptionsTableView.isHidden = true
            self?.conditionLabel.isHidden = true
            self?.searchHistoryTableView.reloadData()
            self?.navigationController?.navigationItem.largeTitleDisplayMode = .always
            self?.navigationController?.navigationBar.prefersLargeTitles = true
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        DispatchQueue.main.async { [weak self] in
            self?.searchOptionsTableView.reloadData()
            self?.conditionLabel.isHidden = true
            
            switch searchText.isEmpty {
            case true:
                self?.searchOptionsTableView.isHidden = true
                self?.searchHistoryTableView.isHidden = false
            default:
                self?.searchOptionsTableView.isHidden = false
                self?.searchHistoryTableView.isHidden = true
            }
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchText = searchBar.text else { return }
        viewModel.saveSearchWord(text: searchText)
    }
}
