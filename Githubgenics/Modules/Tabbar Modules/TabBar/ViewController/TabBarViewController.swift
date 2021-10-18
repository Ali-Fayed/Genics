//
//  TabBarController.swift
//  Githubgenics
//
//  Created by Ali Fayed on 22/02/2021.
//

import UIKit
import XCoordinator

class TabBarViewController: UITabBarController {
    var router: UnownedRouter<TabBarRoute>?
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        if item.tag == 0 { // home tab
            router?.trigger(.home)
        } else if item.tag == 1 { // explore tab
            router?.trigger(.explore)
        } else if item.tag == 2 { // bookmark tab
            router?.trigger(.bookmark)
        } else if item.tag == 3 { // profile tab
            router?.trigger(.profile)
        }
    }
}
