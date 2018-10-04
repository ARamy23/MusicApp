//
//  SongService.swift
//  Anghamify
//
//  Created by ScaRiLiX on 9/27/18.
//  Copyright © 2018 ScaRiLiX. All rights reserved.
//

import Foundation
import Moya
import Alamofire

enum SongService
{
    enum DataType: String
    {
        case discover
        case song
        case playlist
    }
    
    enum QualityLevel: String
    {
        case hqbit64
        case hqbit128
        case hqbit196
    }
    //MARK:- POST
    case search(String)
    
    //MARK:- GET
    case data(objectId: String, type: DataType)
    case download(songId: String, quality: QualityLevel)
    case downloadManager(songId: String)
    case downloadArtwork(artworkId: String, size: String)
}

extension SongService: TargetType
{
    var baseURL: URL {
        switch self
        {
        default:
            return "https://anghamify.cf/v1/".url!
        }
    }
    
    var path: String {
        switch self
        {
        case .search(_):
            return SongsServerPathes.search
        case .data(_, _):
            return SongsServerPathes.dataPath
        case .download(_, _):
            return SongsServerPathes.downloadPath
        case .downloadManager(_):
            return SongsServerPathes.downloadManagerPath
        case .downloadArtwork(_, _):
            return ""
        }
    }
    
    var method: Moya.Method {
        switch self
        {
        case .search(_):
            return .post
        default:
            return .get
        }
    }
    
    var sampleData: Data {
        return "".utf8Encoded
    }
    
    var task: Task {
        switch self
        {
        case .search(let searchText):
            return .requestParameters(parameters: ["query": searchText], encoding: Alamofire.JSONEncoding.default)
        case .data(let objectid, let type):
            return .requestParameters(parameters: ["objectid": objectid, "type": type.rawValue], encoding: Alamofire.URLEncoding.queryString)
        case .download(let songid, let hqbit):
            return .requestParameters(parameters: ["songid": songid, "hqbit": hqbit], encoding: Alamofire.URLEncoding.queryString)
        case .downloadManager(let songid):
            return .requestParameters(parameters: ["songid": songid], encoding: Alamofire.URLEncoding.queryString)
        case .downloadArtwork(let artworkid, let size):
            return .requestParameters(parameters: ["artworkid": artworkid, "size": size], encoding: Alamofire.URLEncoding.queryString)
        }
    }
    
    var headers: [String : String]? {
        return nil
    }
    
    
}

private extension String {
    var urlEscaped: String {
        return addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
    }
    
    var utf8Encoded: Data {
        return data(using: .utf8)!
    }
}
