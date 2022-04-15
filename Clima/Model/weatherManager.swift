//
//  SceneDelegate.swift
//  Clima
//
//  Created by WILDDREAMER on 4/4/2022.
//  Copyright © 2022 App Brewery. All rights reserved.
//

import CoreLocation

protocol WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager: WeatherManager, weatherData: WeatherModel)
    func didFailWithError(error: Error)
}

struct WeatherManager {
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?appid=6935697ae6261b5b564eadf7ff164ace&units=metric"
    var delegate: WeatherManagerDelegate?

    func fetchWeather(cityName: String){
        let city = cityName.replacingOccurrences(of: " ", with: "+")
        let urlString = "\(weatherURL)&q=\(city)"
        performRequest(urlString: urlString)
    }
    
    func fetchWeather(latitude: CLLocationDegrees, longitude: CLLocationDegrees){
        let urlString = "\(weatherURL)&lat=\(latitude)&lon=\(longitude)"
        performRequest(urlString: urlString)
    }
    
    func performRequest(urlString: String){
        //1. create a URL
        if let url = URL(string: urlString){
            
            //2. create a URLSession
            let session = URLSession(configuration: .default)
            
            //3.Give the session a task
            let task = session.dataTask(with: url) { data, response, error in
                if error != nil {
                    delegate?.didFailWithError(error: error!)
                    return
                }
                if let safeData = data {
                    if let weather = self.parseJson(safeData){
                        delegate?.didUpdateWeather(self, weatherData: weather)
                    }
                }
            }
            
            //4. Start the task
            task.resume()
        }
    }
    
    func parseJson(_ weatherData: Data) -> WeatherModel?{
        let decoder = JSONDecoder()
        do {
            let DecoderData = try decoder.decode(WeatherData.self, from: weatherData)
            let id = DecoderData.weather[0].id
            let name = DecoderData.name
            let temp = DecoderData.main.temp
            let Weather = WeatherModel(conditionID: id, cityName: name, temperature: temp)
            return Weather
        } catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
}
