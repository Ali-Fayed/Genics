//
//  GitSessionManger.swift
//  Githubgenics
//
//  Created by Ali Fayed on 31/01/2021.
//

import Alamofire

let session: Session = {
  let configuration = URLSessionConfiguration.af.default
  configuration.requestCachePolicy = .returnCacheDataElseLoad
  let responseCacher = ResponseCacher(behavior: .modify { _, response in
    let userInfo = ["date": Date()]
    return CachedURLResponse(
      response: response.response,
      data: response.data,
      userInfo: userInfo,
      storagePolicy: .allowed)
  })

  let networkLogger = GitNetworkLogger()
  let interceptor = GitRequestInterceptor()

  return Session(
    configuration: configuration,
    interceptor: interceptor,
    cachedResponseHandler: responseCacher,
    eventMonitors: [networkLogger])
}()
