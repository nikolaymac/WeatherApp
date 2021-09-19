//
//  Weather.swift
//  WeatherApp
//
//  Created by Nikolay Mikhaylov on 07.09.2021.
//
// swiftlint:disable all
import Foundation

var dateToHourFormatter: DateFormatter = {
    let dateFormatter = DateFormatter()
    dateFormatter.locale = Locale.current
    dateFormatter.dateFormat = "HH"
    return dateFormatter
}()
var dateToTimeFormatter: DateFormatter = {
    let dateFormatter = DateFormatter()
    dateFormatter.locale = Locale.current
    dateFormatter.dateFormat = "HH:mm"
    return dateFormatter
}()
var dateToStringFormatter: DateFormatter = {
    let dateFormatter = DateFormatter()
    dateFormatter.locale = Locale.current
    dateFormatter.dateFormat = "dd.MM.yyyy"
    return dateFormatter
}()
var dateToDayMonthFormatter: DateFormatter = {
    let dateFormatter = DateFormatter()
    dateFormatter.locale = Locale.current
    dateFormatter.dateFormat = "dd MMMM"
    return dateFormatter
}()
var dateToDayNameFormatter: DateFormatter = {
    let dateFormatter = DateFormatter()
    dateFormatter.locale = Locale.current
    dateFormatter.dateFormat = "EEEE"
    return dateFormatter
}()

struct Forecast: Codable {
    var list: [Weather]
    var days: [WeatherDay]?
    var city: City?
}
struct City: Codable {
    var name: String?
    var sunrise: Date?
    var sunset: Date?
    var sunRiseTimeString: String {
        guard let date = sunrise else {return ""}
        return dateToTimeFormatter.string(from: date)
    }
    var sunSetTimeString: String {
        guard let date = sunset else {return ""}
        return dateToTimeFormatter.string(from: date)
    }
}
struct WeatherDay: Codable {
    var date: Date
    var weathersData: [Weather]?
    var averageTemp: Float? {
        guard let weathersData = weathersData else {return nil}
        var sumTemp: Float = 0
        for w in weathersData {
            sumTemp += w.main.temp
        }
        return sumTemp / Float(weathersData.count)
    }
}

struct Weather: Codable, CustomStringConvertible {
    public var description: String {
        return "Day: \(dateDayString), temp - \(main)"
    }
    let main: Main
    let weather: [WeatherData]?
    let date: Date?
    var dateHourString: String {
        guard let date = date else {return ""}
        return dateToHourFormatter.string(from: date)
    }
    var dateDayString: String {
        guard let date = date else {return ""}
        return dateToStringFormatter.string(from: date)
    }
    private enum CodingKeys: String, CodingKey {
        case main
        case date = "dt"
        case weather
       
    }
    
    init(from decoder: Decoder) throws {
        let container  = try decoder.container(keyedBy: CodingKeys.self)
        main           = try container.decodeIfPresent(Main.self, forKey: .main)!
        date           = try container.decodeIfPresent(Date.self, forKey: .date)
        weather        = try container.decodeIfPresent([WeatherData].self, forKey: .weather)
       
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(main, forKey: .main)
        try container.encode(date, forKey: .date)
    }
}

enum TypeWeather: String {
    case rain = "Rain"
    case сlouds = "Clouds"
}
struct WeatherData: Codable {
    let id: Int?
    var type: TypeWeather?
    var description: String?
    
    private enum CodingKeys: String, CodingKey {
        case id, description
        case type = "main"
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(id, forKey: .id)
        try container.encode(type?.rawValue, forKey: .type)
        try container.encode(description, forKey: .description)
    }
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id            = try container.decodeIfPresent(Int.self, forKey: .id)
        description   = try container.decodeIfPresent(String.self, forKey: .description)
        let type  = try container.decodeIfPresent(String.self, forKey: .type)

        if let type = type {
            self.type = TypeWeather(rawValue: type) ?? .сlouds
        } else {
            self.type = .сlouds
        }
    }
}
struct Main: Codable {
    let temp: Float
    var tempStr: String {
        return "\(Int(temp))" + "°"
    }
    let feels_like: Float
}
