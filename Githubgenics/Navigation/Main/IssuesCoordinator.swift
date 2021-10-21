//
//  IssuesCoordinator.swift
//  Githubgenics
//
//  Created by Ali Fayed on 18/10/2021.
//

import Foundation
import XCoordinator
import SafariServices
// make route has tab controller or navigation controller or a new root view controller
enum IssuesRoute: Route {
    case issues
    case searchIssues(searchText: String)
    case dismiss
}

class IssuesCoordinaotr: NavigationCoordinator<IssuesRoute> {
    init(searchText: String) {
        let viewController = IssuesViewController.instaintiate(on: .issuesView)
        if viewController.navigationController?.navigationBar.prefersLargeTitles == true {
            super.init(initialRoute: .issues)
        } else {
            super.init(initialRoute: .searchIssues(searchText: searchText))
        }
    }
    override func prepareTransition(for route: IssuesRoute) -> NavigationTransition {
        switch route {
        case .issues:
            let viewController = IssuesViewController.instaintiate(on: .issuesView)
            viewController.viewModel.router = unownedRouter
            return .push(viewController)
        case .searchIssues(let searchText):
            let viewController = IssuesViewController.instaintiate(on: .issuesView)
            viewController.viewModel.router = unownedRouter
            viewController.searchController.searchBar.text = searchText
            viewController.query = searchText
            return .push(viewController)
        case .dismiss:
            return .dismiss()
        }
    }
}
