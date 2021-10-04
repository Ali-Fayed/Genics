//
//  PrivateStarredViewModel.swift
//  Githubgenics
//
//  Created by Ali Fayed on 09/04/2021.
//

import UIKit
import JGProgressHUD

class PrivateStarredViewModel {
    
    var starttedRepos = [Repository]()
    var starttedRepositories : Repository?
    
    var numberOfStarredCells: Int {
        return  starttedRepos.count
    }

    func getStarredViewModel( at indexPath: IndexPath ) -> Repository {
        return starttedRepos[indexPath.row]
    }
    
    func loadStarredRepos (tableView: UITableView, view: UIView, loadingSpinner: JGProgressHUD ) {
        loadingSpinner.show(in: view)
        GitAPIcaller.makeRequest(dataModel: [Repository].self, requestData: GitRequestRouter.gitAuthenticatedUserStarred, pagination: false) { [weak self] (started) in
            self?.starttedRepos = started
            loadingSpinner.dismiss()
            tableView.reloadData()
        }
    }
    
    func pushToDestinationVC(indexPath: IndexPath,navigationController: UINavigationController ) {
        let commitsView = CommitsViewController.instaintiate(on: .commitsView)
        commitsView.viewModel.repository = starttedRepositories
        navigationController.pushViewController(commitsView, animated: true)
    }
}
