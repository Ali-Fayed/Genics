//
//  CommitsViewController.swift
//  Githubgenics
//
//  Created by Ali Fayed on 02/02/2021.
//

import UIKit

class CommitsViewController: UITableViewController {
    var commits: [Commit] = []
    var selectedRepository: Repository?
    let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50)) as UIActivityIndicatorView
    var selectedRepositorry: UserRepository?
    
    override func viewDidLoad() {
      super.viewDidLoad()
      loadingIndicator.center = view.center
      view.addSubview(loadingIndicator)
      fetchCommitsForRepository()
        fetchCommitsForRepository2()
        navigationItem.title = "Commits".localized()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationItem.title = "Commits".localized()
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true

    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false

    }

    func fetchCommitsForRepository() {
      loadingIndicator.startAnimating()
      guard let repository = selectedRepository else {
        return
      }
      GitAPIManager.shared.fetchCommits(for: repository.fullName) { [self] commits in
        self.commits = commits
        loadingIndicator.stopAnimating()
        tableView.reloadData()
      }
    }
    
    func fetchCommitsForRepository2() {
      loadingIndicator.startAnimating()
      guard let repository = selectedRepositorry else {
        return
      }
        RepostoriesRouter().fetchCommits(for: repository.fullName) { [self] commits in
        self.commits = commits
        loadingIndicator.stopAnimating()
        tableView.reloadData()
      }

    }
    
  }
