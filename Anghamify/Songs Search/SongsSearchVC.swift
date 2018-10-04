//
//  SongsVC.swift
//  PodcastApp
//
//  Created by ScaRiLiX on 9/27/18.
//  Copyright © 2018 ScaRiLiX. All rights reserved.
//

import UIKit
import Moya
import SVProgressHUD
import SwifterSwift

class SongsSearchVC: UITableViewController {

    //MARK:- Datasource
    var searchFeed = [Song]()
    
    //MARK:- Properties
    var timer: Timer?
    let searchController = UISearchController(searchResultsController: nil)
    
    var selectedSong: Song?
    {
        didSet
        {
            play(selectedSong!)
        }
    }
    
    //MARK:- View Controller Method
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        setupUI()
    }
    
    //MARK:- Setup Methods
    
    fileprivate func setupUI()
    {
        setupSearchBar()
        setupTableView()
    }
    
    fileprivate func setupSearchBar()
    {
        definesPresentationContext = true
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.delegate = self
    }
    
    fileprivate func setupTableView()
    {
        tableView.register(nibWithCellClass: SongsSearchCell.self)
        tableView.separatorStyle = .none
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
        guard let index = searchFeed.index(where: { $0.artist == song.artist && $0.title == $0.title }) else { return }
        let cell = tableView.cellForRow(at: IndexPath(item: index, section: 0)) as! SongsSearchCell
        let mainTabBarController = UIApplication.mainTabBarController()
        
        mainTabBarController?.maximizePlayerDetails()
        mainTabBarController?.playerDetailsView.song = song
        mainTabBarController?.playerDetailsView.episodeImageView.image = cell.songImageView.image
        mainTabBarController?.playerDetailsView.minimizedEpisodeImageView.image = cell.songImageView.image
        mainTabBarController?.playerDetailsView.playlist = searchFeed
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

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchFeed.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withClass: SongsSearchCell.self)
        let searchItem = searchFeed[indexPath.row]
        cell.searchItem = searchItem
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 160
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = UILabel()
        label.text = "Please enter a search term"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 25, weight: .semibold)
        label.textColor = UIColor.appPrimaryColor
        return label
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return self.searchFeed.count > 0 ? 0 : 250
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedSong = searchFeed[indexPath.item]
        handleSelecting(selectedSong, at: indexPath)
    }
    
}

extension SongsSearchVC: UISearchBarDelegate
{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { [weak self ] (_) in
            self?.search(for: searchText)
        })
    }
    
    fileprivate func search(for searchText: String)
    {
        SVProgressHUD.show(withStatus: "Searching...")
        let provider = MoyaProvider<SongService>(plugins: [NetworkLoggerPlugin(verbose: true)])
        provider.request(.search(searchText)) { (result) in
            switch result
            {
            case .success(let response):
                do
                {
                    let searchFeed = try JSONDecoder().decode([Song].self, from: response.data)
                    searchFeed.forEach { print($0.id ?? "id is NIL")}
                    self.searchFeed = searchFeed
                    self.tableView.reloadData()
                    SVProgressHUD.dismiss()
                    
                }
                catch (let err)
                {
                    SVProgressHUD.showError(withStatus: err.localizedDescription)
                    print(err.localizedDescription)
                }
            case .failure(let err):
                SVProgressHUD.showError(withStatus: err.localizedDescription)
            }
        }
    }
}
