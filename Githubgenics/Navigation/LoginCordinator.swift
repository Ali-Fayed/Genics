//
//  LoginCordinator.swift
//  Githubgenics
//
//  Created by Ali Fayed on 17/10/2021.
//

import Foundation
import XCoordinator
import SafariServices
// make route has tab controller or navigation controller or a new root view controller
enum LoginRoute: Route {
    case login
    case home
    case terms
    case privacy
}
class LoginCoordinator: NavigationCoordinator<LoginRoute> {
    init() {
        super.init(initialRoute: .login)
    }
    override func prepareTransition(for route: LoginRoute) -> NavigationTransition {
        switch route {
        case .login:
            let viewController = LoginViewController.instaintiate(on: .loginView)
            viewController.router = strongRouter
            return .push(viewController)
        case .home:
            let tabCoordinator = HomeTabBarCoordinator()
            tabCoordinator.rootViewController.modalPresentationStyle = .overFullScreen
            return .push(tabCoordinator)
        case .terms:
            let termsURL = "https://docs.github.com/en/github/site-policy/github-terms-of-service"
            let safariVC = SFSafariViewController(url: URL(string: termsURL)!)
            return .present(safariVC)
        case .privacy:
            let privacyURL = "https://docs.github.com/en/github/site-policy/github-privacy-statement"
            let safariVC = SFSafariViewController(url: URL(string: privacyURL)!)
            return .present(safariVC)
        }
    }
}
