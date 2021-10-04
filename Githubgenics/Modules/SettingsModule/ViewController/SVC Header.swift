//
//  SVC Header.swift
//  Githubgenics
//
//  Created by Ali Fayed on 10/04/2021.
//

import Alamofire
import UIKit
import SwiftyJSON

class HeaderView: UIViewController {
    
    @IBOutlet weak var userAvatar: UIImageView!
    @IBOutlet weak var userID : UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        AFsession.request(GitRequestRouter.gitAuthenticatedUser).responseJSON { (response) in
            switch response.result {
            case .success(let responseJSON) :
                let recievedJson = JSON(responseJSON)
                self.userID.text = "ID:  " + recievedJson["\(PrivateUser.userID)"].stringValue
                let avatar = recievedJson["\(PrivateUser.userAvatar)"].stringValue
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
