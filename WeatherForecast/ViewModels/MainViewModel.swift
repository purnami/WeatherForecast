//
//  MainViewModel.swift
//  WeatherForecast
//
//  Created by purnami indryaswari on 03/12/24.
//

import SwiftUI
import Combine

final class MainViewModel : ObservableObject {
    @Published var name : String = ""
    @Published var searchProvinceText: String = ""
    @Published var searchRegencyText: String = ""
    @Published var searchDistrictText: String = ""
    @Published var filteredProvinces: [Province] = []
    @Published var filteredRegencies: [Regency] = []
    @Published var filteredDistricts: [District] = []
    @Published var isShowAlert = false
    @Published var alertMessage = ""
    @Published var navigateToWeatherView = false
    @Published var navigateToForecastView = false
    @Published var weatherData : WeatherData?
    @Published var forecastData : [ForecastData] = []
    @Published var days: [String] = []
    @Published var isListProvinceVisible: Bool = false
    @Published var isListRegencyVisible: Bool = false
    @Published var isListDistrictVisible: Bool = false
    private var allProvinces: [Province] = []
    private var allRegencies: [Regency] = []
    private var allDistricts: [District] = []

    var apiServices = ApiServices()
    
    init() {
        fetchProvinces()
        getNextFiveDays()
    }

    // MARK: - API Fetch Methods
    
    func fetchProvinces () {
        apiServices.fetchProvinces { result in
            DispatchQueue.main.async {
                switch result {
                    case .success(let provinces):
                        self.allProvinces = provinces
                        self.filteredProvinces = provinces
                    case .failure(let error):
                        self.showAlert(with: error.localizedDescription)
                }
            }
        }
    }
    
    func fetchRegencies (provinceId: String) {
        apiServices.fetchRegencies(provinceId: provinceId, completion: { result in
            DispatchQueue.main.async {
                switch result {
                    case .success(let regencies):
                        self.allRegencies = regencies
                        self.filteredRegencies = regencies
                    case .failure(let error):
                        self.showAlert(with: error.localizedDescription)
                }
            }
        })
    }
    
    func fetchDistricts (regencyId: String) {
        apiServices.fetchDistricts(regencyId: regencyId, completion: { result in
            DispatchQueue.main.async {
                switch result {
                    case .success(let districts):
                        self.allDistricts = districts
                        self.filteredDistricts = districts
                    case .failure(let error):
                        self.showAlert(with: error.localizedDescription)
                }
            }
        })
    }
    
    func fetchWeather (cityName : String){
        apiServices.fetchWeather(city: cityName) { result in
            DispatchQueue.main.async {
                switch result {
                    case .success(let weatherData):
                        print("weatherData.name \(weatherData.name) \(weatherData.main.temp) \(weatherData.weather.description)")
                        self.navigateToWeatherView = true
                        self.weatherData = weatherData
                    case .failure(_):
                        self.showAlert(with: "Data cuaca tidak tersedia untuk Lokasi tersebut, silahkan pilih Lokasi lainnya !")
                        self.navigateToWeatherView = false
                }
            }
        }
    }
    
    func fetchForecast (cityName : String){
        apiServices.fetchForecast(city: cityName) { result in
            DispatchQueue.main.async {
                switch result {
                    case .success(let forecastData):
                        self.forecastData = forecastData
                    case .failure(let error):
                        print(error)
                        self.showAlert(with: error.localizedDescription)
                }
            }
        }
    }
    
    // MARK: - Search Filters
    
    func filterProvinces() {
        if searchProvinceText.isEmpty {
            filteredProvinces = allProvinces
        } else {
            filteredProvinces = allProvinces.filter {
                $0.name.lowercased().contains(searchProvinceText.lowercased())
            }
        }
    }
    
    func filterRegencies() {
        if searchRegencyText.isEmpty {
            filteredRegencies = allRegencies
        } else {
            filteredRegencies = allRegencies.filter {
                $0.name.lowercased().contains(searchRegencyText.lowercased())
            }
        }
    }
    
    func filterDistricts() {
        if searchDistrictText.isEmpty {
            filteredDistricts = allDistricts
        } else {
            filteredDistricts = allDistricts.filter {
                $0.name.lowercased().contains(searchDistrictText.lowercased())
            }
        }
    }
    
    // MARK: - Helper Methods
    
    func handleNextButton() {
        if name.isEmpty {
            showAlert(with: "Silahkan masukan nama anda")
        } else if searchProvinceText.isEmpty {
            showAlert(with: "Silahkan masukan Provinsi")
        } else if searchRegencyText.isEmpty {
            showAlert(with: "Silahkan masukan Kota atau Kabupaten")
        } else if searchDistrictText.isEmpty {
            showAlert(with: "Silahkan masukan Kecamatan")
        } else {
            fetchWeather(cityName: searchDistrictText)
            fetchForecast(cityName: searchDistrictText)
        }
    }
    
    func showAlert(with message : String){
        alertMessage = message
        isShowAlert = true
    }
    
    func currentTime() -> String {
        let hour = Calendar.current.component(.hour, from: Date())
        
        switch hour {
        case 5..<12:
            return "Pagi"
        case 12..<17:
            return "Siang"
        case 17..<21:
            return "Sore"
        default:
            return "Malam"
        }
    }
    
    func temperatureString(temperature : Double) -> String{
        return String(format: "%.1f", temperature)
    }
    
    func conditionIcon(conditionId : Int) -> String{
        switch conditionId {
        case 200...232:
            return "cloud.bolt"
        case 300...321:
            return "cloud.drizzle"
        case 500...531:
            return "cloud.rain"
        case 600...622:
            return "cloud.snow"
        case 701...781:
            return "cloud.fog"
        case 800:
            return "sun.max"
        case 801...804:
            return "cloud.bolt"
        default:
            return "cloud"
        }
    }
    
    func conditionName(conditionId : Int) -> String{
        switch conditionId {
        case 200...232:
            return "Hujan Badai"
        case 300...321:
            return "Gerimis"
        case 500...531:
            return "Hujan"
        case 600...622:
            return "Bersalju"
        case 701...781:
            return "Berkabut"
        case 800:
            return "Cerah"
        default:
            return "Berawan"
        }
    }
    
    func getNextFiveDays() {
        let calendar = Calendar.current
        let formatter = DateFormatter()
        
        formatter.locale = Locale(identifier: "id_ID")
        
        formatter.dateFormat = "EEEE\nd/MM"
        
        var days: [String] = []
        
        for i in 0..<5 {
            if let date = calendar.date(byAdding: .day, value: i, to: Date()) {
                let dayString = formatter.string(from: date)
                days.append(dayString)
            }
        }
        
        self.days = days
    }
}
