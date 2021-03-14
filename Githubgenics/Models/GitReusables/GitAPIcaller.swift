//
//  GitAPIcaller.swift
//  Githubgenics
//
//  Created by Ali Fayed on 18/01/2021.
//

import Alamofire
import UIKit

class GitAPIcaller {
    
    static let shared = GitAPIcaller ()
    var isPaginating = false
        
    func makeRequest<T: Decodable>(returnType: T.Type, requestData: GitRequsetRouter, pagination paginated: Bool = false, completion: @escaping (T) -> Void) {
        if paginated {
            isPaginating = true
        }
        DispatchQueue.global(qos: .background).asyncAfter(deadline: .now() + (paginated ? 2 : 0)) {
            session.request(requestData).responseDecodable(of: T.self) { [weak self] response in
                guard let results = response.value else {
                    self?.showRequestErrorAlert ()
                    return
                }
                completion(results)
                if paginated {
                    self?.isPaginating = false
                }
            }
        }
    }
    
    func showRequestErrorAlert() {
        let requestErrorAlert: UIAlertController = {
            let alert = UIAlertController(title: "Request Timeout!", message: Messages.requestError , preferredStyle: .alert)
            let action = UIAlertAction(title: "Try Again", style: .default) { (Ok) in
               
            }
            alert.addAction(action)
            return alert
        }()
        let RootViewController = UIApplication.shared.windows.first?.rootViewController
        RootViewController?.present(requestErrorAlert, animated: true, completion: nil)
    }
}
