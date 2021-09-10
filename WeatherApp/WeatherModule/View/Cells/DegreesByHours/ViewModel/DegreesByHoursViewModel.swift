//
//  DegreesByHoursViewModel.swift
//  WeatherApp
//
//  Created by Nikolay Mikhaylov on 08.09.2021.
//

import Foundation
import UIKit
protocol DegreesByHoursViewModelProtocol {
    
}
class DegreesByHoursViewModel {
  
}
extension UICollectionView {

    func register(nibModels: [UICollectionViewCell.Type]) {
        for model in nibModels {
            let identifier = String(describing: model.self)
            let nib = UINib(nibName: identifier, bundle: nil)
            self.register(nib, forCellWithReuseIdentifier: identifier)
        }
    }
//    func dequeueReusableCell(withModel model: CellViewAnyModel, for indexPath: IndexPath, classCell: UITableViewCell.Type) -> UITableViewCell {
//        let idenntifire = String(describing: classCell.self)
//        let cell = dequeueReusableCell(withIdentifier: idenntifire, for: indexPath)
//
//        //model.setupAny(cell: cell)
//        return cell
//    }
    func dequeueReusableCell (withModel model: CellViewAnyModel, for indexPath: IndexPath) -> UICollectionViewCell {
        let identifire = String(describing: type(of: model).cellAnyType)
        let cell = dequeueReusableCell(withReuseIdentifier: identifire, for: indexPath)
        model.setupAny(cell: cell)
        return cell
    }
}
