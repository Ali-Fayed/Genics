//
//  CommitsViewController.swift
//  Githubgenics
//
//  Created by Ali Fayed on 02/02/2021.
//

import UIKit
import JGProgressHUD
import SafariServices

class CommitsViewController: CommonViews {
    
    @IBOutlet var tableView: UITableView!
    lazy var viewModel: CommitsViewModel = {
       return CommitsViewModel()
   }()
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
        initViewModel()
    }
    func initView() {
        tableView.registerCellNib(cellClass: CommitsCell.self)
        tableView.addSubview(refreshControl)
        navigationItem.title = Titles.commitsViewTitle
        tableView.tableFooterView = UIView()
    }
    func initViewModel() {
        viewModel.fetchReposCommits(view: view, tableView: tableView, loadingSpinner: loadingSpinner)
    }
    override func willMove(toParent parent: UIViewController?) {
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        title = Titles.commitsViewTitle
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        refreshControl.endRefreshing()
        HapticsManger.shared.selectionVibrate(for: .soft)
    }
}
