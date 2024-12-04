//
//  WeatherForecastApp.swift
//  WeatherForecast
//
//  Created by purnami indryaswari on 03/12/24.
//

import SwiftUI

@main
struct WeatherForecastApp: App {
    @StateObject private var viewModel = MainViewModel()
    var body: some Scene {
        WindowGroup {
            FormsView()
        }
    }
}
