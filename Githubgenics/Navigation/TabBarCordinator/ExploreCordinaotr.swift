//
//  ExploreCordinaotr.swift
//  Githubgenics
//
//  Created by Ali Fayed on 17/10/2021.
//

import Foundation
import XCoordinator
// make route has tab controller or navigation controller or a new root view controller
enum ExploreRoute: Route {
    case explore
}

class ExploreCordinaotr: NavigationCoordinator<ExploreRoute> {
    init() {
        super.init(initialRoute: .explore)
    }
    override func prepareTransition(for route: ExploreRoute) -> NavigationTransition {
        switch route {
        case .explore:
            let viewController = ExploreViewController.instaintiate(on: .tabBarView)
            viewController.router = unownedRouter
            return .push(viewController)
        }
    }
}
