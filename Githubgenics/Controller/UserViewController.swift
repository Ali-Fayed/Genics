//
//  ViewController.swift
//  Githubgenicsk
//
//  Created by Ali Fayed on 21/12/2020.
//

import UIKit
import Firebase

// MARK: - Image Downloader

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

//MARK: - Class

class UserViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var Users = [APIUsersData]()
    
    // MARK: - ViewDidLoad
      
      override func viewDidLoad() {
          super.viewDidLoad()
   
        
          fetchData {
              print("JSON Loaded")
              self.tableView.reloadData()
          }
          tableView.dataSource = self
          tableView.delegate = self
         }
    
    // MARK: - Sign Out Auth
    
    @IBAction func SignOut(_ sender: UIBarButtonItem) {
        let firebaseAuth = Auth.auth()
    do {
      try firebaseAuth.signOut()
        navigationController?.popToRootViewController(animated: true)
    } catch let signOutError as NSError {
      print ("Error signing out: %@", signOutError)
    }
      }
    

    // MARK: - TableView Datasource Methods
    
    
    @IBOutlet weak var tableView: UITableView!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        cell.textLabel?.text = Users[indexPath.row].login.capitalized
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "SSS", sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destnation = segue.destination as? DetailViewController {
            destnation.User = Users[(tableView.indexPathForSelectedRow?.row)!]
        }
    }
    
//    let imageurl = "https://avatars0.githubusercontent.com/u/1?v=4"

// MARK: - JSON Decoder
    
    func fetchData(completed: @escaping () -> ()) {
        if let url = URL(string: "https://api.github.com/users") {
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
                            print("JSON Error")
                        }
                    }
                }
            }
            task.resume()
        }
    }

}

