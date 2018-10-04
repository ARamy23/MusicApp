//
//  SongsSearchCell.swift
//  PodcastApp
//
//  Created by ScaRiLiX on 9/27/18.
//  Copyright © 2018 ScaRiLiX. All rights reserved.
//

import UIKit
import Kingfisher

class SongsSearchCell: UITableViewCell {

    //MARK:- Outlets
    
    @IBOutlet weak var songImageView: UIImageView!
    @IBOutlet weak var songNameLabel: UILabel!
    @IBOutlet weak var songArtistNameLabel: UILabel!
    
    //MARK:- Datasource
    
    var searchItem: Song?
    {
        didSet
        {
            
            songImageView.kf.setImage(with: URL.getArtworkURL(songId: searchItem?.coverArt ?? ""), placeholder: #imageLiteral(resourceName: "placeholder song image"), options: [.transition(.fade(0.5))], progressBlock: nil, completionHandler: nil)
            songNameLabel.text = searchItem?.title
            songArtistNameLabel.text = searchItem?.artist
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
