//
//  DetailViewController.swift
//  Githubgenics
//
//  Created by Ali Fayed on 21/12/2020.
//

import UIKit
import WebKit

class DetailViewController: UIViewController {

    var User:APIUsersData?
    var repos:APIReposData?
    
    
    @IBOutlet weak var UserName: UILabel!
    @IBOutlet weak var ImageView: UIImageView!
    @IBOutlet weak var buttoo: UIButton!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        buttoo.addTarget(self, action: #selector(Button), for: .touchUpInside)
        UserName.text = User?.login
        let Imageurl = "https://avatars0.githubusercontent.com/u/\(Int.random(in: 105 ... 200))?v=4"
        ImageView.downloaded(from: Imageurl)
    }
    
    @IBAction func Button(_ sender: UIButton) {
        guard let url = URL(string: "https://www.google.com")
        else {
            return }
        let vc = WebManger(url: url, title: "Google")
        let navVc = UINavigationController(rootViewController: vc)
        present(navVc, animated: true)
    }
    

}
