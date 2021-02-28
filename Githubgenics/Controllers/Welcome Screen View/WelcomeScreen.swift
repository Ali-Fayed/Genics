//
//  ViewController2.swift
//  Githubgenicsk
//
//  Created by Ali Fayed on 21/12/2020.
//

import UIKit
import SafariServices
import AuthenticationServices


class WelcomeScreen: UIViewController {
    
    @IBOutlet weak var signInWithGitHub: UIButton!
    @IBOutlet weak var Privacy: UIButton!
    @IBOutlet weak var term: UIButton!
    @IBOutlet weak var and: UILabel!
    @IBOutlet weak var bySign: UILabel!
    var webAuthenticationSession: ASWebAuthenticationSession?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        signInWithGitHub.layer.cornerRadius = 20
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        navigationController?.isToolbarHidden = true
        navigationController?.isNavigationBarHidden = true
        signInWithGitHub.setTitle(Titles.signInButtonTitle , for: .normal)
        Privacy.setTitle(Titles.privacyPolicy, for: .normal)
        term.setTitle(Titles.terms, for: .normal)
        and.text = Titles.and
        bySign.text = Titles.bySign
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
    
    @IBAction func privacyPolicy(_ sender: Any) {
        let url = "https://docs.github.com/en/github/site-policy/github-privacy-statement"
        let vc = SFSafariViewController(url: URL(string: url)!)
        self.present(vc, animated: true)
    }
    
    @IBAction func terms(_ sender: Any) {
        let url = "https://docs.github.com/en/github/site-policy/github-terms-of-service"
        let vc = SFSafariViewController(url: URL(string: url)!)
        self.present(vc, animated: true)
    }
    
    @IBAction func signIn(_ sender: Any) {
        // vibaration when sign in
        HapticsManger.shared.selectionVibrate(for: .medium)
        let sheet = UIAlertController(title: "", message: Titles.makeSure , preferredStyle: .actionSheet)
        sheet.addAction(UIAlertAction(title: Titles.signinWith, style: .default, handler: { (url) in
            // call authentication method
            self.getGitHubAccessToken ()
        }))
        
        // sheet alert between guest and authenticated member
        sheet.addAction(UIAlertAction(title: Titles.signinWithout , style: .default, handler: { (url) in
            let alert = UIAlertController(title: "", message: Titles.byContinue , preferredStyle: .alert)
            alert.view.tintColor = UIColor.black
            let action = UIAlertAction(title: Titles.continuee, style: .default) { (action) in
                self.performSegue(withIdentifier: Segues.welcomeScreenSegue, sender: self)
            }
            action.setValue(UIColor(named: "Color"), forKey: "titleTextColor")
            alert.addAction(action)
            self.present(alert, animated: true)
        }))
        sheet.addAction(UIAlertAction(title: Titles.cancel , style: .cancel, handler: nil ))
        present(sheet, animated: true)
    }
}





extension WelcomeScreen: ASWebAuthenticationPresentationContextProviding {
    func presentationAnchor(for session: ASWebAuthenticationSession) -> ASPresentationAnchor {
        return view.window ?? ASPresentationAnchor()

    }
}
