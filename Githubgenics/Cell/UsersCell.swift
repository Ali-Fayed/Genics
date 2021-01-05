//
//  TableViewCell.swift
//  Githubgenics
//
//  Created by Ali Fayed on 24/12/2020.
//

import UIKit
import CoreData

class UsersCell: UITableViewCell {
    
    
    //    var User:UsersStruct?
//    var Users = [UsersStruct]()

    @IBOutlet weak var ImageView: UIImageView!
    @IBOutlet weak var UserNameLabel: UILabel!
    @IBOutlet weak var Button: UIButton!
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    private var usersdatabase:UsersStruct?
    
//    @IBAction func Bookmark(_ sender: UIBarButtonItem) {
//        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
//        let newContact = NSEntityDescription.insertNewObject(forEntityName: "Users", into: context)
//        let APIImageurl = "https://avatars0.githubusercontent.com/u/\("9")?v=4"
//        ImageView.kf.setImage(with: URL(string: APIImageurl), placeholder: nil, options: [.transition(.fade(0.7))])
//        let imageData:NSData = ImageView.image!.jpegData(compressionQuality: 1)! as NSData
//        newContact.setValue(imageData, forKey: "imageData")
//    }
    override func awakeFromNib() {
        super.awakeFromNib()
        if UserDefaults.standard.value(forKeyPath: "isSaved") != nil {
            Button.setImage(UIImage(named: "bookmark"), for: .normal)

        }
    
        // Initialization code
    }
    @IBAction func BookmarkCell(_ sender: UIButton) {
        
        sender.isSelected = !sender.isSelected
         UserDefaults.standard.set(sender.isSelected, forKey: "isSaved")
        //set image for button
//        Button.setImage(UIImage(named: "EmptyHeart.png"), for: .normal)
//        Button.setImage(UIImage(named: "bookmark"), for: .selected)
        Button.isSelected = UserDefaults.standard.bool(forKey: "isSaved")
    }
    
    
    
    func saveUser() {
        do {
            try context.save()
        } catch {
            print("Error saving \(error)")
        }
    }
    
//    func loadCategories() {
//
//        let request : NSFetchRequest<Category> = UsersStruct.fetchRequest()
//
//        do{
//            categories = try context.fetch(request)
//        } catch {
//            print("Error loading categories \(error)")
//        }
//
//        tableView.reloadData()
//
//    }
 
    
  

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
//    func UserImage () {
//        let APIImageurl = (User?.avatar_url)!
//        ImageView.kf.setImage(with: URL(string: APIImageurl), placeholder: nil, options: [.transition(.fade(0.7))], progressBlock: nil)
//    }
 
    
}
