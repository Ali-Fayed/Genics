//
//  LoginViewController.swift
//  Githubgenics
//
//  Created by Ali Fayed on 30/12/2020.
//

import UIKit
import AuthenticationServices

class LoginViewController: UIViewController {
    
  var webAuthenticationSession: ASWebAuthenticationSession?

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    getGitHubIdentity()
  }
}

// MARK: - ASWebAuthenticationPresentation

extension LoginViewController: ASWebAuthenticationPresentationContextProviding {
  func presentationAnchor(for session: ASWebAuthenticationSession) -> ASPresentationAnchor {
    return view.window ?? ASPresentationAnchor()
  }
}
