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
        NetworkingManger.shared.performRequest(dataModel: [Orgs].self, requestData: GitRequestRouter.gitAuthenticatedUserOrgs) { [weak self] (result) in
            switch result {
            case .success(let result):
                self?.orgsModel = result
                loadingSpinner.dismiss()
                tableView.reloadData()
                if self?.orgsModel.isEmpty == true {
                    tableView.isHidden = true
                    conditionLabel.isHidden = false
                } else {
                    tableView.isHidden = false
                    conditionLabel.isHidden = true
                }
            case .failure(let error):
                break
            }
        }
    }
}
