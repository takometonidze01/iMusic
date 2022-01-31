//
//  MainTabBarController.swift
//  iMusic
//
//  Created by CodergirlTM on 12.01.22.
//

import UIKit
import SwiftUI

protocol MainTabBarControllerDelegate: class {
    func minimizeTrackDetailController()
    func maximizedTrackDetailController(viewModel: SearchViewModel.Cell?)
}

class MainTabBarController: UITabBarController, UITabBarControllerDelegate {
    
    let searchVC: SearchViewController = SearchViewController.loadFromStoryboard()
    let trackDetailView: TrackDetailView = TrackDetailView.loadFromNib()


    var minimizedTopAnchorConstrains: NSLayoutConstraint!
    var maximizedTopAnchorConstrains: NSLayoutConstraint!
    var bottomAnchorConstraint: NSLayoutConstraint!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        view.backgroundColor = .brown
        view.backgroundColor = .systemBackground
           UITabBar.appearance().barTintColor = .systemBackground
           tabBar.tintColor = UIColor(hexString: "#FF2D55")
           setupVCs()
        searchVC.tabBarDelegate = self


    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupTrackDetailView()
        
    }
    
    
    func setupVCs() {
        var library = Library()
        library.tabBarDelegate = self
        let hostVC = UIHostingController(rootView: library)
        hostVC.tabBarItem.image = UIImage(named: "library")
        hostVC.tabBarItem.title = "Library"
          viewControllers = [
              createNavController(for: searchVC, title: NSLocalizedString("Search", comment: ""), image: UIImage(named: "search")!),
              hostVC
          ]
      }
    
    fileprivate func createNavController(for rootViewController: UIViewController,
                                                    title: String,
                                                    image: UIImage) -> UIViewController {
          let navController = UINavigationController(rootViewController: rootViewController)
          navController.tabBarItem.title = title
          navController.tabBarItem.image = image
          navController.navigationBar.prefersLargeTitles = true
          rootViewController.navigationItem.title = title
          return navController
      }
    
    private func setupTrackDetailView() {
        print("here we will add trackDetailView")
        
        trackDetailView.tabBarDelegate = self
        trackDetailView.delegate = searchVC
        view.insertSubview(trackDetailView, belowSubview: tabBar)
        
        // use auto layout
        trackDetailView.translatesAutoresizingMaskIntoConstraints = false
        maximizedTopAnchorConstrains = trackDetailView.topAnchor.constraint(equalTo: view.topAnchor,constant: view.frame.height)
        minimizedTopAnchorConstrains = trackDetailView.topAnchor.constraint(equalTo: tabBar.topAnchor, constant: -64)
        bottomAnchorConstraint = trackDetailView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: view.frame.height)
        
        bottomAnchorConstraint.isActive = true
        maximizedTopAnchorConstrains.isActive = true
        
        trackDetailView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        trackDetailView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        trackDetailView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true

        
    }
}

extension MainTabBarController: MainTabBarControllerDelegate {

    func maximizedTrackDetailController(viewModel: SearchViewModel.Cell?) {
        minimizedTopAnchorConstrains.isActive = false
        maximizedTopAnchorConstrains.isActive = true
        maximizedTopAnchorConstrains.constant = 0
        bottomAnchorConstraint.constant = 0
        UIView.animate(withDuration: 0.5,
                       delay: 0,
                       usingSpringWithDamping: 0.7,
                       initialSpringVelocity: 1,
                       options: .curveEaseInOut,
                       animations: {
                                        self.view.layoutIfNeeded()
            self.tabBar.alpha = 0
            self.trackDetailView.miniTrackView.alpha = 0
            self.trackDetailView.maximizedStackView.alpha = 1
                                    },
                       completion: nil)
        guard let viewModel = viewModel else { return }
        self.trackDetailView.setUpView(viewModel: viewModel)
    }
    
    func minimizeTrackDetailController() {
        maximizedTopAnchorConstrains.isActive = false
        bottomAnchorConstraint.constant = view.frame.height
        minimizedTopAnchorConstrains.isActive = true
        UIView.animate(withDuration: 0.5,
                       delay: 0,
                       usingSpringWithDamping: 0.7,
                       initialSpringVelocity: 1,
                       options: .curveEaseInOut,
                       animations: {
                                        self.view.layoutIfNeeded()
            self.tabBar.alpha = 1
            self.trackDetailView.miniTrackView.alpha = 1
            self.trackDetailView.maximizedStackView.alpha = 0
                                    },
                       completion: nil)
    }
    
    
}
