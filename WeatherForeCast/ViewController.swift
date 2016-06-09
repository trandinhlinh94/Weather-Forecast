//
//  ViewController.swift
//  WeatherForeCast
//
//  Created by Linh Tran on 08/06/16.
//  Copyright © 2016 Linh Tran. All rights reserved.
//

import UIKit

class ViewController: UIViewController, WeatherGetterDelegate, UITextFieldDelegate {
    
    // MARK: Properties
    var weather: WeatherGetter!
    
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var weatherLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var cloudCoverlabel: UILabel!
    @IBOutlet weak var windLabel: UILabel!
    @IBOutlet weak var rainLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var getCityWeatherButton: UIButton!

    
    @IBOutlet weak var cityTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        weather = WeatherGetter(delegate: self)
        //weather.getWeatherByCity("Helsinki")
        
        cityLabel.text = "Hi, I'm Weather"
        weatherLabel.text = ""
        tempLabel.text = ""
        cloudCoverlabel.text = ""
        windLabel.text = ""
        rainLabel.text = ""
        humidityLabel.text = ""
        cityTextField.text = ""
        cityTextField.placeholder = "Enter city name"
        cityTextField.delegate = self
        cityTextField.enablesReturnKeyAutomatically = true
        getCityWeatherButton.enabled = false
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: WeatherGetterDelegate methods
    func didGetWeather(weather: Weather) {
        //print(weather.country)
        self.cityLabel.text = weather.city
        self.weatherLabel.text = weather.weatherDescription
        self.tempLabel.text = "\(Int(round(weather.tempCelsius)))°"
        self.cloudCoverlabel.text = "\(weather.cloudCover)%"
        self.windLabel.text = "\(weather.windSpeed) m/s"
        
        if weather.rainFallInLast3Hours == nil {
            self.rainLabel.text = "__"
        } else {
        self.rainLabel.text = "\(weather.rainFallInLast3Hours!) mm"
        }
        
        self.humidityLabel.text = "\(weather.humidity)%"

    }
    
    func didNotGetWeather(error: NSError) {
        
    print("didNotGetWeather error: \(error)")
    
    }
    
    // MARK BUTTON 'Get Weather' action
    @IBAction func getWeatherForCityButtonTapped(sender: AnyObject) {
        let text = cityTextField.text
        if text!.isEmpty {
            return
        } else {
            weather.getWeatherByCity(text!.urlEncoded)
        }
    }
    
    // MARK UITextFieldDelegate and its methods
    
    // Enable the "Get weather" for your city above button
    // if the city text field contains any text,
    // disable it otherwise.
    func textField(textField: UITextField,
                   shouldChangeCharactersInRange range: NSRange,
                                                 replacementString string: String) -> Bool {
        let currentText = textField.text ?? ""
        let prospectiveText = (currentText as NSString).stringByReplacingCharactersInRange(
            range,
            withString: string)
        getCityWeatherButton.enabled = prospectiveText.characters.count > 0
        print("Count: \(prospectiveText.characters.count)")
        return true
    }
    
    // Pressing the return button on the keyboard should be like
    // pressing the "Get weather" for the city above button.
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        getWeatherForCityButtonTapped(getCityWeatherButton)
        return true
    }
    
    // Tapping on the view should dismiss the keyboard.
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        view.endEditing(true)
    }
    
}

extension String {
    
    // A method for %-encoding strings containing spaces and other
    // characters that need to be converted for use in URLs.
    var urlEncoded: String {
        return self.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLUserAllowedCharacterSet())!
    }
    
}

