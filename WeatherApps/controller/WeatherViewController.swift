//
//  ViewController.swift
//  WeatherApps
//
//  Created by Khongorzul Odonkhuu on 8/30/21.
//

import UIKit
import Foundation
import CoreLocation

class WeatherViewController: UIViewController {
    @IBOutlet weak var cityName: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var desLabel: UILabel!
    @IBOutlet weak var conditionImageView: UIImageView!
    var dateCustom : NSDate =  NSDate()
    
    var weatherDaysList = [List]()
    var weatherService = WeatherService()
    let locationManager = CLLocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        weatherService.delegate = self
        tableView.dataSource = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        
        tableView.register(UINib(nibName: "WeatherCell", bundle:nil),forCellReuseIdentifier:"ResuebleCell")
        DispatchQueue.main.async {
            self.loading()
        }
       
    }

    @IBAction func locationPressed(_ sender: UIButton) {
        DispatchQueue.main.async {
            self.loading()
        }
        locationManager.requestLocation()
    }
    let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
    let alert = UIAlertController(title: nil, message: "Please wait...", preferredStyle: .alert)
    
    func loading() {
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.style = UIActivityIndicatorView.Style.gray
        loadingIndicator.startAnimating()
        alert.view.addSubview(loadingIndicator)

        present(alert, animated: true, completion: nil)
      
    }
    
}

extension WeatherViewController: WeatherServiceDelegate {
    
    func didUpdateWeather(_ weatherManager: WeatherService, weather: WeatherModel) {
        self.weatherDaysList = []
        DispatchQueue.main.async {
            self.temperatureLabel.text =  weather.temperatureString + "°C"
            self.conditionImageView.image = UIImage(systemName: weather.conditionName)
            self.cityName.text = weather.cityName
            self.desLabel.text = weather.des
            
            for day in weather.list {
                let days = List(temp: day.temp, weather: day.weather, dt: day.dt)
                self.weatherDaysList.append(days)
                print(self.weatherDaysList.count)
            }
            self.tableView.reloadData()
            self.loadingIndicator.stopAnimating();
            self.alert.dismiss(animated: true, completion: nil)
            
        }
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
}

//MARK: - CLLocationManagerDelegate
extension WeatherViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
            weatherService.fetchWeather(latitude: lat, longitute:lon)
        }
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error")
    }
}


extension WeatherViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.weatherDaysList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        let cell = tableView.dequeueReusableCell(withIdentifier: "ResuebleCell", for: indexPath) as! WeatherCell
        if weatherDaysList.count > 0 && indexPath.row < weatherDaysList.count {

            let message = weatherDaysList[indexPath.row]
            
            cell.dayLabel?.textColor = UIColor.white
            cell.backgroundColor = .clear
            dateCustom = NSDate(timeIntervalSince1970: TimeInterval(message.dt ))
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            let myStringafd = formatter.string(from: dateCustom as Date)
            let day = getDayOfWeekString(today: myStringafd)
            cell.dayLabel.text = String(day!)
            let contidionImage = conditionName(conditionId: message.weather[0].id)
            cell.conditionImage.tintColor = UIColor.white
            cell.conditionImage.image = UIImage(systemName:contidionImage)
            
            cell.temLabel.textColor = UIColor.white
            cell.temLabel.text =  String(format: "%.0f", message.temp.day) + "°C" + " " + "/" + " " + String(format: "%.0f", message.temp.night) + "°C"

        }
       
        
        return cell
    }
    
    func conditionName(conditionId: Int) -> String {
        switch conditionId {
        case 200...232:
            return "cloud.bolt"
        case 300...321:
            return "cloud.drizzle"
        case 500...531:
            return "cloud.rain"
        case 600...622:
            return "cloud.snow"
        case 701...781:
            return "cloud.fog"
        case 800:
            return "sun.max"
        case 801...804:
            return "cloud.fill"
        default:
            return "cloud"
        }
    }
    
    
    func getDayOfWeekString(today:String)->String? {
        let formatter  = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        if let todayDate = formatter.date(from: today) {
            let myCalendar = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)!
            let myComponents = myCalendar.components(.weekday, from: todayDate)
            let weekDay = myComponents.weekday
            switch weekDay {
            case 1:
                return "Sunday"
            case 2:
                return "Monday"
            case 3:
                return "Tuesday"
            case 4:
                return "Wednesday"
            case 5:
                return "Thursday"
            case 6:
                return "Friday"
            case 7:
                return "Saturday"
            default:
                print("Error fetching days")
                return "Day"
            }
        } else {
            return nil
        }
    }
    
}



