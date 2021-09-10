//
//  NetworkService.swift
//  WeatherApp
//
//  Created by Nikolay Mikhaylov on 07.09.2021.
//

import Foundation
import Moya

enum NetworkService {
    case getWeather(lat: Float?, lon: Float?)
}

extension NetworkService: TargetType {
    
  public var baseURL: URL {
    return URL(string: "https://api.openweathermap.org/data/2.5")!
  }

  public var path: String {
    switch self {
    case .getWeather:
        return "/forecast"
    }
  }
    
  public var method: Moya.Method {
    return .get
  }
    
  public var task: Task {
    
    switch self {
    case .getWeather(let lat, let lon):
        return .requestParameters(parameters: ["appid": "c908b602daf5c7a8fddbe6f94a875693",
                                               "units": "metric",
                                               "lang": Locale.getPreferredLocale.languageCode ?? "en",
                                               "lon": (lon ?? 58.833339)!,
                                               "lat": (lat ?? 60.616339)!],
                                  encoding: URLEncoding.default)
    }
  }
    
  public var headers: [String: String]? {
    return ["Content-Type": "application/json"]
  }

  public var validationType: ValidationType {
    return .successCodes
  }
}
