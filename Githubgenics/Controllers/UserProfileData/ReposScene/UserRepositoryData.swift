//
//  UserRepositoryData.swift
//  Githubgenics
//
//  Created by Ali Fayed on 20/03/2021.
//

import UIKit
import JGProgressHUD

class UserRepositoryData: UIViewController {
    
    // data models
    var repositoryModel = [Repository]()
    var savedRepos = [SavedRepositories]()
    var passedUser : items?
    var repository: Repository?
    let tableFooterView = UIView ()
    let spinner = JGProgressHUD(style: .dark)
    var pageNo : Int = 1
    var totalPages : Int = 100
    // userdefaults to cache user settings
    var starButton = [Int : Bool]()
    // persistentContainer context
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    //

    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(handleRefresh(_:)), for: UIControl.Event.valueChanged)
        refreshControl.tintColor = UIColor.gray
        return refreshControl
    }()
    
    let noReposLabel : UILabel = {
        let label = UILabel()
        label.isHidden = true
        label.text = Titles.noRepos
        label.textAlignment = .center
        label.textColor = UIColor(named: "color")
        label.font = .systemFont(ofSize: 21, weight: .medium)
        return label
    }()
    
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        refreshControl.endRefreshing()
        HapticsManger.shared.selectionVibrate(for: .soft)
    }

}

