//
//  DegreesByHoursTVModel.swift
//  WeatherApp
//
//  Created by Nikolay Mikhaylov on 08.09.2021.
//

import Foundation

struct DegreesByHoursTVModel {
    let list: [Weather]
}
extension DegreesByHoursTVModel: CellViewModel {
    func setup(cell: DegreesByHoursTVCell) {
        cell.viewModel = self
    }
}
extension DegreesByHoursTVModel {
    func setupModelForCellAt(_ indexPath: IndexPath) -> CellViewAnyModel {
        let listItem = list[indexPath.item]
        return DegreesByHoursCVModel(degrees: listItem.main.tempStr, hour: listItem.dateHourString, typeWeather: listItem.weather!.first!.type!)
         
    }
}
