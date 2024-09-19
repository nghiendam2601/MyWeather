//
//  Enum.swift
//  MyWeather
//
//  Created by DamMinhNghien on 9/9/24.
//

import Foundation

enum WeatherError: Error{
    case urlError
    case DecodingError
    case ResponseError
}
enum WeatherDataType{
    case current
    case forecast
}
enum SearchType{
    case city
    case cooodinate
}
