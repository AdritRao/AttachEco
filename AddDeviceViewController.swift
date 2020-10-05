//
//  AddDeviceViewController.swift
//  AttachEcoApp
//
//  Created by Adrit Rao on 10/2/20.
//

import UIKit
import MapKit
import FirebaseDatabase

class AddDeviceViewController: UIViewController, CLLocationManagerDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var mapView: MKMapView!

    @IBOutlet weak var deviceName: UITextField!
    
    var locManager = CLLocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        deviceName.delegate = self
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
    }
    
    @IBAction func registerDevice(_ sender: UIButton) {
        
        locManager.requestAlwaysAuthorization()
        locManager.requestWhenInUseAuthorization()
        
        var currentLocation: CLLocation!

        if CLLocationManager.locationServicesEnabled() {
            locManager.delegate = self
            locManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locManager.startUpdatingLocation()
        }
        
        UserDefaults.standard.setValue(deviceName.text!, forKey: "deviceName")
        
        locationManager(locManager, didUpdateLocations: [])
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        print("locations = \(locValue.latitude) \(locValue.longitude)")
        
        let firebaseReference = Database.database().reference().child("App").child(deviceName.text!)
        firebaseReference.child("longitude").setValue(locValue.longitude)
        firebaseReference.child("latitude").setValue((locValue.latitude))
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2D(latitude: locValue.latitude, longitude: locValue.longitude)
        
        mapView.addAnnotation(annotation)

    }


}
