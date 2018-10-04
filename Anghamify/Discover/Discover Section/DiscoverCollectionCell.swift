//
//  DiscoverCollectionCell.swift
//  Anghamify
//
//  Created by ScaRiLiX on 9/28/18.
//  Copyright © 2018 ScaRiLiX. All rights reserved.
//

import UIKit
import Moya
import SVProgressHUD

class DiscoverCollectionCell: UICollectionViewCell {

    //MARK- Outlets
    
    @IBOutlet weak var sectionNameLabel: UILabel!
    @IBOutlet weak var feedCollectionView: UICollectionView!
    
    //MARK:- Datasource
    var feedItem: SongsFeedItem?
    {
        didSet
        {
            sectionNameLabel.text = feedItem?.title
            feedCollectionView.reloadData()
        }
    }
    
    //MARK:- Helping Vars
    var selectedSong: Song?
    {
        didSet
        {
            play(selectedSong!)
        }
    }
    
    //MARK:- Setup Methods
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupCollectionView()
    }
    
    fileprivate func setupCollectionView()
    {
        feedCollectionView.delegate = self
        feedCollectionView.dataSource = self
        feedCollectionView.backgroundColor = .white
        feedCollectionView.register(nibWithCellClass: DiscoverSongCell.self)
        if let layout = feedCollectionView.collectionViewLayout as? UICollectionViewFlowLayout
        {
            layout.scrollDirection = .horizontal
        }
        
    }
    
    
    //MARK:- Networking
    
    fileprivate func updateSongWithLocationURL(song: Song)
    {
        let provider = MoyaProvider<SongService>(plugins: [NetworkLoggerPlugin(verbose: true)])
        provider.request(.data(objectId: song.id ?? "", type: .song)) { [weak self] (result) in
            switch result
            {
            case .success(let response):
                do
                {
                    let song = try JSONDecoder().decode(Song.self, from: response.data)
                    self?.selectedSong = song
                }
                catch let err
                {
                    SVProgressHUD.showError(withStatus: err.localizedDescription)
                    print(err)
                }
                
            case .failure(let err):
                SVProgressHUD.showError(withStatus: err.localizedDescription)
                print(err)
            }
        }
    }
    
    //MARK:- Logic
    
    fileprivate func play(_ song: Song)
    {
        guard let index = feedItem?.items?.index(where: { $0.artist == song.artist && $0.title == $0.title }) else { return }
        let cell = feedCollectionView.cellForItem(at: IndexPath(item: index, section: 0)) as! DiscoverSongCell
        let mainTabBarController = UIApplication.mainTabBarController()
        
        mainTabBarController?.maximizePlayerDetails()
        mainTabBarController?.playerDetailsView.song = song
        mainTabBarController?.playerDetailsView.episodeImageView.image = cell.songImageView.image
        mainTabBarController?.playerDetailsView.minimizedEpisodeImageView.image = cell.songImageView.image
        mainTabBarController?.playerDetailsView.playlist = feedItem?.items
    }
    
    fileprivate func handleSelecting(_ song: Song, at indexPath: IndexPath)
    {
        if song.fileURL != nil || song.location != nil
        {
            play(song)
        }
        else
        {
            updateSongWithLocationURL(song: song)
        }
        
    }
}

extension DiscoverCollectionCell: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return feedItem?.items?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withClass: DiscoverSongCell.self, for: indexPath)
        let song = feedItem?.items?[indexPath.row]
        cell.discoveredSong = song
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 200, height: 200)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let selectedSong = feedItem?.items?[indexPath.item] else { return }
        handleSelecting(selectedSong, at: indexPath)
    }
    
}
