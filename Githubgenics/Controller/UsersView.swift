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

class UsersView: UITableViewController {

    var UsersAPIStruct = [UsersStruct]()
    var checkmarks = [Int : Bool]()
    
    override func viewDidLoad() {
        self.SkeletonViewLoader()

        super.viewDidLoad()
        view.isSkeletonable = true
        tableView.rowHeight = 100.0
        navigationItem.hidesBackButton = true
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        LoadingIndicator()
        if let checks = UserDefaults.standard.value(forKey: "checkmarks") as? NSData {
            checkmarks = NSKeyedUnarchiver.unarchiveObject(with: checks as Data) as! [Int : Bool]
        }
        
       // MARK: - Call Fetch Function
        
        Fetch(pagination: false) { (result) in
            switch result {
            case.success( _):
                self.UsersAPIStruct.append(contentsOf: self.UsersAPIStruct)
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            case.failure(_):
                break
            }
        }
        
        
       
    }
    
    
    // MARK: - Sign Out Auth
    
    @IBAction func SignOuut(_ sender: UIBarButtonItem) {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            navigationController?.popToRootViewController(animated: true)
            UserDefaults.standard.removeObject(forKey: "email")
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
            SignOutError()
        }
    }
    
    // MARK: - GitHubURL Button
    
    @IBAction func GitHubURL(_ sender: UIBarButtonItem) {
        let APIurl = ("https://github.com/")
        guard let url = URL(string: APIurl)
        else {
            return }
        let vc = WebManger(url: url, title: "Google")
        let navVc = UINavigationController(rootViewController: vc)
        present(navVc, animated: true)
    }
    
    // MARK: - TableView Methods
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return UsersAPIStruct.count
    }
     
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath) as! UsersCell
        cell.UserNameLabel?.text = UsersAPIStruct[indexPath.row].login.capitalized
        let APIImageurl = "https://avatars0.githubusercontent.com/u/\(UsersAPIStruct[indexPath.row].id)?v=4"
        cell.ImageView.kf.setImage(with: URL(string: APIImageurl), placeholder: nil, options: [.transition(.fade(0.7))])
        if checkmarks[indexPath.row] != nil {
            cell.accessoryType = checkmarks[indexPath.row]! ? .checkmark : .none
            
        } else {
            checkmarks[indexPath.row] = false
            cell.accessoryType = .none
        }
        return cell
        
    }

    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if let cell = tableView.cellForRow(at: indexPath as IndexPath) {
            if cell.accessoryType == .checkmark {
                cell.accessoryType = .none
                checkmarks[indexPath.row] = false
            }
            else{
                cell.accessoryType = .checkmark
                checkmarks[indexPath.row] = true
            }
        }
        UserDefaults.standard.set(NSKeyedArchiver.archivedData(withRootObject: checkmarks), forKey: "checkmarks")
        UserDefaults.standard.synchronize()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destnation = segue.destination as? DetailView {
            destnation.Users = UsersAPIStruct[(tableView.indexPathForSelectedRow?.row)!]
        }
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let postion = scrollView.contentOffset.y
        if postion > (tableView.contentSize.height-80-scrollView.frame.size.height) {
            guard !isPaginating else {
                return
            }
            Fetch(pagination: true) { [weak self] result in
                DispatchQueue.main.async {
                    self?.tableView.tableFooterView = nil
                }
                switch result {
                case .success(let UsersAPIStruct):
                    self?.UsersAPIStruct.append(contentsOf: UsersAPIStruct)
                    DispatchQueue.main.async {
                        self?.tableView.reloadData()
                    }
                case .failure(_):
                    break
                }
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let LastSection = tableView.numberOfSections - 1
        let lastRowIndex = tableView.numberOfRows(inSection: LastSection) - 1
        if indexPath.section ==  LastSection && indexPath.row == lastRowIndex {
            DisplaySpinner ()
        }
        
        
    }
    
    
    
    // MARK: - Fetch Data From GitHubAPI
    
   private var Users : [UsersStruct] = []
   var isPaginating = false
   
   func Fetch(pagination: Bool = false, complete: @escaping (Result<[UsersStruct], Error>) -> Void ) {
       
       if pagination {
           isPaginating = true
       }
    
       DispatchQueue.global().asyncAfter(deadline: .now() + (pagination ? 3 : 2)) {
           AF.request("https://api.github.com/users?since=\(Int.random(in: 1 ... 9000))", method: .get).responseJSON { (response) in
               do {
                   let users = try JSONDecoder().decode([UsersStruct].self, from: response.data!)
                   self.Users = users
                   self.tableView.reloadData()
                   DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                       self.dismiss(animated: false, completion: nil)
                   }
                self.SkeletonViewLoader()

                print("Users Parse Done")
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

    
    // MARK: - Loaders
    
    func LoadingIndicator() {
        let alert = UIAlertController(title: nil, message: "Please wait...", preferredStyle: .alert)
        alert.view.tintColor = UIColor.black
        let loadingIndicator: UIActivityIndicatorView = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50)) as UIActivityIndicatorView
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.style = UIActivityIndicatorView.Style.medium
        loadingIndicator.startAnimating();
        alert.view.addSubview(loadingIndicator)
        present(alert, animated: true, completion: nil)
    }
    
    func SkeletonViewLoader () {
        tableView.isSkeletonable = true
        tableView.showAnimatedGradientSkeleton(usingGradient: .init(baseColor: #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)), animation: nil, transition: .crossDissolve(0.25))
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.tableView.stopSkeletonAnimation()
            self.view.hideSkeleton(reloadDataAfter: true, transition: .crossDissolve(0.25))
        }
    }
    
    func SignOutError () {
        let alert = UIAlertController(title: "Error Sign Out", message: "check your internet", preferredStyle: .alert)
        let action = UIAlertAction(title: "Try Again", style: .default) { (action) in
        }
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    
    func DisplaySpinner () {
        let spinner = UIActivityIndicatorView(style: .medium)
        spinner.startAnimating()
        spinner.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: tableView.bounds.width, height: CGFloat(44))
        self.tableView.tableFooterView = spinner
        self.tableView.tableFooterView?.isHidden = false
    }
    

}



