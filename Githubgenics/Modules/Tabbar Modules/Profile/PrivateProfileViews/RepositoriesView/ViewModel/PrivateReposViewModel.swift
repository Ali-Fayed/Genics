//
//  PrivateReposViewModel.swift
//  Githubgenics
//
//  Created by Ali Fayed on 09/04/2021.
//

import UIKit
import JGProgressHUD

class PrivateReposViewModel {
        
    var repositoryModel = [Repository]()
    var savedRepos = [SavedRepositories]()
    var passedUser : User?
    var repository: Repository?
    
    var numberOfReposCells: Int {
        return  repositoryModel.count
    }
    
    func getReposViewModel( at indexPath: IndexPath ) -> Repository {
        return repositoryModel[indexPath.row]
    }
    
    func fetchRepos (tableView: UITableView, loadingSpinner: JGProgressHUD, view: UIView) {
        if self.repositoryModel.isEmpty == true {
            loadingSpinner.show(in: view)
        }
        NetworkingManger.shared.performRequest(dataModel: [Repository].self, requestData: GitRequestRouter.gitAuthenticatedUserRepositories) { [weak self] (result) in
            switch result {
            case .success(let result):
                self?.repositoryModel = result
                loadingSpinner.dismiss()
                tableView.reloadData()
            case .failure(let error):
                break
            }
        }
    }
    
    func fetchMoreUserRepos (tableView: UITableView, loadingSpinner: JGProgressHUD, view: UIView, page: Int) {
        NetworkingManger.shared.performRequest(dataModel: [Repository].self, requestData: GitRequestRouter.gitAuthenticatedUserRepositories, pagination: true) { [weak self]  (result) in
            switch result {
            case .success(let result):
                DispatchQueue.main.async {
                    if result.isEmpty == false {
                        self?.repositoryModel.append(contentsOf: result)
                        tableView.reloadData()
                        tableView.tableFooterView = nil
                    } else {
                        tableView.tableFooterView = nil
                    }
                }
            case .failure(let error):
                break
            }
        }
    }
    
    func pushToDestinationVC(indexPath: IndexPath, navigationController: UINavigationController) {
        let commitsView = CommitsViewController.instaintiate(on: .commitsView)
        commitsView.viewModel.repository = repository
        navigationController.pushViewController(commitsView, animated: true)
    }
}
