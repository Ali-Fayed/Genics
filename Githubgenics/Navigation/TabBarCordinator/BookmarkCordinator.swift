//
//  BookmarkCordinator.swift
//  Githubgenics
//
//  Created by Ali Fayed on 17/10/2021.
//


import Foundation
import XCoordinator
// make route has tab controller or navigation controller or a new root view controller
enum BookmarkRoute: Route {
    case bookmark
    case userSafariURL
    case reposCommits
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
        case .userSafariURL:
            let viewController = CommitsViewController.instaintiate(on: .tabBarView)
            return .push(viewController)
        case .reposCommits:
            let viewController = CommitsViewController.instaintiate(on: .tabBarView)
            return .push(viewController)
        }
    }
}
