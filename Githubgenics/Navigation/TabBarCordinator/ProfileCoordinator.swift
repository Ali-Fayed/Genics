//
//  ProfileeCordinator.swift
//  Githubgenics
//
//  Created by Ali Fayed on 17/10/2021.
//


import Foundation
import XCoordinator
import SafariServices
import JGProgressHUD
// make route has tab controller or navigation controller or a new root view controller
enum ProfileRoute: Route {
    case profile
    case privateRepos
    case privateStarred
    case privateOrgs
    case publiceProfile(passedUser: User)
    case publicRepos(passedUser: User)
    case commits(repository: Repository)
    case publicRepoCommit(view: UIView, tableView: UITableView, loadingSpinner: JGProgressHUD, repository: Repository)
    case commitURL(indexPath: IndexPath)
    case publicStarred(passedUser: User)
    case publicOrgs(passedUser: User)
    case shareRepo(indexPath: IndexPath)
    case repoURL(indexPath: IndexPath)
    case sharePrivateRepo(indexPath: IndexPath)
    case openPrivateRepoURL(indexPath: IndexPath)
    case settings
    case reLogin
    case privacy
    case terms
    case dismiss
}

class ProfileCoordinator: NavigationCoordinator<ProfileRoute> {
    init() {
        super.init(initialRoute: .profile)
    }
    override func prepareTransition(for route: ProfileRoute) -> NavigationTransition {
        switch route {
        case .profile:
            let viewController = ProfileViewController.instaintiate(on: .tabBarView)
            viewController.viewModel.router = unownedRouter
            return .push(viewController)
        case .publiceProfile(let passedUser):
            let viewController = PublicUserProfileViewController.instaintiate(on: .publicProfileView)
            viewController.viewModel.router = unownedRouter
            viewController.viewModel.passedUser = passedUser
            return .push(viewController)
        case .privateRepos:
            let viewController = PrivateReposViewController.instaintiate(on: .reposSB)
            viewController.viewModel.router = unownedRouter
            return .push(viewController)
        case .commits(let repository):
            let viewController = CommitsViewController.instaintiate(on: .commitsView)
            viewController.viewModel.repository = repository
            return .push(viewController)
        case .commitURL(let indexPath):
            let viewController = CommitsViewController.instaintiate(on: .commitsView)
            let commitURL = viewController.viewModel.getCommitViewModel(at: indexPath).commitURL
            let safariVC = SFSafariViewController(url: URL(string: commitURL)!)
            return .push(safariVC)
        case .privateStarred:
            let viewController = PrivateStarredViewController.instaintiate(on: .starredSB)
            viewController.viewModel.router = unownedRouter
            return .push(viewController)
        case .privateOrgs:
            let viewController = PrivateOrgsViewController.instaintiate(on: .orgsSB)
            return .push(viewController)
        case .publicRepos(let passedUser):
            let viewController = PublicReposViewController.instaintiate(on: .reposSB)
            viewController.viewModel.router = unownedRouter
            viewController.viewModel.passedUser = passedUser
            return .push(viewController)
        case .publicStarred(let passedUser):
            let viewController = PublicStarredViewController.instaintiate(on: .starredSB)
            viewController.viewModel.passedUser = passedUser
            viewController.viewModel.router = unownedRouter
            return .push(viewController)
        case .publicOrgs(let passedUser):
            let viewController = PublicOrgsViewController.instaintiate(on: .orgsSB)
            viewController.viewModel.passedUser = passedUser
            return .push(viewController)
        case .settings:
            let viewController = SettingsViewController.instaintiate(on: .settingsView)
            viewController.router = unownedRouter
            return .push(viewController)
        case .terms:
            let termsURL = "https://docs.github.com/en/github/site-policy/github-terms-of-service"
            let safariVC = SFSafariViewController(url: URL(string: termsURL)!)
            return .present(safariVC)
        case .privacy:
            let privacyURL = "https://docs.github.com/en/github/site-policy/github-privacy-statement"
            let safariVC = SFSafariViewController(url: URL(string: privacyURL)!)
            return .present(safariVC)
        case .reLogin:
            let loginCoordinator = LoginCoordinator()
            loginCoordinator.rootViewController.modalPresentationStyle = .overFullScreen
            loginCoordinator.rootViewController.hidesBottomBarWhenPushed = true
            return .present(loginCoordinator)
        case .dismiss:
            return .dismiss()
        case .publicRepoCommit(view: let view, tableView: let tableView, loadingSpinner: let loadingSpinner, repository: let repository):
            let commitsView = CommitsViewController.instaintiate(on: .commitsView)
            commitsView.viewModel.repository = repository
            commitsView.viewModel.fetchReposCommits(view: view, tableView: tableView, loadingSpinner: loadingSpinner)
            return .push(commitsView)
        case .shareRepo(indexPath: let indexPath):
            let viewController = PublicStarredViewController.instaintiate(on: .starredSB)
            let repositoryURL = viewController.viewModel.getStarredViewModel(at: indexPath).repositoryURL
            let sheetVC = UIActivityViewController(activityItems: [repositoryURL], applicationActivities: nil)
            HapticsManger.shared.selectionVibrate(for: .medium)
            return .present(sheetVC)
        case .repoURL(indexPath: let indexPath):
            let viewController = PublicStarredViewController.instaintiate(on: .starredSB)
            let repositoryURL = viewController.viewModel.getStarredViewModel(at: indexPath).repositoryURL
            let safariVC = SFSafariViewController(url: URL(string: repositoryURL)!)
            return .present(safariVC)
        case .sharePrivateRepo(indexPath: let indexPath):
            let viewController = PublicReposViewController.instaintiate(on: .reposSB)
            let repositoryURL = viewController.viewModel.getReposViewModel(at: indexPath).repositoryURL
            let sheetVC = UIActivityViewController(activityItems: [repositoryURL], applicationActivities: nil)
            HapticsManger.shared.selectionVibrate(for: .medium)
            return .present(sheetVC)
        case .openPrivateRepoURL(indexPath: let indexPath):
            let viewController = PublicReposViewController.instaintiate(on: .reposSB)
            let repositoryURL = viewController.viewModel.getReposViewModel(at: indexPath).repositoryURL
            let safariVC = SFSafariViewController(url: URL(string: repositoryURL)!)
            return .present(safariVC)
        }
    }
}
