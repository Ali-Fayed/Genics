//
//  UserRepositoryData.swift
//  Githubgenics
//
//  Created by Ali Fayed on 20/03/2021.
//

import UIKit
import JGProgressHUD

class UserRepositoryData: ViewSetups {
    
    // data models
    var repositoryModel = [Repository]()
    var savedRepos = [SavedRepositories]()
    var passedUser : items?
    var repository: Repository?
    let tableFooterView = UIView ()
    var pageNo : Int = 1
    var totalPages : Int = 100
    // userdefaults to cache user settings
    var starButton = [Int : Bool]()
    // persistentContainer context
    
    let noReposLabel : UILabel = {
        let label = UILabel()
        label.isHidden = true
        label.text = Titles.noRepos
        label.textAlignment = .center
        label.textColor = UIColor(named: "color")
        label.font = .systemFont(ofSize: 21, weight: .medium)
        return label
    }()
    
}

