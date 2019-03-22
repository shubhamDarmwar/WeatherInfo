//
//  WeatherTableCellTableViewCell.swift
//  WeatherInfo
//
//  Created by Shubham Daramwar on 20/03/19.
//  Copyright © 2019 Shubham Daramwar. All rights reserved.
//

import UIKit

class WeatherTableCellTableViewCell: UITableViewCell {

    @IBOutlet weak var areaName: UILabel!
    @IBOutlet weak var temperature: UILabel!
    @IBOutlet weak var humidity: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setData(weatherInfo : WeatherInfo){
        self.areaName.text = weatherInfo.area
        if let humidity = weatherInfo.humidity{
            self.humidity.text = String(humidity)
        }else{
            self.humidity.text = "-"
        }
        if let temperature = weatherInfo.temperature{
            self.temperature.text = String(temperature)
        }else{
            self.temperature.text = "-"
        }
    }
    
}
