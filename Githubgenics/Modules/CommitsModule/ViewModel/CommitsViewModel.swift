//
//  CommitsViewModel.swift
//  Githubgenics
//
//  Created by Ali Fayed on 08/04/2021.
//

import UIKit
import JGProgressHUD

class CommitsViewModel {
    
    var commits = [Commit]()
    var repository : Repository?
    var savedRepos : SavedRepositories?
    var pageNo : Int = 1
    var totalPages : Int = 100
    
    var numberOfCommitCell: Int {
        return  commits.count
    }
    
    func getCommitViewModel( at indexPath: IndexPath ) -> Commit {
        return commits[indexPath.row]
    }
    
    func fetchReposCommits (view: UIView, tableView: UITableView, loadingSpinner: JGProgressHUD) {
        guard let repository = repository else {
            return
        }
        if self.commits.isEmpty == true {
            loadingSpinner.show(in: view)
        }
        GitAPIcaller.makeRequest(dataModel: [Commit].self, requestData: GitRequestRouter.gitRepositoriesCommits(pageNo, repository.repoFullName), pagination: false) { [weak self] (commits) in
            self?.commits = commits
            loadingSpinner.dismiss()
            tableView.reloadData()
        }
    }
    
    func renderCachedReposCommits(view: UIView, tableView: UITableView, loadingSpinner: JGProgressHUD) {
        if self.commits.isEmpty == true {
            loadingSpinner.show(in: view)
        }
        guard let repository = savedRepos else {
            return
        }
        GitAPIcaller.makeRequest(dataModel: [Commit].self, requestData: GitRequestRouter.gitRepositoriesCommits(pageNo, repository.repoUserFullName ?? "")) { [weak self] (commits) in
            self?.commits = commits
            loadingSpinner.dismiss()
            tableView.reloadData()
        }
    }
    
    func fetchMoreCommits (indexPath: IndexPath, footerView: UIView, tableView: UITableView, loadingSpinner: JGProgressHUD, page: Int) {
        // fetch more
        if indexPath.row == commits.count - 1 {
            if pageNo < totalPages {
                pageNo += 1
                guard let repository = repository else {
                    return
                }
                GitAPIcaller.makeRequest(dataModel: [Commit].self, requestData: GitRequestRouter.gitRepositoriesCommits(pageNo, repository.repoFullName), pagination: true) { [weak self] (moreCommits) in
                    DispatchQueue.main.async {
                        if moreCommits.isEmpty == false {
                            self?.commits.append(contentsOf: moreCommits)
                            tableView.reloadData()
                            tableView.tableFooterView = nil
                        } else {
                            tableView.tableFooterView = footerView
                        }
                    }
                }
            }
        }

    }
}
