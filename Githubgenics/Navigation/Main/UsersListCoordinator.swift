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
    case searchUsers(searchText: String)
    case publicUserProfile(user: User)
    case userURL(passedUser: User)
    case openInSafari(indexPath: String)
    case shareUser(avatarURL: String, userURL: String)
    case saveImage(avatarURL: String)
    case dismiss
}
class UserListCoordinaotr: NavigationCoordinator<UsersRoute> {
    init(searchText: String) {
        let viewController = UsersViewController.instaintiate(on: .usersView)
        if viewController.navigationController?.navigationBar.prefersLargeTitles == true {
            super.init(initialRoute: .usersList)
        } else {
            super.init(initialRoute: .searchUsers(searchText: searchText))
        }
    }
    override func prepareTransition(for route: UsersRoute) -> NavigationTransition {
        switch route {
        case .usersList:
            let usersView = UsersViewController.instaintiate(on: .usersView)
            usersView.viewModel.router = strongRouter
            usersView.viewModel.useCase = UserUseCase()
            usersView.title = Titles.usersViewTitle
            return .push(usersView)
        case .searchUsers(let searchText):
            let viewController = UsersViewController.instaintiate(on: .usersView)
            viewController.viewModel.router = strongRouter
            viewController.viewModel.useCase = UserUseCase()
            viewController.searchController.searchBar.text = searchText
            viewController.title = Titles.resultsViewTitle
            viewController.viewModel.query = searchText
            return .push(viewController)
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
        case .openInSafari(let indexPath):
            let usersURL = URL(string: indexPath)!
            let safariVC = SFSafariViewController(url: usersURL)
            return .present(safariVC)
        case .shareUser(let avatarURL, let userURL):
            let fileUrl = URL(string: avatarURL)
            let data = try? Data(contentsOf: fileUrl!)
            let image = UIImage(data: data!)
            let sheetVC = UIActivityViewController(activityItems: [image!,userURL], applicationActivities: nil)
            HapticsManger.shared.selectionVibrate(for: .medium)
            return .present(sheetVC)
        case .saveImage(let avatarURL):
            let fileUrl = URL(string: avatarURL)
            let data = try? Data(contentsOf: fileUrl!)
            let image = UIImage(data: data!)
            UIImageWriteToSavedPhotosAlbum(image!, nil, nil, nil)
            HapticsManger.shared.selectionVibrate(for: .heavy)
            return .none()
        case .dismiss:
            return .dismiss()
        }
    }
}
