//
//  TableViewCell.swift
//  Githubgenics
//
//  Created by Ali Fayed on 24/12/2020.
//

import UIKit
import CoreData
class UsersCell: UITableViewCell {
    
    var User:UsersStruct?
    var Users = [UsersStruct]()

    @IBOutlet weak var ImageView: UIImageView!
    @IBOutlet weak var UserNameLabel: UILabel!

    
    @IBAction func Go(_ sender: UIBarButtonItem) {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let newContact = NSEntityDescription.insertNewObject(forEntityName: "Users", into: context)
        let APIImageurl = "https://avatars0.githubusercontent.com/u/\("9")?v=4"
        ImageView.kf.setImage(with: URL(string: APIImageurl), placeholder: nil, options: [.transition(.fade(0.7))])
        let imageData:NSData = ImageView.image!.jpegData(compressionQuality: 1)! as NSData
        newContact.setValue(imageData, forKey: "imageData")
    }
    
    
    
 
    
    override func awakeFromNib() {
        super.awakeFromNib()

        
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func UserImage () {
        let APIImageurl = (User?.avatar_url)!
        ImageView.kf.setImage(with: URL(string: APIImageurl), placeholder: nil, options: [.transition(.fade(0.7))], progressBlock: nil)
    }
 
    
}
