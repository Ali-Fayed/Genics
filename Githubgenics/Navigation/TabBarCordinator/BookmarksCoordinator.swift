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
    case userSafariURL(userURL: String)
    case repoSafariURL(repoURL: String)
    case shareRepo(repoURL: String)
    case shareUser(userURL: String)
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
        case .userSafariURL(let userURL):
            let safariVC = SFSafariViewController(url: URL(string: userURL)!)
            return .present(safariVC)
        case .repoSafariURL(let repoURL):
            let safariVC = SFSafariViewController(url: URL(string: repoURL)!)
            return .present(safariVC)
        case .reposCommits(view: let view, tableView: let tableView, loadingSpinner: let loadingSpinner, passedRepo: let passedRepo):
            let commitsView = CommitsViewController.instaintiate(on: .commitsView)
            commitsView.viewModel.savedRepos = passedRepo
            commitsView.viewModel.renderCachedReposCommits(view: view, tableView: tableView, loadingSpinner: loadingSpinner)
            return .push(commitsView)
        case .shareRepo(let repoURL):
            let image = UIImage(systemName: "bell")
            let sheetVC = UIActivityViewController(activityItems: [image!,repoURL], applicationActivities: nil)
           HapticsManger.shared.selectionVibrate(for: .medium)
            return .present(sheetVC)
        case .shareUser(let userURL):
            let image = UIImage(systemName: "bell")
           let sheetVC = UIActivityViewController(activityItems: [image!,userURL], applicationActivities: nil)
           HapticsManger.shared.selectionVibrate(for: .medium)
            return .present(sheetVC)
        }
    }
}
