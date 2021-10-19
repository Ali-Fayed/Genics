//
//  HomeCordinatorr.swift
//  Githubgenics
//
//  Created by Ali Fayed on 17/10/2021.
//


import Foundation
import XCoordinator
import SafariServices
// make route has tab controller or navigation controller or a new root view controller
enum HomeRoute: Route {
    case home
    case users
    case repos
    case issues
    case searchUsers(serachText: String)
    case searchRepos(serachText: String)
    case searchIssues(serachText: String)
    case githubWebSite
    case appRepoWeb
}
class HomeCoordinator: NavigationCoordinator<HomeRoute> {
    init() {
        super.init(initialRoute: .home)
    }
    override func prepareTransition(for route: HomeRoute) -> NavigationTransition {
        switch route {
        case .home:
            let viewController = HomeViewController.instaintiate(on: .tabBarView)
            viewController.viewModel.router = strongRouter
            return .push(viewController)
        case .users:
            let userCoordinator = UserListCoordinaotr()
            userCoordinator.rootViewController.modalPresentationStyle = .fullScreen
            userCoordinator.rootViewController.navigationBar.prefersLargeTitles = true
            userCoordinator.rootViewController.navigationItem.largeTitleDisplayMode = .always
            return .present(userCoordinator)
        case .repos:
            let reposCoordinator = ReposListCoordinaotr()
            reposCoordinator.rootViewController.modalPresentationStyle = .fullScreen
            reposCoordinator.rootViewController.navigationBar.prefersLargeTitles = true
            reposCoordinator.rootViewController.navigationItem.largeTitleDisplayMode = .always
            return .present(reposCoordinator)
        case .issues:
            let issuesCoordinator = IssuesCoordinaotr()
            issuesCoordinator.rootViewController.modalPresentationStyle = .fullScreen
            issuesCoordinator.rootViewController.navigationBar.prefersLargeTitles = true
            issuesCoordinator.rootViewController.navigationItem.largeTitleDisplayMode = .always
            return .present(issuesCoordinator)
        case .searchUsers(let searchText):
            let viewController = UsersViewController.instaintiate(on: .usersView)
            viewController.searchController.searchBar.text = searchText
            viewController.query = searchText
            return .push(viewController)
        case .searchRepos(let searchText):
            let viewController = RepositoriesViewController.instaintiate(on: .reposView)
            viewController.searchController.searchBar.text = searchText
            viewController.query = searchText
            return .push(viewController)
        case .searchIssues(let searchText):
            let viewController = IssuesViewController.instaintiate(on: .issuesView)
            viewController.searchController.searchBar.text = searchText
            viewController.query = searchText
            return .push(viewController)
        case .githubWebSite:
            let gitHubWebVC = GithubViewController()
            gitHubWebVC.navigationItem.largeTitleDisplayMode = .never
            gitHubWebVC.navigationController?.navigationBar.prefersLargeTitles = false
            return .present(gitHubWebVC)
        case .appRepoWeb:
            let repoURL = "https://github.com/Ali-Fayed/Githubgenics"
            let repoVC = SFSafariViewController(url: URL(string: repoURL)!)
            return .present(repoVC)
        }
    }
}
