//
//  Offline.swift
//  Githubgenics
//
//  Created by Ali Fayed on 30/12/2020.
//

import UIKit
import Alamofire


class NetworkReachability {
  static let shared = NetworkReachability()
  let ReachabilityManager = NetworkReachabilityManager(host: "www.google.com")
  let OfflineAlertController: UIAlertController = {
    let alert = UIAlertController(title: "   ", message: "Please check your connection and try again", preferredStyle: .alert)
    alert.view.tintColor = UIColor.black
    let loadingIndicator: UIActivityIndicatorView = UIActivityIndicatorView(frame: CGRect(x: 110, y: 5, width: 50, height: 50)) as UIActivityIndicatorView
    loadingIndicator.hidesWhenStopped = true
    loadingIndicator.style = UIActivityIndicatorView.Style.medium
    loadingIndicator.startAnimating();
    alert.view.addSubview(loadingIndicator)
    return alert
  }()
    
    func LoadingIndicator() {
        let alert = UIAlertController(title: nil, message: "No Internet Connection", preferredStyle: .alert)
        alert.view.tintColor = UIColor.black
        let loadingIndicator: UIActivityIndicatorView = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50)) as UIActivityIndicatorView
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.style = UIActivityIndicatorView.Style.medium
        loadingIndicator.startAnimating();
        alert.view.addSubview(loadingIndicator)
    }
    
  func startNetworkMonitoring() {
    ReachabilityManager?.startListening { status in
      switch status {
      case .notReachable:
        self.ShowOfflineAlert()
      case .reachable(.cellular):
        self.DismissOfflineAlert()
      case .reachable(.ethernetOrWiFi):
        self.DismissOfflineAlert()
      case .unknown:
        print("Unknown network state")
      }
    }
  }
    

    
  func ShowOfflineAlert() {
    let RootViewController = UIApplication.shared.windows.first?.rootViewController
    RootViewController?.present(OfflineAlertController, animated: true, completion: nil)
  }

  func DismissOfflineAlert() {
    let RootViewController = UIApplication.shared.windows.first?.rootViewController
    RootViewController?.dismiss(animated: true, completion: nil)
  }
}


