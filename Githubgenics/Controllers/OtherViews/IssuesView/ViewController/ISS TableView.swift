//
//  ISS TableView.swift
//  Githubgenics
//
//  Created by Ali Fayed on 08/04/2021.
//

import UIKit

extension IssuesViewController : UITableViewDataSource , UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfIssuesCell
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue() as IssuesTableViewCell
        cell.cellViewModel(with: viewModel.getIssuesViewModel(at: indexPath))
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {        
        if indexPath.row == viewModel.numberOfIssuesCell - 1 {
            showTableViewSpinner(tableView: tableView)
            if pageNo < totalPages {
                pageNo += 1
                let searchText = searchController.searchBar.text
                let query = viewModel.query(searchText: searchText)
                viewModel.fetchMoreIssues(tableView: tableView, tableFooterView: tableFooterView, query: query, page: pageNo)
            }
        }
    }
        
}
