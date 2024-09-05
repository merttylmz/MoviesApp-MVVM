//
//  YoutubeResponse.swift
//  MoviesApp-MVVM
//
//  Created by Mert Yılmaz on 4.09.2024.
//

import Foundation

// MARK: - YoutubeResponse
struct YoutubeResponse: Codable {
    let kind, etag, nextPageToken, regionCode: String
    let pageInfo: PageInfo
    let items: [Item]
}

// MARK: - Item
struct Item: Codable {
    let kind, etag: String
    let id: ID
}

// MARK: - ID
struct ID: Codable {
    let kind, videoID: String

    enum CodingKeys: String, CodingKey {
        case kind
        case videoID
    }
}

// MARK: - PageInfo
struct PageInfo: Codable {
    let totalResults, resultsPerPage: Int
}
