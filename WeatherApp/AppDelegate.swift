//
//  AppDelegate.swift
//  WeatherApp
//
//  Created by Nikolay Mikhaylov on 07.09.2021.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        self.window = UIWindow(frame: UIScreen.main.bounds)
        sleep(2)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let vc = storyboard.instantiateViewController(withIdentifier: "WeatherViewController") as? WeatherViewController {
            let model = WeatherViewModel(locationService: LocationService())
            model.updateData = {
                vc.refreshControl.endRefreshing()
                vc.tableView?.reloadData()
            }
            vc.model = model
            window?.rootViewController = vc
            window?.makeKeyAndVisible()
        }
        
        return true
    }
}
