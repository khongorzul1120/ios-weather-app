//
//  ViewController.swift
//  WeatherApps
//
//  Created by Khongorzul Odonkhuu on 8/30/21.
//

import UIKit
import CoreLocation

class WeatherViewController: UIViewController {
    
    let locationManager = CLLocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
    }


}

