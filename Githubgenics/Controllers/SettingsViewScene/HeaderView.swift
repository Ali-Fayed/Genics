//
//  HeaderView.swift
//  Githubgenics
//
//  Created by Ali Fayed on 14/03/2021.
//

import UIKit
import SwiftyJSON
import Alamofire

class HeaderView: UIViewController {
    
    @IBOutlet weak var userAvatar: UIImageView!
    @IBOutlet weak var userID : UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        session.request(GitRequestRouter.gitAuthenticatedUser).responseJSON { (response) in
            switch response.result {
            case .success(let responseJSON) :
                let recievedJson = JSON (responseJSON)
                self.userID.text = "ID:  " + recievedJson["\(User.userID)"].stringValue
                let avatar = recievedJson["\(User.userAvatar)"].stringValue
                self.userAvatar.kf.setImage(with: URL(string: avatar), placeholder: nil, options: [.transition(.fade(0.7))], progressBlock: nil)
                self.userAvatar.layer.masksToBounds = false
                self.userAvatar.layer.cornerRadius = self.userAvatar.frame.height/2
                self.userAvatar.clipsToBounds = true
            case .failure(let error):
                print(error)
            }
            
        }
    }
}
