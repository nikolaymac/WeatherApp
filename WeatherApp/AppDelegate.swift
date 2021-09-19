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
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions
                     launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        self.window = UIWindow(frame: UIScreen.main.bounds)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let vc = storyboard.instantiateViewController(withIdentifier: "WeatherViewController") as? WeatherViewController {
            let model = WeatherViewModel(locationService: LocationService())
            model.updateData = { error in
                vc.updateData(error: error)
            }
            vc.model = model
            window?.rootViewController = vc
            window?.makeKeyAndVisible()
        }
        return true
    }
}
extension UIApplication {
    static var topSafeAreaHeight: CGFloat {
        var topSafeAreaHeight: CGFloat = 0
         if #available(iOS 11.0, *) {
               let window = UIApplication.shared.windows[0]
               let safeFrame = window.safeAreaLayoutGuide.layoutFrame
               topSafeAreaHeight = safeFrame.minY
             }
        return topSafeAreaHeight
    }
}
