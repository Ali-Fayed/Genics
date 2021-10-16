//
//  AppCordinator.swift
//  Githubgenics
//
//  Created by Ali Fayed on 03/10/2021.
//

import UIKit
import Foundation

protocol Storyboarded {
    static func instaintiate(on storyboard: AppStoryboards) -> Self
}
enum AppStoryboards: String {
    case mainView = "Main"
    case loginView = "LoginView"
    case tabBarView = "TabBarViews"
    case commitsView = "CommitsView"
    case settingsView = "Settings"
    case usersView = "Users"
    case reposView = "ReposView"
    case issuesView = "Issues"
    case publicProfileView = "PublicProfileView"
    case reposSB = "Repos"
    case starredSB = "Starred"
    case orgsSB = "Orgs"
}

extension Storyboarded where Self: UIViewController {
    static func instaintiate(on storyboard: AppStoryboards) -> Self {
        let vcID = String(describing: self)
        let storyBoard = UIStoryboard(name: storyboard.rawValue, bundle: nil)
        return storyBoard.instantiateViewController(identifier: vcID) as! Self
    }
}
extension UIViewController: Storyboarded {}
