//
//  CommitsViewController.swift
//  Githubgenics
//
//  Created by Ali Fayed on 02/02/2021.
//

import UIKit
import JGProgressHUD
import SafariServices

class CommitsViewController: UIViewController {
    
    // data models
    var commits = [Commit]()
    var repository : Repository?
    var savedRepos : SavedRepositories?
    // loadin spinner
    let spinner = JGProgressHUD(style: .dark)
    // refresh
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(handleRefresh(_:)), for: UIControl.Event.valueChanged)
        refreshControl.tintColor = UIColor.gray
        return refreshControl
    }()
    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        renderCommits()
        tableView.registerCellNib(cellClass: CommitsCell.self)
        renderCachedReposCommits()
        tableView.addSubview(refreshControl)
        navigationItem.title = Titles.commitsViewTitle
        tableView.tableFooterView = UIView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationItem.title = Titles.commitsViewTitle
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
    
    // fetch all commits in all repos view
    func renderCommits() {
      guard let repository = repository else {
        return
      }
        if self.commits.isEmpty == true {
            spinner.show(in: view)
        }
        GitAPIManger().APIcall(returnType: Commit.self, requestData: GitRouter.fetchCommits(repository.repoFullName), pagination: false) { [weak self] (commits) in
            self?.commits = commits
            self?.spinner.dismiss()
            self?.tableView.reloadData()
          }
    }

    // fetch db commits in all repos view
    func renderCachedReposCommits() {
        if self.commits.isEmpty == true {
            spinner.show(in: view)
        }
      guard let repository = savedRepos else {
        return
      }
        GitAPIManger().APIcall(returnType: Commit.self, requestData: GitRouter.fetchCommits(repository.repoUserFullName ?? ""), pagination: false) { [weak self] (commits) in
            self?.commits = commits
            self?.spinner.dismiss()
            self?.tableView.reloadData()
          }
    }
    
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        refreshControl.endRefreshing()
        HapticsManger.shared.selectionVibrate(for: .soft)
    }
}

//MARK:- tableView

extension CommitsViewController: UITableViewDelegate, UITableViewDataSource {
  
   func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return commits.count
  }

   func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeue() as CommitsCell
    let commit = commits[indexPath.row]
    cell.CellData(with: commit)
    return cell
  }
  
   func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      tableView.deselectRow(at: indexPath, animated: true)
    let url = self.commits[indexPath.row].html_url
    let vc = SFSafariViewController(url: URL(string: url)!)
    self.present(vc, animated: true)
    
  }
}

