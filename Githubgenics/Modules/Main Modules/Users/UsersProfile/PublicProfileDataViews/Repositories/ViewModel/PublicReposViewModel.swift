//
//  PublicReposViewModel.swift
//  Githubgenics
//
//  Created by Ali Fayed on 09/04/2021.
//

import UIKit
import JGProgressHUD

class PublicReposViewModel {

    var repositoryModel = [Repository]()
    var savedRepos = [SavedRepositories]()
    var passedUser : User?
    var repository: Repository?
    var pageNo : Int = 1
    var totalPages : Int = 100
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var numberOfReposCells: Int {
        return  repositoryModel.count
    }
    
    func getReposViewModel( at indexPath: IndexPath ) -> Repository {
        return repositoryModel[indexPath.row]
    }
    
    func renderClickedUserPublicRepositories (tableView: UITableView, view: UIView , loadingSpinner: JGProgressHUD, conditionLabel: UILabel ) {
        guard let user = passedUser else {return}
        if repositoryModel.isEmpty == true {
            loadingSpinner.show(in: view)
        }
        NetworkingManger.shared.performRequest(dataModel: [Repository].self, requestData: GitRequestRouter.gitPublicUsersRepositories(pageNo, user.userName)) { [weak self] (result) in
            switch result {
            case .success(let result):
                self?.repositoryModel = result
                DispatchQueue.main.async {
                    loadingSpinner.dismiss()
                    tableView.reloadData()
                    if self?.repositoryModel.isEmpty == true {
                        tableView.isHidden = true
                        conditionLabel.isHidden = false
                    } else {
                        tableView.isHidden = false
                        conditionLabel.isHidden = true
                    }
                }
            case .failure(let error):
                break
            }

        }
    }
        
    func fetchMoreRepositories (at indexPath: IndexPath, tableView: UITableView, tableFooterView: UIView , loadingSpinner: JGProgressHUD) {
        if indexPath.row == numberOfReposCells - 1 {
            if pageNo < totalPages {
                pageNo += 1
                guard let user = passedUser else {return}
                NetworkingManger.shared.performRequest(dataModel: [Repository].self, requestData: GitRequestRouter.gitPublicUsersRepositories(pageNo, user.userName), pagination: true) { [weak self]  (result) in
                    switch result {
                    case .success(let result):
                        DispatchQueue.main.async {
                            if result.isEmpty == false {
                                self?.repositoryModel.append(contentsOf: result)
                                tableView.reloadData()
                                tableView.tableFooterView = nil
                            } else {
                                tableView.tableFooterView = tableFooterView
                            }
                        }
                    case .failure(let error):
                        break
                    }
                }
            }
        }

    }
    
    func pushToDestnationVC(indexPath: IndexPath, navigationController: UINavigationController, view: UIView, tableView: UITableView, loadingSpinner: JGProgressHUD ) {
        let commitsView = CommitsViewController.instaintiate(on: .commitsView)
        commitsView.viewModel.repository = repository
        commitsView.viewModel.fetchReposCommits(view: view, tableView: tableView, loadingSpinner: loadingSpinner)
        navigationController.pushViewController(commitsView, animated: true)
    }
    
    func saveRepoToBookmarks(at indexPath: IndexPath) {
        let repository = self.getReposViewModel(at: indexPath)
        let saveRepoInfo = SavedRepositories(context: self.context)
            saveRepoInfo.repoName = repository.repositoryName
            saveRepoInfo.repoDescription = repository.repositoryDescription
            saveRepoInfo.repoProgrammingLanguage = repository.repositoryLanguage
            saveRepoInfo.repoUserFullName = repository.repoFullName
            saveRepoInfo.repoStars = Float(repository.repositoryStars ?? 0)
            saveRepoInfo.repoURL = repository.repositoryURL
    }

}
