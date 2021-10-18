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
    case commits(selectedRepository: Repository)
    case commitsURL(indexPath: IndexPath)
    case issues
    case searchUsers(serachText: String)
    case searchRepos(serachText: String)
    case searchIssues(serachText: String)
    case githubWebSite
    case repoWeb
}
class HomeCoordinator: NavigationCoordinator<HomeRoute> {
    init() {
        super.init(initialRoute: .home)
    }
    override func prepareTransition(for route: HomeRoute) -> NavigationTransition {
        switch route {
        case .home:
            let viewController =  HomeViewController.instaintiate(on: .tabBarView)
            viewController.viewModel.router = unownedRouter
            return .push(viewController)
        case .users:
            let viewController = UserCordinaotr()
            viewController.rootViewController.modalPresentationStyle = .fullScreen
            viewController.rootViewController.navigationBar.prefersLargeTitles = true
            viewController.rootViewController.navigationItem.largeTitleDisplayMode = .always
            return .present(viewController)
        case .searchUsers(let searchText):
            let viewController = UsersViewController.instaintiate(on: .usersView)
            viewController.searchController.searchBar.text = searchText
            viewController.query = searchText
            return .push(viewController)
        case .repos:
            let viewController = RepositoriesViewController.instaintiate(on: .reposView)
            return .push(viewController)
        case .searchRepos(let searchText):
            let viewController = RepositoriesViewController.instaintiate(on: .reposView)
            viewController.searchController.searchBar.text = searchText
            viewController.query = searchText
            return .push(viewController)
        case .issues:
            let viewController = IssuesViewController.instaintiate(on: .issuesView)
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
            return .push(gitHubWebVC)
        case .repoWeb:
            let repoURL = "https://github.com/Ali-Fayed/Githubgenics"
            let repoVC = SFSafariViewController(url: URL(string: repoURL)!)
            return .push(repoVC)
        case .commits(let selectedRepository):
            let viewController = CommitsViewController.instaintiate(on: .commitsView)
            viewController.viewModel.routerr = unownedRouter
            viewController.viewModel.repository = selectedRepository
            return .push(viewController)
        case .commitsURL(let indexPath):
            let commitsView = CommitsViewController.instaintiate(on: .commitsView)
            let commitURL = commitsView.viewModel.getCommitViewModel(at: indexPath).commitURL
            let safariVC = SFSafariViewController(url: URL(string: commitURL)!)
            return .present(safariVC)
        }
    }
}
