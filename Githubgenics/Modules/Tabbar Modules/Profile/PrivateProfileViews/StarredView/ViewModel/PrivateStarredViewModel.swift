//
//  PrivateStarredViewModel.swift
//  Githubgenics
//
//  Created by Ali Fayed on 09/04/2021.
//

import UIKit
import JGProgressHUD
import XCoordinator

class PrivateStarredViewModel {
    
    var starttedRepos = [Repository]()
    var starttedRepositories : Repository?
    var router: UnownedRouter<ProfileRoute>?

    var numberOfStarredCells: Int {
        return  starttedRepos.count
    }

    func getStarredViewModel( at indexPath: IndexPath ) -> Repository {
        return starttedRepos[indexPath.row]
    }
    
    func loadStarredRepos (tableView: UITableView, view: UIView, loadingSpinner: JGProgressHUD ) {
        loadingSpinner.show(in: view)
        NetworkingManger.shared.performRequest(dataModel: [Repository].self, requestData: GitRequestRouter.gitAuthenticatedUserStarred, pagination: false) { [weak self] (result) in
            switch result {
            case .success(let result):
                self?.starttedRepos = result
                loadingSpinner.dismiss()
                tableView.reloadData()
            case .failure(let error):
                CustomViews.shared.showAlert(message: error.localizedDescription, title: "Error")
                loadingSpinner.dismiss()
            }
        }
    }
    
    func pushToDestinationVC(indexPath: IndexPath,navigationController: UINavigationController ) {
        guard let starttedRepositories = starttedRepositories else {return}
        router?.trigger(.commits(repository: starttedRepositories))
    }
}
