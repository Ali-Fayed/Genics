//
//  ViewController2.swift
//  Githubgenicsk
//
//  Created by Ali Fayed on 21/12/2020.
//

import UIKit

class WelcomeScreen: UIViewController {
    
    @IBOutlet weak var projectTitle: UILabel!
    @IBOutlet weak var projectTextView: UITextView!
    @IBOutlet weak var HelloWorld: UILabel!
    @IBOutlet weak var signInWithGithub: UIButton!
    
    var isLoggedIn: Bool {
        if TokenManager.shared.fetchAccessToken() != nil {
            return true
        }
        return false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        projectTitle.font = UIFont(name: "AppleSDGothicNeo-Light", size: 40)
        projectTitle.text = "GITHUBGENICS".localized()
        HelloWorld.text = "Hello World!".localized()
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        navigationController?.isToolbarHidden = true
        navigationController?.isNavigationBarHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
        navigationController?.isToolbarHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
       
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
      if identifier == "LoginSegue" {
        let shouldProceed = !isLoggedIn
        return shouldProceed
      }
      return true
    }
    
}
