//
//  ViewController2.swift
//  Githubgenicsk
//
//  Created by Ali Fayed on 21/12/2020.
//

import UIKit

class WelcomeScreen: UIViewController {
    
    @IBOutlet weak var signInWithGitHub: UIButton!
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
    
    @IBAction func signIn(_ sender: Any) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
