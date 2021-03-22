//
//  CommitsViewController.swift
//  Githubgenics
//
//  Created by Ali Fayed on 02/02/2021.
//

import UIKit
import JGProgressHUD
import SafariServices

class CommitsViewController: ViewSetups {
    
    var commits = [Commit]()
    var repository : Repository?
    var savedRepos : SavedRepositories?

    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.registerCellNib(cellClass: CommitsCell.self)
        tableView.addSubview(refreshControl)
        navigationItem.title = Titles.commitsViewTitle
        tableView.tableFooterView = UIView()
        fetchReposCommits () 
    }
    
    override func willMove(toParent parent: UIViewController?) {
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        title = Titles.commitsViewTitle
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    func searchCommitsFetch () {
        loadingSpinner.show(in: view)
        GitAPIcaller.shared.makeRequest(returnType: [Commit].self, requestData: GitRequestRouter.gitSearchCommits(1, "v"), pagination: false) { [weak self] (commits) in
            self?.commits = commits
            self?.loadingSpinner.dismiss()
            self?.tableView.reloadData()
        }
    }
    
    // fetch all commits in all repos view
    func fetchReposCommits () {
        guard let repository = repository else {
            return
        }
        if self.commits.isEmpty == true {
            loadingSpinner.show(in: view)
        }
        GitAPIcaller.shared.makeRequest(returnType: [Commit].self, requestData: GitRequestRouter.gitRepositoriesCommits(pageNo, repository.repoFullName), pagination: false) { [weak self] (commits) in
            self?.commits = commits
            self?.loadingSpinner.dismiss()
            self?.tableView.reloadData()
        }
    }
    
    // fetch db commits in all repos view
    func renderCachedReposCommits() {
        if self.commits.isEmpty == true {
            loadingSpinner.show(in: view)
        }
        guard let repository = savedRepos else {
            return
        }
        GitAPIcaller.shared.makeRequest(returnType: [Commit].self, requestData: GitRequestRouter.gitRepositoriesCommits(pageNo, repository.repoUserFullName ?? "")) { [weak self] (commits) in
            self?.commits = commits
            self?.loadingSpinner.dismiss()
            self?.tableView.reloadData()
        }
    }
    
    func fetchMoreCommits (page: Int) {
        guard let repository = repository else {
            return
        }
        GitAPIcaller.shared.makeRequest(returnType: [Commit].self, requestData: GitRequestRouter.gitRepositoriesCommits(pageNo, repository.repoFullName), pagination: true) { [weak self] (moreCommits) in
            DispatchQueue.main.async {
                if moreCommits.isEmpty == false {
                    self?.commits.append(contentsOf: moreCommits)
                    self?.tableView.reloadData()
                    self?.tableView.tableFooterView = nil
                } else {
                    self?.tableView.tableFooterView = self?.tableFooterView
                }
            }
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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        // fetch more
        if indexPath.row == commits.count - 1 {
            showTableViewSpinner()
            if pageNo < totalPages {
                pageNo += 1
                fetchMoreCommits(page: pageNo)
            }
        }
    }
    
    func showTableViewSpinner () {
        let spinner = UIActivityIndicatorView(style: .medium)
        spinner.startAnimating()
        spinner.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: tableView.bounds.width, height: CGFloat(44))
        self.tableView.tableFooterView = spinner
        self.tableView.tableFooterView?.isHidden = false
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let url = self.commits[indexPath.row].html_url
        let vc = SFSafariViewController(url: URL(string: url)!)
        self.present(vc, animated: true)
        
    }
}
