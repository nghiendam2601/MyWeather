//
//  WeatherManager.swift
//  MyWeather
//
//  Created by DamMinhNghien on 9/9/24.
//

import Foundation

struct WeatherManager {
    
    func getCurrentWeather() async throws -> CurrentWeatherModel {
        print("run mana1")
        let urlString = "https://api.weatherapi.com/v1/current.json?key=52dd5b7847a4488a863180153242405&q=London&aqi=no"
        print("run mana2")

        guard let url = URL(string: urlString) else {
            throw WeatherError.urlError
        }
        print("run mana3")

        let (data, response) = try await URLSession.shared.data(from: url)
        print("run mana4")

        // Kiểm tra mã phản hồi HTTP
        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            throw WeatherError.ResponseError
        }
        print("run mana5")

        
        do {
            // Giải mã dữ liệu JSON
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            print("run mana6")

            return try decoder.decode(CurrentWeatherModel.self, from: data)
        } catch {
            throw WeatherError.DecodingError
        }
    }
}
