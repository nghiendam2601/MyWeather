//
//  WeatherManager.swift
//  MyWeather
//
//  Created by DamMinhNghien on 9/9/24.
//

import Foundation



struct WeatherManager {
    private let apiKey = "f18016776a3da6607e724c640736cfea"
    
    func getCurrentWeather(lat: Double, lon: Double) async throws -> CurrentWeatherModel {
        let urlString = "https://api.openweathermap.org/data/2.5/weather?lat=\(lat)&lon=\(lon)&appid=\(apiKey)&units=metric"
        return try await NetworkService.shared.fetchData(from: urlString, responseType: CurrentWeatherModel.self)
    }
    func getCurrentWeather(cityName: String) async throws -> CurrentWeatherModel {
        // Thay đổi URL để nhận dữ liệu dựa trên tên thành phố
        let urlString = "https://api.openweathermap.org/data/2.5/weather?q=\(cityName)&appid=\(apiKey)&units=metric"
        
        return try await NetworkService.shared.fetchData(from: urlString, responseType: CurrentWeatherModel.self)
    }
    
    // Nhận dự báo thời tiết dựa trên vĩ độ và kinh độ
    func getForecastWeather(lat: Double, lon: Double) async throws -> [ForecastWeatherModel] {
        let urlString = "https://api.openweathermap.org/data/2.5/forecast?lat=\(lat)&lon=\(lon)&appid=\(apiKey)&units=metric"
        let forecastResponse = try await NetworkService.shared.fetchData(from: urlString, responseType: ForecastResponse.self)
        return forecastResponse.list
    }
    func getForecastWeather(cityName: String) async throws -> [ForecastWeatherModel] {
        // Thay đổi URL để nhận dự báo thời tiết dựa trên tên thành phố
        let urlString = "https://api.openweathermap.org/data/2.5/forecast?q=\(cityName)&appid=\(apiKey)&units=metric"
        
        let forecastResponse = try await NetworkService.shared.fetchData(from: urlString, responseType: ForecastResponse.self)
        return forecastResponse.list
    }
}
