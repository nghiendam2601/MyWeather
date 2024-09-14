//
//  Protocols.swift
//  MyWeather
//
//  Created by DamMinhNghien on 10/9/24.
//

import Foundation

protocol weatherDelegate{
    func updateWeatherData(WeatherData: CurrentWeatherModel)
//    func updateUICurrent(text: String,temp:Double,name:String,image:String)
}
