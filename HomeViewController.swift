//
//  HomeViewController.swift
//  AttachEcoApp
//
//  Created by Adrit Rao on 10/2/20.
//

import UIKit
import MapKit
import FirebaseDatabase

class HomeViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    
    var timer = Timer()
    var titleToUse = String()
    
    var locManager = CLLocationManager()
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var getDataButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        
        getDataButton.layer.cornerRadius = 12
        locManager.requestAlwaysAuthorization()
        locManager.requestWhenInUseAuthorization()
        scheduledTimerWithTimeInterval()
    }
    
    func scheduledTimerWithTimeInterval(){
        // Scheduling timer to Call the function "updateCounting" with the interval of 1 seconds
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.updateCounting), userInfo: nil, repeats: true)
    }
    
    @objc func updateCounting(){
        
        guard let deviceName = UserDefaults.standard.string(forKey: "deviceName") else { return }
        
        let firebaseForAll = Database.database().reference().child("App")
        
        var currentLocation: CLLocation!

        if CLLocationManager.locationServicesEnabled() {
            locManager.delegate = self
            locManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locManager.startUpdatingLocation()
        }
        
        locationManager(locManager, didUpdateLocations: [])
        
//        let firebaseReference = Database.database().reference().child("App").child(deviceName)
        
        firebaseForAll.observeSingleEvent(of: .value, with: { snapshot in
                    for child in snapshot.children {
                        let snap = child as! DataSnapshot
                        let placeDict = snap.value as! [String: Any]
                        
                        let annotation = MKPointAnnotation()
                        annotation.coordinate = CLLocationCoordinate2D(latitude: placeDict["latitude"] as! CLLocationDegrees, longitude: placeDict["longitude"] as! CLLocationDegrees)
                        annotation.title = snap.key
                        firebaseForAll.child("temp").observe(.value) { (snapshot) in
                            annotation.subtitle = String(placeDict["temp"] as? Float ?? 0.0)
                        }
             
                        self.mapView.addAnnotation(annotation)
                    }
        })
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
//        print("locations = \(locValue.latitude) \(locValue.longitude)")
//
//        guard let deviceName = UserDefaults.standard.string(forKey: "deviceName") else { return }
//
//        let firebaseReference = Database.database().reference().child("App").child(deviceName)
//
//        firebaseReference.child("longitude").setValue(locValue.longitude)
//        firebaseReference.child("latitude").setValue((locValue.latitude))
//
//        let annotation = MKPointAnnotation()
//        annotation.coordinate = CLLocationCoordinate2D(latitude: locValue.latitude, longitude: locValue.longitude)
//
//        mapView.addAnnotation(annotation)

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetailsViewController" {
        let detailsViewController = segue.destination as! DetailsViewController
        detailsViewController.titleToUse = titleToUse
        } else {  }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView?
        {
            let annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: "annotationView")
            annotationView.canShowCallout = true
        annotationView.rightCalloutAccessoryView = UIButton.init(type: UIButton.ButtonType.detailDisclosure)
        annotationView.rightCalloutAccessoryView?.tintColor = UIColor.black
        annotationView.markerTintColor = UIColor(red: 0.28, green: 0.58, blue: 0.38, alpha: 1.00)
            return annotationView
        }

        func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl)
        {
            guard let annotation = view.annotation else
            {
                return
            }

            let urlString = "http://maps.apple.com/?sll=\(annotation.coordinate.latitude),\(annotation.coordinate.longitude)"
            guard let url = URL(string: urlString) else
            {
                return
            }
            
            titleToUse = (annotation.title ?? "") ?? ""
            self.performSegue(withIdentifier: "toDetailsViewController", sender: nil)
            
        }
    
    @IBAction func getDataButtonTapped(_ sender: UIButton) {
        guard let deviceName = UserDefaults.standard.string(forKey: "deviceName") else { return }
        
        let date = Date()
        let formatter = DateFormatter()
        
        formatter.dateFormat = "dd MMM"
        
        let result = formatter.string(from: date)
        
        
        let firebaseForAll = Database.database().reference().child("App").child(deviceName)
        let firebaseReference = Database.database().reference().child(deviceName)
        firebaseReference.child("temp").observe(.value) { (snapshot) in
            firebaseForAll.child("temp").setValue(snapshot.value)
            firebaseForAll.child("data").child(String(result)).child("temp").setValue(snapshot.value)
        }
        firebaseReference.child("gas").observe(.value) { (snapshot) in
            firebaseForAll.child("gas").setValue(snapshot.value)
            firebaseForAll.child("data").child(String(result)).child("gas").setValue(snapshot.value)
        }
        firebaseReference.child("hum").observe(.value) { (snapshot) in
            firebaseForAll.child("hum").setValue(snapshot.value)
            firebaseForAll.child("data").child(String(result)).child("hum").setValue(snapshot.value)
        }
        
        
        
        
        return
    }

}
