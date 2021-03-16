//
//  GitNetworkLogger.swift
//  Githubgenics
//
//  Created by Ali Fayed on 31/01/2021.
//

import Alamofire
import UIKit

class GitNetworkLogger: EventMonitor {
  let queue = DispatchQueue(label: "com.product.IOS14.Githubgenics.networklogger")

  func requestDidFinish(_ request: Request) {
    print(request.description)
  }

  func request<Value>(_ request: DataRequest, didParseResponse response: DataResponse<Value, AFError>) {
    guard let data = response.data else {
      return
    }
    

    if let json = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) {
      print(json)
    }
    

  }
    
    func alert () {
        let OfflineAlertController: UIAlertController = {
            let alert = UIAlertController(title: "Request Error", message: Messages.internetError , preferredStyle: .alert)
            let action = UIAlertAction(title: "Ok", style: .default) { (Ok) in
               //
            }
            alert.addAction(action)
            return alert
        }()
        let RootViewController = UIApplication.shared.windows.first?.rootViewController
        RootViewController?.present(OfflineAlertController, animated: true, completion: nil)
    }
}
