//
//  GitUser.swift
//  GitSearch
//
//  Created by Chanappa on 10/10/19.
//  Copyright © 2019 Chanappa. All rights reserved.
//

import Foundation

struct UserModel: Codable {
    let totalCount: Int
    let incompleteResults: Bool
    let items: [GitUser]

    enum CodingKeys: String, CodingKey {
        case totalCount = "total_count"
        case incompleteResults = "incomplete_results"
        case items
    }
}

// MARK: - Item
struct GitUser: Codable {
    let login: String
    let id: Int
    let nodeID: String?
    let avatarURL: String
    let gravatarID: String?
    let url, htmlURL, followersURL: String?
    let followingURL, gistsURL, starredURL: String?
    let subscriptionsURL, organizationsURL, reposURL: String?
    let eventsURL: String?
    let receivedEventsURL: String?
    let type: TypeEnum?
    let siteAdmin: Bool?
    let score: Double?
    let location: String?
    let bio: String?
    let email: String?
    let followers: Int?
    let following: Int?
    let created_at: String?
    
    enum CodingKeys: String, CodingKey {
        case login, id
        case nodeID = "node_id"
        case avatarURL = "avatar_url"
        case gravatarID = "gravatar_id"
        case url
        case htmlURL = "html_url"
        case followersURL = "followers_url"
        case followingURL = "following_url"
        case gistsURL = "gists_url"
        case starredURL = "starred_url"
        case subscriptionsURL = "subscriptions_url"
        case organizationsURL = "organizations_url"
        case reposURL = "repos_url"
        case eventsURL = "events_url"
        case receivedEventsURL = "received_events_url"
        case type
        case siteAdmin = "site_admin"
        case score, location, bio, email, followers, following, created_at
    }
}

enum TypeEnum: String, Codable {
    case user = "User"
}
