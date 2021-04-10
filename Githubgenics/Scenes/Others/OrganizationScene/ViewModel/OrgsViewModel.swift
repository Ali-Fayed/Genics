//
//  OrgsViewModel.swift
//  Githubgenics
//
//  Created by Ali Fayed on 09/04/2021.
//

import UIKit
import JGProgressHUD

class OrgsViewModel {
    
    var passedUser : User?
    var orgsModel = [Orgs]()

    var numberOfOrgsCells: Int {
        return orgsModel.count
    }
    
    func getOrgsViewModel( at indexPath: IndexPath ) -> Orgs {
        return orgsModel[indexPath.row]
    }
    
    func fetchPublicUserOrgs (tableView: UITableView , loadingSpinner: JGProgressHUD , view: UIView) {
        guard let repository = passedUser else {return}
        loadingSpinner.show(in: view)
        GitAPIcaller.shared.makeRequest(returnType: [Orgs].self, requestData: GitRequestRouter.gitPublicUsersOrgs(repository.userName), pagination: true) { [weak self] (result) in
            DispatchQueue.main.async {
                self?.orgsModel = result
                tableView.reloadData()
                loadingSpinner.dismiss()
            }
        }
    }
}
