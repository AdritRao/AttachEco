//
//  DetailsViewController.swift
//  AttachEcoApp
//
//  Created by Adrit Rao on 10/3/20.
//

import UIKit
import FirebaseDatabase
import MapKit

class DetailsViewController: UIViewController, MKMapViewDelegate {
    
    var titleToUse = String()
    
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    var latitude = CLLocationDegrees()
    var longitude = CLLocationDegrees()
    
    // Value Labels
    
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var humLabel: UILabel!
    @IBOutlet weak var gasLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        
        let firebaseReference = Database.database().reference().child("App").child(titleToUse)
        firebaseReference.child("temp").observe(.value) { (snapshot) in
            self.tempLabel.text = "Temperature: \(snapshot.value ?? 0) °F"
        }
        firebaseReference.child("hum").observe(.value) { (snapshot) in
            self.humLabel.text = "Humidity: \(snapshot.value ?? 0) %"
        }
        firebaseReference.child("gas").observe(.value) { (snapshot) in
            self.gasLabel.text = "Carbon dioxide: \(snapshot.value ?? 0) ppm"
        }
        
        firebaseReference.child("latitude").observe(.value) { (snapshot) in
            self.latitude = snapshot.value as! CLLocationDegrees ?? 0
        }
        firebaseReference.child("longitude").observe(.value) { (snapshot) in
            self.longitude = snapshot.value as! CLLocationDegrees ?? 0
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
  
        let annotation = MKPointAnnotation()
            annotation.coordinate = CLLocationCoordinate2D(latitude: self.latitude, longitude: self.longitude)
            self.mapView.addAnnotation(annotation)
            
        }
        
        titleLabel.text = titleToUse

        print(titleToUse)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {

        let annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: "pin")


            annotationView.markerTintColor = UIColor(red: 0.28, green: 0.58, blue: 0.38, alpha: 1.00)


        return annotationView
    }
    
    @IBAction func dataButtonTapped(_ sender: UIButton) {
        UserDefaults.standard.setValue(titleLabel.text, forKey: "title")
    }
    


}
