//
//  URL.swift
//  Anghamify
//
//  Created by ScaRiLiX on 9/28/18.
//  Copyright © 2018 ScaRiLiX. All rights reserved.
//

import Foundation

extension URL
{
    static let artworkBaseURL = "https://anghamicoverart1.akamaized.net/".url!
    
    static func getArtworkURL(songId: String) -> URL
    {
        return URL.artworkBaseURL.appendingQueryParameters(["id": songId, "size": "400"])
    }
}
