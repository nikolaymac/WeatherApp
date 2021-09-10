//
//  String+Extensions.swift
//  WeatherApp
//
//  Created by Nikolay Mikhaylov on 10.09.2021.
//

import Foundation
extension String {
    func capitalizingFirstLetter() -> String {
        return prefix(1).capitalized + dropFirst()
    }

    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
}
