//
//  UserDefaults.swift
//  PodcastApp
//
//  Created by ScaRiLiX on 9/25/18.
//  Copyright © 2018 ScaRiLiX. All rights reserved.
//

import Foundation

extension UserDefaults
{
    //TODO:- Caching Songs Utilities here
    static let savedSongsKey = "savedSongsKey"
    static let downloadedSongsKey = "downloadedSongsKey"
    
    func savedSongs() -> [Song]
    {
        guard let savedPodcastsData =  data(forKey: UserDefaults.savedSongsKey) else { return [] }
        do
        {
            let savedPodcasts = try JSONDecoder().decode([Song].self, from: savedPodcastsData)
            return savedPodcasts
        }
        catch (let err)
        {
            print(err)
            return []
        }
    }
    
    func downloadedSongs() -> [Song]
    {
        guard let downloadedSongsData =  data(forKey: UserDefaults.downloadedSongsKey) else { return [] }
        do
        {
            let downloadedSongs = try JSONDecoder().decode([Song].self, from: downloadedSongsData)
            return downloadedSongs
        }
        catch (let err)
        {
            print(err)
            return []
        }
    }
    
    func save(_ podcasts: [Song])
    {
        do
        {
            let data = try JSONEncoder().encode(podcasts)
            UserDefaults.standard.set(data, forKey: UserDefaults.savedSongsKey)
        }
        catch (let err)
        {
            print("failed to encode Episode with error:", err)
        }
    }
    
    func download(_ song: Song)
    {
        do
        {
            var songs = downloadedSongs()
            songs.append(song)
            let data = try JSONEncoder().encode(songs)
            UserDefaults.standard.set(data, forKey: UserDefaults.downloadedSongsKey)
        }
        catch (let err)
        {
            print("failed to encode Episode with error:", err)
        }
    }
    
    func remove(_ song: Song)
    {
        do
        {
            var songs = downloadedSongs()
            if let index = songs.index(where: { $0.title == song.title && $0.artist == song.artist } )
            {
                songs.remove(at: index)
                let data = try JSONEncoder().encode(songs)
                UserDefaults.standard.set(data, forKey:     UserDefaults.downloadedSongsKey)
            }
        }
        catch (let err)
        {
            print("failed to encode Episode with error:", err)
        }
    }
}
