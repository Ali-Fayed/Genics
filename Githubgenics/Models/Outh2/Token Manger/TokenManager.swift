//
//  TokenManager.swift
//  Githubgenics
//
//  Created by Ali Fayed on 30/12/2020.
//

class TokenManager {
  let userAccount = "accessToken"
  static let shared = TokenManager()
    
  let secureStore: SecureStore = {
    let accessTokenQueryable = GenericPasswordQueryable(service: "GitHubService")
    return SecureStore(secureStoreQueryable: accessTokenQueryable)
  }()

  func saveAccessToken(gitToken: GitHubAccessToken) {
    do {
      try secureStore.setValue(gitToken.accessToken, for: userAccount)
    } catch let exception {
      print("Error saving access token: \(exception)")
    }
  }

  func fetchAccessToken() -> String? {
    do {
      return try secureStore.getValue(for: userAccount)
    } catch let exception {
      print("Error fetching access token: \(exception)")
    }
    return nil
  }

  func clearAccessToken() {
    do {
      return try secureStore.removeValue(for: userAccount)
    } catch let exception {
      print("Error clearing access token: \(exception)")
    }
  }
}
