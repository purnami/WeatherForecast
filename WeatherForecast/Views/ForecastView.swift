//
//  ForecastView.swift
//  WeatherForecast
//
//  Created by purnami indryaswari on 03/12/24.
//

import SwiftUI
import Kingfisher

struct ForecastView: View {
    @ObservedObject var viewModel : MainViewModel
    
    var body: some View {
        VStack(spacing: 20) {
            header
            forecastScrollView
            Spacer()
        }
        .padding()
    }
    
    private var header: some View {
        Text("Ramalan 5 Hari")
            .font(.largeTitle)
            .padding(.top, 20)
    }

    private var forecastScrollView: some View {
        HStack(spacing: 10) {
            ForEach(Array(viewModel.days.enumerated()), id: \.element) { index, day in
                forecastItem(for: day, at: index)
            }
        }
    }

    private func forecastItem(for day: String, at index: Int) -> some View {
        VStack(alignment: .center, spacing: 10) {
            Text(day)
                .font(.body)
                .padding(.vertical, 5)
                .multilineTextAlignment(.center)

            weatherIcon(for: index)

            Text(viewModel.conditionName(conditionId: viewModel.forecastData[index].weather.first?.id ?? 0))
                .font(.body)

            Text("\(viewModel.temperatureString(temperature: viewModel.forecastData[index].main.temp)) °C")
                .font(.headline)
        }
    }

    private func weatherIcon(for index: Int) -> some View {
        KFImage(URL(string: "https://openweathermap.org/img/wn/\(viewModel.forecastData[index].weather.first?.icon ?? "02d")@2x.png"))
            .resizable()
            .scaledToFill()
            .frame(width: 60, height: 60)
    }
}

