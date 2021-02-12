//
//  LoginViewMethods.swift
//  Githubgenics
//
//  Created by Ali Fayed on 11/02/2021.
//

import Foundation
import AuthenticationServices

extension LoginViewController {
    
    func getGitHubIdentity() {
      var authorizeURLComponents = URLComponents(string: GitHubConstants.authorizeURL)
      authorizeURLComponents?.queryItems = [
        URLQueryItem(name: "client_id", value: GitHubConstants.clientID),
        URLQueryItem(name: "scope", value: GitHubConstants.scope)
      ]
      guard let authorizeURL = authorizeURLComponents?.url else {
        return
      }
      webAuthenticationSession = ASWebAuthenticationSession.init(
        url: authorizeURL,
        callbackURLScheme: GitHubConstants.redirectURI) { (callBack: URL?, error: Error?) in
        guard
          error == nil,
          let successURL = callBack
        else {
          return
        }
        //Retrieve access code
        guard let accessCode = URLComponents(string: (successURL.absoluteString))?
          .queryItems?.first(where: { $0.name == "code" }) else {
          return
        }
        guard let value = accessCode.value else {
          return
        }
        //fetch token using access code
          GitUsersRouter().fetchAccessToken(accessToken: value) { isSuccess in
          if !isSuccess {
            print("Error fetching access token")
          }
          self.navigationController?.popViewController(animated: true)
            self.performSegue(withIdentifier: Segues.loginToTabBarSegue, sender: self)
          UserDefaults.standard.setValue(isSuccess, forKey: "outh")

        }
      }
      webAuthenticationSession?.presentationContextProvider = self
      webAuthenticationSession?.start()
    }
}
