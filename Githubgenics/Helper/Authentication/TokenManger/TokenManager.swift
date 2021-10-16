//
//  TokenManager.swift
//  Githubgenics
//
//  Created by Ali Fayed on 30/12/2020.
//

class TokenManager {
    
    let userAccount = "accessToken"
    static let shared = TokenManager()
    
    func fetchAccessToken(accessToken: String, completion: @escaping (Bool) -> Void) {
        NetworkingManger.shared.afSession.request(GitRequestRouter.gitAccessToken(accessToken))
            .responseDecodable(of: AccessToken.self) { response in
                guard let token = response.value else { return completion(false) }
                TokenManager.shared.saveAccessToken(gitToken: token)
                completion(true)
            }
    }
    
    let secureStore: GitSecureStore = {
        let accessTokenQueryable = GenericPasswordQueryable(service: "GitHubService")
        return GitSecureStore(secureStoreQueryable: accessTokenQueryable)
    }()
    
    func saveAccessToken(gitToken: AccessToken) {
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
