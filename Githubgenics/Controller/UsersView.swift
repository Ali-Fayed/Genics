//
//  TableViewController.swift
//  Githubgenics
//
//  Created by Ali Fayed on 22/12/2020.
//
//extension UIImageView {
//
//    func downloaded(from url: URL, contentMode mode: UIView.ContentMode = .scaleAspectFit) {
//        contentMode = mode
//        URLSession.shared.dataTask(with: url) { data, response, error in
//            guard
//                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
//                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
//                let data = data, error == nil,
//                let image = UIImage(data: data)
//                else { return }
//            DispatchQueue.main.async() { [weak self] in
//                self?.image = image
//            }
//        }.resume()
//    }
//    func downloaded(from link: String, contentMode mode: UIView.ContentMode = .scaleAspectFit) {
//        guard let url = URL(string: link) else { return }
//        downloaded(from: url, contentMode: mode)
//    }
//}
import UIKit
import Firebase
import SkeletonView
import WebKit




extension UIImageView {
    func downloaded(from url: URL, contentMode mode: UIView.ContentMode = .scaleAspectFit) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
            else { return }
            DispatchQueue.main.async() { [weak self] in
                self?.image = image
            }
        }.resume()
    }
    func downloaded(from link: String, contentMode mode: UIView.ContentMode = .scaleAspectFit) {
        guard let url = URL(string: link) else { return }
        downloaded(from: url, contentMode: mode)
    }
}


class UsersView: UITableViewController  {
    
    var Users = [APIUsersData]()
    var SpecificUser = [UserAPI]()
    var ReposData = [APIReposData]()
    var UsersCall:APIUsersData?
    var SpeicficUserCall:UserAPI?
    var ReposCall:APIReposData?
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        view.isSkeletonable = true
        view.showAnimatedGradientSkeleton()
        tableView.rowHeight = 100.0
        navigationItem.hidesBackButton = true
        
        fetchData {
            print("JSON Users Data Loaded")
            self.tableView.reloadData()
        }
        
        view.hideSkeleton()
    }
    
    
    // MARK: - Sign Out Auth
    
    
    @IBAction func SignOuut(_ sender: UIBarButtonItem) {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            navigationController?.popToRootViewController(animated: true)
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
    }
    
    // MARK: - TableView Datasource Methods
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Users.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath) as! UsersCell
        cell.UserNameLabel?.text = Users[indexPath.row].login.capitalized
        let APIImageurl = "https://avatars0.githubusercontent.com/u/\(Users[indexPath.row].id)?v=4"
        cell.ImageView.downloaded(from: APIImageurl)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destnation = segue.destination as? DetailView {
            destnation.UsersCall = Users[(tableView.indexPathForSelectedRow?.row)!]
        }
    }
    
    
    
    
    // MARK: - JSON Decoder
    
    func fetchData(completed: @escaping () -> ()) {
        if let url = URL(string: "https://api.github.com/users?since=5") {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, response, error) in
                if error == nil {
                    let decoder = JSONDecoder()
                    if let safeData = data {
                        do {
                            self.Users = try decoder.decode([APIUsersData].self, from: safeData)
                            DispatchQueue.main.async {
                                completed()
                            }
                        } catch {
                            let error = error
                            print("JSON Error")
                            print(error.localizedDescription)
                        }
                    }
                }
            }
            task.resume()
        }
        
        
    }
    
}
