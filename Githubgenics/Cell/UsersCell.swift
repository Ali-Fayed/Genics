//
//  TableViewCell.swift
//  Githubgenics
//
//  Created by Ali Fayed on 24/12/2020.
//

import UIKit
import CoreData

class UsersCell: UITableViewCell {
    var buttonstate:Bool = true
    var checkmarks:Bool?

    @IBOutlet weak var ImageView: UIImageView!
    @IBOutlet weak var UserNameLabel: UILabel!
    @IBOutlet weak var Button: UIButton!
    let defaults = UserDefaults.standard
    var favid: Int = 0
    
    

//
//    var setImageStatus: String = "off" {
//        willSet {
//            if newValue == "on" {
//                Button.setImage(UIImage(systemName: "bookmark"), for: .normal)
//
//            } else {
//                Button.setImage(UIImage(systemName: "bookmark.fill"), for: .normal)
//            }
//        }
//    }

    override func awakeFromNib() {
        super.awakeFromNib()
//        Button.setImage(UIImage(systemName: "bookmark"), for: .normal)
//               Button.setImage(UIImage(systemName: "bookmark"), for: .normal)

//        if UserDefaults.standard.value(forKeyPath: "state") != nil {
//            Button.tag == 0
//
//        }
//            if let imgStatus = defaults.string(forKey: "imgStatus")
//                 {
//                     setImageStatus = imgStatus
//                 } else {
//                     setImageStatus = "off"
//
//        }// Initialization code
        
        if checkmarks != nil {
            Button.setImage(UIImage(systemName: "bookmark.fill"), for: .normal)

        } else {
            checkmarks = false
            Button.setImage(UIImage(systemName: "bookmark"), for: .normal)
        }

    }
    
    @IBAction func BookmarkCell(_ sender: UIButton) {
        
   
        
        if Button.tag == 0 {
            Button.setImage(UIImage(systemName: "bookmark.fill"), for: .normal)
            Button.tag = 1
        } else {
            Button.setImage(UIImage(systemName: "bookmark"), for: .normal)
            Button.tag = 0
        }
//        let stat = setImageStatus == "on" ? "off" : "on"
//             setImageStatus = stat
//            defaults.set(stat, forKey: "imgStatus")
//         }
//
    
    }
    
    
    

 
    
  


    
    

 
    


}
