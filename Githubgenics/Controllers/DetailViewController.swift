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

class DetailViewController: UIViewController {
        
    var ReposData = [ReposStruct]()
    var Users:UsersStruct?
    var defaults = UserDefaults.standard
    let refreshControl = UIRefreshControl()
    var setFavBTState: String = "off" {
        willSet {
            if newValue == "on" {
                BookmarkBT.setBackgroundImage(UIImage(named: "like"), for: .normal) }
            else { BookmarkBT.setBackgroundImage(UIImage(named: "unlike"), for: .normal) }
        }
    }
    
    @IBOutlet weak var BookmarkBT: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var UserName: UILabel!
    @IBOutlet weak var ImageView: UIImageView!
    @IBOutlet weak var Followers: UILabel!
    @IBOutlet weak var Following: UILabel!
    
    
    
    @IBAction func BookmarkBT(_ sender: UIButton) {
        let stat = setFavBTState == "on" ? "off" : "on"
        setFavBTState = stat
        defaults.set(stat, forKey: ((Users?.login)!))
        print(stat)
    }

    
    //MARK:- View Lifecycle Func
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        FetchRepositories ()
        UserProfileInfo ()
        tableView.rowHeight = 120.0
        RefreshControl ()
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        navigationItem.title = "Detail View".localized()
        
        if let ButtonState = defaults.string(forKey: ((Users?.login)!))
        { setFavBTState = ButtonState }
        else { setFavBTState = "off" }

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
    

   
    //MARK:- Detail View Functions
    
    func UserProfileInfo () {
        UserName.text = "\((Users?.login.capitalized)!)"
        let avatar_URL = (Users?.avatar_url)!
        ImageView.kf.indicatorType = .activity
        ImageView.kf.setImage(with: URL(string: avatar_URL), placeholder: nil, options: [.transition(.fade(0.7))], progressBlock: nil)
        ImageView.layer.masksToBounds = false
        ImageView.layer.cornerRadius = ImageView.frame.height/2
        ImageView.clipsToBounds = true
        Followers.text = String(Int.random(in: 10 ... 50))
        Following.text = String(Int.random(in: 10 ... 50))
    }
    
    private var Reposs : [ReposStruct] = []
    var isPaginating = false
 
    func MainFetchFunctions(pagination: Bool = false , complete: @escaping (Result<[ReposStruct], Error>) -> Void ) {
        


           
        
        
        if pagination {
            isPaginating = true
        }
        DispatchQueue.global().asyncAfter(deadline: .now() + (pagination ? 3 : 2)) {
            let url = "https://api.github.com/users/\((self.Users?.login)!)/repos?per_page=\(3)"

         AF.request(url , method: .get).responseJSON { (response) in
                do {
                    let repos = try JSONDecoder().decode([ReposStruct].self, from: response.data!)
                    self.Reposs = repos
                 self.tableView.reloadData()
                 self.dismiss(animated: false, completion: nil)

                 print("Main Fetch")
                } catch {
                    let error = error
                    print(error.localizedDescription)
                }
            }
            complete(.success( pagination ? self.Reposs : self.Reposs ))

            if pagination {
                self.isPaginating = false
            }
        }
    }
    
    
    func FetchRepositories(Page: Int = 5) {
        let url = "https://api.github.com/users/\((Users?.login)!)/repos?per_page=\(Page)"
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
    
    
    
    func RefreshControl () {
    refreshControl.attributedTitle = NSAttributedString(string: "")
    refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
    tableView.addSubview(refreshControl)
        refreshControl.endRefreshing()
    }
    
    @objc func refresh(_ sender: AnyObject) {
        FetchRepositories()
        refreshControl.endRefreshing()
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
    
    func DisplaySpinner () {
        let spinner = UIActivityIndicatorView(style: .medium)
        spinner.startAnimating()
        spinner.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: tableView.bounds.width, height: CGFloat(44))
        self.tableView.tableFooterView = spinner
        self.tableView.tableFooterView?.isHidden = false
    }
    
    
}


//MARK:- Repositories TableView Methods

extension DetailViewController: UITableViewDataSource , UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ReposData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RepoCell", for: indexPath) as! ReposCell
        cell.CellData(with: ReposData[indexPath.row])
        cell.BookmarkRepo.tag = indexPath.row
        return cell
    }
    
  
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let url = ReposData[indexPath.row].html_url
        let vc = SFSafariViewController(url: URL(string: url)!)
        present(vc, animated: true)
    }
    
     func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let postion = scrollView.contentOffset.y
        if postion > (tableView.contentSize.height-100-scrollView.frame.size.height) {
            PaginateRepos ()
        }
         
    }
    
     func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let LastSection = tableView.numberOfSections - 1
        let lastRowIndex = tableView.numberOfRows(inSection: LastSection) - 20
        if indexPath.section ==  LastSection && indexPath.row == lastRowIndex {

        }
        if indexPath.row == ReposData.count - 1 {
            DisplaySpinner()
        }

    }
        

    func  PaginateRepos () {
      guard !isPaginating else {
          return
      }
      MainFetchFunctions(pagination: true ) { [weak self] result in
          DispatchQueue.main.async {
              self?.tableView.tableFooterView = nil
          }
          switch result {
          case .success(let UsersAPIStruct):
              self?.ReposData.append(contentsOf: UsersAPIStruct)
              DispatchQueue.main.async {
                  self?.tableView.reloadData()
              }

          case .failure(_):
          break
          }
      }
  }
        
        }
    

