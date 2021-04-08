//
//  UserRepositoryViewController.swift
//  Githubgenics
//
//  Created by Ali Fayed on 22/02/2021.
//

import UIKit
import JGProgressHUD

class UserRepositoryViewController: ViewSetups {

    @IBOutlet weak var tableView: UITableView!
    var repositoryModel = [Repository]()
    var savedRepos = [SavedRepositories]()
    var passedUser : items?
    var repository: Repository?
    override func viewDidLoad() {
        super.viewDidLoad()
        title = Titles.repositoriesViewTitle
        tableView.registerCellNib(cellClass: ReposCell.self)
        fetchRepos ()
        tableView.tableFooterView = tableFooterView
        tableView.addSubview(refreshControl)
    }
    
    override func viewDidLayoutSubviews() {
        conditionLabel.frame = CGRect(x: view.width/4, y: (view.height-200)/2, width: view.width/2, height: 200)
    }
    
    func fetchRepos () {
        if self.repositoryModel.isEmpty == true {
            loadingSpinner.show(in: view)
        }
        GitAPIcaller.shared.makeRequest(returnType: [Repository].self, requestData: GitRequestRouter.gitAuthenticatedUserRepositories) { [weak self] (repos) in
            self?.repositoryModel = repos
            self?.loadingSpinner.dismiss()
            self?.tableView.reloadData()
        }
    }
    
    func fetchMoreUserRepos (page: Int) {
        GitAPIcaller.shared.makeRequest(returnType: [Repository].self, requestData: GitRequestRouter.gitAuthenticatedUserRepositories, pagination: true) { [weak self]  (moreRepos) in
            DispatchQueue.main.async {
                if moreRepos.isEmpty == false {
                    self?.repositoryModel.append(contentsOf: moreRepos)
                    self?.tableView.reloadData()
                    self?.tableView.tableFooterView = nil
                } else {
                    self?.tableView.tableFooterView = nil
                }
            }
        }
    }
    
}

//MARK:- User Repos Table

extension UserRepositoryViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return repositoryModel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue() as ReposCell
        cell.CellData(with: repositoryModel[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
        
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = UIStoryboard.init(name: Storyboards.commitsView , bundle: Bundle.main).instantiateViewController(withIdentifier: ID.commitsViewControllerID) as? CommitsViewController
        vc?.viewModel.repository = repository
        self.navigationController?.pushViewController(vc!, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        repository = repositoryModel[indexPath.row]
        return indexPath
    }
    
}
