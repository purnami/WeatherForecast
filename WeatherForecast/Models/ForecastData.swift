//
//  ForecastData.swift
//  WeatherForecast
//
//  Created by purnami indryaswari on 03/12/24.
//
import Foundation

struct ForecastResponse: Codable {
    let list: [ForecastData]
}

struct ForecastData: Codable {
    let dt: TimeInterval
    let main: ForecastMain
    let weather: [ForecastWeather]
    let dt_txt: String
}

struct ForecastMain: Codable {
    let temp: Double
}

struct ForecastWeather: Codable {
    let id: Int
    let main: String
    let description: String
    let icon: String
}



