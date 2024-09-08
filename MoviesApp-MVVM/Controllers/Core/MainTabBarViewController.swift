//
//  ViewController.swift
//  MoviesApp-MVVM
//
//  Created by Mert Yılmaz on 27.08.2024.
//

import UIKit

class MainTabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        createTabBar()
    }

    func createTabBar() {
        
        let homeTab = UINavigationController(rootViewController: HomeViewController())
        let upcomingTab = UINavigationController(rootViewController: UpcomingViewController())
        let searchTab = UINavigationController(rootViewController: SearchViewController())
        let downloadsTab = UINavigationController(rootViewController: DownloadsViewController())

        
        homeTab.tabBarItem = UITabBarItem(title: "Home", image: UIImage(systemName: "house"), tag: 1)
        upcomingTab.tabBarItem = UITabBarItem(title: "Upcoming", image: UIImage(systemName: "play.display"), tag: 2)
        searchTab.tabBarItem = UITabBarItem(title: "Search", image: UIImage(systemName: "magnifyingglass"), tag: 3)
        downloadsTab.tabBarItem = UITabBarItem(title: "Downloads", image: UIImage(systemName: "arrow.down"), tag: 4)
        
        setViewControllers([homeTab,upcomingTab,searchTab,downloadsTab], animated: true)

    }
    
}

