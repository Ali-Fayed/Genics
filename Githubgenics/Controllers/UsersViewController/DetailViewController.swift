//
//  DetailViewController.swift
//  Githubgenics
//
//  Created by Ali Fayed on 21/12/2020.
//

import UIKit
import SkeletonView
import Alamofire
import Kingfisher
import SafariServices

//MARK:- Main Class

class DetailViewController: UIViewController  {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var userRepository : [UserRepository] = []
    var passedUser : Users?
    var usersDataBase = [UsersDataBase]()
    var savedRepositories = [SavedRepositories]()

    @IBOutlet weak var BookmarkBT: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var UserName: UILabel!
    @IBOutlet weak var ImageView: UIImageView!
    @IBOutlet weak var Followers: UILabel!
    @IBOutlet weak var Following: UILabel!
    
    
    //MARK:- View Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        navigationItem.title = "Detail View".localized()
        userInfo ()
        loadTheButtonWithSavedState ()
        guard let repository = passedUser else {return}
        NetworkingManger.shared.fetchClickedRepositories(for: repository.login!) { (repos) in
            self.userRepository = repos
            self.tableView.reloadData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = false
        navigationController?.isToolbarHidden = true
    }
    

    //MARK:- DataBase Methods
    
    func saveBookmarkedUser (login: String , avatar_url: String , html_url: String) {
        let DataParameters = UsersDataBase(context: context)
        DataParameters.login = login
        DataParameters.avatar_url = avatar_url
        DataParameters.html_url = html_url
        do {
            try context.save()
              fetchBookmarkedUsers ()
        } catch {
            
        }
    }
    
    func saveBookmarkedRepository (name: String , descriptin: String , url: String , stars: Int) {
        let DataParameters = SavedRepositories(context: context)
        DataParameters.name = name as NSObject
        DataParameters.descriptin = descriptin as NSObject
        DataParameters.url = url as NSObject
        DataParameters.stars = stars as NSObject
        do {
            try context.save()
              fetchBookmarkedUsers ()
        } catch {
            
        }
    }

    func fetchBookmarkedUsers () {
        do {
            usersDataBase = try context.fetch(UsersDataBase.fetchRequest())
            savedRepositories = try context.fetch(SavedRepositories.fetchRequest())
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        } catch {
            //error
        }
    }
    
    //MARK:- User Bookmark Button
    
    var defaults = UserDefaults.standard
    let refreshControl = UIRefreshControl()
    var setFavBTState: String = "off" {
        willSet {
            if newValue == "on" {
                BookmarkBT.setBackgroundImage(UIImage(named: "like"), for: .normal)
                let login = passedUser?.login
                let image = passedUser?.avatar_url
                let url = passedUser?.html_url
                saveBookmarkedUser(login: login!, avatar_url: image!, html_url: url!)
            }
            else { BookmarkBT.setBackgroundImage(UIImage(named: "unlike"), for: .normal)

            }
        }
    }
    
    @IBAction func BookmarkBT(_ sender: UIButton) {
        let stat = setFavBTState == "on" ? "off" : "on"
        setFavBTState = stat
        defaults.set(stat, forKey: ((passedUser?.login)!))
        print(stat)
    }
    
    func loadTheButtonWithSavedState () {
        if let ButtonState = defaults.string(forKey: ((passedUser?.login)!))
        { setFavBTState = ButtonState }
        else { setFavBTState = "off" }
    }
    

    //MARK:- Other Methods
    
    func userInfo () {
        UserName.text = "\((passedUser?.login?.capitalized)!)"
        let avatar_URL = (passedUser?.avatar_url)!
        ImageView.kf.indicatorType = .activity
        ImageView.kf.setImage(with: URL(string: avatar_URL), placeholder: nil, options: [.transition(.fade(0.7))], progressBlock: nil)
        ImageView.layer.masksToBounds = false
        ImageView.layer.cornerRadius = ImageView.frame.height/2
        ImageView.clipsToBounds = true
        Followers.text = String(Int.random(in: 10 ... 50))
        Following.text = String(Int.random(in: 10 ... 50))
    }
    
    func shimmerLoadingView () {
        tableView.isSkeletonable = true
        tableView.showAnimatedGradientSkeleton(usingGradient: .init(baseColor: #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)), animation: nil, transition: .crossDissolve(0.25))
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.tableView.stopSkeletonAnimation()
            self.view.hideSkeleton(reloadDataAfter: true, transition: .crossDissolve(0.25))
        }
    }

}


//MARK:-  TableView DataSource

extension DetailViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userRepository.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RepoCell", for: indexPath) as! ReposCell
        cell.CellData(with: userRepository[indexPath.row])
        cell.BookmarkRepo?.tag = indexPath.row
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
       return 120
   }
}

//MARK:- TableView Delegate

extension DetailViewController: UITableViewDelegate {
    
  
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let url = userRepository[indexPath.row].html_url
        let vc = SFSafariViewController(url: URL(string: url!)!)
        present(vc, animated: true)
    }
    
    func DisplaySpinner () {
        let spinner = UIActivityIndicatorView(style: .medium)
        spinner.startAnimating()
        spinner.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: tableView.bounds.width, height: CGFloat(44))
        self.tableView.tableFooterView = spinner
        self.tableView.tableFooterView?.isHidden = false
    }

}
    

