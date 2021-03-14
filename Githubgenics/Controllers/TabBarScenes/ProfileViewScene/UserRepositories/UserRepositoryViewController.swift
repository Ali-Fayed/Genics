//
//  UserCellDetailsController.swift
//  Githubgenics
//
//  Created by Ali Fayed on 22/02/2021.
//

import UIKit
import JGProgressHUD

class UserRepositoryViewController: UIViewController {
    
    // data model
    var repositories : Repository?
    var repository = [Repository]()
    // footer
    let footer = UIView ()
    // spinner
    let spinner = JGProgressHUD(style: .dark)

    // IBOutlets
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(handleRefresh(_:)), for: UIControl.Event.valueChanged)
        refreshControl.tintColor = UIColor.gray
        return refreshControl
    }()
    
    @IBOutlet weak var tableView: UITableView!
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        refreshControl.endRefreshing()
        HapticsManger.shared.selectionVibrate(for: .soft)
    }
    //MARK:- LifeCycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = Titles.repositoriesViewTitle
        tableView.registerCellNib(cellClass: ReposCell.self)
        // fetch user repos
        if self.repository.isEmpty == true {
            spinner.show(in: view)
        }
        GitAPIcaller.shared.makeRequest(returnType: [Repository].self, requestData: GitRequsetRouter.gitAuthenticatedUserRepositories, pagination: false) { [weak self] (repos) in
            self?.repository = repos
            self?.spinner.dismiss()
            self?.tableView.reloadData()
        }
        tableView.tableFooterView = footer
        // gestures
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        tableView.addSubview(refreshControl)
    }
    
}

//MARK:- User Repos Table

extension UserRepositoryViewController : UITableViewDataSource , UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return repository.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue() as ReposCell
        cell.CellData(with: repository[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = UIStoryboard.init(name: Storyboards.commits , bundle: Bundle.main).instantiateViewController(withIdentifier: ID.commitsViewControllerID) as? CommitsViewController
        vc?.repository = repositories
        self.navigationController?.pushViewController(vc!, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        repositories = repository[indexPath.row]
        return indexPath
    }
    
}
