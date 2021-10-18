//
//  AppCoordinator.swift
//  Githubgenics
//
//  Created by Ali Fayed on 17/10/2021.
//
import UIKit
import Foundation
import XCoordinator

enum AppRoute: Route {
    case splash
    case login
    case home
}

class AppCoordinator: NavigationCoordinator<AppRoute> {
    // MARK: Initialization
    init() {
        super.init(initialRoute: .splash)
    }
    // MARK: Overrides
    override func prepareTransition(for route: AppRoute) -> NavigationTransition {
        switch route {
        case .splash:
            let viewController = SplashViewController.instaintiate(on: .mainView)
            viewController.router = strongRouter
            return .push(viewController)
        case .login:
            let loginCoordinator = LoginCoordinator()
            loginCoordinator.rootViewController.modalPresentationStyle = .overFullScreen
            return .present(loginCoordinator)
        case .home:
            let tabCoordinator = HomeTabBarCoordinator()
            tabCoordinator.rootViewController.modalPresentationStyle = .overFullScreen
            return .present(tabCoordinator)
        }
    }
}
