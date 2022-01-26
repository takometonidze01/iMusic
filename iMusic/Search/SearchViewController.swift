//
//  SearchViewController.swift
//  iMusic
//
//  Created by CodergirlTM on 18.01.22.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol SearchDisplayLogic: class
{
    func displaySomething(viewModel: Search.Something.ViewModel.ViewModelData)
}

class SearchViewController: UIViewController, SearchDisplayLogic
{
    
    
  var interactor: SearchBusinessLogic?
  var router: (NSObjectProtocol & SearchRoutingLogic & SearchDataPassing)?
    let searchController = UISearchController(searchResultsController: nil)
    @IBOutlet weak var table: UITableView!
    
    private var searchViewModel = SearchViewModel.init(cells: [])
    private var timer: Timer?
    private lazy var footerView = FooterView()
  // MARK: Setup
  
  private func setup()
  {
    let viewController = self
    let interactor = SearchInteractor()
    let presenter = SearchPresenter()
    let router = SearchRouter()
    viewController.interactor = interactor
    viewController.router = router
    interactor.presenter = presenter
    presenter.viewController = viewController
    router.viewController = viewController
    router.dataStore = interactor
  }
  
  // MARK: Routing
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?)
  {
    if let scene = segue.identifier {
      let selector = NSSelectorFromString("routeTo\(scene)WithSegue:")
      if let router = router, router.responds(to: selector) {
        router.perform(selector, with: segue)
      }
    }
  }
  
  // MARK: View lifecycle
  
  override func viewDidLoad()
  {
    super.viewDidLoad()
//    doSomething()
      setup()
      setupSearchBar()
      setupTableView()
      self.interactor?.doSomething(request: Search.Something.Request.RequestType.getTracks(searchText: "t"))
  }
    

  
  // MARK: Do something
  
  //@IBOutlet weak var nameTextField: UITextField!
  
//  func doSomething()
//  {
//    let request = Search.Something.Request()
//    interactor?.doSomething(request: request)
//  }
  
    func displaySomething(viewModel: Search.Something.ViewModel.ViewModelData) {
        switch viewModel {
            
        case .some:
            print("viewController .some")
        case .displayTracks(let searchViewModel):
            print("viewController .displayTracks")
            self.searchViewModel = searchViewModel
            table.reloadData()
            footerView.hideLoader()
        case .displayFooterView:
            footerView.showLoader()
        }
    }
    private func setupSearchBar() {
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.obscuresBackgroundDuringPresentation = false
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.searchBar.delegate = self

    }
    
    private func setupTableView() {
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cellId")
        let nib = UINib(nibName: "TrackCell", bundle: nil)
        table.register(nib, forCellReuseIdentifier: TrackCell.reuseId)
        
        table.tableFooterView = footerView
    }
}
// MARK: - UITableViewDelegate, UITableViewDataSource
extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchViewModel.cells.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = table.dequeueReusableCell(withIdentifier: TrackCell.reuseId, for: indexPath) as! TrackCell
        let cellViewModel = searchViewModel.cells[indexPath.row]
        cell.trackImageView.image = UIImage(named: "Image")
        cell.setModel(viewModel: cellViewModel)
//        cell.textLabel?.text = "\(cellViewModel.trackName)\n\(cellViewModel.artistName)"
//        cell.textLabel?.numberOfLines = 2
//        cell.imageView?.image = UIImage(named: "")
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = UILabel()
        label.text = "Please enter search term above..."
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        return label
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return searchViewModel.cells.count > 0 ? 0 : 250
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cellViewModel = searchViewModel.cells[indexPath.row]
        
        let window = UIApplication.shared.keyWindow
        let trackDetailsView: TrackDetailView = TrackDetailView.loadFromNib()
        trackDetailsView.setUpView(viewModel: cellViewModel)
        trackDetailsView.delegate = self
        window?.addSubview(trackDetailsView)
    }
    
}
// MARK: - UISearchBarDelegate
extension SearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print(searchText)
        var searchTxt = "t"
        if searchText == "" {
            searchTxt = "t"
        } else {
            searchTxt = searchText
        }
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 0.5,
                                     repeats: false,
                                     block: { (_) in
            self.interactor?.doSomething(request: Search.Something.Request.RequestType.getTracks(searchText: searchTxt))

        })
    }
}

extension SearchViewController: TrackMovingDelegate {
    private func getTrack(isForwardTrack: Bool) -> SearchViewModel.Cell? {
        guard let indexPath = table.indexPathForSelectedRow else { return nil }
        table.deselectRow(at: indexPath, animated: true)
        var nextIndexPath: IndexPath!
        if isForwardTrack {
            nextIndexPath = IndexPath(row: indexPath.row + 1, section: indexPath.section)
            if nextIndexPath.row == searchViewModel.cells.count {
                nextIndexPath.row = 0
            }
        } else {
            nextIndexPath = IndexPath(row: indexPath.row - 1, section: indexPath.section)
            if nextIndexPath.row == -1 {
                nextIndexPath.row = searchViewModel.cells.count - 1
            }
        }
        
        table.selectRow(at: nextIndexPath, animated: true, scrollPosition: .none)
        let cellViewModel = searchViewModel.cells[nextIndexPath.row]
        return cellViewModel
    }
    
    func moveBackForPreviousTrack() -> SearchViewModel.Cell? {
        print("go back")
        return getTrack(isForwardTrack: false)
    }
    
    func moveForwardForPreviousTrack() -> SearchViewModel.Cell? {
        print("go forward")
        return getTrack(isForwardTrack: true)
    }
    
    
}
