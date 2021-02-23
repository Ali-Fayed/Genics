//
//  LaunchAnimation.swift
//  Githubgenics
//
//  Created by Ali Fayed on 13/01/2021.
//

import UIKit
import Lottie

class LaunchAnimation: UIViewController {
    
    let animationView = AnimationView()
    static let animation = "loadingspinner"

    override func viewDidLoad() {
        super.viewDidLoad()
        self.startAnimation ()
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            if UserDefaults.standard.value(forKeyPath: "outh") != nil {
                self.performSegue(withIdentifier: Segues.TabBarSegue, sender: self)
                self.view.willRemoveSubview(self.animationView)
            } else {
                self.performSegue(withIdentifier: Segues.welcomeScreenSegue, sender: self)
            }
        }
    }
        
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
    }
        
    private func startAnimation () {
        animationView.animation = Animation.named(LaunchAnimation.animation)
        animationView.frame = CGRect(x: 0, y: 0, width: 150, height: 150)
        animationView.center = view.center
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = .loop
        animationView.play()
        view.addSubview(animationView)
    }
}
