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

//MARK:- Main Class

class DetailView: UIViewController {
    
    let sessionManager: Session = {
      let configuration = URLSessionConfiguration.af.default
      configuration.requestCachePolicy = .returnCacheDataElseLoad
      let responseCacher = ResponseCacher(behavior: .modify { _, response in
        let userInfo = ["date": Date()]
        return CachedURLResponse(
          response: response.response,
          data: response.data,
          userInfo: userInfo,
          storagePolicy: .allowed)
      })

      let networkLogger = GitNetworkLogger()
      let interceptor = GitRequestInterceptor()

      return Session(
        configuration: configuration,
        interceptor: interceptor,
        cachedResponseHandler: responseCacher,
        eventMonitors: [networkLogger])
    }()
    
    var UsersAPIStruct = [UsersStruct]()
    var ReposData = [ReposStruct]()
    var Users:UsersStruct?
    var Repos:ReposStruct?
    
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var UserName: UILabel!
    @IBOutlet weak var ImageView: UIImageView!
    @IBOutlet weak var Site: UIBarButtonItem!
    
    //MARK:- ViewDidLoad
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        tableView.rowHeight = 170.0
        tableView.dataSource = self
        tableView.delegate = self
        self.tableView.rowHeight = 100.0

        FetchRepos ()
        UserName.text = Users?.login
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
        sessionManager.request(url, method: .get).responseJSON { (response) in
          do {
            if let safedata = response.data {
                let users = try JSONDecoder().decode([ReposStruct].self, from: safedata)
               self.ReposData = users
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "RepoCell", for: indexPath) as! DetailCellTableViewCell
        cell.RepoNameLabel?.text = ReposData[indexPath.row].name.capitalized
        cell.Description?.text = ReposData[indexPath.row].description.capitalized
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
