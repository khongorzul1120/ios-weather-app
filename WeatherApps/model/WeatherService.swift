//
//  WeatherService.swift
//  WeatherApps
//
//  Created by Khongorzul Odonkhuu on 9/5/21.
//

import Foundation

import CoreLocation

protocol WeatherServiceDelegate {
    func didUpdateWeather(_ weatherManager: WeatherService, weather: WeatherModel)
    func didFailWithError(error: Error)
}

struct WeatherService {
    let weatherURL = "https://api.openweathermap.org/data/2.5/forecast/daily"
    let appID = "04ae5b793376316ba8f6fb90c1dd48fb&units=metric"
    let days = "5"
    
    
    var delegate: WeatherServiceDelegate?

    
    func fetchWeather(cityName: String) {
        let urlString = "\(weatherURL)&q=\(cityName)"
        performRequest(with: urlString)
    }
    
    func fetchWeather(latitude: CLLocationDegrees, longitute: CLLocationDegrees) {
        let urlString = "\(weatherURL)?lat=\(latitude)&lon=\(longitute)&cnt=\(days)&appid=\(appID)"
        performRequest(with: urlString)
     
    }
    
    func performRequest(with urlString: String) {
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                if let safeData = data {
                   
                    if let weather = self.parseJSON(safeData) {
                        
                        self.delegate?.didUpdateWeather(self, weather: weather)
                    }
                }
            }
            task.resume()
        }
    }
    
    func parseJSON(_ weatherData: Data) -> WeatherModel? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            print(decodedData)
            let id = decodedData.list[0].weather[0].id
            let temp = decodedData.list[0].temp.day
            let name = decodedData.city.name
            let des = decodedData.list[0].weather[0].main
            let weather = WeatherModel(conditionId: id, cityName: name, temperature: temp, list: decodedData.list,des: des)
            return weather
            
        } catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
    
    
    
}
