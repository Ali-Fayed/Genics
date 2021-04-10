//
//  UserOrgsViewController.swift
//  Githubgenics
//
//  Created by Ali Fayed on 09/04/2021.
//

import UIKit

class PrivateOrgsViewController: ViewSetups {

    @IBOutlet weak var tableView: UITableView!
    
    lazy var viewModel: PrivateOrgsViewModel = {
       return PrivateOrgsViewModel()
   }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView ()
        initViewModel()
    }
    
    override func viewDidLayoutSubviews() {
        conditionLabel.frame = CGRect(x: view.width/4, y: (view.height-200)/2, width: view.width/2, height: 200)
    }
    
    func initView () {
        title = Titles.organizationsViewTitle
        tableView.tableFooterView = tableFooterView
        tableView.addSubview(refreshControl)
        view.addSubview(conditionLabel)
        conditionLabel.text = Titles.noOrgs
    }
    
    func initViewModel() {
        viewModel.fetchUserOrgs(tableView: self.tableView, loadingSpinner: loadingSpinner, view: view, conditionLabel: conditionLabel)
    }
              
}
