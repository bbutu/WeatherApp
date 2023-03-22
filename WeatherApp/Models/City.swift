//
//  City.swift
//  WeatherApp
//
//  Created by Beka Buturishvili on 04.03.23.
//

import Foundation

struct City: Codable {
    var weather: [Weather]
    var main: Main
    var clouds: Clouds
    var wind: Wind
    var sys: Sys
    let name: String
    
    struct Weather: Codable {
        let id: Int?
        let main: String?
        let description: String?
        let icon: String
    }
    
    struct Sys: Codable {
        let type: Int
        let id: Double
        let country: String
        let sunrise: Double?
        let sunset: Double?
    }

    struct Clouds: Codable {
        let all: Double
    }

    struct Main: Codable {
        let temp: Double
        let feels_like: Double?
        let temp_min: Double?
        let temp_max: Double?
        let pressure: Double
        let humidity: Double
        let sea_level: Double?
        let grnd_level: Double?
    }

    struct Wind: Codable {
        let deg: Double
        let speed: Double
    }

}

