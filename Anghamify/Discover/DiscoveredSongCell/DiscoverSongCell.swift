//
//  DiscoverSongCell.swift
//  Anghamify
//
//  Created by ScaRiLiX on 9/28/18.
//  Copyright © 2018 ScaRiLiX. All rights reserved.
//

import UIKit


class DiscoverSongCell: UICollectionViewCell {

    @IBOutlet weak var songImageView: UIImageView!
    @IBOutlet weak var songNameLabel: UILabel!
    @IBOutlet weak var artistNameLabel: UILabel!
    
    
    var discoveredSong: Song?
    {
        didSet
        {
            songImageView.kf.setImage(with: URL.getArtworkURL(songId: discoveredSong?.coverArt ?? ""), placeholder: #imageLiteral(resourceName: "placeholder song image"), options: [.transition(.fade(0.5))], progressBlock: nil, completionHandler: nil)
            songNameLabel.text = discoveredSong?.title
            artistNameLabel.text = discoveredSong?.artist
        }
    }

}
