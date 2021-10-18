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
enum UsersRoute: Route {
    case usersList
    case publicUserProfile(user: User)
    case userURL(passedUser: User)
    case shareUser(indexPath: IndexPath)
    case lastSearch(indexPath: IndexPath)
    case dismiss
}
class UserListCoordinaotr: NavigationCoordinator<UsersRoute> {
    init() {
        super.init(initialRoute: .usersList)
    }
    override func prepareTransition(for route: UsersRoute) -> NavigationTransition {
        switch route {
        case .usersList:
            let usersView = UsersViewController.instaintiate(on: .usersView)
            usersView.viewModel.router = strongRouter
            return .push(usersView)
        case .publicUserProfile(let user):
            let publicProfileCoordinaotr = PublicProfileCoordinaotr(user: user)
            publicProfileCoordinaotr.rootViewController.modalPresentationStyle = .fullScreen
            publicProfileCoordinaotr.rootViewController.navigationBar.prefersLargeTitles = true
            publicProfileCoordinaotr.rootViewController.navigationItem.largeTitleDisplayMode = .always
            return .present(publicProfileCoordinaotr)
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
        case .lastSearch(let indexPath):
            let usersView = UsersViewController.instaintiate(on: .usersView)
            let userURL = usersView.viewModel.getLastSearchViewModel(at: indexPath).userURL
            let safariVC = SFSafariViewController(url: URL(string: userURL!)!)
            return .present(safariVC)
        case .dismiss:
            return .dismiss()
        }
    }
}
