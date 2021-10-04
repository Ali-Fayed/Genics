//
//  ProfileCordinator.swift
//  Githubgenics
//
//  Created by Ali Fayed on 04/10/2021.
//

import Foundation
import UIKit

class ProfileCordinator {
    enum ProfileRouter  {
        case privateRepos
        case privateStarred
        case privateOrgs
        case publicRepos
        case publicStarred
        case publicOrgs
        case settings
    }
    func pushTo (destination: ProfileRouter, navigationController: UINavigationController, passedUser: User?) {
        switch destination {
        case .privateRepos:
            let privateReposViewVC = PrivateReposViewController.instaintiate(on: .privateReposView)
            navigationController.pushViewController(privateReposViewVC, animated: true)
        case .privateStarred:
            let privateStarredViewVC = PrivateStarredViewController.instaintiate(on: .privateStarredView)
            navigationController.pushViewController(privateStarredViewVC, animated: true)
        case .privateOrgs:
            let privateOrgsViewVC = PrivateOrgsViewController.instaintiate(on: .privateOrgsView)
            navigationController.pushViewController(privateOrgsViewVC, animated: true)
        case .publicRepos:
            let publicReposView = PublicReposViewController.instaintiate(on: .publicReposView)
            publicReposView.viewModel.passedUser = passedUser
            navigationController.pushViewController(publicReposView, animated: true)
        case .publicStarred:
            let publicStarredView = PublicStarredViewController.instaintiate(on: .publicStarredView)
            publicStarredView.viewModel.passedUser = passedUser
            navigationController.pushViewController(publicStarredView, animated: true)
        case .publicOrgs:
            let publicOrgsView = PublicOrgsViewController.instaintiate(on: .publicOrgsView)
            publicOrgsView.viewModel.passedUser = passedUser
            navigationController.pushViewController(publicOrgsView, animated: true)
        case .settings:
            let settingsVC = SettingsViewController.instaintiate(on: .settingsView)
            navigationController.pushViewController(settingsVC, animated: true)
        }
    }
}
