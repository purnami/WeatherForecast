//
//  WeatherView.swift
//  WeatherForecast
//
//  Created by purnami indryaswari on 03/12/24.
//

import SwiftUI
import Kingfisher

struct WeatherView: View {
    @ObservedObject var viewModel : MainViewModel
    
    var body: some View {
        NavigationStack {
            VStack {
                weatherInfoSection
                Spacer()
                navigationToForecast
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(backgroundImage)
        }
    }
    
    private var weatherInfoSection: some View {
        VStack(alignment: .trailing, spacing: 10) {
            greetingText
            weatherIcon
            weatherCondition
            temperatureText
            locationTexts
        }
    }
    
    private var navigationToForecast: some View {
        NavigationLink("Ramalan 5 Hari", destination: ForecastView(viewModel: viewModel))
            .font(.headline)
            .foregroundColor(.white)
            .frame(height: 45)
            .frame(maxWidth: .infinity)
            .background(Color(hex: "#475464"))
            .cornerRadius(25)
            .padding(.horizontal)
    }
    
    private var backgroundImage: some View {
        Image("background")
            .resizable()
            .scaledToFill()
            .edgesIgnoringSafeArea(.all)
    }
    
    private var greetingText: some View {
        Text("Selamat \(viewModel.currentTime()), \(viewModel.name)")
            .font(.largeTitle)
    }
    
    private var weatherIcon: some View {
        KFImage(URL(string: "https://openweathermap.org/img/wn/\(viewModel.weatherData?.weather.first?.icon ?? "02d")@4x.png"))
            .resizable()
            .scaledToFill()
            .frame(width: 200, height: 200)
    }

    private var weatherCondition: some View {
        Text(viewModel.conditionName(conditionId: viewModel.weatherData?.weather.first?.id ?? 0))
            .font(.largeTitle)
    }

    private var temperatureText: some View {
        Text("\(viewModel.temperatureString(temperature: viewModel.weatherData?.main.temp ?? 0.0)) °C")
            .font(.largeTitle)
            .padding(.vertical, 10)
    }

    private var locationTexts: some View {
        VStack(alignment: .trailing, spacing: 5) {
            Text(viewModel.searchProvinceText)
                .font(.headline)
            Text(viewModel.searchRegencyText)
                .font(.headline)
            Text(viewModel.searchDistrictText)
                .font(.headline)
        }
    }
}
