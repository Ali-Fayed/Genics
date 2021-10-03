//
//  HomeCellViewModel.swift
//  Githubgenics
//
//  Created by Ali Fayed on 07/04/2021.
//

import UIKit

class HomeTableViewCell: UITableViewCell {
    var isLoggedIn: Bool {
        if TokenManager.shared.fetchAccessToken() != nil {
            return true
        }
        return false
    }
    func getData(model: ProfileTableData) {
        textLabel?.text = model.cellHeader
        imageView?.image = UIImage(named: model.image)
        imageView?.clipsToBounds = true
        imageView?.layer.cornerRadius = 10
        accessoryType = .disclosureIndicator
    }
    func getSeconSectionData () {
        textLabel?.text = "Githubgenics"
        detailTextLabel?.text = "Ali-Fayed"
        imageView?.image = UIImage(named: "ali")
        imageView?.clipsToBounds = true
        imageView?.layer.cornerRadius = 10
        accessoryType = .disclosureIndicator
    }
    func getThirdSectionData () {
        textLabel?.text = isLoggedIn ? Titles.authenticatedModeTitle : Titles.guestModeTitle
        accessoryType = .none
    }
}
