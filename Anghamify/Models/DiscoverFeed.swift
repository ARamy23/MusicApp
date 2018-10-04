//
//  DiscoverFeed.swift
//  Anghamify
//
//  Created by ScaRiLiX on 9/27/18.
//  Copyright © 2018 ScaRiLiX. All rights reserved.
//

import Foundation

typealias SongsFeed = [SongsFeedItem]

struct SongsFeedItem: Codable {
    let title: String?
    let items: [Song]?
    let type, coverArt, id: String?
}


