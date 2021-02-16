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
        let alert = UIAlertController(title: "", message: Messages.internetError , preferredStyle: .alert)
        alert.view.tintColor = UIColor.black
        let loadingIndicator: UIActivityIndicatorView = UIActivityIndicatorView(frame: CGRect(x: 110, y: 5, width: 50, height: 50)) as UIActivityIndicatorView
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.style = UIActivityIndicatorView.Style.medium
        loadingIndicator.startAnimating();
        alert.view.addSubview(loadingIndicator)
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
    
    func ShowOfflineAlert() {
        let RootViewController = UIApplication.shared.windows.first?.rootViewController
        RootViewController?.present(OfflineAlertController, animated: true, completion: nil)
    }
    
    func DismissOfflineAlert() {
        let RootViewController = UIApplication.shared.windows.first?.rootViewController
        RootViewController?.dismiss(animated: true, completion: nil)
    }
}
