//
//  BookmarkCordinator.swift
//  Githubgenics
//
//  Created by Ali Fayed on 17/10/2021.
//


import Foundation
import XCoordinator
import JGProgressHUD
import SafariServices
// make route has tab controller or navigation controller or a new root view controller
enum BookmarkRoute: Route {
    case bookmark
    case userSafariURL(indexPath: IndexPath)
    case repoSafariURL(indexPath: IndexPath)
    case shareRepo(indexPath: IndexPath)
    case shareUser(indexPath: IndexPath)
    case reposCommits(view: UIView, tableView: UITableView, loadingSpinner: JGProgressHUD, passedRepo: SavedRepositories)
}
class BookmarkCordinator: NavigationCoordinator<BookmarkRoute> {
    init() {
        super.init(initialRoute: .bookmark)
    }
    override func prepareTransition(for route: BookmarkRoute) -> NavigationTransition {
        switch route {
        case .bookmark:
            let viewController = BookmarksViewController.instaintiate(on: .tabBarView)
            viewController.router = unownedRouter
            return .push(viewController)
        case .userSafariURL(let indexPath):
            let viewController = BookmarksViewController.instaintiate(on: .tabBarView)
            let userURL = viewController.viewModel.getUsersViewModel(at: indexPath).userURL!
            let safariVC = SFSafariViewController(url: URL(string: userURL)!)
            return .present(safariVC)
        case .repoSafariURL(indexPath: let indexPath):
            let viewController = BookmarksViewController.instaintiate(on: .tabBarView)
            let repoURL = viewController.viewModel.getReposViewModel(at: indexPath)
            let safariVC = SFSafariViewController(url: URL(string: repoURL.repoURL!)!)
            return .present(safariVC)
        case .reposCommits(view: let view, tableView: let tableView, loadingSpinner: let loadingSpinner, passedRepo: let passedRepo):
            let commitsView = CommitsViewController.instaintiate(on: .commitsView)
            commitsView.viewModel.savedRepos = passedRepo
            commitsView.viewModel.renderCachedReposCommits(view: view, tableView: tableView, loadingSpinner: loadingSpinner)
            return .push(commitsView)
        case .shareRepo(indexPath: let indexPath):
            let viewController = BookmarksViewController.instaintiate(on: .tabBarView)
            let image = UIImage(systemName: "bell")
            let repoURL = viewController.viewModel.getReposViewModel(at: indexPath).repoURL
           let sheetVC = UIActivityViewController(activityItems: [image!,repoURL!], applicationActivities: nil)
           HapticsManger.shared.selectionVibrate(for: .medium)
            return .present(sheetVC)
        case .shareUser(indexPath: let indexPath):
            let viewController = BookmarksViewController.instaintiate(on: .tabBarView)
            let image = UIImage(systemName: "bell")
            let userURL = viewController.viewModel.getUsersViewModel(at: indexPath).userURL
           let sheetVC = UIActivityViewController(activityItems: [image!,userURL!], applicationActivities: nil)
           HapticsManger.shared.selectionVibrate(for: .medium)
            return .present(sheetVC)
        }
    }
}
