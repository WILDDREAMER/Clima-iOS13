//
//  WeatherData.swift
//  Clima
//
//  Created by WILDDREAMER on 5/4/2022.
//  Copyright © 2022 App Brewery. All rights reserved.
//

import Foundation

struct WeatherData: Decodable{
    let name: String
    let weather: [Weather]
    let main: Main 
}

struct Weather: Decodable {
    let id: Int
}

struct Main: Decodable {
    let temp: Double
}
