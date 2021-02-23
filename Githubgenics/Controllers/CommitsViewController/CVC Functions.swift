//
//  CommitsViewMethods.swift
//  Githubgenics
//
//  Created by Ali Fayed on 11/02/2021.
//

import Foundation

extension CommitsViewController {
    
    // fetch all commits in all repos view
    func renderCommits() {
      loadingIndicator.startAnimating()
      guard let repository = repository else {
        return
      }
        GitAPIManger().APIcall(returnType: Commit.self, requestData: GitRouter.fetchCommits(repository.repoFullName), pagination: false) { [weak self] (commits) in
            self?.commits = commits
            self?.loadingIndicator.stopAnimating()
            self?.tableView.reloadData()
          }
    }
    
    // fetch db commits in all repos view
    func renderCachedReposCommits() {
      loadingIndicator.startAnimating()
      guard let repository = savedRepos else {
        return
      }
        GitAPIManger().APIcall(returnType: Commit.self, requestData: GitRouter.fetchCommits(repository.repoUserFullName ?? ""), pagination: false) { [weak self] (commits) in
            self?.commits = commits
            self?.loadingIndicator.stopAnimating()
            self?.tableView.reloadData()
          }
    }
}
