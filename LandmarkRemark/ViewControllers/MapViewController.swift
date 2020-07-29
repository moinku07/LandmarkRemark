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
import FirebaseFirestore
import CoreTelephony

class MapViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var locationManager: CLLocationManager?
    
    var locationVM: LocationViewModel!
    var userVM: UserViewModel?
    var noteVM: NoteViewModel?
    
    var noteText: String?
    
    var annotations: [MKAnnotation] = [MKAnnotation]()
    
    deinit {
        print("=====================")
        print("\(String(describing: type(of: self))) is being deinitialised. That means no memory leak in this vc")
        print("=====================")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.accessibilityIdentifier = "SearchBar"
        searchBar.delegate = self
        
        mapView.delegate = self
        mapView.showsUserLocation = true
        
        let locationManager = LRLocationManager()
        self.locationVM = LocationViewModel(locationManager: locationManager)
        
        userVM = UserViewModel(service: UserService())
        userVM?.firstName = "John"
        userVM?.lastName = "Smith"
        userVM?.userName = "johnsmith"
        
        userVM?.createUser(completion: { [unowned self] (user, error) in
            if let error = error{
                print("User get/create error = \(error.localizedDescription)")
                
                self.showAlert(title: "Error", message: error.localizedDescription, buttons: ["Okay"])
                return
            }
            // we have got our logged in user
        })
        
        noteVM = NoteViewModel(service: NoteService())
        
        /*
        DispatchQueue.main.asyncAfter(deadline: .now() + 60) {
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
        
        loadNotes()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.locationVM.stopLocationManager()
        
        self.noteVM?.removeGetNoteSubscription()
    }
    
    // method to present an alert
    func showAlert(title: String, message: String, buttons: [String]){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        buttons.forEach{
            alert.addAction(UIAlertAction(title: $0, style: UIAlertAction.Style.default, handler: nil))
        }
        self.present(alert, animated: true)
    }
}

extension MapViewController{
    // load notes from firestore using the note service
    func loadNotes(){
        if Reachability.shared.isConnectedToNetwork{
            noteVM?.getNotes(forUser: nil, completion: {[unowned self] notes, error in
                DispatchQueue.main.async {
                    if let error = error{
                        self.showAlert(title: "Error", message: error.localizedDescription, buttons: ["Okay"])
                    }else if let notes = notes{
                        self.setAnnotations(fromNotes: notes)
                    }
                }
            })
        }else{
            DispatchQueue.main.async {
                self.showAlert(title: "Warning", message: "Device is currently offline. Please check device internet connection.", buttons: ["Okay"])
            }
        }
    }
    
    // set annotations on the map from the notes
    func setAnnotations(fromNotes notes: [Notes]){
        self.mapView.removeAnnotations(self.annotations)
        self.annotations.removeAll()
        
        var wasAnnotationSelected: Bool = false
        
        notes.forEach{
            let annotation = MKPointAnnotation()
            annotation.coordinate = CLLocationCoordinate2D(latitude: $0.geo!.latitude, longitude: $0.geo!.longitude)
            annotation.subtitle = $0.note
            
            Firestore.firestore().collection("users").whereField("userName", isEqualTo: $0.userName).getDocuments { documentSnapshot, error in
                if let error = error{
                    self.showAlert(title: "Error", message: error.localizedDescription, buttons: ["Okay"])
                }else if let data = documentSnapshot?.documents.first?.data(){
                    annotation.title = try? User(dictionary: data).userName
                }
            }
            self.annotations.append(annotation)
            self.mapView.addAnnotation(annotation)
            
            if annotation.subtitle == self.noteText{
                self.mapView.selectAnnotation(annotation, animated: true)
                wasAnnotationSelected = true
            }
        }
        
        self.mapView.showAnnotations(self.mapView.annotations, animated: true)
        
        if !wasAnnotationSelected && self.annotations.count > 0{
            self.mapView.selectAnnotation(self.annotations.last!, animated: true)
        }
    }
}

extension MapViewController{
    // handles the location authorisation, show appropriate prompt or starts location updates if authorisation given already
    func requestLocationAuthorisation(){
        if CLLocationManager.authorizationStatus() == .notDetermined{
            if(locationManager == nil){
                locationManager = CLLocationManager()
                locationManager?.delegate = self
            }
            locationManager?.requestWhenInUseAuthorization()
        }else if CLLocationManager.authorizationStatus() == .denied || CLLocationManager.authorizationStatus() == .restricted{
            let alert = UIAlertController(title: "Error", message: "Location permission is required to show your current location on the map. You can authorise location from Settings.", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))
            
            alert.addAction(UIAlertAction(title: "Settings", style: UIAlertAction.Style.default, handler: { _ in
                if UIApplication.shared.canOpenURL(URL(string: UIApplication.openSettingsURLString)!){
                    UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!, options: [:])
                }
            }))
            
            self.present(alert, animated: true)
        }
    }
    
    // start location updates to get current device location
    func startLocationUpdates(){
        self.locationVM.startLocationManager{ _, error in
            DispatchQueue.main.async {
                if let error = error{
                    self.showAlert(title: "Error", message: error.localizedDescription, buttons: ["Okay"])
                }else{
                    self.updateUserMarkerLocation()
                    // As we need user/device location once to display on map, we should stop locationManager.
                    // Otherwise, the marker will keep updating user's location whenever changes
                    self.locationVM.stopLocationManager()
                }
            }
        }
    }
    
    // zoom in to device location on the map
    func updateUserMarkerLocation(){
        if let currentLocation = self.locationVM.currentLocation?.coordinate{
            // zoom in to user/device location
            let region = MKCoordinateRegion(center: currentLocation, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
            self.mapView.setRegion(region, animated: true)
        }
    }
}

extension MapViewController: MKMapViewDelegate{
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if view.annotation is MKUserLocation{
            
            if !Reachability.shared.isConnectedToNetwork{
                self.showAlert(title: "Warning", message: "Device is currently offline. Please check device internet connection.", buttons: ["Okay"])
                return
            }
            
            if self.userVM?.userName == ""{
                self.showAlert(title: "Warning", message: "App could not retrieve the logged in user. Please check device internet connection and try again", buttons: ["Okay"])
                return
            }
            
            
            let alert = UIAlertController(title: "Add Note", message: nil, preferredStyle: .alert)
            alert.view.accessibilityIdentifier = "AddNote"
            alert.addTextField { textField in
                textField.accessibilityIdentifier = "NoteInputField"
                textField.placeholder = "Write a note"
            }
            let saveAction = UIAlertAction(title: "Save", style: UIAlertAction.Style.default, handler: {[unowned self] action in
                if let text = alert.textFields?.first?.text{
                    let noteVM = NoteViewModel(service: NoteService())
                    noteVM.noteText = text
                    noteVM.userName = self.userVM!.userName
                    noteVM.geo = GeoPoint(latitude: self.locationVM.currentLocation!.coordinate.latitude, longitude: self.locationVM.currentLocation!.coordinate.longitude)
                    self.noteText = text
                    noteVM.saveNote { note, error in
                        DispatchQueue.main.async {
                            if let error = error{
                                self.showAlert(title: "Error", message: error.localizedDescription, buttons: ["Okay"])
                            }else{
                                self.showAlert(title: "Note Saved", message: "Your note was saved", buttons: ["Okay"])
                                DispatchQueue.global().asyncAfter(deadline: .now() + 1) {
                                    self.noteText = nil
                                }
                            }
                        }
                    }
                }
            })
            saveAction.accessibilityLabel = "SaveNote"
            alert.addAction(saveAction)
            alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        if annotation is MKUserLocation{
            // do not show the callout for current location
            (annotation as? MKUserLocation)?.title = "UserLocationPin"
            return nil
        }
        
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "annotationView")
        
        if annotationView == nil{
            annotationView = MKPinAnnotationView(annotation: nil, reuseIdentifier: "annotationView")
        }
        
        annotationView?.annotation = annotation
        
        // give logged in user's pin a different color
        if annotation.title == self.userVM?.userName{
            (annotationView as? MKPinAnnotationView)?.pinTintColor = .green
        }
        
        let label = UILabel()
        label.text = annotation.subtitle ?? ""
        annotationView?.detailCalloutAccessoryView = label
        annotationView?.canShowCallout = true
        
        annotationView?.tintColor = .green
        
        (annotationView as? MKPinAnnotationView)?.accessibilityIdentifier = "Marker_\(self.annotations.firstIndex{$0 === annotation}!)"
        
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, didAdd views: [MKAnnotationView]) {
        // this may not be necessary but I did not want to show the callout for device location annotation
        views.forEach{
            if $0.annotation is MKUserLocation{
                $0.canShowCallout = false
            }
        }
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

extension MapViewController: UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        if let term = searchBar.text, term > ""{
            noteVM?.removeGetNoteSubscription()
            
            noteVM?.search(term: searchBar.text!, completion: { notes, error in
                if let error = error{
                    print(error.localizedDescription)
                    self.showAlert(title: "Error", message: error.localizedDescription, buttons: ["Okay"])
                }else if let notes = notes{
                    self.setAnnotations(fromNotes: notes)
                }
            })
        }else{
            loadNotes()
        }
    }
}
