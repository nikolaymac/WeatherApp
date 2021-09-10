//
//  WeatherViewModel.swift
//  WeatherApp
//
//  Created by Nikolay Mikhaylov on 07.09.2021.
//

import Foundation
import Moya

protocol WeatherViewModelProtocol {
    var  updateData: ( () -> Void )? { get set }
    func loadData()
    func refreshData()
    func setupModelForCellAt(_ indexPath: IndexPath) -> CellViewAnyModel
    func numberOfRowsInSection(_ section: Int) -> Int
}

protocol CellViewAnyModel {
    static var cellAnyType: UIView.Type { get }
    func setupAny(cell: UIView)
}

protocol CellViewModel: CellViewAnyModel {
    associatedtype CellType: UIView
    func setup(cell: CellType)
}

extension CellViewModel {
    static var cellAnyType: UIView.Type {
        return  CellType.self
    }
    func setupAny(cell: UIView) {
        if let cell = cell as? CellType {
            setup(cell: cell)
        } else {
            assertionFailure("Cell is Not CellType")
        }
    }
}

class WeatherViewModel: WeatherViewModelProtocol {
    
    enum SectionWeather {
        case mainDegrees
        case degreesByHours
        case days
        case sun
    }
    
    var updateData: (() -> Void)?
    var sections: [SectionWeather] = [.mainDegrees, .sun, .degreesByHours, .days]
    var forecast: Forecast = Forecast(list: [])
    
    var currentDegrees: String? {
        if  let temp = forecast.list.first?.main.temp {
            return "\(Int(temp))" + "°"
        } else {
            return nil
        }
    }
    var currentCity: City? {
        return forecast.city
    }
    var currentType: TypeWeather? {
        return forecast.list.first?.weather?.first?.type
    }
    var currentDesc: String? {
        return forecast.list.first?.weather?.first?.description
    }
    
    var locationService: LocationService
    
    init(locationService: LocationService) {
        self.locationService = locationService
        self.locationService.currentLocationWasSet = { [weak self] in
            self?.loadData()
        }
    }
    
    func loadData() {
        getWeather { [weak self] result in
            switch result {
            case .success(let forecast):
                self?.saveForecast(forecast)
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    @objc func refreshData() {
        loadData()
    }
    
    private func getWeather(completion: @escaping (Result<Forecast, Error>) -> Void) {
        // NetworkLoggerPlugin()
        let provider = MoyaProvider<NetworkService>(plugins: [])
     
        provider.request(.getWeather(lat: locationService.currentLocationLat, lon: locationService.currentLocationLon)) { result in
            switch result {
            case .success(let response):
                do {
                   // let json = try response.mapJSON()
                   // let forecast = try response.map(Forecast.self)
                    let decoder =  JSONDecoder()
                    decoder.dateDecodingStrategy = .secondsSince1970
                    let forecast = try decoder.decode(Forecast.self, from: response.data)
                    completion(.success(forecast))
                } catch {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    private func saveForecast(_ forecast: Forecast) {
        self.forecast = forecast
        var daysDic = [String: [Weather]]()
        for one in forecast.list {
            if daysDic[one.dateDayString] != nil {
                daysDic[one.dateDayString]!.append(one)
            } else {
                daysDic[one.dateDayString] = [one]
            }
        }
        var days: [WeatherDay] = []
        for d in daysDic {
            if let date = d.value.sorted(by: {$0.date! > $1.date!}).first?.date {
                let day = WeatherDay(date: date, weathersData: d.value)
                days.append(day)
            }
        }
        self.forecast.days = days.sorted(by: {$0.date < $1.date})
        self.updateData?()
    }
    
    // MARK: - TableView
    
    func setupModelForCellAt(_ indexPath: IndexPath) -> CellViewAnyModel {
        let sectionType = sections[indexPath.section]
        var modelCell: CellViewAnyModel
        switch sectionType {
        case .mainDegrees:
            modelCell = DegreesTVModel(degreesNow: currentDegrees, type: currentType, description: currentDesc, city: currentCity?.name)
        case .sun:
            modelCell = SunTVModel(timeSunrise: currentCity?.sunRiseTimeString, timeSunset: currentCity?.sunSetTimeString)
        case .degreesByHours:
            modelCell = DegreesByHoursTVModel(list: forecast.list)
        case .days:
            modelCell = DayWeatherTVModel(day: forecast.days![indexPath.row])
        }
        return modelCell
    }
    
    func numberOfRowsInSection(_ section: Int) -> Int {
        switch sections[section] {
        case .mainDegrees, .degreesByHours, .sun:
            return 1
        case .days:
            return forecast.days?.count ?? 0
        }
    }
}

// MARK: - Extension UITableView

extension UITableView {
    func register(nibModels: [UITableViewCell.Type]) {
        for model in nibModels {
            let identifier = String(describing: model.self)
            let nib = UINib(nibName: identifier, bundle: nil)
            self.register(nib, forCellReuseIdentifier: identifier)
        }
    }
    func dequeueReusableCell (withModel model: CellViewAnyModel, for indexPath: IndexPath) -> UITableViewCell {
        let identifire = String(describing: type(of: model).cellAnyType)
        let cell = dequeueReusableCell(withIdentifier: identifire, for: indexPath)
        model.setupAny(cell: cell)
        return cell
    }
}
