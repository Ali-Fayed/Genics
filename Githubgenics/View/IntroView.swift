//
//  ViewController2.swift
//  Githubgenicsk
//
//  Created by Ali Fayed on 21/12/2020.
//

import UIKit
import CLTypingLabel

class IntroView: UIViewController {
    
    @IBOutlet weak var Button: UIButton!
    @IBOutlet weak var IntroLabel: CLTypingLabel!
    @IBOutlet weak var SignIn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        

        IntroLabel.text = "Githubgenics"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.isNavigationBarHidden = false
    }

//    @IBAction func Button(_ sender: UIButton) {
//        guard let url = URL(string: "www.google.com")else {
//            return
//        }
//        let vc = WebViewController(url: url, title: "Google")
//        let navVc = UINavigationController(rootViewController: vc)
//        present(navVc, animated: true)
//    }
    

}
