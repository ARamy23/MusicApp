//
//  ServerPaths.swift
//  Anghamify
//
//  Created by Ahmed Ramy on 6/24/18.
//  Copyright © 2018 Ahmed Ramy. All rights reserved.
//

import Foundation

struct SongsServerPathes
{
    //MARK:- POST
    
    static let search = "search"
    
    //MARK:- GET
    
    static let dataPath = "data" // parameters = [“objectId”: Int, “type”: String]
    static let downloadPath = "download" // paramters = [“songId”: Int, “hqbit”: Int]
    static let downloadManagerPath = "downmanager" // parameters = [“songid”: Int]
}
