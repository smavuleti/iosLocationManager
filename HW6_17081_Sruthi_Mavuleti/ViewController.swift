//
//  ViewController.swift
//  HW6_17081_Sruthi_Mavuleti
//
//  Created by Sruthi Mavuleti on 6/21/16.
//  Copyright © 2016 Sruthi Mavuleti. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {
    
    
    //display labels:
    
    
    @IBOutlet var latitudeLabel: UILabel!
    @IBOutlet var longitudeLabel: UILabel!
    @IBOutlet var horizontalAccuracyLabel: UILabel!
    @IBOutlet var altitudeLabel: UILabel!
    @IBOutlet var verticalAccuracyLabel: UILabel!
    @IBOutlet var distanceTraveled: UILabel!
    
    
    private let locationManager = CLLocationManager()
    private var previousPoint:CLLocation?
    private var totalMovementDistance:CLLocationDistance = 0
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        locationManager.delegate = self //refering to the controller class
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization() //don't need requestAlwaysAuthorization()
    }
    
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus){
        print("Authorization status changed to \(status.rawValue)")
        switch status {
        case .Authorized, .AuthorizedWhenInUse:
            locationManager.startUpdatingLocation()
        default :
            locationManager.stopUpdatingLocation()
        }
    }
    
    //error handling
    func locationManager(manager:CLLocationManager, didFailWithError error: NSError){
        let errorType = error.code == CLError.Denied.rawValue ? "Access Denied" : "Error \(error.code)"
        let alertController = UIAlertController(title: "Location Manager Error",message:errorType,
                                                preferredStyle: .Alert)
        let okAction = UIAlertAction(title:"OK",style: .Cancel, handler: {action in})
        alertController.addAction(okAction)
        presentViewController(alertController, animated: true,completion: nil)
    }
    
    
    //update location
    
    
    
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]){
        let newLocation = (locations as [CLLocation]) [locations.count - 1]
        
        let latitudeString = String(format: "%g\u{00B0}",newLocation.coordinate.latitude)
        latitudeLabel.text = latitudeString
        
        let longitudeString = String(format: "%g\u{00B0}", newLocation.coordinate.longitude)
        longitudeLabel.text = longitudeString
        
        let horizontalAccuracyString = String(format: "%gm", newLocation.horizontalAccuracy)
        horizontalAccuracyLabel.text = horizontalAccuracyString
        
        let altitudeString = String(format:"%gm", newLocation.altitude)
        altitudeLabel.text = altitudeString
        
        let verticalAccuracyString = String(format:"%gm", newLocation.verticalAccuracy)
        verticalAccuracyLabel.text = verticalAccuracyString
        
        
        if newLocation.horizontalAccuracy < 0 {
            //invalid accuracy
            return
        }
        
        if newLocation.horizontalAccuracy > 100 || newLocation.verticalAccuracy > 50 {
            //accuracy radius is so large, it's not accurate enough. We can't use it
            return
        }
        
        if previousPoint == nil{
            totalMovementDistance = 0
        } else {
            print("movement distance:\(newLocation.distanceFromLocation(previousPoint!))")
            totalMovementDistance += newLocation.distanceFromLocation(previousPoint!)
        }
        
        previousPoint = newLocation
        
        let distanceString = String(format:"%gm", totalMovementDistance)
        distanceTraveled.text = distanceString
        
    }
    
    


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

