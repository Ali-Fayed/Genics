//
//  IssuesViewModel.swift
//  Githubgenics
//
//  Created by Ali Fayed on 08/04/2021.
//

import UIKit
import JGProgressHUD
import XCoordinator

class IssuesViewModel {
    
    var issuesData = [Issue]()
    var router: UnownedRouter<IssuesRoute>?
    var numberOfIssuesCell: Int {
        return issuesData.count
    }
    
    func getIssuesViewModel( at indexPath: IndexPath ) -> Issue {
        return issuesData[indexPath.row]
    }
    
    func searchIssues (tableView: UITableView, loadingSpinner: JGProgressHUD, view: UIView) {
            loadingSpinner.show(in: view)
        NetworkingManger.shared.performRequest(dataModel: Issues.self, requestData: GitRequestRouter.gitSearchIssues(1, "a"), pagination: false) { [weak self] (result) in
            switch result {
            case .success(let result):
                self?.issuesData = result.items
                DispatchQueue.main.async {
                    tableView.reloadData()
                    loadingSpinner.dismiss()
                }
            case .failure(let error):
                CustomViews.shared.showAlert(message: error.localizedDescription, title: "Error")
                loadingSpinner.dismiss()
            }
        }
    }
    
    func passedSearchIssues (tableView: UITableView, loadingSpinner: JGProgressHUD, view: UIView, query: String) {
        loadingSpinner.show(in: view)
        NetworkingManger.shared.performRequest(dataModel: Issues.self, requestData: GitRequestRouter.gitSearchIssues(1, query), pagination: false) { [weak self] (result) in
            switch result {
            case .success(let result):
                self?.issuesData = result.items
                DispatchQueue.main.async {
                    tableView.reloadData()
                    loadingSpinner.dismiss()
                }
            case .failure(let error):
                CustomViews.shared.showAlert(message: error.localizedDescription, title: "Error")
                loadingSpinner.dismiss()
            }
        }
    }
    
    func fetchMoreIssues (tableView: UITableView, tableFooterView: UIView, query: String, page: Int) {
        NetworkingManger.shared.performRequest(dataModel: Issues.self, requestData: GitRequestRouter.gitSearchIssues(page, query), pagination: true) { [weak self] (result) in
            switch result {
            case .success(let result):
                DispatchQueue.main.async {
                    if result.items.isEmpty == false {
                        self?.issuesData.append(contentsOf: result.items)
                        tableView.reloadData()
                        tableView.tableFooterView = nil
                    } else {
                        tableView.tableFooterView = tableFooterView
                    }
                }
            case .failure(let error):
                CustomViews.shared.showAlert(message: error.localizedDescription, title: "Error")
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
        NetworkingManger.shared.performRequest(dataModel: Issues.self, requestData: GitRequestRouter.gitSearchIssues(page, query)) { [weak self] (result) in
            switch result {
            case .success(let result):
                self?.issuesData = result.items
                loadingSpinner.dismiss()
                tableView.reloadData()
            case .failure(let error):
                CustomViews.shared.showAlert(message: error.localizedDescription, title: "Error")
                loadingSpinner.dismiss()
            }
        }
    }
}
