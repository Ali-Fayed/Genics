//
//  NetworkReachability.swift
//  Githubgenics
//
//  Created by Ali Fayed on 30/12/2020.
//

import UIKit
import Alamofire

class NetworkReachabilityModel {
    
    static let shared = NetworkReachabilityModel()
    let ReachabilityManager = NetworkReachabilityManager(host: "www.google.com")
    let OfflineAlertController: UIAlertController = {
        let alert = UIAlertController(title: "Internet Error", message: Messages.internetError , preferredStyle: .alert)
        let action = UIAlertAction(title: "Try Again", style: .default) { (Ok) in
            DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                NetworkReachabilityModel.shared.retryOnce()
            }
        }
        alert.addAction(action)
        return alert
    }()
    
    let connectionFailed: UIAlertController = {
        let alert = UIAlertController(title: "No Internet", message:  "You are now in offline mode" , preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default) { (Ok) in
         
        }
        alert.addAction(action)
        return alert
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
                print("Unknown state")
            }
        }
    }
    
    func retryOnce() {
        ReachabilityManager?.startListening { status in
            switch status {
            case .notReachable:
                self.show()
            case .reachable(.cellular):
                self.DismissOfflineAlert()
            case .reachable(.ethernetOrWiFi):
                self.DismissOfflineAlert()
            case .unknown:
                print("Unknown state")
            }
        }
    }
    
    func ShowOfflineAlert() {
        let RootViewController = UIApplication.shared.windows.first?.rootViewController
        RootViewController?.present(OfflineAlertController, animated: true, completion: nil)
    }
    
    func show() {
        let RootViewController = UIApplication.shared.windows.first?.rootViewController
        RootViewController?.present(connectionFailed, animated: true, completion: nil)
    }
    
    func DismissOfflineAlert() {
        let RootViewController = UIApplication.shared.windows.first?.rootViewController
        RootViewController?.dismiss(animated: true, completion: nil)
    }
}
