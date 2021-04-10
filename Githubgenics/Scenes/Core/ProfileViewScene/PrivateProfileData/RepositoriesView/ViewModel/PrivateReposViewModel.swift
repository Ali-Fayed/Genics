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
        GitAPIcaller.shared.makeRequest(returnType: [Repository].self, requestData: GitRequestRouter.gitAuthenticatedUserRepositories) { [weak self] (repos) in
            self?.repositoryModel = repos
            loadingSpinner.dismiss()
            tableView.reloadData()
        }
    }
    
    func fetchMoreUserRepos (tableView: UITableView, loadingSpinner: JGProgressHUD, view: UIView, page: Int) {
        GitAPIcaller.shared.makeRequest(returnType: [Repository].self, requestData: GitRequestRouter.gitAuthenticatedUserRepositories, pagination: true) { [weak self]  (moreRepos) in
            DispatchQueue.main.async {
                if moreRepos.isEmpty == false {
                    self?.repositoryModel.append(contentsOf: moreRepos)
                    tableView.reloadData()
                    tableView.tableFooterView = nil
                } else {
                    tableView.tableFooterView = nil
                }
            }
        }
    }
    
    func pushToDestinationVC(indexPath: IndexPath, navigationController: UINavigationController) {
        let vc = UIStoryboard.init(name: Storyboards.commitsView , bundle: Bundle.main).instantiateViewController(withIdentifier: ID.commitsViewControllerID) as? CommitsViewController
        vc?.viewModel.repository = repository
        navigationController.pushViewController(vc!, animated: true)
    }
}
