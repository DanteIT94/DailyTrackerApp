//
//  TabBarViewConroller.swift
//  ToDoTracker
//
//  Created by Денис on 21.06.2023.
//

import UIKit

final class TabBarViewController: UITabBarController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBar.isTranslucent = false
        tabBar.barTintColor = .YPBlack
        tabBar.tintColor = .white
        
        let trackerViewController = TrackerViewController()
        trackerViewController.tabBarItem = UITabBarItem(
            title: "Трекеры",
            image: UIImage(named: "Record_circle_fill"),
            selectedImage: nil)
        
        let statisticViewController = StatisticViewController()
        statisticViewController.tabBarItem = UITabBarItem(
            title: "Статистика",
            image: UIImage(named: "Hare_fill"),
            selectedImage: nil)
        
        self.viewControllers = [trackerViewController, statisticViewController]
        
    }
    
    
}
