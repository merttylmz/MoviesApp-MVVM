// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let youtubeSearchResponse = try? JSONDecoder().decode(YoutubeSearchResponse.self, from: jsonData)

import Foundation

// MARK: - YoutubeSearchResponse
struct YoutubeSearchResponse: Codable {
    let kind: String?
    let etag: String?
    let nextPageToken: String?
    let regionCode: String?
    let pageInfo: PageInfo?
    let items: [Item]?

    enum CodingKeys: String, CodingKey {
        case kind = "kind"
        case etag = "etag"
        case nextPageToken = "nextPageToken"
        case regionCode = "regionCode"
        case pageInfo = "pageInfo"
        case items = "items"
    }
}

// MARK: - Item
struct Item: Codable {
    let kind: String?
    let etag: String?
    let id: ID?

    enum CodingKeys: String, CodingKey {
        case kind = "kind"
        case etag = "etag"
        case id = "id"
    }
}

// MARK: - ID
struct ID: Codable {
    let kind: String?
    let videoid: String?

    enum CodingKeys: String, CodingKey {
        case kind = "kind"
        case videoid = "videoId"
    }
}

// MARK: - PageInfo
struct PageInfo: Codable {
    let totalResults: Int?
    let resultsPerPage: Int?

    enum CodingKeys: String, CodingKey {
        case totalResults = "totalResults"
        case resultsPerPage = "resultsPerPage"
    }
}
