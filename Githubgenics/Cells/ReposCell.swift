//
//  DetailCellTableViewCell.swift
//  Githubgenics
//
//  Created by Ali Fayed on 25/12/2020.
//


import UIKit
import Firebase
import SkeletonView
import Alamofire
import Kingfisher
import SafariServices
import CoreData

//MARK:- Main Class



class ReposCell: UITableViewCell {
    public var defaults = UserDefaults.standard

    
    @IBOutlet weak var RepoNameLabel: UILabel!
    @IBOutlet weak var De: UITextView!
    @IBOutlet weak var likec: UILabel!
    @IBOutlet weak var language: UILabel!
    @IBOutlet weak var BookmarkRepo: UIButton?
    
    
    static func nib() -> UINib {
        return UINib(nibName: "RepoSearchCell",
                     bundle: nil)
    }
    
    var setButtonState: String = "off" {
        willSet {
            if newValue == "on" {
                BookmarkRepo?.setBackgroundImage(UIImage(named: "like"), for: .normal)
                
                
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
    
    
    override func awakeFromNib() {
           super.awakeFromNib()
        if let ButtonState = defaults.string(forKey: "Bookmark State")
        { setButtonState = ButtonState }
        else { setButtonState = "off" }
    }
    
    func userCellData( with model: repositoriesParameters ) {
                self.RepoNameLabel.text = model.name
                self.De.text = model.description
                self.likec.text = String(model.stargazers_count!)
                self.language.text = model.language
    }
    
    
    func CellData(with model: Repository) {
        RepoNameLabel?.text = model.name
        De?.text = model.description
        language.text = model.language
        likec.text = String(model.stargazers_count!)
    }
    
    func cellll(with model: SavedRepositories) {
        self.RepoNameLabel.text = model.name as? String
        self.De.text = model.descriptin as? String
        self.likec.text = model.stars! as? String
        self.language.text = model.language as? String
    }
    
    
}
