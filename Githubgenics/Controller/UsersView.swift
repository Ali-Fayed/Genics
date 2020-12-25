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
    
    var UsersAPIStruct = [UsersStruct]()
    var ReposData = [APIReposData]()
    var SpeicficUserCall:UsersStruct?
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
        return UsersAPIStruct.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath) as! UsersCell
        cell.UserNameLabel?.text = UsersAPIStruct[indexPath.row].login.capitalized
        let APIImageurl = "https://avatars0.githubusercontent.com/u/\(UsersAPIStruct[indexPath.row].id)?v=4"
        cell.ImageView.downloaded(from: APIImageurl)
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
    
    func fetchData(completed: @escaping () -> ()) {
        if let url = URL(string: "https://api.github.com/users?per_page=150") {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, response, error) in
                if error == nil {
                    let decoder = JSONDecoder()
                    if let safeData = data {
                        do {
                            self.UsersAPIStruct = try decoder.decode([UsersStruct].self, from: safeData)
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
