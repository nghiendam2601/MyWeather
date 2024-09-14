//
//  WeatherModel.swift
//  MyWeather
//
//  Created by DamMinhNghien on 9/9/24.
//
import Foundation

struct WeatherModel: Codable {
    var location: Location
    var current: Current
}

struct Location: Codable {
    var name: String
}

struct Current: Codable {
    var tempC: Double
    var condition: Condition
}

struct Condition: Codable {
    var text: String
    var icon: String
}
struct forecast: Codable{
    var forecastday: Forecastday
}
struct Forecastday: Codable{
    var hour: [Hours]
}
struct Hours: Codable{
    var time: String
    var tempC: Double
    var condition: Condition
}

