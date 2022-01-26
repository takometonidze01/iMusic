//
//  SearchViewController.swift
//  iMusic
//
//  Created by CodergirlTM on 12.01.22.
//

import UIKit
import SnapKit
import Alamofire

class SearchMusicViewController: UITableViewController {
    
    private var timer: Timer?
    let searchController = UISearchController(searchResultsController: nil)
    var tracks = [Track]()
    var networkService = NetworkService()
    override func  viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cellId")
//        addSearchBar()
        setupSearchBar()
        searchController.searchBar.delegate = self

    }
    
    private func setupSearchBar() {
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false

    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tracks.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath)
        let track = tracks[indexPath.row]
        cell.textLabel?.text = "\(track.trackName ?? "")\n\(track.artistName ?? "")" 
        cell.textLabel?.numberOfLines = 2
        cell.imageView?.image = UIImage(named: "Image")
        return cell
    }
    
//    func addSearchBar() {
//        let searchBar:UISearchBar = UISearchBar()
//        searchBar.searchBarStyle = UISearchBar.Style.prominent
//        searchBar.placeholder = " Search..."
//        searchBar.sizeToFit()
//        searchBar.isTranslucent = false
//        searchBar.backgroundImage = UIImage()
//        searchBar.delegate = self
//        view.addSubview(searchBar)
//        searchBar.snp.makeConstraints { make in
//            make.top.equalTo(view)
//            make.leading.equalTo(view)
//            make.trailing.equalTo(view)
//            make.height.equalTo(100)
//        }
//    }
}

extension SearchMusicViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print(searchText)
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { (_) in
            self.networkService.fetchTracks(searchText: searchText) { [weak self](searchResult) in
                self!.tracks = searchResult?.results ?? []
                self!.tableView.reloadData()
            }
        })
        
    }
}

