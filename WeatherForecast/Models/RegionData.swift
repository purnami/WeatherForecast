//
//  RegionData.swift
//  WeatherForecast
//
//  Created by purnami indryaswari on 03/12/24.
//

import Foundation

struct Province: Codable, Identifiable {
    let id: String
    let name: String
}

struct Regency: Codable, Identifiable {
    let id: String
    let provinceId: String
    let name: String

    enum CodingKeys: String, CodingKey {
        case id
        case provinceId = "province_id"
        case name
    }
}

struct District: Codable, Identifiable {
    let id: String
    let regencyId: String
    let name: String

    enum CodingKeys: String, CodingKey {
        case id
        case regencyId = "regency_id"
        case name
    }
}
