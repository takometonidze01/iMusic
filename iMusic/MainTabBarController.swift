//
//  MainTabBarController.swift
//  iMusic
//
//  Created by CodergirlTM on 12.01.22.
//

import UIKit

protocol MainTabBarControllerDelegate: class {
    func minimizeTrackDetailController() 
}

class MainTabBarController: UITabBarController, UITabBarControllerDelegate {
    
    let searchVC: SearchViewController = SearchViewController.loadFromStoryboard()
    let libraryVC = LibraryViewController()

    var minimizedTopAnchorConstrains: NSLayoutConstraint!
    var maximizedTopAnchorConstrains: NSLayoutConstraint!
    var bottomAnchorConstraint: NSLayoutConstraint!

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .brown
        view.backgroundColor = .systemBackground
           UITabBar.appearance().barTintColor = .systemBackground
           tabBar.tintColor = .label
           setupVCs()


    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        viewControllers = [
//            generateViewController(rootViewController: searchVC, image: UIImage(named: "search")!, title: "Search"),
//            generateViewController(rootViewController: libraryVC, image: UIImage(named: "library")!, title: "Library")
//        ]
//        tabBar.tintColor = UIColor(hexString: "#FF2D55")
//        UITabBarItem.appearance().titlePositionAdjustment = UIOffset(horizontal: 0, vertical: 0)
        setupTrackDetailView()
        
    }
    
//    private func generateViewController(rootViewController: UIViewController, image: UIImage, title: String) -> UIViewController {
//        let navigationVC = UINavigationController(rootViewController: rootViewController)
//        navigationVC.tabBarItem.image = image
//        navigationVC.tabBarItem.title = title
//        rootViewController.navigationItem.title = title
//        navigationVC.navigationBar.prefersLargeTitles = true
//        return navigationVC
//    }
    
    
    func setupVCs() {
          viewControllers = [
              createNavController(for: searchVC, title: NSLocalizedString("Search", comment: ""), image: UIImage(named: "search")!),
              createNavController(for: libraryVC, title: NSLocalizedString("Library", comment: ""), image: UIImage(named: "library")!),

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
        let trackDetailView: TrackDetailView = TrackDetailView.loadFromNib()
        
        trackDetailView.backgroundColor = .gray
        trackDetailView.tabBarDelegate = self
        trackDetailView.delegate = searchVC
        view.insertSubview(trackDetailView, belowSubview: tabBar)
        
        // use auto layout
        trackDetailView.translatesAutoresizingMaskIntoConstraints = false
        maximizedTopAnchorConstrains = trackDetailView.topAnchor.constraint(equalTo: view.topAnchor)
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
    func minimizeTrackDetailController() {
        maximizedTopAnchorConstrains.isActive = false
        minimizedTopAnchorConstrains.isActive = true
        UIView.animate(withDuration: 0.5,
                       delay: 0,
                       usingSpringWithDamping: 0.7,
                       initialSpringVelocity: 1,
                       options: .curveEaseInOut,
                       animations: {
                                        self.view.layoutIfNeeded()
                                    },
                       completion: nil)
    }
    
    
}
