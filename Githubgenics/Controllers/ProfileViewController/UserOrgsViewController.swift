//
//  UserOrgsSegue.swift
//  Githubgenics
//
//  Created by Ali Fayed on 22/02/2021.
//

import UIKit

class UserOrgsViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var organization = [Orgs]()
    let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50)) as UIActivityIndicatorView
    let footer = UIView ()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = Titles.Organizations
        renderAndDisplayUserOrgs()
        tableView.tableFooterView = footer
        view.addSubview(noORgsLabel)
        if organization.isEmpty == true {
            tableView.isHidden = true
            noORgsLabel.isHidden = false
   
        } else {
            tableView.isHidden = false
            noORgsLabel.isHidden = true
        }
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }
    
    let noORgsLabel: UILabel = {
       let label = UILabel()
       label.isHidden = true
        label.text = Titles.noOrgs
       label.textAlignment = .center
       label.textColor = UIColor(named: "color")
       label.font = .systemFont(ofSize: 21, weight: .medium)
       return label
   }()
    
    override func viewDidLayoutSubviews() {
        noORgsLabel.frame = CGRect(x: view.width/4,
                                      y: (view.height-200)/2,
                                      width: view.width/2,
                                      height: 200)
    }

    func renderAndDisplayUserOrgs() {
        loadingIndicator.startAnimating()
        GitAPIManger().APIcall(returnType: Orgs.self, requestData: GitRouter.gitOrgs, pagination: false) { [weak self] (orgs) in
            self?.organization = orgs
            self?.loadingIndicator.stopAnimating()
            self?.tableView.reloadData()
        }
    }
 

}

//MARK:- User Orgs Table

extension UserOrgsViewController : UITableViewDataSource , UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return organization.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = organization[indexPath.row].orgName
        cell.detailTextLabel?.text = organization[indexPath.row].orgDescription
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
}
