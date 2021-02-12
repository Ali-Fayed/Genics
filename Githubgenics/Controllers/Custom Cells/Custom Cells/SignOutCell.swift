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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        logOut.setTitle(Titles.logOut, for: .normal)
    }
    
    
    @IBAction func signOut(_ sender: Any) {
        delegate?.didTapButton(cell: self, didTappedThe: sender as? UIButton)
    }
}

extension SettingsViewController : DidTapSignOutCell {
    func didTapButton(cell: SignOutCell, didTappedThe button: UIButton?) {
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "WelcomeScreen") as? WelcomeScreen
        self.navigationController?.pushViewController(vc!, animated: true)
        TokenManager.shared.clearAccessToken()
        UserDefaults.standard.removeObject(forKey: "outh")
    }
}
