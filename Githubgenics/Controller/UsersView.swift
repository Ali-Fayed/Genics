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
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.isSkeletonable = true
        tableView.rowHeight = 100.0
        navigationItem.hidesBackButton = true
        fetchData()
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        LoadingIndicator()
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.dismiss(animated: false, completion: nil)
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
            let alert = UIAlertController(title: "Error Sign Out", message: "check your internet", preferredStyle: .alert)
            let action = UIAlertAction(title: "Try Again", style: .default) { (action) in
            }
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
            self.tableView.stopSkeletonAnimation()
//            self.view.hideSkeleton(reloadDataAfter: true, transition: .crossDissolve(0.25))
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
    
    // MARK: - TableView Datasource Methods
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return UsersAPIStruct.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath) as! UsersCell
        cell.UserNameLabel?.text = UsersAPIStruct[indexPath.row].login.capitalized
        let APIImageurl = "https://avatars0.githubusercontent.com/u/\(UsersAPIStruct[indexPath.row].id)?v=4"
        cell.ImageView.kf.setImage(with: URL(string: APIImageurl), placeholder: nil, options: [.transition(.fade(0.7))])
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destnation = segue.destination as? DetailView {
            destnation.Users = UsersAPIStruct[(tableView.indexPathForSelectedRow?.row)!]
        }
    }
    
    
    
    
    // MARK: - JSON Decoder
    
    func fetchData() {
        let url = "https://api.github.com/users?per_page=100"
        AF.request(url, method: .get).responseJSON { (response) in
            do {
                let users = try JSONDecoder().decode([UsersStruct].self, from: response.data!)
                self.UsersAPIStruct = users
                self.tableView.reloadData()
            } catch {
                let error = error
                print("Users Parse Error")
                print(error.localizedDescription)
            }
        }
    }
    
    // MARK: - DataBase
    
    func saveItems() {
        
        do {
            try context.save()
        } catch {
            print("Error saving context \(error.localizedDescription)")
        }
        
        self.tableView.reloadData()
    }

    @IBAction func Data(_ sender: UIBarButtonItem) {
 
    }
    
    // MARK: - Loader and SkeletonView
    
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
    
    override func viewDidAppear(_ animated: Bool) {

        super.viewDidAppear(animated)
        tableView.isSkeletonable = true
        tableView.showAnimatedGradientSkeleton(usingGradient: .init(baseColor: #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)), animation: nil, transition: .crossDissolve(0.25))
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.tableView.stopSkeletonAnimation()
            self.view.hideSkeleton(reloadDataAfter: true, transition: .crossDissolve(0.25))
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.tableView.stopSkeletonAnimation()
            self.view.hideSkeleton(reloadDataAfter: true, transition: .crossDissolve(0.25))
        }

    }
    
}



