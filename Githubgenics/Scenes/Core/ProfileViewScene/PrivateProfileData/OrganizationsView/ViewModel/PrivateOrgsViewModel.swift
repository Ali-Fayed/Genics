//
//  UserOrgsViewModel.swift
//  Githubgenics
//
//  Created by Ali Fayed on 09/04/2021.
//

import UIKit
import JGProgressHUD

class PrivateOrgsViewModel {
    
    var orgsModel = [Orgs]()

    var numberOfOrgsCells: Int {
        return orgsModel.count
    }
    
    func getOrgsViewModel( at indexPath: IndexPath ) -> Orgs {
        return orgsModel[indexPath.row]
    }
        
    func fetchUserOrgs(tableView: UITableView , loadingSpinner: JGProgressHUD , view: UIView , conditionLabel: UILabel) {
        loadingSpinner.show(in: view)
        GitAPIcaller.shared.makeRequest(returnType: [Orgs].self, requestData: GitRequestRouter.gitAuthenticatedUserOrgs) { [weak self] (orgs) in
            self?.orgsModel = orgs
            loadingSpinner.dismiss()
            tableView.reloadData()
            if self?.orgsModel.isEmpty == true {
                tableView.isHidden = true
                conditionLabel.isHidden = false
            } else {
                tableView.isHidden = false
                conditionLabel.isHidden = true
            }
        }
    }
}
