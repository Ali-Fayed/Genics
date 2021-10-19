//
//  SettingsCoordinator.swift
//  Githubgenics
//
//  Created by Ali Fayed on 19/10/2021.
//


import Foundation
import XCoordinator
import SafariServices

enum SettingsRoute: Route {
    case settings
    case reLogin
    case privacy
    case terms
    case dismiss
}

class SettingsCoordinaotr: NavigationCoordinator<SettingsRoute> {
    init() {
        super.init(initialRoute: .settings)
    }
    override func prepareTransition(for route: SettingsRoute) -> NavigationTransition {
        switch route {
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
        }
    }
}
