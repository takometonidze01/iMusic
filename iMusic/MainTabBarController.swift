//
//  MainTabBarController.swift
//  iMusic
//
//  Created by CodergirlTM on 12.01.22.
//

import UIKit

class MainTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .brown
        let searchVC: SearchViewController = SearchViewController.loadFromStoryboard()
        let libraryVC = LibraryViewController()
        viewControllers = [
            generateViewController(rootViewController: searchVC, image: UIImage(named: "search")!, title: "Search"),
            generateViewController(rootViewController: libraryVC, image: UIImage(named: "library")!, title: "Library")
        ]
        tabBar.tintColor = UIColor(hexString: "#FF2D55")
        UITabBarItem.appearance().titlePositionAdjustment = UIOffset(horizontal: 0, vertical: 0)
    }
    
    
    private func generateViewController(rootViewController: UIViewController, image: UIImage, title: String) -> UIViewController {
        let navigationVC = UINavigationController(rootViewController: rootViewController)
        navigationVC.tabBarItem.image = image
        navigationVC.tabBarItem.title = title
        rootViewController.navigationItem.title = title
        navigationVC.navigationBar.prefersLargeTitles = true
        return navigationVC
    }
}
