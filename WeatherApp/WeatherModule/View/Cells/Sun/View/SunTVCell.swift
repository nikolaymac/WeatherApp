//
//  SunTVCell.swift
//  WeatherApp
//
//  Created by Nikolay Mikhaylov on 10.09.2021.
//

import UIKit

class SunTVCell: UITableViewCell {

    @IBOutlet weak var sunRise: UILabel!
    @IBOutlet weak var sunSet: UILabel!
    var viewModel: SunTVModel! {
        didSet {
            updateUI()
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }

    func updateUI() {
        sunRise.text = viewModel.timeSunrise
        sunSet.text = viewModel.timeSunset
    }
}
