//
//  TrackModel.swift
//  iMusic
//
//  Created by CodergirlTM on 13.01.22.
//

import UIKit

struct SearchResponse: Decodable {
    var resultCount: Int
    var results: [Track]
}

struct Track: Decodable {
    var artistName: String?
    var trackName: String?
    var collectionName: String?
    var artworkUrl100: String?
    var previewUrl: String?
}
