//
//  ViewController.swift
//  WeatherManIO
//
//  Created by scott harris on 11/6/14.
//  Copyright (c) 2014 scott harris. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIGestureRecognizerDelegate, UIAlertViewDelegate {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var iconView: UIImageView!
    @IBOutlet weak var currentTimeLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var precipitationLabel: UILabel!
    @IBOutlet weak var summaryLabel: UILabel!
    
//    let refreshControlRecognizer = UISwipeGestureRecognizer()
    
    
    private let apiKey = ""
    
    let app = UIApplication.sharedApplication()
    let refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        app.statusBarStyle = UIStatusBarStyle.LightContent
        
        self.scrollView.alwaysBounceVertical = true

        let font = UIFont.boldSystemFontOfSize(18)
        
        let title = NSAttributedString(string: "Loading..", attributes: [NSFontAttributeName: font, NSForegroundColorAttributeName: UIColor.whiteColor(), NSStrokeColorAttributeName: UIColor.whiteColor()])
        
        
        refreshControl.backgroundColor = UIColor.grayColor()
        refreshControl.tintColor = UIColor.whiteColor()
        refreshControl.attributedTitle = title
        refreshControl.selected = true

        refreshControl.addTarget(self, action: "showAlert", forControlEvents: UIControlEvents.ValueChanged)
        
        self.scrollView.addSubview(refreshControl)
        
        
        
        
        
//        self.view.addSubview(scrollView)
//        self.view.userInteractionEnabled = true
    
        getCurrentWeatherData()
        
        
    }
    
    func showAlert() {
        //let app = UIApplication.sharedApplication()
        if (refreshControl.refreshing) {
            refreshControl.selected = true
        }
        let alertView = UIAlertView(title: "Bout Fucking Time!!", message: "Finally You Shit HEAD.. you did something right", delegate: self, cancelButtonTitle: "OK", otherButtonTitles:"Great")
        alertView.show()
        
    }
    
    
    func getCurrentWeatherData() -> Void {
        let baseURL = NSURL(string: "https://api.forecast.io/forecast/\(apiKey)/")
        let forecastURL = NSURL(string: "40.757656,-73.975690", relativeToURL: baseURL)
        
        let sharedSession = NSURLSession.sharedSession()
        let downloadTask: NSURLSessionDownloadTask = sharedSession.downloadTaskWithURL(forecastURL!, completionHandler: { (location: NSURL!, response: NSURLResponse!, error: NSError!) -> Void in
            
            if (error == nil) {
                let dataObject = NSData(contentsOfURL: location)
                let weatherDictionary: NSDictionary = NSJSONSerialization.JSONObjectWithData(dataObject!, options: nil, error: nil) as! NSDictionary
                
                let currentWeather = Current(weatherDictionary: weatherDictionary)
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.temperatureLabel.text = "\(currentWeather.temperature)"
                    self.iconView.image = currentWeather.icon!
                    self.currentTimeLabel.text = "At \(currentWeather.currentTime!) It Is"
                    self.humidityLabel.text = "\(currentWeather.humidity)"
                    self.precipitationLabel.text = "\(currentWeather.precipProbability)"
                    self.summaryLabel.text = "\(currentWeather.summary)"
                    
                    // Stop refresh animation
//                    self.refreshActivityIndicator.stopAnimating()
//                    self.refreshActivityIndicator.hidden = true
//                    self.refreshButton.hidden = false
                    
                })
                
            } else {
                let networkIssueController = UIAlertController(title: "Error", message: "Unable to load data. Connectivity Error!", preferredStyle: .Alert)
                
                let okButtton = UIAlertAction(title: "Ok", style: .Default, handler: nil)
                networkIssueController.addAction(okButtton)
                
                let cancelButton = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
                networkIssueController.addAction(cancelButton)
                
                self.presentViewController(networkIssueController, animated: true, completion: nil)
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    // Stop refresh animation
//                    self.refreshActivityIndicator.stopAnimating()
//                    self.refreshActivityIndicator.hidden = true
//                    self.refreshButton.hidden = false
                })
                
            }
            
        })
        
        
        downloadTask.resume()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

