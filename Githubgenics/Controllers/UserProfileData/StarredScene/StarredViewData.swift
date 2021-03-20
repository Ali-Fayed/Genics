//
//  StarredViewData.swift
//  Githubgenics
//
//  Created by Ali Fayed on 20/03/2021.
//

import UIKit
import JGProgressHUD

class UserStarredViewData: UIViewController {
    
    // data model
    var starttedRepos = [Repository]()
    var starttedRepositories : Repository?
    var passedUser: items?
    var pageNo : Int = 1
    var totalPages : Int = 100
    let tableViewFooter = UIView ()
    let spinner = JGProgressHUD(style: .dark)
    var starButton = [Int : Bool]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        refreshControl.endRefreshing()
        HapticsManger.shared.selectionVibrate(for: .soft)
    }
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(handleRefresh(_:)), for: UIControl.Event.valueChanged)
        refreshControl.tintColor = UIColor.gray
        return refreshControl
    }()
    let noStarredReposLabel: UILabel = {
        let label = UILabel()
        label.isHidden = true
        label.text = Titles.noStartted
        label.textAlignment = .center
        label.textColor = UIColor(named: "color")
        label.font = .systemFont(ofSize: 21, weight: .medium)
        return label
    }()
}
