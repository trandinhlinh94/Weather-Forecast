//
//  WeatherGetter.swift
//  WeatherForeCast
//
//  Created by Linh Tran on 08/06/16.
//  Copyright © 2016 Linh Tran. All rights reserved.
//

import Foundation


// The delegate's didNotGetWeather method is called if either:
// - The weather was not acquired from OpenWeatherMap.org, or
// - The received weather data could not be converted from JSON into a dictionary.
protocol WeatherGetterDelegate {
    func didGetWeather(weather: Weather)
    func didNotGetWeather(error: NSError)
}

class WeatherGetter{
    
    private var delegate: WeatherGetterDelegate
    
    init(delegate: WeatherGetterDelegate) {
        self.delegate = delegate
    }
    
    private let openWeatherMapBaseURL = "http://api.openweathermap.org/data/2.5/weather"
    private let API_key = "066bc6f6c5c5a309078a248fd6b309c0"
    
//    func getWeatherByCity(city: String) {
//        let weatherRequestURL = NSURL(string: "\(openWeatherMapBaseURL)?APPID=\(API_key)&q=\(city)")!
//        getWeather(String(weatherRequestURL))
//    }
    
//    init(weather:Weather) {
//        self.weather = weather
//    }
    
    
    func getWeatherByCity(city: String) {
        
        // create a networking task with shared session
        let session = NSURLSession.sharedSession()
        
        // construct the URL to fetch data
        let weatherRequestURL = NSURL(string: "\(openWeatherMapBaseURL)?APPID=\(API_key)&q=\(city)")!
        // Getting data from API into data task
        // NSSessionDataTask is used for downloading data from sever to memory
        let dataTask = session.dataTaskWithURL(weatherRequestURL) {
            // the completion handler is executed only when the task is finished requesting and retrieving data from server
            (data: NSData?, response: NSURLResponse?, error: NSError?) in
            if let error = error {
                // case 1: error
                // throw error message when trying to get data from server 
                print("Error:\n\(error)")
            } else {
                // case 2: success
                // server sends the response
                // print("Raw data:\n\(data!)\n")
                //let dataString = String(data: data!, encoding: NSUTF8StringEncoding)
                //print("Human-readable data:\n\(dataString!)")
                
                // convert JSON data into Swift objects (dictionaries) using NSJSONSerialization and JSONObjectWithData
                do {
                    let weatherData = try NSJSONSerialization.JSONObjectWithData(data!, options: .MutableContainers) as! [String: AnyObject]
                    
                    // try to print some content
/*
                    print("Date and time: \(weather["dt"]!)")
                    print("City: \(weather["name"]!)")
                    
                    print("Longitude: \(weather["coord"]!["lon"]!!)")
                    print("Latitude: \(weather["coord"]!["lat"]!!)")
                    
                    print("Weather ID: \(weather["weather"]![0]!["id"]!!)")
                    print("Weather main: \(weather["weather"]![0]!["main"]!!)")
                    print("Weather description: \(weather["weather"]![0]!["description"]!!)")
                    print("Weather icon ID: \(weather["weather"]![0]!["icon"]!!)")
                    
                    print("Temperature: \(weather["main"]!["temp"]!!)")
                    print("Humidity: \(weather["main"]!["humidity"]!!)")
                    print("Pressure: \(weather["main"]!["pressure"]!!)")
                    
                    print("Cloud cover: \(weather["clouds"]!["all"]!!)")
                    
                    print("Wind direction: \(weather["wind"]!["deg"]!!) degrees")
                    print("Wind speed: \(weather["wind"]!["speed"]!!)")
                    
                    print("Country: \(weather["sys"]!["country"]!!)")
                    print("Sunrise: \(weather["sys"]!["sunrise"]!!)")
                    print("Sunset: \(weather["sys"]!["sunset"]!!)")
 */
                    // create weather instance variable from the dictionary
                    let weather = Weather(weatherData: weatherData)
                    
                    // notify changes to the delagte 
                    self.delegate.didGetWeather(weather)
                    
                } catch let jsonError as NSError {
                    // throw error if convertion process encounters error
                    //print("JSON error description: \(jsonError.description)")
                    self.delegate.didNotGetWeather(jsonError)

                }
            }
        }
        // The task is ready. fire it up
        dataTask.resume()
    }
}