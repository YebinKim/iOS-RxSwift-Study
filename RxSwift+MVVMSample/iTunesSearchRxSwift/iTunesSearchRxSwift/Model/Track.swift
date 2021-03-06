//
//  Track.swift
//  iTunesSearchRxSwift
//
//  Created by Yebin Kim on 2021/04/18.
//

import Foundation

// MARK: - Wrapper Model
struct Tracks: Decodable {
    let results: [Track]
}

// MARK: - Network Data Model
struct Track: Decodable {

    let artistName: String
    let songName: String
    let previewUrl: String
    let thumbnailUrl: String

    enum CodingKeys: String, CodingKey {
        case artistName
        case songName = "trackName"
        case previewUrl
        case thumbnailUrl = "artworkUrl100"
    }
}
