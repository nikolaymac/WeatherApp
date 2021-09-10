//
//  SunTVModel.swift
//  WeatherApp
//
//  Created by Nikolay Mikhaylov on 10.09.2021.
//

import Foundation
struct SunTVModel {
    let timeSunrise: String?
    let timeSunset: String?
}

extension SunTVModel: CellViewModel {
    func setup(cell: SunTVCell) {
        cell.viewModel = self
    }
}
