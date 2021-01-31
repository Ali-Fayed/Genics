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
    
    @IBOutlet weak var Hello: UILabel!
    @IBOutlet weak var PleaseSignUptoCon: UILabel!
    @IBOutlet weak var FullName: UILabel!
    @IBOutlet weak var EmailLabel: UILabel!
    @IBOutlet weak var PasswordLabel: UILabel!
    @IBOutlet weak var ConfirmPassword: UILabel!
    @IBOutlet weak var Or: UILabel!
    @IBOutlet weak var SignupwithLabel: UILabel!
    @IBOutlet weak var Alreadyhaveaccount: UILabel!
    @IBOutlet weak var SignUp: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SignUp.setTitle("Sign Up".localized(), for: .normal)
        Hello.text = "Hello!".localized()
        PleaseSignUptoCon.text = "Please signup to continue".localized()
        FullName.text = "Full Name".localized()
        EmailLabel.text = "E-mail".localized()
        PasswordLabel.text = "Password".localized()
        ConfirmPassword.text = "Confirm Password".localized()
        Or.text = "Or".localized()
        SignupwithLabel.text = "Signup with".localized()
        Alreadyhaveaccount.text = "Already have account?".localized()
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
        let alert = UIAlertController(title: "Error Sign up", message: "Enter Valid E-mail and the password must be 6 characters long or more", preferredStyle: .alert)
        let action = UIAlertAction(title: "Try Again", style: .default) { (action) in
        }
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
}
