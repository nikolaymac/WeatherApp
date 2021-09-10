//
//  DegreesTVModel.swift
//  WeatherApp
//
//  Created by Nikolay Mikhaylov on 08.09.2021.
//

import Foundation

struct DegreesTVModel {
    let degreesNow: String?
    let type: TypeWeather?
    let description: String?
    let city: String?
    var isLoading: Bool {
            return degreesNow == nil
        }
}

extension DegreesTVModel: CellViewModel {
    func setup(cell: DegreesTVCell) {
        cell.viewModel = self
    }
}
