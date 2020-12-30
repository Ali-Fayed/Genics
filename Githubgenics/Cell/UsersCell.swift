//
//  TableViewCell.swift
//  Githubgenics
//
//  Created by Ali Fayed on 24/12/2020.
//

import UIKit

class UsersCell: UITableViewCell {
    
    var User:UsersStruct?
    var Users = [UsersStruct]()

    @IBOutlet weak var ImageView: UIImageView!
    @IBOutlet weak var UserNameLabel: UILabel!
    @IBAction func ItemSave(_ sender: Any) {
    }
    
    
//    @IBAction func Button(_ sender: UIBarButtonItem) {
//        
//       let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
//        func saveItems() {
//            
//            do {
//              try context.save()
//            } catch {
//               print("Error saving context \(error)")
//            }
//                    }
//    }
//    
    
    
 
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.ImageView.layer.cornerRadius = self.ImageView.frame.width/4.0
        self.ImageView.clipsToBounds = true
        
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func UserImage () {
        ImageView.layer.cornerRadius = 10
        let APIImageurl = (User?.avatar_url)!
        ImageView.kf.setImage(with: URL(string: APIImageurl), placeholder: nil, options: [.transition(.fade(0.7))], progressBlock: nil)
    }
 
    
}
