//
//  ProfileeCordinator.swift
//  Githubgenics
//
//  Created by Ali Fayed on 17/10/2021.
//


import Foundation
import XCoordinator
import SafariServices
// make route has tab controller or navigation controller or a new root view controller
enum ProfileRoute: Route {
    case profile
    case privateRepos
    case privateStarred
    case privateOrgs
    case publiceProfile(passedUser: User)
    case publicRepos(passedUser: User)
    case commits(repository: Repository)
    case commitURL(indexPath: IndexPath)
    case publicStarred(passedUser: User)
    case publicOrgs(passedUser: User)
    case settings
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
            return .push(viewController)
        case .privateOrgs:
            let viewController = PrivateOrgsViewController.instaintiate(on: .orgsSB)
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
        case .settings:
            let viewController = SettingsViewController.instaintiate(on: .settingsView)
            viewController.router = unownedRouter
            return .push(viewController)
        }
    }
}
