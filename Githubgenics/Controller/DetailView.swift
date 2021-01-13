//
//  DetailViewController.swift
//  Githubgenics
//
//  Created by Ali Fayed on 21/12/2020.
//

import UIKit
import Firebase
import SkeletonView
import Alamofire
import Kingfisher

//MARK:- Main Class



class Celll: UITableViewCell {
    
    
    public var Users:UsersStruct?
    
    public var defaults = UserDefaults.standard
    
    @IBOutlet weak var RepoNameLabel: UILabel!
    
}



class DetailView: UIViewController {
    var ReposData = [ReposStruct]()
    var repo:ReposStruct?
    public var Users:UsersStruct?
    public var defaults = UserDefaults.standard
    var refreshControl = UIRefreshControl()
    
    var setImageStatus: String = "off" {
        willSet {
            if newValue == "on" {
                Btn.setImage(UIImage(systemName: "heart.fill"), for: .normal) }
            else { Btn.setImage(UIImage(systemName: "heart"), for: .normal) }
        }
    }
    
    @IBOutlet weak var Btn: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var UserName: UILabel!
    @IBOutlet weak var ImageView: UIImageView!
    @IBOutlet weak var Site: UIBarButtonItem!
    
    @IBAction func Btn(_ sender: UIButton) {
        let stat = setImageStatus == "on" ? "off" : "on"
        setImageStatus = stat
        defaults.set(stat, forKey: ((Users?.login)!))
        print(stat)
    }
    
    
    @objc func refresh(_ sender: AnyObject) {
        FetchRepos()
        refreshControl.endRefreshing()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        FetchRepos ()
        
        refreshControl.attributedTitle = NSAttributedString(string: "")
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        tableView.addSubview(refreshControl) // not required when using UITableViewController
        refreshControl.endRefreshing()
        
        if let imgStatus = defaults.string(forKey: ((Users?.login)!))
        { setImageStatus = imgStatus }
        else { setImageStatus = "off" }
        
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        UserName.text = "\((Users?.login.capitalized)!)"
        let APIImageurl = (Users?.avatar_url)!
        ImageView.kf.indicatorType = .activity
        ImageView.kf.setImage(with: URL(string: APIImageurl), placeholder: nil, options: [.transition(.fade(0.7))], progressBlock: nil)
        ImageView.layer.borderWidth = 1
        ImageView.layer.masksToBounds = false
        ImageView.layer.cornerRadius = ImageView.frame.height/2
        ImageView.clipsToBounds = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = false
        navigationController?.isToolbarHidden = false
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
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
    
    //MARK:- Fetch Repostories 
    
    func FetchRepos() {
        let url = "https://api.github.com/users/\((Users?.login)!)/repos"
        AF.request(url, method: .get).responseJSON { (response) in
            do {
                if let safedata = response.data {
                    let repos = try JSONDecoder().decode([ReposStruct].self, from: safedata)
                    self.ReposData = repos
                    self.tableView.reloadData()
                    self.SkeletonViewLoader ()
                }
            }
            catch {
                let error = error
                print(error.localizedDescription)
                self.ErroLoadingRepos ()
            }
        }
    }
    
    func SkeletonViewLoader () {
        tableView.isSkeletonable = true
        tableView.showAnimatedGradientSkeleton(usingGradient: .init(baseColor: #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)), animation: nil, transition: .crossDissolve(0.25))
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.tableView.stopSkeletonAnimation()
            self.view.hideSkeleton(reloadDataAfter: true, transition: .crossDissolve(0.25))
        }
    }
    
    func ErroLoadingRepos () {
        let alert = UIAlertController(title: "Server Error", message: "Repositories server not stable", preferredStyle: .alert)
        let action = UIAlertAction(title: "Try Again", style: .default) { (action) in

        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
}

//MARK:- TableView

extension DetailView: UITableViewDataSource , UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ReposData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RepoCell", for: indexPath) as! Celll
        cell.RepoNameLabel?.text = ReposData[indexPath.row].name.capitalized
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destnation = segue.destination as? Repositories {
            destnation.Repo = ReposData[(tableView.indexPathForSelectedRow?.row)!]
        }
    }
    
}
