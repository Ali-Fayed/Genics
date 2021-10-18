//
//  TabBarCordinator.swift
//  Githubgenics
//
//  Created by Ali Fayed on 17/10/2021.
//

import Foundation
import XCoordinator
// make route has tab controller or navigation controller or a new root view controller
enum TabBarRoute: Route {
    case home
    case explore
    case bookmark
    case profile
}
class HomeTabBarCoordinator: TabBarCoordinator<TabBarRoute> {
    private let homeRouter: StrongRouter<HomeRoute>
    private let exploreRouter: StrongRouter<ExploreRoute>
    private let bookmarkRouter: StrongRouter<BookmarkRoute>
    private let profileRouter: StrongRouter<ProfileRoute>
    // MARK: - Initialization
    convenience init() {
        let homeCoordinator = HomeCoordinator()
        homeCoordinator.rootViewController.navigationBar.prefersLargeTitles = true
        homeCoordinator.rootViewController.navigationItem.largeTitleDisplayMode = .always
        homeCoordinator.rootViewController.tabBarItem =
        UITabBarItem(title: "Home".localized(), image: UIImage(systemName: "homekit"), selectedImage: UIImage(systemName: "homekit"))
        //
        let exploreCoordinator = ExploreCordinaotr()
        exploreCoordinator.rootViewController.navigationBar.prefersLargeTitles = true
        exploreCoordinator.rootViewController.navigationItem.largeTitleDisplayMode = .always
        exploreCoordinator.rootViewController.tabBarItem =
        UITabBarItem(title: "Explore".localized(), image: UIImage(systemName: "lightbulb.fill"), selectedImage: UIImage(systemName: "lightbulb.fill"))
        //
        let bookmarkCoordinator = BookmarkCordinator()
        bookmarkCoordinator.rootViewController.navigationBar.prefersLargeTitles = true
        bookmarkCoordinator.rootViewController.navigationItem.largeTitleDisplayMode = .always
        bookmarkCoordinator.rootViewController.tabBarItem =
        UITabBarItem(title: "Bookmarks".localized(), image: UIImage(systemName: "bookmark.fill"), selectedImage: UIImage(systemName: "bookmark.fill"))
        //
        let profileCoordinator = ProfileCoordinator()
        profileCoordinator.rootViewController.navigationBar.prefersLargeTitles = true
        profileCoordinator.rootViewController.navigationItem.largeTitleDisplayMode = .always
        profileCoordinator.rootViewController.tabBarItem =
        UITabBarItem(title: "Profile".localized(), image: UIImage(systemName: "person.fill"), selectedImage: UIImage(systemName: "person.fill"))
        //
        self.init(homeRouter: homeCoordinator.strongRouter,
                  exploreRouter: exploreCoordinator.strongRouter, bookmarkRouter: bookmarkCoordinator.strongRouter, profileRouter: profileCoordinator.strongRouter)
    }
    init(homeRouter: StrongRouter<HomeRoute>, exploreRouter: StrongRouter<ExploreRoute>, bookmarkRouter: StrongRouter<BookmarkRoute>, profileRouter: StrongRouter<ProfileRoute>) {
        self.homeRouter = homeRouter
        self.exploreRouter = exploreRouter
        self.bookmarkRouter = bookmarkRouter
        self.profileRouter = profileRouter
        super.init(tabs: [homeRouter, exploreRouter, bookmarkRouter, profileRouter], select: homeRouter)
    }
    // MARK: - Overrides
    override func prepareTransition(for route: TabBarRoute) -> TabBarTransition {
        switch route {
        case .home:
            return .select(homeRouter)
        case .explore:
            return .select(exploreRouter)
        case .bookmark:
            return .select(bookmarkRouter)
        case .profile:
            return .select(profileRouter)
        }
    }
 }
