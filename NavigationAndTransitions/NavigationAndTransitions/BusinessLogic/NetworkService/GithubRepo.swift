//
//  GithubRepo.swift
//  NavigationAndTransitions
//
//  Created by 19657264 on 26.11.2021.
//

import Foundation

struct GithubRepo: Codable {
    let name: String?
    let cloneURL: String?
    let language: String?
    enum CodingKeys: String, CodingKey {
        case name
        case cloneURL = "clone_url"
        case language
    }
}
