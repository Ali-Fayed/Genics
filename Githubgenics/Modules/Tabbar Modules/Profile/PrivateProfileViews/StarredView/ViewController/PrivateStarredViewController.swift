//
//  PrivateStarredViewController.swift
//  Githubgenics
//
//  Created by Ali Fayed on 22/02/2021.
//

import UIKit
import JGProgressHUD

class PrivateStarredViewController: CommonViews {
    
    @IBOutlet weak var tableView: UITableView!
    
    lazy var viewModel: PrivateStarredViewModel = {
       return PrivateStarredViewModel()
   }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
        initViewModel()
    }
    
    func initView() {
        title = Titles.starredViewTitle
        tableView.registerCellNib(cellClass: ReposTableViewCell.self)
        tableView.tableFooterView = tableFooterView
        tableView.addSubview(refreshControl)
        conditionLabel.text = Titles.noStarred
    }
    
    func initViewModel () {
        viewModel.loadStarredRepos(tableView: tableView, view: view, loadingSpinner: loadingSpinner)
    }
        
}
