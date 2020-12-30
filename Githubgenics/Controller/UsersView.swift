//
//  TableViewController.swift
//  Githubgenics
//
//  Created by Ali Fayed on 22/12/2020.
//

import UIKit
import Firebase
import SkeletonView
import WebKit
import Alamofire
import Kingfisher
import CoreData

class UsersView: UITableViewController {
    
    let sessionManager: Session = {
        let configuration = URLSessionConfiguration.af.default
        configuration.requestCachePolicy = .returnCacheDataElseLoad
        let responseCacher = ResponseCacher(behavior: .modify { _, response in
            let userInfo = ["date": Date()]
            return CachedURLResponse(
                response: response.response,
                data: response.data,
                userInfo: userInfo,
                storagePolicy: .allowed)
        })
        
        let networkLogger = GitNetworkLogger()
        let interceptor = GitRequestInterceptor()
        
        return Session(
            configuration: configuration,
            interceptor: interceptor,
            cachedResponseHandler: responseCacher,
            eventMonitors: [networkLogger])
    }()
    
    
    var UsersAPIStruct = [UsersStruct]()
    var ReposData = [ReposStruct]()
    var SpeicficUserCall:UsersStruct?
    var ReposCall:ReposStruct?
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.isSkeletonable = true
        view.showAnimatedGradientSkeleton()
        tableView.rowHeight = 100.0
        navigationItem.hidesBackButton = true
        fetchData()
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
        let url = "https://api.github.com/users?since=100"
        sessionManager.request(url, method: .get).responseJSON { (response) in
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
    
    func saveItems() {
        
        do {
            try context.save()
        } catch {
            print("Error saving context \(error.localizedDescription)")
        }
        
        self.tableView.reloadData()
    }
    
    
    
}



