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

//MARK:- Main Class



class ReposCell: UITableViewCell {
    public var defaults = UserDefaults.standard

    
    @IBOutlet weak var RepoNameLabel: UILabel!
    @IBOutlet weak var De: UITextView!
    @IBOutlet weak var likec: UILabel!
    @IBOutlet weak var language: UILabel!
    @IBOutlet weak var BookmarkRepo: UIButton!
    
    
    var setButtonState: String = "off" {
        willSet {
            if newValue == "on" {
                BookmarkRepo.setBackgroundImage(UIImage(named: "like"), for: .normal)
                
            }
            else { BookmarkRepo.setBackgroundImage(UIImage(named: "unlike"), for: .normal)
                
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
    
   
    
    
    func CellData(with model: ReposStruct) {
        self.RepoNameLabel.text = model.name
        self.De.text = model.description
        self.likec.text = String(model.stargazers_count)
        self.language.text = model.language
    }
    
    
}
