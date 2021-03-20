//
//  OrgsViewController.swift
//  Githubgenics
//
//  Created by Ali Fayed on 22/02/2021.
//

import UIKit
import JGProgressHUD


class OrgsViewController: OrgsViewData {
    
    var passedUser : items?

    @IBOutlet weak var tableView: UITableView!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        title = Titles.Organizations
        tableView.tableFooterView = tableFooterView
        tableView.addSubview(refreshControl)
        view.addSubview(noOrgsLabel)
    }
      
    override func viewDidLayoutSubviews() {
        noOrgsLabel.frame = CGRect(x: view.width/4, y: (view.height-200)/2, width: view.width/2, height: 200)
    }
    
    func fetchOrgsList () {
        spinner.show(in: view)
        GitAPIcaller.shared.makeRequest(returnType: [Orgs].self, requestData: GitRequestRouter.gitListOrgs(30, 30)) { [weak self] (result) in
            DispatchQueue.main.async {
                self?.organization = result
                self?.tableView.reloadData()
                self?.spinner.dismiss()
                self?.orgsEmptyHandling(tableView: self!.tableView)
            }
        }
    }
    
    func fetchUserOrgs() {
        spinner.show(in: view)
        GitAPIcaller.shared.makeRequest(returnType: [Orgs].self, requestData: GitRequestRouter.gitAuthenticatedUserOrgs) { [weak self] (orgs) in
            self?.organization = orgs
            self?.spinner.dismiss()
            self?.tableView.reloadData()
            self?.orgsEmptyHandling(tableView: self!.tableView)
        }
    }
    
    func fetchPublicUserOrgs () {
        guard let repository = passedUser else {return}
            spinner.show(in: view)
        GitAPIcaller.shared.makeRequest(returnType: [Orgs].self, requestData: GitRequestRouter.gitPublicUsersOrgs(repository.userName), pagination: true) { [weak self] (result) in
            DispatchQueue.main.async {
                self?.organization = result
                self?.tableView.reloadData()
                self?.spinner.dismiss()
                self?.orgsEmptyHandling(tableView: self!.tableView)
            }
        }
    }

}
