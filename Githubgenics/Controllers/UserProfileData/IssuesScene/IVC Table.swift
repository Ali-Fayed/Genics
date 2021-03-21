//
//  IVC Table.swift
//  Githubgenics
//
//  Created by Ali Fayed on 17/03/2021.
//

import UIKit


extension IssuesViewController : UITableViewDataSource , UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return issuesData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = issuesData[indexPath.row].issueTitle
        cell.detailTextLabel?.text = issuesData[indexPath.row].issueState
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        // fetch more
        
        if indexPath.row == issuesData.count - 1 {
            showTableViewSpinner()
            let query : String = {
                var queryString = String()
                if let searchText = searchController.searchBar.text {
                    queryString = searchText.isEmpty ? "a" : searchText
                }
                return queryString
            }()
            if pageNo < totalPages {
                pageNo += 1
            fetchMoreUsers(query: query, page: pageNo)
            }
        }
    }
    
    // fetch more users
    func fetchMoreUsers (query: String, page: Int) {
        GitAPIcaller.shared.makeRequest(returnType: Issues.self, requestData: GitRequestRouter.gitSearchIssues(page, query), pagination: true) { [weak self] (moreUsers) in
            DispatchQueue.main.async {
                if moreUsers.items.isEmpty == false {
                    self?.issuesData.append(contentsOf: moreUsers.items)
                    self?.tableView.reloadData()
                    self?.tableView.tableFooterView = nil
                } else {
                    self?.tableView.tableFooterView = self?.footer
                }
            }
        }
    }
    
    // show spinner
    func showTableViewSpinner () {
        let spinner = UIActivityIndicatorView(style: .medium)
        spinner.startAnimating()
        spinner.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: tableView.bounds.width, height: CGFloat(44))
        self.tableView.tableFooterView = spinner
        self.tableView.tableFooterView?.isHidden = false
    }
}
