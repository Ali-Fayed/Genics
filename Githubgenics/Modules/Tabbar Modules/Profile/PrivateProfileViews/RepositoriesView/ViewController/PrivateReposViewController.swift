//
//  PrivateReposViewController.swift
//  Githubgenics
//
//  Created by Ali Fayed on 22/02/2021.
//

import UIKit
import JGProgressHUD

class PrivateReposViewController: CommonViews {

    @IBOutlet weak var tableView: UITableView!

    lazy var viewModel: PrivateReposViewModel = {
       return PrivateReposViewModel()
   }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
         initView()
         initViewModel()
    }
    
    override func viewDidLayoutSubviews() {
        conditionLabel.frame = CGRect(x: view.width/4, y: (view.height-200)/2, width: view.width/2, height: 200)
    }
    
    func initView() {
        title = Titles.repositoriesViewTitle
        tableView.registerCellNib(cellClass: ReposTableViewCell.self)
        tableView.tableFooterView = tableFooterView
        tableView.addSubview(refreshControl)
    }
    
    func initViewModel () {
        viewModel.fetchRepos(tableView: tableView, loadingSpinner: loadingSpinner, view: view)
    }
    
}
