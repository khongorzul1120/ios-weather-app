//
//  WeatherData.swift
//  WeatherApps
//
//  Created by Khongorzul Odonkhuu on 9/5/21.
//

import Foundation


struct WeatherData: Codable {
    let city: City
    let list: [List]
}

struct List: Codable {
    let temp: Temp
    let weather: [Weather]
    let dt: Int
}

struct City: Codable {
    let name: String
}


struct Weather: Codable {
    let main: String
    let id: Int
}

struct Temp: Codable {
    let day: Double
    let night: Double
}
