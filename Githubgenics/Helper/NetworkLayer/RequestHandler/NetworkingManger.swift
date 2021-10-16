//
//  GitAPIcaller.swift
//  Githubgenics
//
//  Created by Ali Fayed on 18/01/2021.
//

import Alamofire
import UIKit

class NetworkingManger {
    static let shared = NetworkingManger()
    let afSession: Session = {
        let networkLogger = NetworkLogger()
        let interceptor = RequestIntercptor()
        return Session(
            interceptor: interceptor,
            eventMonitors: [networkLogger])
    }()
    
    func performRequest<T: Decodable>(dataModel: T.Type, requestData: URLRequestConvertible,pagination isPaginating: Bool = false, completion: @escaping (Result<T, Error>) -> Void) {
        DispatchQueue.global(qos: .background).asyncAfter(deadline: .now() + (isPaginating ? 0.5 : 0)) {
            self.afSession.request(requestData)
                .validate(statusCode: 200...300)
                .responseDecodable(of: T.self, completionHandler: { response in
                    switch response.result {
                    case .success(_):
                        guard let value = response.value else {return}
                        completion(.success(value))
                    case .failure(let error):
                        guard let statusCode = response.response?.statusCode else {return}
                        switch statusCode  {
                        case 400..<500:
                            guard let data = response.data else {return}
                            guard let apiError = try? JSONDecoder().decode(ApiError.self, from: data) else {return}
                            completion(.failure(apiError))
                            print(error)
                        default:
                            completion(.failure(ApiError(.general)))
                        }
                    }
                })
        }
    }
}
