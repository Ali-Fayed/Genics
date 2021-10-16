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
        NetworkingManger.shared.performRequest(dataModel: [Commit].self, requestData: GitRequestRouter.gitRepositoriesCommits(pageNo, repository.repoFullName), pagination: false) { [weak self] (result) in
            switch result {
            case .success(let result):
                self?.commits = result
                loadingSpinner.dismiss()
                tableView.reloadData()
            case .failure(let error):
                CustomViews.shared.showAlert(message: error.localizedDescription, title: "Error")
                loadingSpinner.dismiss()
            }
        }
    }
    
    func renderCachedReposCommits(view: UIView, tableView: UITableView, loadingSpinner: JGProgressHUD) {
        if self.commits.isEmpty == true {
            loadingSpinner.show(in: view)
        }
        guard let repository = savedRepos else {
            return
        }
        NetworkingManger.shared.performRequest(dataModel: [Commit].self, requestData: GitRequestRouter.gitRepositoriesCommits(pageNo, repository.repoUserFullName ?? "")) { [weak self] (result) in
            switch result {
            case .success(let result):
                self?.commits = result
                loadingSpinner.dismiss()
                tableView.reloadData()
            case .failure(let error):
                CustomViews.shared.showAlert(message: error.localizedDescription, title: "Error")
                loadingSpinner.dismiss()
            }
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
                NetworkingManger.shared.performRequest(dataModel: [Commit].self, requestData: GitRequestRouter.gitRepositoriesCommits(pageNo, repository.repoFullName), pagination: true) { [weak self] (result) in
                    switch result {
                    case .success(let result):
                        DispatchQueue.main.async {
                            if result.isEmpty == false {
                                self?.commits.append(contentsOf: result)
                                tableView.reloadData()
                                tableView.tableFooterView = nil
                            } else {
                                tableView.tableFooterView = footerView
                            }
                        }
                    case .failure(let error):
                        CustomViews.shared.showAlert(message: error.localizedDescription, title: "Error")
                        loadingSpinner.dismiss()
                    }
                }
            }
        }

    }
}
