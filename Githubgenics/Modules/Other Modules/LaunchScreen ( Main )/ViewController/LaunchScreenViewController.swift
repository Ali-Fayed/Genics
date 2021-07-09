//
//  LaunchAnimation.swift
//  Githubgenics
//
//  Created by Ali Fayed on 13/01/2021.
//

import UIKit
import Lottie

class LaunchScreenViewController: ViewSetups {
    
    let animationView = AnimationView()
    static let animation = "loadingspinner"

    override func viewDidLoad() {
        super.viewDidLoad()
        startAnimation()
        handleAnimation()
    }
        
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
    }
        
    private func startAnimation () {
        animationView.animation = Animation.named(LaunchScreenViewController.animation)
        animationView.frame = CGRect(x: 0, y: 0, width: 150, height: 150)
        animationView.center = view.center
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = .loop
        animationView.play()
        view.addSubview(animationView)
    }
    
    func handleAnimation() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            if self.isLoggedIn {
                let tabBarView = UIStoryboard.init(name: Storyboards.tabBarView , bundle: Bundle.main).instantiateViewController(withIdentifier: ID.tabBarViewControllerID) as? TabBarViewController
                    self.navigationController?.pushViewController(tabBarView!, animated: true)
            } else {
                let loginView = UIStoryboard.init(name: Storyboards.loginView , bundle: Bundle.main).instantiateViewController(withIdentifier: ID.loginViewControllerID) as? LoginViewController
                    self.navigationController?.pushViewController(loginView!, animated: true)
            }
        }
    }
}
