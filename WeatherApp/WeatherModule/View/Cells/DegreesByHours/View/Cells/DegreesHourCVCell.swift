//
//  DegreesHourCVCell.swift
//  WeatherApp
//
//  Created by Nikolay Mikhaylov on 08.09.2021.
//

import UIKit

struct DegreesByHoursCVModel {
    
    let degrees: String?
    let hour: String
    let typeWeather: TypeWeather
    
}

extension DegreesByHoursCVModel: CellViewModel {
    func setup(cell: DegreesHourCVCell) {
        cell.viewModel = self
    }
}

class DegreesHourCVCell: UICollectionViewCell {

    @IBOutlet weak var hourLabel: UILabel!
    @IBOutlet weak var weatherImage: UIImageView!
    @IBOutlet weak var degreesLabel: UILabel!
    
    var viewModel: DegreesByHoursCVModel? {
        didSet {
            updateUI()
        }
    }
    
    func updateUI() {
        guard let viewModel = viewModel else {return}
        hourLabel.text = viewModel.hour
        degreesLabel.text = viewModel.degrees
        switch viewModel.typeWeather {
        case .rain:
            weatherImage.image = R.image.rain()
        case .сlouds:
            weatherImage.image = R.image.cloudy()
        }
    }
    
}
