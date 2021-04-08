//
//  UserStarredViewController.swift
//  Githubgenics
//
//  Created by Ali Fayed on 22/02/2021.
//

import UIKit
import JGProgressHUD

class UserStarredViewController: ViewSetups {
    
    @IBOutlet weak var tableView: UITableView!
    // data model
    var starttedRepos = [Repository]()
    var starttedRepositories : Repository?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = Titles.starredViewTitle
        tableView.registerCellNib(cellClass: ReposCell.self)
        tableView.tableFooterView = tableFooterView
        tableView.addSubview(refreshControl)
        loadStarredRepos ()
        conditionLabel.text = Titles.noStarred
    }
    
    func loadStarredRepos () {
        loadingSpinner.show(in: view)
        GitAPIcaller.shared.makeRequest(returnType: [Repository].self, requestData: GitRequestRouter.gitAuthenticatedUserStarred, pagination: false) { [weak self] (started) in
            self?.starttedRepos = started
            self?.loadingSpinner.dismiss()
            self?.tableView.reloadData()
        }
    }
    
}

//MARK:- User Started Table

extension UserStarredViewController : UITableViewDataSource , UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return starttedRepos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue() as ReposCell
        let model = starttedRepos[indexPath.row]
        cell.CellData(with: model)
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = UIStoryboard.init(name: Storyboards.commitsView , bundle: Bundle.main).instantiateViewController(withIdentifier: ID.commitsViewControllerID) as? CommitsViewController
        vc?.viewModel.repository = starttedRepositories
        self.navigationController?.pushViewController(vc!, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        starttedRepositories = starttedRepos[indexPath.row]
        return indexPath
    }
    
}
