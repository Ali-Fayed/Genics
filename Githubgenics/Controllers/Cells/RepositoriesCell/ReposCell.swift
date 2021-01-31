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


    var defaults = UserDefaults.standard
    static func nib() -> UINib {
        return UINib(nibName: "RepoSearchCell",
                     bundle: nil)
    }
    
    @IBOutlet weak var repositoryName: UILabel!
    @IBOutlet weak var repositoryDescription: UITextView!
    @IBOutlet weak var repositoryStars: UILabel!
    @IBOutlet weak var repositoryLanguage: UILabel!
    @IBOutlet weak var bookmarkRepository: UIButton?
    
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
                bookmarkRepository?.setBackgroundImage(UIImage(named: "like"), for: .normal)
//                let model = userRepository[indexPath!.row]
//                saveBookmarkedRepository(name: model.name!, descriptin: model.description!, url: model.html_url!, stars: model.stargazers_count!)
            }
            else { bookmarkRepository?.setBackgroundImage(UIImage(named: "unlike"), for: .normal)
                
                
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
        self.repositoryName.text = model.repositoryName
        self.repositoryDescription.text = model.repositoryDescription
        self.repositoryStars.text = String(model.repositoryStars!)
        self.repositoryLanguage.text = model.repositoryLanguage
    }
    
    
    func CellData(with model: Repository) {
        repositoryName?.text = model.repositoryName
        repositoryDescription?.text = model.repositoryDescription
        repositoryLanguage.text = model.repositoryLanguage
        repositoryStars.text = String(model.repositoryStars)
    }
    
    func CellData(with model: SavedRepositories) {
        self.repositoryName.text = model.name as? String
        self.repositoryDescription.text = model.descriptin as? String
        self.repositoryStars.text = model.stars! as? String
        self.repositoryLanguage.text = model.language as? String
    }
    
    
}
extension UIResponder {

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
