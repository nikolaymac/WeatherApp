//
//  DegreesTVCell.swift
//  WeatherApp
//
//  Created by Nikolay Mikhaylov on 07.09.2021.
//

import UIKit

class DegreesTVCell: UITableViewCell {

    @IBOutlet weak var valueDegreesLabel: UILabel!
    @IBOutlet weak var indicatorView: UIActivityIndicatorView!
    @IBOutlet weak var weatherImage: UIImageView!
    @IBOutlet weak var typeWeatherLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    
    var viewModel: DegreesTVModel? {
        didSet {
            updateUI()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        contentView.backgroundColor = UIColor(red: 0.039, green: 0.606, blue: 0.925, alpha: 1)
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        valueDegreesLabel.text = ""
        cityLabel.text = ""
        typeWeatherLabel.text = ""
        weatherImage.image = nil
    }
    
    func updateUI() {
        
        guard let viewModel = viewModel else {return}
        valueDegreesLabel.text = viewModel.degreesNow
        valueDegreesLabel.isHidden = viewModel.isLoading
        cityLabel.text = viewModel.city
        typeWeatherLabel.text = viewModel.description
        if viewModel.isLoading {
            indicatorView.startAnimating()
        } else {
            indicatorView.stopAnimating()
        }
        
        switch viewModel.type {
        case .rain:
            weatherImage.image = R.image.rain()
        case .сlouds:
            weatherImage.image = R.image.cloudy()
            
        case .none:
            weatherImage.image = nil
        }
        
    }
    
}
