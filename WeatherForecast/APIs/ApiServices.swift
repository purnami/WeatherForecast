//
//  ApiServices.swift
//  WeatherForecast
//
//  Created by purnami indryaswari on 03/12/24.
//
import Foundation

class ApiServices {
    let regionURL = "https://www.emsifa.com/api-wilayah-indonesia/api"
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather"
    let forecastURL = "https://api.openweathermap.org/data/2.5/forecast"
    let weatherApiID = "6d746eeef4f57390aaf30670b6eecb3f"

    func fetchData<T: Decodable>(url: String, completion: @escaping (Result<T, Error>) -> Void) {
        guard let url = URL(string: url) else {
            completion(.failure(NSError(domain: "Invalid URL", code: 0, userInfo: nil)))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "No data", code: 0, userInfo: nil)))
                return
            }
            
            do {
                let decodedData = try JSONDecoder().decode(T.self, from: data)
                completion(.success(decodedData))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
        
    func fetchProvinces(completion: @escaping (Result<[Province], Error>) -> Void) {
        let url = "\(regionURL)/provinces.json"
        fetchData(url: url, completion: completion)
    }
    
    func fetchRegencies(provinceId: String, completion: @escaping (Result<[Regency], Error>) -> Void) {
        let url = "\(regionURL)/regencies/\(provinceId).json"
        fetchData(url: url, completion: completion)
    }
    
    func fetchDistricts(regencyId: String, completion: @escaping (Result<[District], Error>) -> Void) {
        let url = "\(regionURL)/districts/\(regencyId).json"
        fetchData(url: url, completion: completion)
    }
    
    func fetchWeather(city: String, completion: @escaping (Result<WeatherData, Error>) -> Void) {
        var components = URLComponents(string: weatherURL)
        components?.queryItems = [
            URLQueryItem(name: "q", value: city),
            URLQueryItem(name: "appid", value: weatherApiID),
            URLQueryItem(name: "units", value: "metric")
        ]
        
        guard let url = components?.url else {
            print("Invalid URL")
            completion(.failure(NSError(domain: "Invalid URL", code: 0, userInfo: nil)))
            return
        }
        
        fetchData(url: url.absoluteString, completion: completion)
    }

    func fetchForecast(city: String, completion: @escaping (Result<[ForecastData], Error>) -> Void) {
        
        var components = URLComponents(string: forecastURL)
        components?.queryItems = [
            URLQueryItem(name: "q", value: city),
            URLQueryItem(name: "appid", value: weatherApiID),
            URLQueryItem(name: "units", value: "metric")
        ]
        
        guard let url = components?.url else {
            print("Invalid URL")
            completion(.failure(NSError(domain: "Invalid URL", code: 0, userInfo: nil)))
            return
        }
        
        fetchData(url: url.absoluteString) { (result: Result<ForecastResponse, Error>) in
            switch result {
            case .success(let forecastResponse):
                var uniqueDates: [String] = []
                let forecastsByDate = forecastResponse.list.filter { forecast in
                    let date = String(forecast.dt_txt.prefix(10))
                    if !uniqueDates.contains(date) && uniqueDates.count < 5 {
                        uniqueDates.append(date)
                        return true
                    }
                    return false
                }
                completion(.success(forecastsByDate))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
