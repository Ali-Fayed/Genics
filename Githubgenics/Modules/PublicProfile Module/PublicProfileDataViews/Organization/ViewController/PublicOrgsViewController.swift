//
//  OrgsViewController.swift
//  Githubgenics
//
//  Created by Ali Fayed on 22/02/2021.
//

import UIKit

class PublicOrgsViewController: ViewSetups {
    
    @IBOutlet weak var tableView: UITableView!
    
    lazy var viewModel: OrgsViewModel = {
       return OrgsViewModel()
   }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView ()
        initViewModel ()
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
    
    func initViewModel () {
        viewModel.fetchPublicUserOrgs(tableView: self.tableView, loadingSpinner: loadingSpinner, view: view)
    }
              
    func orgsEmptyHandling () {
        if viewModel.orgsModel.isEmpty == true {
            tableView.isHidden = true
            conditionLabel.isHidden = false
        } else {
            tableView.isHidden = false
            conditionLabel.isHidden = true
        }
    }

}
