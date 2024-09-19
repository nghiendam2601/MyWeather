//
//  ForecastWeatherModel.swift
//  MyWeather
//
//  Created by DamMinhNghien on 14/9/24.
//
import Foundation

struct ForecastWeatherModel: Decodable {
    var hour: String
    var dayMonth: String  // Thêm biến lưu ngày/tháng
    var temp: Int
    var icon: String
    
    enum CodingKeys: String, CodingKey {
        case dt
        case main
        case weather
    }
    
    enum MainKeys: String, CodingKey {
        case temp
    }
    
    enum WeatherKeys: String, CodingKey {
        case icon
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        // Convert timestamp (dt) to hour string and day/month string
        let timestamp = try container.decode(Int.self, forKey: .dt)
        let date = Date(timeIntervalSince1970: TimeInterval(timestamp))
        
        // Formatter for hour
        let hourFormatter = DateFormatter()
        hourFormatter.dateFormat = "HH:mm"
        hour = hourFormatter.string(from: date)
        
        // Formatter for day/month
        let dayMonthFormatter = DateFormatter()
        dayMonthFormatter.dateFormat = "dd/MM"
        dayMonth = dayMonthFormatter.string(from: date)
        
        // Decode temperature
        let main = try container.nestedContainer(keyedBy: MainKeys.self, forKey: .main)
        let tempDouble = try main.decode(Double.self, forKey: .temp)
        temp = Int(tempDouble)  // Chuyển đổi Double sang Int
        
        // Decode weather icon (first element)
        var weatherArray = try container.nestedUnkeyedContainer(forKey: .weather)
        let weatherContainer = try weatherArray.nestedContainer(keyedBy: WeatherKeys.self)
        icon = try weatherContainer.decode(String.self, forKey: .icon)
    }
}

struct ForecastResponse: Decodable {
    var list: [ForecastWeatherModel]
}
