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
    case lastSearch(indexPath: IndexPath)
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
            viewController.query = searchText
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
