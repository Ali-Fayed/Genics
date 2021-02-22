//
//  CommitsViewMethods.swift
//  Githubgenics
//
//  Created by Ali Fayed on 11/02/2021.
//

import Foundation

extension CommitsViewController {
    
    func renderSearchedRepositoriesCommits() {
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
    
    func renderUserRepositoriesCommits() {
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
    
    func renderStartedReposCommits() {
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
}
