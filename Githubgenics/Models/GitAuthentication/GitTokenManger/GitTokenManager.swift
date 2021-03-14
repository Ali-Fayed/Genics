//
//  TokenManager.swift
//  Githubgenics
//
//  Created by Ali Fayed on 30/12/2020.
//

class GitTokenManager {
    
    let userAccount = "accessToken"
    static let shared = GitTokenManager()
    
    func fetchAccessToken(accessToken: String, completion: @escaping (Bool) -> Void) {
        session.request(GitRequsetRouter.gitAccessToken(accessToken))
            .responseDecodable(of: GitHubAccessToken.self) { response in
                guard let token = response.value else { return completion(false) }
                GitTokenManager.shared.saveAccessToken(gitToken: token)
                completion(true)
            }
    }
    
    let secureStore: GitSecureStore = {
        let accessTokenQueryable = GenericPasswordQueryable(service: "GitHubService")
        return GitSecureStore(secureStoreQueryable: accessTokenQueryable)
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
