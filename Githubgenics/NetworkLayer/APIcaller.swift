//
//  GitAPIcaller.swift
//  Githubgenics
//
//  Created by Ali Fayed on 18/01/2021.
//

import Alamofire
import UIKit

class GitAPIcaller {
    static func makeRequest<T: Decodable>(dataModel: T.Type, requestData: GitRequestRouter, pagination isPaginating: Bool = false, completion: @escaping (T) -> Void) {
        DispatchQueue.global(qos: .background).asyncAfter(deadline: .now() + (isPaginating ? 0.5 : 0)) {
            AFsession.request(requestData).responseDecodable(of: T.self) { response in
                guard let results = response.value else { return }
                completion(results)
            }
        }
    }    
}
