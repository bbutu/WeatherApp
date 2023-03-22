//
//  APICaller.swift
//  WeatherApp
//
//  Created by Beka Buturishvili on 04.03.23.
//

import Foundation

struct Constants {
    static let API_KEY = "b143f6b270fb4a88ec4ae9405f3454e4"
    static let baseURL = "https://api.openweathermap.org"
    static let imagePathLeft = "https://openweathermap.org/img/wn/"
    static let imagePathRight = "@2x.png"
}

enum APIError: Error {
    case failedToGetData
}

class APICaller {
    static let shared = APICaller()
    
    func getCurrentWeather(latitude: String,longitude: String,completion: @escaping (Result<City, Error>) -> Void) {
        guard let url = URL(string: "\(Constants.baseURL)/data/2.5/weather?lat=\(latitude)&lon=\(longitude)&appid=\(Constants.API_KEY)") else{return}
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            guard let data = data, error == nil else{
                return
            }
            do {
                let result = try JSONDecoder().decode(City.self,from: data)
                completion(.success(result)) 
            } catch {
                completion(.failure(error))
            }
        }
        task.resume() 
    }
    
    func getFiveDaysWeather(latitude: String,longitude: String,completion: @escaping (Result<City, Error>) -> Void) {
        guard let url = URL(string: "\(Constants.baseURL)/data/2.5/forecast?lat=\(latitude)&lon=\(longitude)&appid=\(Constants.API_KEY)") else{return}
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            guard let data = data, error == nil else{
                return
            }
            do {
                let result = try JSONDecoder().decode(City.self,from: data)
                completion(.success(result))
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
    
    func getCityWith(cityName: String,completion: @escaping (Result<City, Error>) -> Void) {
        guard let url = URL(string: "\(Constants.baseURL)/data/2.5/weather?q=\(cityName)&appid=\(Constants.API_KEY)") else{return}
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            guard let data = data, error == nil else{
                return
            }
            do {
                let result = try JSONDecoder().decode(City.self,from: data)
                completion(.success(result))
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
    
    func getWeatherIconUrl(with iconName: String) -> String {
        return Constants.imagePathLeft + iconName + Constants.imagePathRight
    }
    
}
