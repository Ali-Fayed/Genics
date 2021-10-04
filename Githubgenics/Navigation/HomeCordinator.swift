//
//  HomeCordinator.swift
//  Githubgenics
//
//  Created by Ali Fayed on 04/10/2021.
//

import Foundation
import RxSwift
import UIKit

class HomeCordinator {
    enum HomeRouter {
        case users
        case searchUsers
        case repos
        case searchRepos
        case issues
        case searchIssues
        case githubWebSite
    }
    func pushTo (destination: HomeRouter, navigationController: UINavigationController, searchText: String) {
        switch destination {
        case .users:
            let usersView = UsersViewController.instaintiate(on: .usersView)
            navigationController.pushViewController(usersView, animated: true)
        case .searchUsers:
            let usersView = UsersViewController.instaintiate(on: .usersView)
            usersView.searchController.searchBar.text = searchText
            usersView.query = searchText
            navigationController.pushViewController(usersView, animated: true)
        case .repos:
            let reposView = RepositoriesViewController.instaintiate(on: .reposView)
            navigationController.pushViewController(reposView, animated: true)
        case .searchRepos:
            let reposView = RepositoriesViewController.instaintiate(on: .reposView)
            reposView.searchController.searchBar.text = searchText
            reposView.query = searchText
            navigationController.pushViewController(reposView, animated: true)
        case .issues:
            let issuesView = IssuesViewController.instaintiate(on: .issuesView)
            navigationController.pushViewController(issuesView, animated: true)
        case .searchIssues:
            let issuesView = IssuesViewController.instaintiate(on: .issuesView)
            issuesView.searchController.searchBar.text = searchText
            issuesView.query = searchText
            navigationController.pushViewController(issuesView, animated: true)
        case .githubWebSite:
            let gitHubWebVC = GithubViewController()
            gitHubWebVC.navigationItem.largeTitleDisplayMode = .never
            gitHubWebVC.navigationController?.navigationBar.prefersLargeTitles = false
            navigationController.pushViewController(gitHubWebVC, animated: true)
        }
    }
 
}
