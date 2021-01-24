//
//  TableViewController.swift
//  Githubgenics
//
//  Created by Ali Fayed on 22/12/2020.
//

import UIKit
import Firebase
import SkeletonView
import Alamofire
import Kingfisher
import CoreData

class UsersListViewController: UITableViewController {
    
    static let shared = UsersListViewController()

    var usersParameters = [UsersStruct]()
   
    @IBOutlet weak var SignOutBT: UIBarButtonItem!
  
    

    //MARK:- View LifeCycle Methods
    
    override func viewDidLoad() {
        
        if NetworkReachabilityModel.shared.isConnected {
            print("connected")
        } else {
            print("You're not")
        }
        super.viewDidLoad()
        self.tabBarController?.navigationItem.hidesBackButton = true
        self.tabBarController?.navigationItem.leftBarButtonItem = SignOutBT
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        fetchFirstPage ()
        SignOutBT.title = "Signout".localized()
        let longPress = UILongPressGestureRecognizer()
        self.tableView.addGestureRecognizer(longPress)
        longPress.addTarget(self, action: #selector(ges))
    }
    
    @objc func ges () {
        print("done")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isToolbarHidden = true
        navigationController?.isNavigationBarHidden = false
        tableView.resignFirstResponder()

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        self.tabBarController?.navigationItem.title = "Github Users".localized()

    }
    
 

    
    // MARK: - Networking Methods
    
   private var Users : [UsersStruct] = []
   var isPaginating = false

    
    
    func MainFetchFunctions(pagination: Bool = false, since : Int , page : Int , complete: @escaping (Result<[UsersStruct], Error>) -> Void ) {

       if pagination {
           isPaginating = true
       }
       DispatchQueue.global().asyncAfter(deadline: .now() + (pagination ? 3 : 2)) {
        let url = "https://api.github.com/users?since=\(since)&per_page=\(page)"

        AF.request(url , method: .get).responseJSON { (response) in
               do {
                   let users = try JSONDecoder().decode([UsersStruct].self, from: response.data!)
                   self.Users = users
                   self.tableView.reloadData()
                   self.dismiss(animated: false, completion: nil)

                print("Main Fetch")
               } catch {
                   let error = error
                   print(error.localizedDescription)
               }
           }
           complete(.success( pagination ? self.Users : self.Users ))

           if pagination {
               self.isPaginating = false
           }
       }
   }
    
    
    
    func fetchFirstPage () {
        AF.request("https://api.github.com/users", method: .get).responseJSON { (response) in
            do {
                if let safedata = response.data {
                    let repos = try JSONDecoder().decode([UsersStruct].self, from: safedata)
                    self.usersParameters = repos
                    self.tableView.reloadData()
                    self.shimmerLoadingView ()
                }
            }
            catch {
                let error = error
                print(error.localizedDescription)
                self.serverErrorAlert()
            }
        }
    }

    func FetchMoreUsers () {
        guard !isPaginating else {
            return
        }
        MainFetchFunctions(pagination: true, since: Int.random(in: 40 ... 5000 ), page: 10 ) { [weak self] result in
            DispatchQueue.main.async {
                self?.tableView.tableFooterView = nil
            }
            switch result {
            case .success(let UsersAPIStruct):
                self?.usersParameters.append(contentsOf: UsersAPIStruct)
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }

            case .failure(_):
                self!.serverErrorAlert()
            break
            }
        }
    }
    
    
    func shimmerLoadingView () {
        tableView.isSkeletonable = true
        tableView.showAnimatedGradientSkeleton(usingGradient: .init(baseColor: #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)), animation: nil, transition: .crossDissolve(0.25))
        tableView.skeletonCornerRadius = 5
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.tableView.stopSkeletonAnimation()
            self.view.hideSkeleton(reloadDataAfter: true, transition: .crossDissolve(0.25))
        }
    }
    
    
    func serverErrorAlert () {
        let alert = UIAlertController(title: "Server isn't stable", message: "Pull to refresh to load the data", preferredStyle: .alert)
        let action = UIAlertAction(title: "Try Again", style: .default) { (action) in
            self.MainFetchFunctions(pagination: false, since: 1, page: 20) { (result) in
                switch result {
                case.success( let UsersAPIStruct):
                    self.usersParameters.append(contentsOf: UsersAPIStruct)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        self.tableView.reloadData()
                    }
                case.failure(_):
                    break
                }
            }
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func refreshTable(_ sender: UIRefreshControl) {
        sender.endRefreshing()
        fetchFirstPage ()
    }
    
    
    
    //MARK:- signOut
    
    
    @IBAction func SignOut(_ sender: UIBarItem) {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            for controller in self.navigationController!.viewControllers as Array {
                if controller.isKind(of: WelcomeScreen.self) {
                    self.navigationController!.popToViewController(controller, animated: true)
                    break
                }
            }
            UserDefaults.standard.removeObject(forKey: "email")
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
            SignOutError()
        }
    }
    
    func SignOutError () {
        let alert = UIAlertController(title: "Error Sign Out", message: "check your internet", preferredStyle: .alert)
        let action = UIAlertAction(title: "Try Again", style: .default) { (action) in
        }
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    
    
    // MARK: - TableView DataSource and Delegate Methods
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
       return 60
   }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return usersParameters.count
    }
     
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: UsersCell.identifier, for: indexPath) as! UsersCell
        cell.CellData(with: usersParameters[indexPath.row])
        let longPress = UILongPressGestureRecognizer()
        cell.addGestureRecognizer(longPress)
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destnation = segue.destination as? DetailViewController {
            destnation.passedUserData = usersParameters[(tableView.indexPathForSelectedRow?.row)!]
        }
    }
    
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let postion = scrollView.contentOffset.y
        if postion > (tableView.contentSize.height-100-scrollView.frame.size.height) {
            FetchMoreUsers()
        }
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == usersParameters.count - 1 {
            tableViewSpinner()
        }
    }
    
    func tableViewSpinner () {
        let spinner = UIActivityIndicatorView(style: .medium)
        spinner.startAnimating()
        spinner.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: tableView.bounds.width, height: CGFloat(44))
        self.tableView.tableFooterView = spinner
        self.tableView.tableFooterView?.isHidden = false
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let important = importantAction(at: indexPath)
        return UISwipeActionsConfiguration(actions: [important])
    }
    
    func importantAction(at indexPath: IndexPath) -> UIContextualAction {
        let action = UIContextualAction(style: .normal, title: "Bookmark") { [self] (action, view, completion) in
     
        }
        action.image = #imageLiteral(resourceName: "like")
        action.backgroundColor = .gray
        return action
    }
    

}

//MARK:- SearchBar Methods

extension UsersListViewController: UISearchBarDelegate {
    
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        performSegue(withIdentifier: "SearchBar", sender: self)
    }
    
}

//MARK:- Localization Extention

extension String {
    func localized () -> String {
        return NSLocalizedString(self, tableName: "Localizable", bundle: .main, value: self, comment: self
        )
    }
}
