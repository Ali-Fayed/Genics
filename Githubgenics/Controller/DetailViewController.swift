//
//  DetailViewController.swift
//  Githubgenics
//
//  Created by Ali Fayed on 21/12/2020.
//

import UIKit

class DetailViewController: UIViewController {

    var User:APIUsersData?
    
    @IBOutlet weak var UserName: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        UserName.text = User?.login
    }
    


}
