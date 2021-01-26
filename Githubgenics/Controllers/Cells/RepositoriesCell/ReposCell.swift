//
//  DetailCellTableViewCell.swift
//  Githubgenics
//
//  Created by Ali Fayed on 25/12/2020.
//


import UIKit
import Kingfisher

//MARK:- Main Class



class ReposCell: UITableViewCell {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var userRepository = [UserRepository]()
    var passedUser : Users?
    var usersDataBase = [UsersDataBase]()
    var savedRepositories = [SavedRepositories]()

    var defaults = UserDefaults.standard
    static func nib() -> UINib {
        return UINib(nibName: "RepoSearchCell",
                     bundle: nil)
    }
    
    @IBOutlet weak var RepoNameLabel: UILabel!
    @IBOutlet weak var De: UITextView!
    @IBOutlet weak var likec: UILabel!
    @IBOutlet weak var language: UILabel!
    @IBOutlet weak var BookmarkRepo: UIButton?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        if let ButtonState = defaults.string(forKey: "Bookmark State")
        { setButtonState = ButtonState }
        else { setButtonState = "off" }
    }
    
  
  //MARK:- Bookmark Button
    
    var setButtonState: String = "off" {
        willSet {
            if newValue == "on" {
                BookmarkRepo?.setBackgroundImage(UIImage(named: "like"), for: .normal)
//                let model = userRepository[indexPath!.row]
//                saveBookmarkedRepository(name: model.name!, descriptin: model.description!, url: model.html_url!, stars: model.stargazers_count!)
            }
            else { BookmarkRepo?.setBackgroundImage(UIImage(named: "unlike"), for: .normal)
                
                
            }
        }
    }
    
    @IBAction func BookmarkRepo(_ sender: UIButton) {
        let stat = setButtonState == "on" ? "off" : "on"
        setButtonState = stat
        defaults.set(stat , forKey: "Bookmark State")
        print(stat)
    }
    
    func saveBookmarkedRepository (name: String , descriptin: String , url: String , stars: Int) {
        let DataParameters = SavedRepositories(context: context)
        DataParameters.name = name as NSObject
        DataParameters.descriptin = descriptin as NSObject
        DataParameters.url = url as NSObject
        DataParameters.stars = stars as NSObject
        do {
            try context.save()
        } catch {
            
        }
    }


    
    //MARK:- Repositories Cell Data
    
    func CellData( with model: UserRepository ) {
        self.RepoNameLabel.text = model.name
        self.De.text = model.description
        self.likec.text = String(model.stargazers_count!)
        self.language.text = model.language
    }
    
    
    func CellData(with model: Repository) {
        RepoNameLabel?.text = model.name
        De?.text = model.description
        language.text = model.language
        likec.text = String(model.stargazers_count)
    }
    
    func CellData(with model: SavedRepositories) {
        self.RepoNameLabel.text = model.name as? String
        self.De.text = model.descriptin as? String
        self.likec.text = model.stars! as? String
        self.language.text = model.language as? String
    }
    
    
}
extension UIResponder {
    /**
     * Returns the next responder in the responder chain cast to the given type, or
     * if nil, recurses the chain until the next responder is nil or castable.
     */
    func next<U: UIResponder>(of type: U.Type = U.self) -> U? {
        return self.next.flatMap({ $0 as? U ?? $0.next() })
    }
}

extension UITableViewCell {
    var tableView: UITableView? {
        return self.next(of: UITableView.self)
    }

    var indexPath: IndexPath? {
        return self.tableView?.indexPath(for: self)
    }
}
