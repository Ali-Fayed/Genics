//
//  OrgsViewController.swift
//  Githubgenics
//
//  Created by Ali Fayed on 22/02/2021.
//

import UIKit
import JGProgressHUD


class OrgsViewController: ViewSetups {
    
    var passedUser : items?
    var orgsModel = [Orgs]()
    @IBOutlet weak var tableView: UITableView!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        title = Titles.organizationsViewTitle
        tableView.tableFooterView = tableFooterView
        tableView.addSubview(refreshControl)
        view.addSubview(conditionLabel)
        conditionLabel.text = Titles.noOrgs
    }
      
    override func viewDidLayoutSubviews() {
        conditionLabel.frame = CGRect(x: view.width/4, y: (view.height-200)/2, width: view.width/2, height: 200)
    }
    
    func fetchOrgsList () {
        loadingSpinner.show(in: view)
        GitAPIcaller.shared.makeRequest(returnType: [Orgs].self, requestData: GitRequestRouter.gitListOrgs(30, 30)) { [weak self] (result) in
            DispatchQueue.main.async {
                self?.orgsModel = result
                self?.tableView.reloadData()
                self?.loadingSpinner.dismiss()
                self?.orgsEmptyHandling ()
            }
        }
    }
    
    func fetchUserOrgs() {
        loadingSpinner.show(in: view)
        GitAPIcaller.shared.makeRequest(returnType: [Orgs].self, requestData: GitRequestRouter.gitAuthenticatedUserOrgs) { [weak self] (orgs) in
            self?.orgsModel = orgs
            self?.loadingSpinner.dismiss()
            self?.tableView.reloadData()
            self?.orgsEmptyHandling ()
        }
    }
    
    func fetchPublicUserOrgs () {
        guard let repository = passedUser else {return}
        loadingSpinner.show(in: view)
        GitAPIcaller.shared.makeRequest(returnType: [Orgs].self, requestData: GitRequestRouter.gitPublicUsersOrgs(repository.userName), pagination: true) { [weak self] (result) in
            DispatchQueue.main.async {
                self?.orgsModel = result
                self?.tableView.reloadData()
                self?.loadingSpinner.dismiss()
                self?.orgsEmptyHandling ()
            }
        }
    }
    
    func orgsEmptyHandling () {
        if orgsModel.isEmpty == true {
            tableView.isHidden = true
            conditionLabel.isHidden = false
        } else {
            tableView.isHidden = false
            conditionLabel.isHidden = true
        }
    }

}

extension OrgsViewController : UITableViewDataSource , UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orgsModel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = orgsModel[indexPath.row].orgName
        cell.detailTextLabel?.text = orgsModel[indexPath.row].orgDescription
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}
