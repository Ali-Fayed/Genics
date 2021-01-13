//
//  ViewController.swift
//  Githubgenics
//
//  Created by Ali Fayed on 11/01/2021.
//

import UIKit

class Repositories: UIViewController {
    public var defaults = UserDefaults.standard

    @IBOutlet weak var Butto: UIButton!
    @IBOutlet weak var Name: UILabel!
    @IBOutlet weak var LastUpdatedat: UILabel!
    
    @IBOutlet weak var Forks: UILabel!
    @IBOutlet weak var Stars: UILabel!
    
    @IBOutlet weak var Branch: UILabel!
    @IBOutlet weak var lang: UILabel!
    @IBOutlet weak var Createdat: UILabel!
    
    @IBOutlet weak var somedata: UILabel!
    @IBOutlet weak var Desc: UITextView!
    
    @IBOutlet weak var other: UILabel!
    
    @IBOutlet weak var watchers: UILabel!
    
    var Repo: ReposStruct?
    
    var setImageStatus: String = "off" {
        willSet {
            if newValue == "on" {
                Butto.setImage(UIImage(named: "Liked"), for: .normal) }
            else { Butto.setImage(UIImage(named: "Like"), for: .normal) }
        }
    }
    
    @IBAction func Btn(_ sender: UIButton) {
        let stat = setImageStatus == "on" ? "off" : "on"
        setImageStatus = stat
        defaults.set(stat, forKey: ((Repo?.name)!))
        print(stat)
    }
    
    
    @IBAction func Site(_ sender: Any) {
        let APIurl = (Repo?.html_url)!
        guard let url = URL(string: APIurl)
        else {
            return }
        let vc = WebManger(url: url, title: "Google")
        let navVc = UINavigationController(rootViewController: vc)
        present(navVc, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let imgStatus = defaults.string(forKey: ((Repo?.name)!))
        { setImageStatus = imgStatus }
        else { setImageStatus = "off" }
        
        Name.text = "\((Repo?.name.capitalized)!)"
        LastUpdatedat.text = "\((Repo?.updated_at.capitalized)!)"
        Forks.text = "\((Repo?.forks_count)!)"
        Createdat.text = "\((Repo?.created_at.capitalized)!)"
//        somedata.text = "\((Repo?.language.capitalized)!)"
        Desc.text = "\((Repo?.description.capitalized)!)"
        lang.text = "\((Repo?.language.capitalized)!)"
        watchers.text = "\((Repo?.watchers_count)!)"
        Branch.text = "\((Repo?.default_branch)!)"

        // Do any additional setup after loading the view.
    }
    

}
