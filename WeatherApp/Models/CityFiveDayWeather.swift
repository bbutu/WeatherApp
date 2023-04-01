//
//  CityFiveDayWeather.swift
//  WeatherApp
//
//  Created by Beka Buturishvili on 29.03.23.
//

import Foundation

struct CityFiveDayWeather: Codable, Hashable {
    var list: [CityThreeHourlyWeather]?
    
    struct CityThreeHourlyWeather: Codable, Hashable {
        var main: Main
        let weather: [Weather]
        var clouds: Clouds
        var wind: Wind
        var sys: Sys?
        let dt_txt: String
    }

    struct Weather: Codable, Hashable {
        let id: Int?
        let main: String?
        let description: String?
        let icon: String
    }

    struct Sys: Codable, Hashable {
        let type: Int?
        let id: Double?
        let country: String?
        let sunrise: Double?
        let sunset: Double?
    }

    struct Clouds: Codable , Hashable{
        let all: Double
    }

    struct Main: Codable, Hashable {
        let temp: Double
        let feels_like: Double?
        let temp_min: Double?
        let temp_max: Double?
        let pressure: Double
        let humidity: Double
        let sea_level: Double?
        let grnd_level: Double?
    }

    struct Wind: Codable, Hashable {
        let deg: Double
        let speed: Double
    }

}
