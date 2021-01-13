//
//  ViewController2.swift
//  Githubgenicsk
//
//  Created by Ali Fayed on 21/12/2020.
//

import UIKit

class Main: UIViewController {
    
    @IBOutlet weak var Button: UIButton!
    @IBOutlet weak var SignIn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        navigationController?.isToolbarHidden = true
        navigationController?.isNavigationBarHidden = true

    }
    
    @IBAction func AutoSignIn(_ sender: Any) {
       if UserDefaults.standard.value(forKeyPath: "email") != nil {
            performSegue(withIdentifier: "Main", sender: self)
       } else {
        performSegue(withIdentifier: "Default", sender: self)
       }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
        navigationController?.isToolbarHidden = true

    }
////
////    override func viewWillDisappear(_ animated: Bool) {
////        super.viewWillDisappear(animated)
////        navigationController?.isNavigationBarHidden = false
////        navigationController?.isToolbarHidden = true
////   override func viewWillAppear(_ animated: Bool) {
//    super.viewWillAppear(animated)
//    navigationController?.isNavigationBarHidden = true
//    self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
//
//}
//
//override func viewDidAppear(_ animated: Bool) {
//    super.viewDidAppear(animated)
//    self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
//}
//
////    }
    
  
    
}
