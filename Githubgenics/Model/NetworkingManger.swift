////
////  NetworkingManger.swift
////  Githubgenics
////
////  Created by Ali Fayed on 22/12/2020.
////
//
//import Foundation
//
//
//struct NetworkManger{
//    
//    
//
//    var ReposData = [APIReposData]()
//    
//    func FetchRepos(completed: @escaping () -> Void) {
//        if let url = URL(string: "https://api.github.com/users/ivey/repos") {
//            let session = URLSession(configuration: .default)
//            let task = session.dataTask(with: url) { (data, response, error) in
//                if error == nil {
//                    let decoder = JSONDecoder()
//                    if let safeData = data {
//                        do {
//                            self.ReposData = try decoder.decode([APIReposData].self, from: safeData)
//                            DispatchQueue.main.async {
//                                completed()
//                            }
//                        } catch {
//                            print("JSON Error")
//                        }
//                    }
//                }
//            }
//            task.resume()
//        }
//    }
//}
