//
//  OrgsViewModel.swift
//  Githubgenics
//
//  Created by Ali Fayed on 09/04/2021.
//

import UIKit
import JGProgressHUD
import XCoordinator

class OrgsViewModel {
    
    var passedUser : User?
    var orgsModel = [Orgs]()
    var router: UnownedRouter<PublicProfileRoute>?
    var numberOfOrgsCells: Int {
        return orgsModel.count
    }
    
    func getOrgsViewModel( at indexPath: IndexPath ) -> Orgs {
        return orgsModel[indexPath.row]
    }
    
    func fetchPublicUserOrgs (tableView: UITableView , loadingSpinner: JGProgressHUD , view: UIView) {
        guard let repository = passedUser else {return}
        loadingSpinner.show(in: view)
        NetworkingManger.shared.performRequest(dataModel: [Orgs].self, requestData: GitRequestRouter.gitPublicUsersOrgs(repository.userName), pagination: true) { [weak self] (result) in
            switch result {
            case .success(let result):
                DispatchQueue.main.async {
                    self?.orgsModel = result
                    tableView.reloadData()
                    loadingSpinner.dismiss()
                }
            case .failure(let error):
                CustomViews.shared.showAlert(message: error.localizedDescription, title: "Error")
                loadingSpinner.dismiss()
            }
        }
    }
}
