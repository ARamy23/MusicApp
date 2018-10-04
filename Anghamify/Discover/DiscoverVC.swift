//
//  DiscoverVC.swift
//  Anghamify
//
//  Created by ScaRiLiX on 9/27/18.
//  Copyright © 2018 ScaRiLiX. All rights reserved.
//

import UIKit
import Moya
import SVProgressHUD

class DiscoverVC: UICollectionViewController, UICollectionViewDelegateFlowLayout {

    //MARK:- Datasource
    
    var discoverFeed = SongsFeed()
    
    //MARK:- Properties
    
    let provider = MoyaProvider<SongService>(plugins: [NetworkLoggerPlugin(verbose: true)])
    
    //MARK:- ViewController Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        setupCollectionView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchDiscoveringMusicData()
    }
    
    //MARK:- Setup Methods
    
    fileprivate func setupCollectionView()
    {
        collectionView.backgroundColor = .white
        collectionView.register(nibWithCellClass: DiscoverCollectionCell.self)
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout
        {
            layout.scrollDirection = .vertical
        }
    }
    
    //MARK:- Network Methods
    
    fileprivate func fetchDiscoveringMusicData()
    {
        SVProgressHUD.show(withStatus: "Retrieving Songs...")
        provider.request(.data(objectId: "", type: .discover)) { [weak self] (result) in
            switch result
            {
            case .success(let response):
                do
                {
                    let incomingFeed = try JSONDecoder().decode(SongsFeed.self, from: response.data)
                    self?.discoverFeed = incomingFeed
                    
                    DispatchQueue.main.async { [weak self] in
                        self?.collectionView.reloadData()
                        SVProgressHUD.dismiss()
                    }
                    
                    
                }
                catch let err
                {
                    SVProgressHUD.showError(withStatus: err.localizedDescription)
                    print(err)
                }
            case .failure(let error):
                print(error)
                SVProgressHUD.showError(withStatus: error.localizedDescription)
            }
        }
    }
    
    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return discoverFeed.count
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    
        return discoverFeed.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withClass: DiscoverCollectionCell.self, for: indexPath)
        let feedItem = discoverFeed[indexPath.row]
        cell.feedItem = feedItem
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.view.width, height: 300)
    }
}
