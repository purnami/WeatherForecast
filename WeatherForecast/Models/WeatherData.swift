//
//  WeatherData.swift
//  WeatherForecast
//
//  Created by purnami indryaswari on 03/12/24.
//

import Foundation

struct WeatherData : Codable{
    let name : String
    let main : Main
    let weather : [Weather]
}

struct Main : Codable{
    let temp : Double
}

struct Weather : Codable{
    let id : Int
    let description : String
    let icon : String
}


