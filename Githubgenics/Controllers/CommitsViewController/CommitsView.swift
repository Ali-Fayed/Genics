//
//  CommitsViewController.swift
//  Githubgenics
//
//  Created by Ali Fayed on 02/02/2021.
//

import UIKit

class CommitsViewController: UITableViewController {
    var commits: [Commit] = []
    var selectedRepository: UserRepository?
    let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50)) as UIActivityIndicatorView

    override func viewDidLoad() {
      super.viewDidLoad()
      loadingIndicator.center = view.center
      view.addSubview(loadingIndicator)
      fetchCommitsForRepository()
    }

    func fetchCommitsForRepository() {
      loadingIndicator.startAnimating()
      guard let repository = selectedRepository else {
        return
      }
        RepostoriesRouter().fetchCommits(for: repository.fullName) { [self] commits in
        self.commits = commits
        loadingIndicator.stopAnimating()
        tableView.reloadData()
      }

    }
  }
