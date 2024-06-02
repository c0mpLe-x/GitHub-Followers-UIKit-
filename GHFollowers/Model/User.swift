//
//  User.swift
//  GHFollowers
//
//  Created by Він on 31.05.2024.
//

import Foundation

struct User: Codable {
    let login: String
    let avatarUrl: URL
    var name: String?
    var location: String?
    var bio: String?
    let publicRepos: Int
    let publicGists: Int
    let htmlUrl: URL?
    let following: Int
    let followers: Int
    let createdAt: Date
}
