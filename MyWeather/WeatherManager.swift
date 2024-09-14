//
//  WeatherManager.swift
//  MyWeather
//
//  Created by DamMinhNghien on 9/9/24.
//

import Foundation

struct WeatherManager {
    
    func getWeather() async throws -> CurrentWeatherModel {
        let urlString = "https://api.openweathermap.org/data/2.5/weather?q=Moscow&appid=f18016776a3da6607e724c640736cfea&units=metric"
        
        guard let url = URL(string: urlString) else {
            throw WeatherError.urlError
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        // Kiểm tra mã phản hồi HTTP
        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            throw WeatherError.ResponseError
        }
        
        
        do {
            // Giải mã dữ liệu JSON
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            
            return try decoder.decode(CurrentWeatherModel.self, from: data)
        } catch {
            throw WeatherError.DecodingError
        }
    }
}
