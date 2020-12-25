//
//  DetailViewController.swift
//  Githubgenics
//
//  Created by Ali Fayed on 21/12/2020.
//

import UIKit
import WebKit

//extension UIViewController {
//    func loader() -> UIAlertController {
//        let alert = UIAlertController(title: nil, message: "Please wait...", preferredStyle: .alert)
//        let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
//        loadingIndicator.hidesWhenStopped = true
//        loadingIndicator.style = UIActivityIndicatorView.Style.large
//        loadingIndicator.startAnimating()
//        alert.view.addSubview(loadingIndicator)
//        present(alert, animated: true, completion: nil)
//        return alert
//    }
//}


class DetailView: UIViewController, UITableViewDataSource,UITableViewDelegate {
    

    
    
    var UsersAPIStruct = [UsersStruct]()
    var ReposData = [APIReposData]()
    var Users:UsersStruct?
    var Repos:APIReposData?
    
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var UserName: UILabel!
    @IBOutlet weak var ImageView: UIImageView!
    @IBOutlet weak var Followers: UILabel!
    @IBOutlet weak var Following: UILabel!
    @IBOutlet weak var Site: UIBarButtonItem!
    
    
    override func viewDidLoad() {

        super.viewDidLoad()
        tableView.rowHeight = 70.0
        tableView.dataSource = self
        tableView.delegate = self
        FetchRepos {
            print("Repos List Loaded")
            self.tableView.reloadData()
            self.tableView.rowHeight = 100.0
        }
        UserName.text = Users?.login
        let APIImageurl = (Users?.avatar_url)!
        ImageView.layer.cornerRadius = 40
        ImageView.downloaded(from: APIImageurl)
        
    }
    

    @IBAction func Site(_ sender: UIBarButtonItem) {
        let APIurl = (Users?.html_url)!
        guard let url = URL(string: APIurl)
        else {
            return }
        let vc = WebManger(url: url, title: "Google")
        let navVc = UINavigationController(rootViewController: vc)
        present(navVc, animated: true)
    }
    
    
        
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ReposData.count
    }
    
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RepoCell", for: indexPath) as! DetailCellTableViewCell
        cell.RepoNameLabel?.text = ReposData[indexPath.row].name.capitalized
        cell.Description?.text = ReposData[indexPath.row].description.capitalized
        
        return cell
    }
    
     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
        
    
    
    func FetchRepos(completed: @escaping () -> ()) {
        if let url = URL(string: "https://api.github.com/users/\((Users?.login)!)/repos") {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, response, error) in
                if error == nil {
                    let decoder = JSONDecoder()
                    if let safeData = data {
                        do {
                            self.ReposData = try decoder.decode([APIReposData].self, from: safeData)
                            DispatchQueue.main.async {
                                completed()
                            }
                        } catch {
                            print("JSON Error")
                        }
                    }
                }
            }
            task.resume()
        }
    }
    
}
