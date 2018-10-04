//
//  DownloadService.swift
//  Anghamify
//
//  Created by ScaRiLiX on 9/28/18.
//  Copyright © 2018 ScaRiLiX. All rights reserved.
//

import Foundation
import Moya
import Alamofire
import SVProgressHUD

final class DownloadService
{
    static let shared = DownloadService()
    
    fileprivate let provider = MoyaProvider<SongService>(plugins: [NetworkLoggerPlugin(verbose: true)])
    
    var downloads = [DownloadRequest]()
    
    fileprivate func handleProgressObservation() -> ((Progress) -> ())
    {
        return { (progress) in
            SVProgressHUD.showProgress(progress.fractionCompleted.float)
        }
    }
    
    fileprivate func handleSaving(_ song: Song) -> ((DefaultDownloadResponse) -> ())
    {
        return { (response) in
            var downloadedSongs = UserDefaults.standard.downloadedSongs()
            if let index = downloadedSongs.index(where: { $0.title == song.title && $0.artist == song.artist}), let destinationURL = response.destinationURL
            {
                downloadedSongs[index].fileURL = destinationURL
                do
                {
                    let data = try JSONEncoder().encode(downloadedSongs)
                    UserDefaults.standard.set(data, forKey: UserDefaults.downloadedSongsKey)
                }
                catch let err
                {
                    print(err)
                    SVProgressHUD.showError(withStatus: err.localizedDescription)
                }
            }
        }
    }
    
    fileprivate func downloadSongFromServerCache(_ song: Song)
    {
        let songDownload = Alamofire.download("https://anghamicoverart1.akamaized.net/v1/downmanger?songid=\(song.id ?? "")", to: DownloadRequest.suggestedDownloadDestination())
            .downloadProgress(closure: self.handleProgressObservation())
            .response(completionHandler: handleSaving(song))
        downloads.append(songDownload)
    }
    
    fileprivate func cacheSongOnServer(_ song: Song)
    {
        provider.request(.download(songId: song.id ?? "0", quality: .hqbit128)) { (result) in
            switch result
            {
            case .success(let response):
                print(response.data.debugDescription)
            case .failure(let err):
                print(err.errorDescription)
                SVProgressHUD.showError(withStatus: err.localizedDescription)
            }
        }
    }
    
    func download(_ song: Song)
    {
        
        cacheSongOnServer(song)
        downloadSongFromServerCache(song)
    }
    
    func cancelDownload(at index: Int)
    {
        if downloads.indices.contains(index)
        {
            downloads[index].cancel()
            downloads.remove(at: index)
        }
    }
}
