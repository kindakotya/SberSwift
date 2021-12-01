//
//  NetworkService.swift
//  NavigationAndTransitions
//
//  Created by 19657264 on 26.11.2021.
//

import UIKit
import simd
import OctoKit

class NetworkService {
    static public let shared = NetworkService()
    let session: URLSession = .shared
    let config = TokenConfiguration("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")
    var reposArray: [GithubRepo] = []
    var condition = NSCondition()
    var predicate = false

    private init() {}

    func getReposArray(_ userName: String) {
        condition.lock()
        guard userName != "" else {
            reposArray.removeAll()
            self.sendSignal()
            return
        }
        Octokit(config).user(name: userName) {response in
            switch response {
            case .success(let user):
                var request = URLRequest(url: URL(string: user.reposURL)!)
                request.httpMethod = "GET"
                self.session.dataTask(with: request) { data, _, error in
                    if data != nil {
                        do {
                            self.reposArray = try JSONDecoder().decode([GithubRepo].self, from: data!)
                            self.sendSignal()
                        } catch {
                            print(error)
                            self.reposArray.removeAll()
                            self.sendSignal()
                        }
                    } else {
                        print(error ?? "Some error")
                        self.reposArray.removeAll()
                        self.sendSignal()
                    }
                }.resume()
            case .failure(let error):
                print(error)
                self.reposArray.removeAll()
                self.sendSignal()
            }
        }
    }

    func sendSignal() {
        self.predicate = true
        self.condition.signal()
        self.condition.unlock()
    }
}
