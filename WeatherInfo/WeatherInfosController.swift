//
//  WeatherInfosController.swift
//  WeatherInfo
//
//  Created by Shubham Daramwar on 20/03/19.
//  Copyright © 2019 Shubham Daramwar. All rights reserved.
//

import UIKit
import CoreLocation
class WeatherInfosController: UITableViewController, CLLocationManagerDelegate {

    var cellReuseId : String{
        return "cellreuseid"
    }
    var weatherInfos = [WeatherInfo]()
    let locationManager = CLLocationManager.init()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        self.tableView.register(UINib.init(nibName: String(describing: WeatherTableCellTableViewCell.self), bundle: nil), forCellReuseIdentifier: self.cellReuseId)
        
        self.startLocationUpdating()
        self.tableView.estimatedRowHeight = 72
    }
    
    func startLocationUpdating(){
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.weatherInfos.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: self.cellReuseId, for: indexPath) as! WeatherTableCellTableViewCell
        cell.setData(weatherInfo: self.weatherInfos[indexPath.row])
        return cell
    }
    
    //MARK:- CLLocationManagerDelegate
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first{
            self.loadWeatherInfo(location: location)
            manager.stopUpdatingLocation()
        }
        
        
    }
    
}

//MARK:- API Call
extension WeatherInfosController{
    
    func weatherUrlString(location : CLLocation) -> String{
        return "http://api.openweathermap.org/data/2.5/find?lat=\(location.coordinate.latitude)&lon=\(location.coordinate.longitude)&cnt=10&appid=4f397fe500ace4ea8700ba6f7d1be62f"
    }
    
    func loadWeatherInfo(location : CLLocation){
        URLSession.shared.dataTask(with: URL.init(string: weatherUrlString(location: location) )!) { (data, response, error) in
            
            if error != nil{
                print(error?.localizedDescription ?? "Something went wrong")
            }
            guard data != nil else{return}
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! [String : Any]
                if let list = json["list"] as? [[String : Any]]{
                    self.weatherInfos.removeAll()
                    for dic in list{
                        self.weatherInfos.append(WeatherInfo.init(dic: dic))
                    }
                }else{
                    DispatchQueue.main.async {
                        let alert = UIAlertController.init(title: "Error", message: json["message"] as? String, preferredStyle: .alert)
                        alert.addAction(UIAlertAction.init(title: "OK", style: .default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                    }
                }
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
                
            }catch{
                print("Parsing error")
            }
            }.resume()
    }
}
