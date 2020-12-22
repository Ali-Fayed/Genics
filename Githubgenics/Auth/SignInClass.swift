//
//  LogInClass.swift
//  Githubgenics
//
//  Created by Ali Fayed on 22/12/2020.
//

import UIKit
import Firebase

class SignInClass: UIViewController {
    
    
    @IBOutlet weak var Email: UITextField!
    @IBOutlet weak var Password: UITextField!
    
    
    @IBAction func SignIn(_ sender: UIButton) {
        
        if let email = Email.text, let password = Password.text {
            Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
                guard self != nil else { return }
            if let e = error {
                print(e.localizedDescription)
            } else {
                print("Sign In Complete")
                self?.performSegue(withIdentifier: K.SignIn, sender: self)
            }
        }
    }
        
    }
}
