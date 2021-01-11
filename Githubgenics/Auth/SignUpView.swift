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
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isToolbarHidden = true
        navigationController?.isNavigationBarHidden = true
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true


    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.isToolbarHidden = true
        navigationController?.isNavigationBarHidden = true

    }
    
    @IBAction func SignUp(_ sender: UIButton) {
        
        if let email = Email.text, let password = Password.text {
            UserDefaults.standard.set(Email.text, forKey: "email")
            Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                if let e = error {
                    print(e.localizedDescription)
                    self.ErrorSignUpAlert ()
                } else {
                    self.performSegue(withIdentifier: K.SignUpSegue, sender: self)
                }
            }
        }
    }
    

    func ErrorSignUpAlert () {
        let alert = UIAlertController(title: "Error Sign up", message: "The password must be 6 characters long or more", preferredStyle: .alert)
        let action = UIAlertAction(title: "Try Again", style: .default) { (action) in
        }
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
}
