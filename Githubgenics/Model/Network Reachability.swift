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
    UIAlertController(title: "No Network", message: "Please connect to network and try again", preferredStyle: .alert)
  }()
    

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


