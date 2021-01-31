//
//  Offline.swift
//  Githubgenics
//
//  Created by Ali Fayed on 30/12/2020.
//

import UIKit
import Network
import Alamofire


class NetworkReachabilityModel {
  static let shared = NetworkReachabilityModel()
    
    private let queue = DispatchQueue.global()
    private let monitor: NWPathMonitor
    public private(set) var isConnected: Bool = false
    public private(set) var connectionType: ConnectionType = .unknown
    
    enum  ConnectionType {
        case wifi
        case cellular
        case ethernet
        case unknown
    }
    
    private init () {
        monitor = NWPathMonitor()
    }
    
    public func startMonitoring() {
        monitor.start(queue: queue)
        monitor.pathUpdateHandler = { [weak self] path in
            self?.isConnected = path.status != .unsatisfied
            self?.getConnectionType(path)
            print(self?.isConnected ?? "N/A")

        }
        
    }
    
    public func stopMonitoring () {
        monitor.cancel()
    }
    
    func getConnectionType (_ path: NWPath) {
        if path.usesInterfaceType(.wifi) {
            connectionType = .wifi
        } else if path.usesInterfaceType(.cellular) {
            connectionType = .cellular
        } else if path.usesInterfaceType(.wiredEthernet) {
            connectionType = .ethernet
        } else {
            connectionType = .unknown
        }
    }
  let ReachabilityManager = NetworkReachabilityManager(host: "www.google.com")

  let OfflineAlertController: UIAlertController = {
    let alert = UIAlertController(title: "", message: "Please check your connection and try again".localized(), preferredStyle: .alert)
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


