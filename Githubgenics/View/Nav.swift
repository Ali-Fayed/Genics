//
//  Nav.swift
//  Githubgenics
//
//  Created by Ali Fayed on 02/01/2021.
//

import UIKit

class Nav: UINavigationController, UIGestureRecognizerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        interactivePopGestureRecognizer?.delegate = self
        
    }
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return viewControllers.count > 1
    }


}
