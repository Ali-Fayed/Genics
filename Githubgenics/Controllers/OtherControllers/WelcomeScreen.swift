//
//  ViewController2.swift
//  Githubgenicsk
//
//  Created by Ali Fayed on 21/12/2020.
//

import UIKit
import TransitionButton
import Lottie


class Second: CustomTransitionViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .blue
    }
}
class WelcomeScreen: UIViewController {
    let animationView = AnimationView()

    @IBOutlet weak var signInWithGitHub: TransitionButton!
    @IBOutlet weak var Terms: UIButton!
    @IBOutlet weak var Privacy: UIButton!
    
    @IBAction func privacy(_ sender: Any) {
    }
    
    @IBAction func terms(_ sender: Any) {
    }
    
    var isLoggedIn: Bool {
        if TokenManager.shared.fetchAccessToken() != nil {
            return true
        }
        return false
    }
    
    @objc func didTapButton () {
    
    }
    
    @IBAction func signIn(_ sender: Any) {
        signInWithGitHub.startAnimation()
        DispatchQueue.main.asyncAfter(deadline: .now()+2) {
            self.signInWithGitHub.stopAnimation(animationStyle: .expand, revertAfterDelay: 1) {
               
                self.signInWithGitHub.layer.cornerRadius = 20
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        signInWithGitHub.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
        signInWithGitHub.spinnerColor = .black
        signInWithGitHub.layer.cornerRadius = 20
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        navigationController?.isToolbarHidden = true
        navigationController?.isNavigationBarHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
        navigationController?.isToolbarHidden = true
        signInWithGitHub.layer.cornerRadius = 20
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        signInWithGitHub.layer.cornerRadius = 20

       
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
      if identifier == "LoginSegue" {
        let shouldProceed = !isLoggedIn
        return shouldProceed
      }
      return true
    }
    

    
}
