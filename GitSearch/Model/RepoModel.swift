//
//  RepoModel.swift
//  GitSearch
//
//  Created by Chanappa on 10/10/19.
//  Copyright © 2019 Chanappa. All rights reserved.
//

import UIKit

// MARK: - RepoModelElement
struct RepoModelElement: Codable {
    let id: Int
    let nodeID, name, fullName: String
    let repoModelPrivate: Bool
    let fork: Bool
    let size, stargazersCount, watchersCount: Int
    let language: String?
    let hasIssues, hasProjects, hasDownloads, hasWiki: Bool
    let hasPages: Bool
    let forksCount: Int
    let archived, disabled: Bool
    let openIssuesCount: Int
    let forks, openIssues, watchers: Int

    enum CodingKeys: String, CodingKey {
        case id
        case nodeID = "node_id"
        case name
        case fullName = "full_name"
        case repoModelPrivate = "private"
        case fork
        case size
        case stargazersCount = "stargazers_count"
        case watchersCount = "watchers_count"
        case language
        case hasIssues = "has_issues"
        case hasProjects = "has_projects"
        case hasDownloads = "has_downloads"
        case hasWiki = "has_wiki"
        case hasPages = "has_pages"
        case forksCount = "forks_count"
        case archived, disabled
        case openIssuesCount = "open_issues_count"
        case forks
        case openIssues = "open_issues"
        case watchers
    }
}
