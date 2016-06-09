//
//  Weather.swift
//  WeatherForeCast
//
//  Created by Linh Tran on 08/06/16.
//  Copyright © 2016 Linh Tran. All rights reserved.
//

import Foundation

class Weather {

    let dataAndTime: NSDate
    
    let city: String
    let country: String
    
    let longitude: Double
    let latitude: Double
    
    let weatherID: Int
    let mainWeather: String
    let weatherDescription: String
    let weatherIconID: String
    
    // OpenWeatherMap provides temperature in Kelvin, here we do the conversion to celsius and fahrenheit
    private let temp: Double
    var tempCelsius: Double {
        get {
            return temp - 273.15
        }
    }
    var tempFahrenheit: Double {
        get {
            return (temp - 273.15) * 1.8 + 32
        }
    }
    
    let humidity: Int
    let pressure: Int
    let cloudCover: Int
    let windSpeed: Double
    
    let windDirection: Double?
    let rainFallInLast3Hours: Double?
    
    let sunrise: NSDate
    let sunset: NSDate
    
    // when initialize the Weather class, dictionary[String: AnyObject] created by parsing JSON data 
    // from the API. The Weather class then takes the data from dictionary object 
    // to initialize its properties
    
    init(weatherData: [String: AnyObject]) {
        
        self.dataAndTime = NSDate(timeIntervalSince1970: weatherData["dt"] as! NSTimeInterval)
        
        self.city = weatherData["name"] as! String
        
        let coordDict = weatherData["coord"] as! [String:AnyObject]
        self.longitude = coordDict["lon"] as! Double
        self.latitude = coordDict["lat"] as! Double
        
        let weatherDict = weatherData["weather"]![0] as! [String: AnyObject]
        self.weatherID = weatherDict["id"] as! Int
        self.mainWeather = weatherDict["main"] as! String
        self.weatherDescription = weatherDict["description"] as! String
        self.weatherIconID = weatherDict["icon"] as! String
        
        let mainDict = weatherData["main"] as! [String: AnyObject]
        self.temp = mainDict["temp"] as! Double
        self.humidity = mainDict["humidity"] as! Int
        self.pressure = mainDict["pressure"] as! Int
        
        self.cloudCover = weatherData["clouds"]!["all"] as! Int
        
        let windDict = weatherData["wind"] as! [String: AnyObject]
        self.windSpeed = windDict["speed"] as! Double
        self.windDirection = (windDict["deg"] as! Double)
        
        if weatherData["rain"] != nil {
            let rainDict = weatherData["rain"] as! [String: AnyObject]
            self.rainFallInLast3Hours = rainDict["3h"] as? Double
        } else {
            self.rainFallInLast3Hours = nil
        }
        
        let sysDict = weatherData["sys"] as! [String: AnyObject]
        self.country = sysDict["country"] as! String
        self.sunrise = NSDate(timeIntervalSince1970: sysDict["sunrise"] as! NSTimeInterval)
        self.sunset = NSDate(timeIntervalSince1970: sysDict["sunset"] as! NSTimeInterval)
    }
    
}