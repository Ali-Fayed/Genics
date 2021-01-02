//
//  LogInClass.swift
//  Githubgenics
//
//  Created by Ali Fayed on 22/12/2020.
//

import UIKit
import Firebase

class SignInView: UIViewController {
    
    
    @IBOutlet weak var Email: UITextField!
    @IBOutlet weak var Password: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//             let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
//   
//            view.addGestureRecognizer(tap)
        }

        @objc func dismissKeyboard() {
            view.endEditing(true)
    }
    
    @IBAction func SignIn(_ sender: UIButton) {
        
        if let email = Email.text, let password = Password.text {
            UserDefaults.standard.set(Email.text, forKey: "email")
            Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
                guard self != nil else { return }
            if let e = error {
                print(e.localizedDescription)
                let alert = UIAlertController(title: "Enter Vaild Informations", message: "", preferredStyle: .alert)
                let action = UIAlertAction(title: "Try Again", style: .default) { (action) in
                }
                alert.addAction(action)
                self!.present(alert, animated: true, completion: nil)
                
            } else {
                print("Sign In Complete")
                self?.performSegue(withIdentifier: K.SignInSegue, sender: self)
            }
        }
    }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
        navigationController?.isToolbarHidden = true
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.isNavigationBarHidden = false
        navigationController?.isToolbarHidden = false
    }
}
