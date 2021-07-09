//
//  TableViewCell.swift
//  Githubgenics
//
//  Created by Ali Fayed on 11/02/2021.
//

import UIKit

class SignOutCell: UITableViewCell {
    
    @IBOutlet weak var logOut: UILabel!
    
    var isLoggedIn: Bool {
        if GitTokenManager.shared.fetchAccessToken() != nil {
            return true
        }
        return false
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        if isLoggedIn {
            logOut.text = Titles.logOut
        } else {
            logOut.text = Titles.signInWithGithubTitle
        }
    }
}
