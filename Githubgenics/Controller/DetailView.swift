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
import SafariServices

//MARK:- Main Class



class Celll: UITableViewCell {
    
    
    @IBOutlet weak var RepoNameLabel: UILabel!
    @IBOutlet weak var De: UITextView!
    @IBOutlet weak var likec: UILabel!
    @IBOutlet weak var language: UILabel!
    
    
    
    
    func CellData(with model: ReposStruct) {
        self.RepoNameLabel.text = model.name
        self.De.text = model.description
        self.likec.text = String(model.stargazers_count)
        self.language.text = model.language
        
//        RepoNameLabel.layer.masksToBounds = false
//        RepoNameLabel.layer.cornerRadius = RepoNameLabel.frame.height/2
//        RepoNameLabel.clipsToBounds = true
//        
//        De.layer.masksToBounds = false
//        De.layer.cornerRadius = De.frame.height/2
//        De.clipsToBounds = true
//        
//        likec.layer.masksToBounds = false
//        likec.layer.cornerRadius = likec.frame.height/2
//        likec.clipsToBounds = true
//        
//        language.layer.masksToBounds = false
//        language.layer.cornerRadius = language.frame.height/2
//        language.clipsToBounds = true
    }

    
}



class DetailView: UIViewController {
    var ReposData = [ReposStruct]()
     var Users:UsersStruct?
    public var defaults = UserDefaults.standard
    var refreshControl = UIRefreshControl()
    
    var setButtonState: String = "off" {
        willSet {
            if newValue == "on" {
                Btn.setBackgroundImage(UIImage(named: "like"), for: .normal) }
            else { Btn.setBackgroundImage(UIImage(named: "unlike"), for: .normal) }
        }
    }
    
    @IBOutlet weak var Btn: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var UserName: UILabel!
    @IBOutlet weak var ImageView: UIImageView!
    @IBOutlet weak var Site: UIBarButtonItem!
    @IBOutlet weak var Followers: UILabel!
    
    @IBOutlet weak var Following: UILabel!
    @IBAction func Btn(_ sender: UIButton) {
        let stat = setButtonState == "on" ? "off" : "on"
        setButtonState = stat
        defaults.set(stat, forKey: ((Users?.login)!))
        print(stat)
    }
    
    
    @objc func refresh(_ sender: AnyObject) {
        FetchRepositories()
        refreshControl.endRefreshing()
    }
    override func viewDidLoad() {
        tableView.rowHeight = 120.0
        super.viewDidLoad()
        FetchRepositories ()
        UserAvatar ()
        
        refreshControl.attributedTitle = NSAttributedString(string: "")
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        tableView.addSubview(refreshControl)
        refreshControl.endRefreshing()
        
        if let ButtonState = defaults.string(forKey: ((Users?.login)!))
        { setButtonState = ButtonState }
        else { setButtonState = "off" }
        
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        UserName.text = "\((Users?.login.capitalized)!)"
        Followers.text = String(Int.random(in: 10 ... 50))
        Following.text = String(Int.random(in: 10 ... 50))
        
    }
    
    func UserAvatar () {
        let avatar_URL = (Users?.avatar_url)!
        ImageView.kf.indicatorType = .activity
        ImageView.kf.setImage(with: URL(string: avatar_URL), placeholder: nil, options: [.transition(.fade(0.7))], progressBlock: nil)
        ImageView.layer.masksToBounds = false
        ImageView.layer.cornerRadius = ImageView.frame.height/2
        ImageView.clipsToBounds = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = false
        navigationController?.isToolbarHidden = true
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
    
    //MARK:- WebView
    
//    @IBAction func Site(_ sender: UIBarButtonItem) {
//        let APIurl = (Users?.html_url)!
//        guard let url = URL(string: APIurl)
//        else {
//            return }
//        let vc = WebManger(url: url, title: "Google")
//        let navVc = UINavigationController(rootViewController: vc)
//        present(navVc, animated: true)
//    }
    
    //MARK:- Fetch Repostories 
    
    func FetchRepositories() {
        let url = "https://api.github.com/users/\((Users?.login)!)/repos?per_page=6"
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
        cell.CellData(with: ReposData[indexPath.row])
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let url = ReposData[indexPath.row].html_url
        let vc = SFSafariViewController(url: URL(string: url)!)
        present(vc, animated: true)
    }
    
}
