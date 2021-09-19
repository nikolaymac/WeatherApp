//
//  DailyTVCell.swift
//  WeatherApp
//
//  Created by Nikolay Mikhaylov on 08.09.2021.
//

import UIKit

class DailyTVCell: UITableViewCell {

    var viewModel: DayWeatherTVModel? {
        didSet {
            updateUI()
        }
    }
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var weatherImage: UIImageView!
    @IBOutlet weak var degreesLabel: UILabel!
    @IBOutlet weak var dayNameLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }
    func updateUI() {
        guard let viewModel = viewModel else {return}
        degreesLabel.text = viewModel.day?.averageTemp?.cleanDegrees
        dateLabel.text = viewModel.dayMonthString
        dayNameLabel.text = viewModel.dayNameString.capitalizingFirstLetter()        
        let typeWeather = viewModel.day?.weathersData?.first?.weather?.first?.type
        switch typeWeather {
        case .rain:
            weatherImage.image = R.image.rain()
        case .сlouds:
            weatherImage.image = R.image.cloudy()
        default:
            break
        }
    }

}

extension Float {
    var cleanDegrees: String {
        return String(format: "%.0f°", self)
    }
}
