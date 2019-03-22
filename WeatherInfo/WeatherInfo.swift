//
//  WeatherInfo.swift
//  WeatherInfo
//
//  Created by Shubham Daramwar on 20/03/19.
//  Copyright © 2019 Shubham Daramwar. All rights reserved.
//

import Foundation
struct WeatherInfo {
    var area : String
    var humidity : Double?
    var temperature : Double?
    init(area : String, humidity : Double?, temperature : Double?) {
        self.area = area
        self.humidity = humidity
        self.temperature = temperature
    }
    
    init(dic : [String : Any]) {
        self.area = dic["name"] as? String ?? ""
        guard let main = dic["main"] as? [String : Any] else {return}
        if let temp = main["temp"] as? Double{
            self.temperature = temp
        }
        if let humidity = main["humidity"] as? Double{
            self.humidity = humidity
        }
    }
}
