//
//  UsersListCoordinator.swift
//  Githubgenics
//
//  Created by Ali Fayed on 17/10/2021.
//

import Foundation
import XCoordinator
import SafariServices
import JGProgressHUD
// make route has tab controller or navigation controller or a new root view controller
enum UsersRoute: Route {
    case users
    case publicProfile(passedUser: User)
    case publicRepos(passedUser: User)
    case publicStarred(passedUser: User)
    case publicOrgs(passedUser: User)
    case shareSheet(passedUser: User)
    case publicCommits(view: UIView, tableView: UITableView, loadingSpinner: JGProgressHUD, repository: Repository)
    case userURL(passedUser: User)
}

class UserCordinaotr: NavigationCoordinator<UsersRoute> {
    init() {
        super.init(initialRoute: .users)
    }
    override func prepareTransition(for route: UsersRoute) -> NavigationTransition {
        switch route {
        case .users:
            let usersView = UsersViewController.instaintiate(on: .usersView)
            usersView.viewModel.router = unownedRouter
            return .push(usersView)
        case .publicProfile(passedUser: let passedUser):
            let viewController = PublicUserProfileViewController.instaintiate(on: .publicProfileView)
            viewController.viewModel.publicRouter = unownedRouter
            viewController.viewModel.passedUser = passedUser
            return .push(viewController)
        case .publicCommits(view: let view, tableView: let tableView, loadingSpinner: let loadingSpinner, repository: let repository):
            let viewController = CommitsViewController.instaintiate(on: .commitsView)
            viewController.viewModel.router = unownedRouter
            viewController.viewModel.repository = repository
            viewController.viewModel.fetchReposCommits(view: view, tableView: tableView, loadingSpinner: loadingSpinner)
            return .push(viewController)
        case .publicRepos(let passedUser):
            let viewController = PublicReposViewController.instaintiate(on: .reposSB)
            viewController.viewModel.passedUser = passedUser
            return .push(viewController)
        case .publicStarred(let passedUser):
            let viewController = PublicStarredViewController.instaintiate(on: .starredSB)
            viewController.viewModel.passedUser = passedUser
            return .push(viewController)
        case .publicOrgs(let passedUser):
            let viewController = PublicOrgsViewController.instaintiate(on: .orgsSB)
            viewController.viewModel.passedUser = passedUser
            return .push(viewController)
        case .shareSheet(let passedUser):
            let sheetVC = UIActivityViewController(activityItems: [passedUser.userURL], applicationActivities: nil)
            HapticsManger.shared.selectionVibrate(for: .medium)
            return .present(sheetVC)
        case .userURL(let passedUser):
            let userURL = passedUser.userURL
            let safariVC = SFSafariViewController(url: URL(string: userURL)!)
            return .push(safariVC)
        }
    }
}
