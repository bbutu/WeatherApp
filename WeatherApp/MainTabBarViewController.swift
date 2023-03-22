//
//  ViewController.swift
//  WeatherApp
//
//  Created by Beka Buturishvili on 13.02.23.
//

import UIKit

class MainTabBarViewController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let vc1 = UINavigationController(rootViewController: TodayViewController())
        let vc2 = UINavigationController(rootViewController: ForecastViewController())
        
        vc1.tabBarItem.image = UIImage(systemName: "sun.max")
        vc2.tabBarItem.image = UIImage(systemName: "clock")
        
        vc1.title = "Today"
        vc2.title = "Forecast"
        
        tabBar.tintColor = .accentColor
        tabBar.barTintColor = .white
        
        setViewControllers([vc1,vc2], animated: true)
    }

}

