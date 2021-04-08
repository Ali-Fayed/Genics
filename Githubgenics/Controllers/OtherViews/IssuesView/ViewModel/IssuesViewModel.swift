//
//  IssuesViewModel.swift
//  Githubgenics
//
//  Created by Ali Fayed on 08/04/2021.
//

import UIKit
import JGProgressHUD

class IssuesViewModel {
    
    var issuesData = [Issue]()

    var numberOfIssuesCell: Int {
        return issuesData.count
    }
    
    func getIssuesViewModel( at indexPath: IndexPath ) -> Issue {
        return issuesData[indexPath.row]
    }
    
    func searchIssues (tableView: UITableView, loadingSpinner: JGProgressHUD, view: UIView) {
            loadingSpinner.show(in: view)
        GitAPIcaller.shared.makeRequest(returnType: Issues.self, requestData: GitRequestRouter.gitSearchIssues(1, "a"), pagination: false) { [weak self] (result) in
            self?.issuesData = result.items
            DispatchQueue.main.async {
                tableView.reloadData()
                loadingSpinner.dismiss()
            }
        }
    }
    
    func passedSearchIssues (tableView: UITableView, loadingSpinner: JGProgressHUD, view: UIView, query: String) {
        loadingSpinner.show(in: view)
        GitAPIcaller.shared.makeRequest(returnType: Issues.self, requestData: GitRequestRouter.gitSearchIssues(1, query), pagination: false) { [weak self] (result) in
            self?.issuesData = result.items
            DispatchQueue.main.async {
                tableView.reloadData()
                loadingSpinner.dismiss()
            }
        }
    }
    
    func fetchMoreIssues (tableView: UITableView, tableFooterView: UIView, query: String, page: Int) {
        GitAPIcaller.shared.makeRequest(returnType: Issues.self, requestData: GitRequestRouter.gitSearchIssues(page, query), pagination: true) { [weak self] (moreUsers) in
            DispatchQueue.main.async {
                if moreUsers.items.isEmpty == false {
                    self?.issuesData.append(contentsOf: moreUsers.items)
                    tableView.reloadData()
                    tableView.tableFooterView = nil
                } else {
                    tableView.tableFooterView = tableFooterView
                }
            }
        }
    }
    
    func query (searchText : String? ) -> String {
        let query : String = {
            var queryString = String()
            if let searchText = searchText {
                queryString = searchText.isEmpty ? "a" : searchText
            }
            return queryString
        }()
        return query
    }
    
    // Fetch Methods
    func searchIssues (view: UIView, tableView: UITableView, loadingSpinner: JGProgressHUD, query: String, page: Int) {
        if issuesData.isEmpty {
            loadingSpinner.show(in: view)
        }
        GitAPIcaller.shared.makeRequest(returnType: Issues.self, requestData: GitRequestRouter.gitSearchIssues(page, query)) { [weak self] (repositories) in
            self?.issuesData = repositories.items
            loadingSpinner.dismiss()
            tableView.reloadData()
        }
    }
}
