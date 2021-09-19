//
//  ErrorViewController.swift
//  WeatherApp
//
//  Created by Nikolay Mikhaylov on 19.09.2021.
//

import UIKit

class ErrorViewController: UIViewController {

    var error: WeatherError! = .dataFailure

    @IBOutlet weak var retryButton: UIButton!
    @IBOutlet weak var settingsButton: UIButton!
    @IBOutlet weak var textLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
       
        settingsButton.isHidden = error != .locationIsDisable
        textLabel.text = error.rawValue
    }
    
    @IBAction func settingsAction(_ sender: Any) {
        if let bundleId = Bundle.main.bundleIdentifier,
            let url = URL(string: "\(UIApplication.openSettingsURLString)&path=LOCATION/\(bundleId)") {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
}
