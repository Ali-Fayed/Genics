//
//  SignUpClass.swift
//  Githubgenics
//
//  Created by Ali Fayed on 22/12/2020.
//

import UIKit
import Firebase

class SignUpView: UIViewController {

    @IBOutlet weak var Email: UITextField!
    @IBOutlet weak var Password: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
             let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))

            view.addGestureRecognizer(tap)
        }

        @objc func dismissKeyboard() {
            view.endEditing(true)
    }
    
    @IBAction func SignUp(_ sender: UIButton) {
        
        if let email = Email.text, let password = Password.text {
        
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let e = error {
                print(e.localizedDescription)
                self.performSegue(withIdentifier: K.SignUpErrorSegue, sender: self)
            } else {
                print("Done")
                self.performSegue(withIdentifier: K.SignUpSegue, sender: self)
                
            }
        }
    }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isToolbarHidden = true
        navigationController?.isNavigationBarHidden = true

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.isToolbarHidden = false
        navigationController?.isNavigationBarHidden = false
        
    }
}
