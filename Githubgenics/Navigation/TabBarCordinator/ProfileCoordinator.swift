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
    case settings
    case repositories
    case starredRepos
    case organizations
    case commits(repository: Repository)
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
        case .settings:
            let settingsCoordinator = SettingsCoordinaotr()
            settingsCoordinator.rootViewController.modalPresentationStyle = .fullScreen
            settingsCoordinator.rootViewController.navigationBar.prefersLargeTitles = true
            settingsCoordinator.rootViewController.navigationItem.largeTitleDisplayMode = .always
            return .present(settingsCoordinator)
        case .repositories:
            let viewController = PrivateReposViewController.instaintiate(on: .reposSB)
            viewController.viewModel.router = unownedRouter
            return .push(viewController)
        case .commits(let repository):
            let viewController = CommitsViewController.instaintiate(on: .commitsView)
            viewController.viewModel.repository = repository
            return .push(viewController)
        case .starredRepos:
            let viewController = PrivateStarredViewController.instaintiate(on: .starredSB)
            viewController.viewModel.router = unownedRouter
            return .push(viewController)
        case .organizations:
            let viewController = PrivateOrgsViewController.instaintiate(on: .orgsSB)
            return .push(viewController)
        }
    }
}
