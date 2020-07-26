//
//  MapViewController.swift
//  LandmarkRemark
//
//  Created by Moin Uddin on 24/7/20.
//  Copyright © 2020 Moin Uddin. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class MapViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    
    var locationVM: LocationViewModel!
    
    var myLocationMarker: MKPointAnnotation?
    
    var locationManager: CLLocationManager?
    
    deinit {
        print("=====================")
        print("\(String(describing: type(of: self))) is being deinitialised. That means no memory leak in this vc")
        print("=====================")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        
        let locationManager = LRLocationManager()
        self.locationVM = LocationViewModel(locationManager: locationManager)
        /*
        DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
            let vc = UIViewController()
            vc.view.backgroundColor = .red
            UIApplication.shared.keyWindow?.rootViewController = vc
        }*/
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if !self.locationVM.locationManager.locationManagerAvailable || self.locationVM.locationManager.permissionDenied{
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.requestLocationAuthorisation()
            }
        }else if self.locationVM.state == .notStarted{
            self.startLocationUpdates()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.locationVM.stopLocationManager()
    }
}

extension MapViewController{
    
    func requestLocationAuthorisation(){
        if CLLocationManager.authorizationStatus() == .notDetermined{
            if(locationManager == nil){
                locationManager = CLLocationManager()
                locationManager?.delegate = self
            }
            locationManager?.requestWhenInUseAuthorization()
        }else if CLLocationManager.authorizationStatus() == .denied || CLLocationManager.authorizationStatus() == .restricted{
            let alert = UIAlertController(title: "Error", message: "Location permission is required to show your current location on the map. You can authorise location from Settings.", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: { _ in
                // do nothing
            }))
            
            alert.addAction(UIAlertAction(title: "Settings", style: UIAlertAction.Style.default, handler: { _ in
                if UIApplication.shared.canOpenURL(URL(string: UIApplication.openSettingsURLString)!){
                    UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!, options: [:])
                }
            }))
            
            self.present(alert, animated: true)
        }
    }
    
    func startLocationUpdates(){
        self.locationVM.startLocationManager{ _, error in
            DispatchQueue.main.async {
                if let error = error{
                    let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                    self.present(alert, animated: true)
                }else{
                    self.updateUserMarkerLocation()
                    // As we need user/device location once to display on map, we should stop locationManager.
                    // Otherwise, the marker will keep updating user's location whenever changes
                    self.locationVM.stopLocationManager()
                }
            }
        }
    }
    
    func updateUserMarkerLocation(){
        if self.myLocationMarker == nil{
            self.myLocationMarker = MKPointAnnotation()
            self.myLocationMarker?.title = "MyMarker"
            self.mapView.addAnnotation(self.myLocationMarker!)
        }
        
        if let currentLocation = self.locationVM.currentLocation?.coordinate{
            self.myLocationMarker?.coordinate = currentLocation
            
            let region = MKCoordinateRegion(center: currentLocation, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
            self.mapView.setRegion(region, animated: true)
        }
    }
}

extension MapViewController: MKMapViewDelegate{
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        print(view.description)
    }
}

extension MapViewController: CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if [CLAuthorizationStatus.authorizedAlways, CLAuthorizationStatus.authorizedWhenInUse].contains(status){
            self.startLocationUpdates()
        }else{
            // If the location permission is denied or restricted, the app will keep asking for location permission.
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.requestLocationAuthorisation()
            }
        }
    }
}

