//
//  GitNetworkMonitor.swift
//  Githubgenics
//
//  Created by Ali Fayed on 30/12/2020.
//

import Foundation
import UIKit
import Network

class GitNetworkMonitor {
    
    static let shared = GitNetworkMonitor()
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
}
