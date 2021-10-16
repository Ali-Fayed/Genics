//
//  CustomViews.swift
//  Githubgenics
//
//  Created by Ali Fayed on 16/10/2021.
//

import UIKit

class CustomViews {
    static let shared = CustomViews()
    func showAlert(message: String, title: String) {
        let rootViewController = UIApplication.shared.windows.first?.rootViewController
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default) {_ in
            rootViewController?.dismiss(animated: true, completion: nil)
        }
        alert.addAction(action)
        rootViewController?.present(alert, animated: true, completion: nil)
    }
}
