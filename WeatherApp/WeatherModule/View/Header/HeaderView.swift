//
//  HeaderView.swift
//  WeatherApp
//
//  Created by Nikolay Mikhaylov on 19.09.2021.
//

import Foundation
import UIKit

class MyCustomHeader: UITableViewHeaderFooterView {
    var valueDegreesLabel = InfoCenterLabel()
    var indicatorView = UIActivityIndicatorView()
    var weatherImage = UIImageView()
    var typeWeatherLabel = InfoCenterLabel()
    var cityLabel = InfoCenterLabel()
    
    var viewModel: DegreesTVModel? {
        didSet {
            updateUI()
        }
    }
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        configureContents()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
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
        cityLabel.layoutIfNeeded()
        self.layoutIfNeeded()
    }
    
    func configureContents() {

        cityLabel.translatesAutoresizingMaskIntoConstraints = false
        cityLabel.font = UIFont.systemFont(ofSize: 24)
        contentView.addSubview(cityLabel)
    
        typeWeatherLabel.translatesAutoresizingMaskIntoConstraints = false
        typeWeatherLabel.font = UIFont.systemFont(ofSize: 18)
        contentView.addSubview(typeWeatherLabel)
        
        valueDegreesLabel.translatesAutoresizingMaskIntoConstraints = false
        valueDegreesLabel.font = UIFont.systemFont(ofSize: 58)
        contentView.addSubview(valueDegreesLabel)
        
        weatherImage.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(weatherImage)
        
        NSLayoutConstraint.activate([
            cityLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0),
            cityLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0),
            cityLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),

            typeWeatherLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0),
            typeWeatherLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0),
            typeWeatherLabel.topAnchor.constraint(equalTo: cityLabel.bottomAnchor, constant: 0),
            
            valueDegreesLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0),
            valueDegreesLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0),
            valueDegreesLabel.topAnchor.constraint(equalTo: typeWeatherLabel.bottomAnchor, constant: 8),

            weatherImage.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            weatherImage.heightAnchor.constraint(equalToConstant: 46),
            weatherImage.widthAnchor.constraint(equalToConstant: 46),
            weatherImage.topAnchor.constraint(equalTo: valueDegreesLabel.bottomAnchor, constant: 8)
        ])
        
        let con = weatherImage.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0)
        con.priority = UILayoutPriority(999)
        con.isActive = true
    }
}

class InfoCenterLabel: UILabel {
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initializeLabel()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initializeLabel()
    }
    
    func initializeLabel() {
        
        self.textAlignment = .center
        self.textColor = .black
    }
}
