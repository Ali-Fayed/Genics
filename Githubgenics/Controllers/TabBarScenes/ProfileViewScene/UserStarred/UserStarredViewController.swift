//
//  UserStartedSegue.swift
//  Githubgenics
//
//  Created by Ali Fayed on 22/02/2021.
//

import UIKit
import JGProgressHUD

class UserStarredViewController: UIViewController {
    
    // data model
    var starttedRepos = [Repository]()
    var starttedRepositories : Repository?
    let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50)) as UIActivityIndicatorView
    let footer = UIView ()
    let spinner = JGProgressHUD(style: .dark)

    // IBOutlets
    @IBOutlet weak var tableView: UITableView!
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(handleRefresh(_:)), for: UIControl.Event.valueChanged)
        refreshControl.tintColor = UIColor.gray
        return refreshControl
    }()
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        refreshControl.endRefreshing()
        HapticsManger.shared.selectionVibrate(for: .soft)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.registerCellNib(cellClass: ReposCell.self)
        // load started
        if self.starttedRepos.isEmpty == true {
            spinner.show(in: view)
        }
        GitAPIcaller.shared.makeRequest(returnType: [Repository].self, requestData: GitRequsetRouter.gitAuthenticatedUserStarred, pagination: false) { [weak self] (started) in
            self?.starttedRepos = started
            self?.spinner.dismiss()
            self?.tableView.reloadData()
        }
        // title
        title = Titles.Starred
        // footer
        tableView.tableFooterView = footer
        // gesture back
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        tableView.addSubview(refreshControl)
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
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = UIStoryboard.init(name: Storyboards.commits , bundle: Bundle.main).instantiateViewController(withIdentifier: ID.commitsViewControllerID) as? CommitsViewController
        vc?.repository = starttedRepositories
        self.navigationController?.pushViewController(vc!, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        starttedRepositories = starttedRepos[indexPath.row]
        return indexPath
    }
    
}
