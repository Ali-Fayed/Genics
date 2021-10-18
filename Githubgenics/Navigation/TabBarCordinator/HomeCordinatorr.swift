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
    case appRepoWeb
    case repoURL(indexPath: IndexPath)
    case shareRepo(indexPath: IndexPath)
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
            return .push(viewController)
        case .searchUsers(let searchText):
            let viewController = UsersViewController.instaintiate(on: .usersView)
            viewController.searchController.searchBar.text = searchText
            viewController.query = searchText
            return .push(viewController)
        case .repos:
            let viewController = RepositoriesViewController.instaintiate(on: .reposView)
            viewController.viewModel.router = unownedRouter
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
        case .appRepoWeb:
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
            commitsView.viewModel.routerr = unownedRouter
            let commitURL = commitsView.viewModel.getCommitViewModel(at: indexPath).commitURL
            let safariVC = SFSafariViewController(url: URL(string: commitURL)!)
            return .present(safariVC)
        case .repoURL(let indexPath):
            let viewController = RepositoriesViewController.instaintiate(on: .reposView)
            let repositoryURL = viewController.viewModel.getReposViewModel(at: indexPath).repositoryURL
            let safariVC = SFSafariViewController(url: URL(string: repositoryURL)!)
            return .present(safariVC)
        case .shareRepo(let indexPath):
            let viewController = RepositoriesViewController.instaintiate(on: .reposView)
            let image = UIImage(systemName: "bell")
            let repositoryURL = viewController.viewModel.getReposViewModel(at: indexPath).repositoryURL
           let sheetVC = UIActivityViewController(activityItems: [image!,repositoryURL], applicationActivities: nil)
           HapticsManger.shared.selectionVibrate(for: .medium)
            return .present(sheetVC)
        }
    }
}
