//
//  ReposViewModel.swift
//  Githubgenics
//
//  Created by Ali Fayed on 08/04/2021.
//

import UIKit
import JGProgressHUD

class ReposViewModel {
    
    var publicRepositories = [Repository]()
    var selectedRepository: Repository?
    var savedRepositories = [SavedRepositories]()
    var pageNo : Int = 1
    var totalPages : Int = 100
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    var numberOfReposCell: Int {
        return publicRepositories.count
    }
    
    func getReposViewModel( at indexPath: IndexPath ) -> Repository {
        return publicRepositories[indexPath.row]
    }
    func searchRepositories (tableView: UITableView, loadingSpinner: JGProgressHUD, query: String, page: Int, view: UIView) {
        if publicRepositories.isEmpty {
            loadingSpinner.show(in: view)
        }
        GitAPIcaller.shared.makeRequest(returnType: Repositories.self, requestData: GitRequestRouter.gitPublicRepositories(page, query)) { [weak self] (repositories) in
            self?.publicRepositories = repositories.items
            loadingSpinner.dismiss()
            tableView.reloadData()
        }
    }
        
    func renderAndDisplayBestSwiftRepositories(view: UIView, tableView: UITableView, loadingSpinner: JGProgressHUD) {
        if publicRepositories.isEmpty {
            loadingSpinner.show(in: view)
        }
        GitAPIcaller.shared.makeRequest(returnType: Repositories.self, requestData: GitRequestRouter.gitPublicRepositories(pageNo, "language:Swift")) { [weak self] (repos) in
            self?.publicRepositories = repos.items
            loadingSpinner.dismiss()
            tableView.reloadData()
        }
    }
    
    func query (searchText : String? ) -> String {
        let query : String = {
            var queryString = String()
            if let searchText = searchText {
                queryString = searchText.isEmpty ? "language:Swift" : searchText
            }
            return queryString
        }()
        return query
    }
    
    func pushWithData (navigationController: UINavigationController) {
        let vc = UIStoryboard.init(name: Storyboards.commitsView , bundle: Bundle.main).instantiateViewController(withIdentifier: ID.commitsViewControllerID) as? CommitsViewController
        vc?.viewModel.repository = selectedRepository
        navigationController.pushViewController(vc!, animated: true)
    }
    
    func fetchMoreCells (tableView: UITableView, loadingSpinner: JGProgressHUD, indexPath: IndexPath, searchController: UISearchController) {
        if indexPath.row == numberOfReposCell - 1 {
            if pageNo < totalPages {
                pageNo += 1
                let searchText = searchController.searchBar.text
               let queryText = query(searchText: searchText)
                GitAPIcaller.shared.makeRequest(returnType: Repositories.self, requestData: GitRequestRouter.gitPublicRepositories(pageNo, queryText), pagination: true) { [weak self]  (moreRepos) in
                    DispatchQueue.main.async {
                        if moreRepos.items.isEmpty == false {
                            self?.publicRepositories.append(contentsOf: moreRepos.items)
                            tableView.reloadData()
                            tableView.tableFooterView = nil
                        } else {
                            tableView.tableFooterView = nil
                        }
                    }
                }
                
            }
        }
    }
    
    func saveRepos(indexPath: IndexPath) {
        let saveRepoInfo = SavedRepositories(context: self.context)
        let repository = self.getReposViewModel(at: indexPath)
        saveRepoInfo.repoName = repository.repositoryName
        saveRepoInfo.repoDescription = repository.repositoryDescription
        saveRepoInfo.repoProgrammingLanguage = repository.repositoryLanguage
        saveRepoInfo.repoUserFullName = repository.repoFullName
        saveRepoInfo.repoStars = Float(repository.repositoryStars ?? 0)
        saveRepoInfo.repoURL = repository.repositoryURL
        try! self.context.save()
    }
}
