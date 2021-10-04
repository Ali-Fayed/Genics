//
//  LaunchAnimation.swift
//  Githubgenics
//
//  Created by Ali Fayed on 13/01/2021.
//

import UIKit
import Lottie

class SplashViewController: CommonViews {
    
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
        animationView.animation = Animation.named(SplashViewController.animation)
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
                let tabBarView = TabBarViewController.instaintiate(on: .tabBarView)
                    self.navigationController?.pushViewController(tabBarView, animated: true)
            } else {
                let loginView = LoginViewController.instaintiate(on: .loginView)
                    self.navigationController?.pushViewController(loginView, animated: true)
            }
        }
    }
}
