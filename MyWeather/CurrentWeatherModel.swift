//
//  WeatherModel.swift
//  MyWeather
//
//  Created by DamMinhNghien on 9/9/24.
//
import Foundation

struct CurrentWeatherModel: Decodable {
    var name: String
    var temp: Int   
    var des: String
    var icon: String

    enum CodingKeys: String, CodingKey {
        case name
        case main
        case weather
    }

    enum MainKeys: String, CodingKey {
        case temp
    }

    enum WeatherKeys: String, CodingKey {
        case des = "description"
        case icon
    }

    // Custom decoding for nested keys
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        // Decode the city name
        name = try container.decode(String.self, forKey: .name)

        // Decode the temperature from the nested "main" container
        let main = try container.nestedContainer(keyedBy: MainKeys.self, forKey: .main)
        let tempDouble = try main.decode(Double.self, forKey: .temp)
        temp = Int(tempDouble)  // Chuyển đổi Double sang Int

        // Decode the "weather" array (first element)
        var weatherArray = try container.nestedUnkeyedContainer(forKey: .weather)
        let weatherContainer = try weatherArray.nestedContainer(keyedBy: WeatherKeys.self)
        des = try weatherContainer.decode(String.self, forKey: .des)
        icon = try weatherContainer.decode(String.self, forKey: .icon)
    }

    // Custom encoding for nested keys
//    func encode(to encoder: Encoder) throws {
//        var container = encoder.container(keyedBy: CodingKeys.self)
//        try container.encode(name, forKey: .name)
//
//        // Encode the temperature in the "main" container
//        var mainContainer = container.nestedContainer(keyedBy: MainKeys.self, forKey: .main)
//        try mainContainer.encode(Double(temp), forKey: .temp)
//
//        // Encode the "weather" array (first element)
//        var weatherArray = container.nestedUnkeyedContainer(forKey: .weather)
//        var weatherContainer = weatherArray.nestedContainer(keyedBy: WeatherKeys.self)
//        try weatherContainer.encode(des, forKey: .des)
//        try weatherContainer.encode(icon, forKey: .icon)
//    }
}
