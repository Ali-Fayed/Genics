import UIKit




class ReposView: UITableViewController {
    
    var Users = [APIUsersData]()
    var SpecificUser = [UserAPI]()
    var ReposData = [APIReposData]()
    var UsersCall:APIUsersData?
    var SpeicficUserCall:UserAPI?
    var ReposCall:APIReposData?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        FetchRepos {
            print("Repos List Loaded")
            self.tableView.reloadData()
            self.tableView.rowHeight = 100.0
        }
        
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ReposData.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        cell.textLabel?.text = ReposData[indexPath.row].name.capitalized
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    // MARK: - JSON Decoder
    
    func FetchRepos(completed: @escaping () -> ()) {
        if let url = URL(string: "https://api.github.com/users/ivey/repos") {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, response, error) in
                if error == nil {
                    let decoder = JSONDecoder()
                    if let safeData = data {
                        do {
                            self.ReposData = try decoder.decode([APIReposData].self, from: safeData)
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
