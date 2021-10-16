//
//  PublicStarredViewModel.swift
//  Githubgenics
//
//  Created by Ali Fayed on 09/04/2021.
//

import UIKit
import JGProgressHUD

class PublicStarredViewModel {

    var starttedRepos = [Repository]()
    var starttedRepositories : Repository?
    var passedUser: User?
    var pageNo : Int = 1
    var totalPages : Int = 100
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var numberOfStarredCells: Int {
        return  starttedRepos.count
    }

    func getStarredViewModel( at indexPath: IndexPath ) -> Repository {
        return starttedRepos[indexPath.row]
    }
    
    func loadStarred (tableView: UITableView, view: UIView, loadingSpinner: JGProgressHUD, conditionLabel: UILabel ) {
        guard let repository = passedUser else {return}
        if self.starttedRepos.isEmpty == true {
            loadingSpinner.show(in: view)
        }
        NetworkingManger.shared.performRequest(dataModel: [Repository].self, requestData: GitRequestRouter.gitPublicUsersStarred(pageNo, repository.userName)) { [weak self] (result) in
            switch result {
            case .success(let result):
                self?.starttedRepos = result
                DispatchQueue.main.async {
                    if self?.starttedRepos.isEmpty == true {
                        tableView.isHidden = true
                        conditionLabel.isHidden = false

                    } else {
                        tableView.isHidden = false
                        conditionLabel.isHidden = true
                    }
                    loadingSpinner.dismiss()
                    tableView.reloadData()
                }
            case .failure(let error):
                break
            }
        }
    }
    
    func fetchMoreStarredRepos (at indexPath: IndexPath, tableView: UITableView, tableFooterView: UIView, loadingSpinner: JGProgressHUD) {
        
        if indexPath.row == numberOfStarredCells - 1 {
            if pageNo < totalPages {
                pageNo += 1
                guard let user = passedUser else {return}
                NetworkingManger.shared.performRequest(dataModel: [Repository].self, requestData: GitRequestRouter.gitPublicUsersStarred(pageNo, user.userName), pagination: true) { [weak self]  (result) in
                    switch result {
                    case .success(let result):
                        DispatchQueue.main.async {
                            if result.isEmpty == false {
                                self?.starttedRepos.append(contentsOf: result)
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
    
    func saveRepoToBookmarks(at indexPath: IndexPath) {
        let saveRepoInfo = SavedRepositories(context: self.context)
        let repository = starttedRepos[indexPath.row]
            saveRepoInfo.repoName = repository.repositoryName
            saveRepoInfo.repoDescription = repository.repositoryDescription
            saveRepoInfo.repoProgrammingLanguage = repository.repositoryLanguage
            saveRepoInfo.repoUserFullName = repository.repoFullName
            saveRepoInfo.repoStars = Float(repository.repositoryStars ?? 0)
            saveRepoInfo.repoURL = repository.repositoryURL
    }
    
    func pushToDestnationVC(indexPath: IndexPath, navigationController: UINavigationController ) {
        let commitsView = CommitsViewController.instaintiate(on: .commitsView)
        commitsView.viewModel.repository = starttedRepositories
        navigationController.pushViewController(commitsView, animated: true)
    }
    
}
