//
//  TableViewCell.swift
//  Githubgenics
//
//  Created by Ali Fayed on 11/02/2021.
//

import UIKit

class SignOutCell: UITableViewCell {
    
    weak var delegate : DidTapSignOutCell?
    @IBOutlet weak var logOut: UIButton!
    
    var isLoggedIn: Bool {
        if TokenManager.shared.fetchAccessToken() != nil {
            return true
        }
        return false
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        if isLoggedIn {
            logOut.setTitle(Titles.logOut, for: .normal)
        } else {
            logOut.setTitle(Titles.signinWith, for: .normal)
        }
    }
    
    @IBAction func signOut(_ sender: Any) {
        delegate?.didTapButton(cell: self, didTappedThe: sender as? UIButton)
    }
}

extension SettingsViewController : DidTapSignOutCell {
    func didTapButton(cell: SignOutCell, didTappedThe button: UIButton?) {
        if isLoggedIn {
            let vc = UIStoryboard.init(name: Storyboards.login , bundle: Bundle.main).instantiateViewController(withIdentifier: ID.loginViewControllerID) as? LoginViewController
            self.navigationController?.pushViewController(vc!, animated: true)
            TokenManager.shared.clearAccessToken()
            UserDefaults.standard.removeObject(forKey: "outh")
        } else {
            let vc = UIStoryboard.init(name: Storyboards.login, bundle: Bundle.main).instantiateViewController(withIdentifier: ID.loginViewControllerID) as? LoginViewController
            self.navigationController?.pushViewController(vc!, animated: true)
        }
    }
}
