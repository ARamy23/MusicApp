//
//  Song.swift
//  Anghamify
//
//  Created by ScaRiLiX on 9/28/18.
//  Copyright © 2018 ScaRiLiX. All rights reserved.
//

import Foundation


struct Song: Codable {
    let id, artist, title, album: String?
    let coverArt: String?
    let location: String?
    let type: String?
    let cached: Bool?
    let url: String?
    var fileURL: URL?
}
