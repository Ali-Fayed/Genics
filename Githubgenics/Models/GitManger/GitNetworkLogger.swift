//
//  GitNetworkLogger.swift
//  Githubgenics
//
//  Created by Ali Fayed on 31/01/2021.
//

import Alamofire

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
}
