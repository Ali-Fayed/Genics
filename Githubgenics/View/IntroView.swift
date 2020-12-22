//
//  ViewController2.swift
//  Githubgenicsk
//
//  Created by Ali Fayed on 21/12/2020.
//

import UIKit
import CLTypingLabel

class IntroView: UIViewController {
    
    @IBOutlet weak var IntroLabel: CLTypingLabel!
    @IBOutlet weak var SignIn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        

        IntroLabel.text = "Githubgentics"
    }
//    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        self.navigationController?.navigationBar.barTintColor = UIColor.green
//        self.navigationController?.navigationBar.tintColor = UIColor.blue
//        self.navigationController!.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.blue]
//   }



}
