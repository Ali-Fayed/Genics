//
//  DetailViewController.swift
//  Githubgenics
//
//  Created by Ali Fayed on 21/12/2020.
//

import UIKit
import Firebase
import SkeletonView
import WebKit
import Alamofire
import Kingfisher

//MARK:- Main Class

class DetailView: UIViewController {
    
    var uC = UsersView()
    var ReposData = [ReposStruct]()
    var Users:UsersStruct?
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var UserName: UILabel!
    @IBOutlet weak var ImageView: UIImageView!
    @IBOutlet weak var Site: UIBarButtonItem!
    
    @IBOutlet weak var Followers: UILabel!
    @IBOutlet weak var Following: UILabel!
    //MARK:- ViewDidLoad
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        Following.text = "Following: \(String(Int.random(in: 100...150)))"
        Followers.text = "Following: \(String(Int.random(in: 100...300)))"
        FetchRepos ()
        UserName.text = "Username:  \((Users?.login.capitalized)!)"
        let APIImageurl = (Users?.avatar_url)!
        ImageView.kf.indicatorType = .activity
        ImageView.kf.setImage(with: URL(string: APIImageurl), placeholder: nil, options: [.transition(.fade(0.7))], progressBlock: nil)

        
    }
    
    //MARK:- WebView
    
    
    @IBAction func Site(_ sender: UIBarButtonItem) {
        let APIurl = (Users?.html_url)!
        guard let url = URL(string: APIurl)
        else {
            return }
        let vc = WebManger(url: url, title: "Google")
        let navVc = UINavigationController(rootViewController: vc)
        present(navVc, animated: true)
    }
    
    //MARK:- JSON Viewer
    
    func FetchRepos() {
        let url = "https://api.github.com/users/\((Users?.login)!)/repos"
        AF.request(url, method: .get).responseJSON { (response) in
          do {
            if let safedata = response.data {
                let repos = try JSONDecoder().decode([ReposStruct].self, from: safedata)
               self.ReposData = repos
               self.tableView.reloadData()
               print("Fetch OK")
            }
          }
          catch {
              let error = error
              print("Detail View Error")
              print(error.localizedDescription)
        }
      }
  }

    //
}
//

//MARK:- TableView

extension DetailView: UITableViewDataSource , UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return ReposData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RepoCell", for: indexPath) as! ReposCell
        cell.RepoNameLabel?.text = ReposData[indexPath.row].name.capitalized
        cell.Description?.text = ReposData[indexPath.row].description.capitalized
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
