//
//  DetailViewController.swift
//  Githubgenics
//
//  Created by Ali Fayed on 21/12/2020.
//

import UIKit
import WebKit

extension UIViewController {
    func loader() -> UIAlertController {
        let alert = UIAlertController(title: nil, message: "Please wait...", preferredStyle: .alert)
        let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.style = UIActivityIndicatorView.Style.large
        loadingIndicator.startAnimating()
        alert.view.addSubview(loadingIndicator)
        present(alert, animated: true, completion: nil)
        return alert
    }
}

class DetailView: UIViewController {
    
    var Users = [APIUsersData]()
    var SpecificUser = [UserAPI]()
    var ReposData = [APIReposData]()
    var UsersCall:APIUsersData?
    var SpeicficUserCall:UserAPI?
    var ReposCall:APIReposData?
    
    
    
    @IBOutlet weak var UserName: UILabel!
    @IBOutlet weak var ImageView: UIImageView!
    //    @IBOutlet weak var buttoo: UIButton!
    @IBOutlet weak var Followers: UILabel!
    @IBOutlet weak var Following: UILabel!
    @IBOutlet weak var Site: UIBarButtonItem!
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        fetchUser {
            print("Detail Data Done")
            //            self.tableView.reloadData()
        }
        //        buttoo.addTarget(self, action: #selector(Button), for: .touchUpInside)
        UserName.text = UsersCall?.login
        let APIImageurl = (UsersCall?.avatar_url)!
        ImageView.layer.cornerRadius = 40
        ImageView.downloaded(from: APIImageurl)
        //        Followers.text = String(UsersCall!.id)
        //        Following.text = SpeicficUserCall?.login
    }
    
    //    override func viewWillAppear(_ animated: Bool) {
    //        Followers.text = SPUser?.login
    //    }
    
    //    @IBAction func Button(_ sender: UIButton) {
    //        let APIurl = (UsersCall?.html_url)!
    //        guard let url = URL(string: APIurl)
    //        else {
    //            return }
    //        let vc = WebManger(url: url, title: "Google")
    //        let navVc = UINavigationController(rootViewController: vc)
    //        present(navVc, animated: true)
    //    }
    //
    
    @IBAction func Site(_ sender: UIBarButtonItem) {
        let APIurl = (UsersCall?.html_url)!
        guard let url = URL(string: APIurl)
        else {
            return }
        let vc = WebManger(url: url, title: "Google")
        let navVc = UINavigationController(rootViewController: vc)
        present(navVc, animated: true)
    }
    
    func fetchUser(completed: @escaping () -> ()) {
        if let url = URL(string: "https://api.github.com/users/ivey/") {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, response, error) in
                if error == nil {
                    let decoder = JSONDecoder()
                    if let safeData = data {
                        do {
                            self.SpecificUser = try decoder.decode([UserAPI].self, from: safeData)
                            DispatchQueue.main.async {
                                completed()
                            }
                        } catch {
                            let error = error
                            print("JSON User Error")
                            print(error.localizedDescription)
                        }
                    }
                }
            }
            task.resume()
        }
        
        
    }
    
}
