//
//  PublicProfileCoordinator.swift
//  Githubgenics
//
//  Created by Ali Fayed on 18/10/2021.
//

import Foundation
import XCoordinator
import SafariServices
import JGProgressHUD
enum PublicProfileRoute: Route {
    case publicProfile(passedUser: User)
    case publicRepos(passedUser: User)
    case publicStarred(passedUser: User)
    case publicOrgs(passedUser: User)
    case shareSheet(passedUser: User)
    case userURL(passedUser: User)
    case shareUser(indexPath: IndexPath)
    case userCommits(view: UIView, tableView: UITableView, loadingSpinner: JGProgressHUD, repository: Repository)
    case starredCommits(starttedRepositories: Repository)
    case userCommitsURL(indexPath: IndexPath)
    case dismiss
}

class PublicProfileCoordinaotr: NavigationCoordinator<PublicProfileRoute> {
    init(user: User) {
        super.init(initialRoute: .publicProfile(passedUser: user))
    }
    override func prepareTransition(for route: PublicProfileRoute) -> NavigationTransition {
        switch route {
        case .publicProfile(passedUser: let passedUser):
            let viewController = PublicUserProfileViewController.instaintiate(on: .publicProfileView)
            viewController.viewModel.publicRouter = unownedRouter
            viewController.viewModel.passedUser = passedUser
            return .push(viewController)
        case .publicRepos(let passedUser):
            let viewController = PublicReposViewController.instaintiate(on: .reposSB)
            viewController.viewModel.passedUser = passedUser
            viewController.viewModel.router = unownedRouter
            return .push(viewController)
        case .publicStarred(let passedUser):
            let viewController = PublicStarredViewController.instaintiate(on: .starredSB)
            viewController.viewModel.passedUser = passedUser
            viewController.viewModel.router = unownedRouter
            return .push(viewController)
        case .userCommits(view: let view, tableView: let tableView, loadingSpinner: let loadingSpinner, repository: let repository):
            let commitsView = CommitsViewController.instaintiate(on: .commitsView)
            commitsView.viewModel.repository = repository
            commitsView.viewModel.fetchReposCommits(view: view, tableView: tableView, loadingSpinner: loadingSpinner)
            return .push(commitsView)
        case .userCommitsURL(indexPath: let indexPath):
            let commitsView = CommitsViewController.instaintiate(on: .commitsView)
            let commitURL = commitsView.viewModel.getCommitViewModel(at: indexPath).commitURL
            let safariVC = SFSafariViewController(url: URL(string: commitURL)!)
            return .present(safariVC)
        case .starredCommits(starttedRepositories: let starttedRepositories):
            let commitsView = CommitsViewController.instaintiate(on: .commitsView)
            commitsView.viewModel.repository = starttedRepositories
            return .push(commitsView)
        case .publicOrgs(let passedUser):
            let viewController = PublicOrgsViewController.instaintiate(on: .orgsSB)
            viewController.viewModel.router = unownedRouter
            viewController.viewModel.passedUser = passedUser
            return .push(viewController)
        case .shareSheet(let passedUser):
            let sheetVC = UIActivityViewController(activityItems: [passedUser.userURL], applicationActivities: nil)
            HapticsManger.shared.selectionVibrate(for: .medium)
            return .present(sheetVC)
        case .userURL(let passedUser):
            let userURL = passedUser.userURL
            let safariVC = SFSafariViewController(url: URL(string: userURL)!)
            return .present(safariVC)
        case .shareUser(let indexPath):
            let usersView = UsersViewController.instaintiate(on: .usersView)
            let avatarUrl = usersView.viewModel.getUsersCellsViewModel(at: indexPath).userAvatar
            let usersURL = usersView.viewModel.getUsersCellsViewModel(at: indexPath).userURL
            let fileUrl = URL(string: avatarUrl)
            let data = try? Data(contentsOf: fileUrl!)
            let image = UIImage(data: data!)
            let sheetVC = UIActivityViewController(activityItems: [image!,usersURL], applicationActivities: nil)
            HapticsManger.shared.selectionVibrate(for: .medium)
            return .present(sheetVC)
        case .dismiss:
            return .dismiss()
        }
    }
}
