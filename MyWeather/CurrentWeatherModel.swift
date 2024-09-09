//
//  WeatherModel.swift
//  MyWeather
//
//  Created by DamMinhNghien on 9/9/24.
//
import Foundation

struct CurrentWeatherModel {
    var location: Location
    var current: Current
}

struct Location {
    var name: String
}

struct Current {
    var tempC: Double
    var condition: Condition
}

struct Condition {
    var text: String
    var icon: String
}
