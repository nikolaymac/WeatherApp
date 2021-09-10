//
//  DayWeatherTVModel.swift
//  WeatherApp
//
//  Created by Nikolay Mikhaylov on 08.09.2021.
//

import Foundation
struct DayWeatherTVModel {
    let day: WeatherDay?
    var dayMonthString: String {
        guard let date = day?.date else {return ""}
        return dateToDayMonthFormatter.string(from: date)
    }
    var dayNameString: String {
        guard let date = day?.date else {return ""}
        return dateToDayNameFormatter.string(from: date)
    }
    var isLoading: Bool {
        return day == nil
        }
}

extension DayWeatherTVModel: CellViewModel {
    func setup(cell: DailyTVCell) {
        cell.viewModel = self
    }
}
