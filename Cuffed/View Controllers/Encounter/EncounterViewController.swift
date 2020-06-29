//
//  EncounterViewController.swift
//  Cuffed
//
//  Created by Evan Guan on 13/2/20.
//  Copyright © 2020 Evan Guan. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import SDWebImage
import Firebase
import QuartzCore

class EncounterViewController: UIViewController {

    // IBOutlets
    
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var encounterButtonShadowView: UIView!
    
    @IBOutlet weak var recenterView: UIView!
    
    
    let locationManager = CLLocationManager()
    
    let regionInMeters:Double = 1000
    
    let thirtyMinutesInSeconds = 1800
    
    var selfUID:String?

    let imageView = UIImageView()

    var userLocationImage:UIImage?
    
    var imageURLString:String?
    
    var borderFloat:Float?
    
    let fsRef = Firestore.firestore()
    
    let dbRef = Database.database().reference()
    
    var displayUID:String?
    
    var detailCard:DetailCardViewController?

    
    @IBOutlet weak var encounterButton: UIButton!
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        mapView.delegate = self
        checkLocationServices()
        locationManager.delegate = self
        styleInterface()
        
        // Initialise the detail card
        detailCard = storyboard?.instantiateViewController(identifier: Con.Storyboard.DetailCardViewController) as? DetailCardViewController
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        reloadEncounters()
        centerViewOnUserLocation()
        
    }
    
    func reloadEncounters(){
        
        // Check for activeEncounters for selfUID inside Firestore
        
        guard selfUID != nil else { return }
        
        fsRef.collection(Con.Firestore.users).document(selfUID!).collection(Con.Firestore.activeEncounters).getDocuments { (snapshot, error) in
            
            //I think this just grabs all the documents that are inside?
            
            if error != nil {
                print(error?.localizedDescription as Any)
                return
            }
            
            let encounterDocuments = snapshot!.documents
            
            for document in encounterDocuments {
                
                
                let long = document.data()[Con.Firestore.long] as? Double
                let lat = document.data()[Con.Firestore.lat] as? Double
                let time = document.data()[Con.Firestore.timestamp] as? Int
                
                guard long != nil && lat != nil && time != nil else { return }
                
                self.fetchEncounterMatches(long!, lat!, time!)
                
            }
            
            
        }
        
    }
    @IBAction func recenterTouched(_ sender: UIButton) {
        Animations.animateHighlight(button: recenterView)
    }
    
    @IBAction func recenterTapped(_ sender: UIButton) {
        
        Animations.animateUnhighlight(button: recenterView)
        

        centerViewOnUserLocation()
        reloadEncounters()
        
        // Show modal pop up at the top saying refresh successful
        
    }
    
    @IBAction func encounterTouched(_ sender: UIButton) {
        Animations.animateHighlight(button: encounterButtonShadowView)
    }
    
        
    
    @IBAction func encounterTapped(_ sender: UIButton) {
        Animations.animateUnhighlight(button: encounterButtonShadowView)
        
        // Store Longitude, Latitude, Timestamp, UID, profileImage
        

        handleEncounter()
        
    }
    
    

    

    
    
    func fetchEncounterMatches(_ long:Double,_ lat:Double,_ time:Int?){
        
        // Before we begin, empty all the documents
        var timeDocument:[QueryDocumentSnapshot]?
        
        var longDocument:[QueryDocumentSnapshot]?
        
        var latDocument:[QueryDocumentSnapshot]?
        
        var displayDocument = [QueryDocumentSnapshot]()
        
        guard time != nil else { return }
        
        fsRef.collection(Con.Firestore.encounters).whereField(Con.Firestore.timestamp, isGreaterThanOrEqualTo: time! - thirtyMinutesInSeconds).whereField(Con.Firestore.timestamp, isLessThanOrEqualTo: time! + thirtyMinutesInSeconds).getDocuments { (snapshot, error) in
            
            if error != nil { return }
            
            timeDocument = snapshot!.documents
            
            guard longDocument != nil && latDocument != nil && timeDocument != nil else {
                print("Nil documents")
                return
                
            }
            
            for item in longDocument! {
                // For every item longitude documents
                
                if latDocument!.contains(item) && timeDocument!.contains(item) {
                    // If they also exist in the latitude and timestamp document arrays
                    // Then this document fits within the cube
                    displayDocument.append(item)
                    
                    
                }
                
            }
            
            self.displayEncounters(displayDocument: displayDocument)
            
            
        }
        
        fsRef.collection(Con.Firestore.encounters).whereField(Con.Firestore.long, isLessThanOrEqualTo: long + Con.coordinates.longConstant).whereField(Con.Firestore.long, isGreaterThanOrEqualTo: long - Con.coordinates.longConstant).getDocuments { (snapshot, error) in
            
            if error != nil { return }
            
            
            longDocument = snapshot?.documents
            
            // Guard statement only passes if all three fetches have been complete
            guard longDocument != nil && latDocument != nil && timeDocument != nil else {
                print("Nil documents")
                return
                
            }
            
            for item in longDocument! {
                // For every item longitude documents
                
                if latDocument!.contains(item) && timeDocument!.contains(item) {
                    // If they also exist in the latitude and timestamp document arrays
                    // Then this document fits within the cube
                    displayDocument.append(item)
                    
                    
                }
                
            }
            
            self.displayEncounters(displayDocument: displayDocument)
            
        }
        
        fsRef.collection(Con.Firestore.encounters).whereField(Con.Firestore.lat, isLessThanOrEqualTo: lat + Con.coordinates.latConstant).whereField(Con.Firestore.lat, isGreaterThanOrEqualTo: lat - Con.coordinates.latConstant).getDocuments { (snapshot, error) in
            
            if error != nil { return }
            
            latDocument = snapshot?.documents
            
            guard longDocument != nil && latDocument != nil && timeDocument != nil else {
                print("Nil documents")
                return
                
            }
            
            for item in longDocument! {
                // For every item longitude documents
                
                if latDocument!.contains(item) && timeDocument!.contains(item) {
                    // If they also exist in the latitude and timestamp document arrays
                    // Then this document fits within the cube
                    displayDocument.append(item)
                    
                    
                }
                
            }
            
            self.displayEncounters(displayDocument: displayDocument)
            
        }
        
        // Match up and look for elements that are common within the three arrays
        
        
        
    }
    
    func displayEncounters(displayDocument:[QueryDocumentSnapshot]) {
        
        var duplicateCheck = [String]()
        
        // Plot each item in the displayDocument onto the map
        for snapshot in displayDocument {
            
            let annotation = CustomPointAnnotation()
            
            let lat = snapshot.data()[Con.Firestore.lat]
            
            let long = snapshot.data()[Con.Firestore.long]
            
            let uid = snapshot.data()[Con.Firestore.uid] as? String
            
            let documentID = snapshot.documentID
            
            let profileImage = snapshot.data()[Con.Firestore.profileImage] as? String
            
            let border = snapshot.data()[Con.Firestore.border] as? Float
            
            annotation.coordinate = CLLocationCoordinate2D(latitude: lat as! CLLocationDegrees, longitude: long as! CLLocationDegrees)
            
            // Perform duplicate check
            
            guard uid != nil else { continue }
            
            if duplicateCheck.contains(uid!){
                // User already exists in current encounterList
                // Do not add to annotationArray, and continue
                continue
            } else {
                
                // Add the uid into the array
                duplicateCheck.append(uid!)
                
            }
            
            
            // Retrieve
            annotation.uid = uid
            
            annotation.documentID = documentID
            
            annotation.profileImage = profileImage
            
            annotation.border = border
            
            
            // Ensuring that its not the user's themselves
            if annotation.uid != selfUID {
                
                var allowAppend = true
                
                // Check to make sure that the current annotation is not already appended into
                // the mapView annotations array
                for anote in mapView.annotations {
                    
                    let customAnote = anote as? CustomPointAnnotation
                    
                    guard customAnote != nil else { continue }
                    
                    if customAnote!.documentID == annotation.documentID {
                        
                        // The current encounterID has already been appended to the mapView annotations
                        // Do not append again
                        
                        allowAppend = false
                        
                        break
                        
                    }
                     
                }
                
                if allowAppend {
                    
                        mapView.addAnnotation(annotation)
                    
                }
                
            }

            
            
        }
        
    }
    
    func styleInterface(){
        
        Utilities.styleCardBackButton(encounterButton, Con.cardBackButtons.encounter.colourTop, Con.cardBackButtons.encounter.colourBottom)
        
        recenterView.layer.cornerRadius = 15
        
        
        
        
        

   
        
    }
    
    func fetchTime() -> Int {
        
        let currentDate = Date()
        
        let since1970 = currentDate.timeIntervalSince1970
        
        return Int(since1970)
        
    }
    
    
    func setupLocationManager() {

        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
    }
    
    func centerViewOnUserLocation() {
        if let location = locationManager.location?.coordinate {
            
            
            let region = MKCoordinateRegion.init(center: location, latitudinalMeters: regionInMeters, longitudinalMeters: regionInMeters)
            
            mapView.setRegion(region, animated: true)
            
            
        }
        
    }
    
    func checkLocationServices() {
        if CLLocationManager.locationServicesEnabled() {
            
            // Setup our location manager
            setupLocationManager()
            checkLocationAuthorization()
            
        } else {
            
            // Show alert letting the user know they have to turn this on
            
        }
        
        
    }
    
    
    func resizedImage(for size:CGSize, image:UIImage?) -> UIImage? {
        
        guard image != nil else {
            return nil
        }
        
        let renderer = UIGraphicsImageRenderer(size: size)
        
        return renderer.image { (context) in
            
            image!.draw(in: CGRect(origin: .zero, size: size))
            
        }
        
    }
    
    func fetchUserData() {
        
        selfUID = Retrieve.retrieveUID()
        
        let dbRef = Database.database().reference()
            
            
    dbRef.child(Con.Database.users).child(selfUID!).observe(.value) { (snapshot) in

        let dataDict = snapshot.value as? [String:Any]
        
        guard dataDict != nil else { return }
            
        let urlString = dataDict![Con.Database.profileImage] as? String
        
        self.borderFloat = dataDict![Con.Database.border] as? Float

            guard urlString != nil else { return }
        
            self.imageURLString = urlString

            let url = URL(string: urlString!)
        
            

        self.imageView.sd_setImage(with: url) { (image, error, cacheType, url) in

                if error != nil {
                    print(error?.localizedDescription as Any)
                    return
                }

            self.imageView.frame = CGRect(x: 0, y: 0, width: 70, height: 70)
            self.imageView.image = image
            self.imageView.layer.cornerRadius = self.imageView.layer.frame.width/2
            self.imageView.layer.borderColor = UIColor.white.cgColor
            self.imageView.layer.borderWidth = 4
            self.imageView.contentMode = .scaleAspectFill
            self.imageView.layer.masksToBounds = true
                
            self.mapView.showsUserLocation = true


            }


        }
    }
    
    func setImage(urlString:String?, annotationView:MKAnnotationView, border:Float){
        
        guard urlString != nil else { return }
        
        let url = URL(string: urlString!)
        
        guard url != nil else { return }
        
        let tempImageView = UIImageView()
        
        tempImageView.sd_setImage(with: url) { (image, error, cacheType, url) in
            
                if error != nil {
                    print(error?.localizedDescription as Any)
                    return
                }
            
            annotationView.frame = CGRect(x: 0, y: 0, width: 70, height: 70)
            annotationView.backgroundColor = .white
            annotationView.layer.cornerRadius = 35
            annotationView.layer.shadowRadius = 5
            annotationView.layer.shadowOpacity = 0.3
            annotationView.layer.shadowOffset = .init(width: 0, height: 8)

            tempImageView.frame = CGRect(x: 0, y: 0, width: 70, height: 70)
            tempImageView.image = image
            tempImageView.layer.cornerRadius = self.imageView.layer.frame.width/2
            tempImageView.layer.borderColor = UIColor.white.cgColor
            tempImageView.layer.borderWidth = 4
            tempImageView.contentMode = .scaleAspectFill
            tempImageView.layer.masksToBounds = true
            
            annotationView.addSubview(tempImageView)

            
        }
        
        
    }
    
    func checkLocationAuthorization() {
        
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse:
            // Do map stuff
            print("authorised when in use")
            fetchUserData()
            centerViewOnUserLocation()
            break
        case .denied:
            // Show alert instructing them how to turn on permission
            break
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
            break
        case .restricted:
            // Show alert saying we cannot do it
            break
        case .authorizedAlways:
            print("authorised always")
            fetchUserData()
            centerViewOnUserLocation()
            break
        @unknown default:
            break
        }
        
        
    }
    



}



extension EncounterViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let region = MKCoordinateRegion.init(center: center, latitudinalMeters: regionInMeters, longitudinalMeters: regionInMeters)
        mapView.setRegion(region, animated: true)
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        //
        checkLocationAuthorization()
        
        
    }
    
    
    
}



extension EncounterViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {

        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "AnnotationVIew")
        
        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "AnnotationView")
//            annotationView!.canShowCallout = true
            
        } else {
            
            annotationView!.annotation = annotation
            
        }
        
        
        if annotation === mapView.userLocation {
            
//            let shadowView = UIView(frame: CGRect(x: 0, y: 0, width: 70, height: 70))

            annotationView!.frame = CGRect(x: 0, y: 0, width: 70, height: 70)
            annotationView!.backgroundColor = .white
            annotationView!.layer.cornerRadius = 35
            annotationView!.layer.shadowRadius = 5
            annotationView!.layer.shadowOpacity = 0.3
            annotationView!.layer.shadowOffset = .init(width: 0, height: 8)

//            annotationView?.addSubview(shadowView)
            
            
            annotationView?.addSubview(self.imageView)
            
        } else {
        
            
            // Displaying a non-userLocation annotation
            
            // Try to cast it into our CustomPointAnnotation class
            
            let customAnnotation = annotation as? CustomPointAnnotation
            
            guard customAnnotation != nil else {
                print("Cast unsuccessful")
                return annotationView
            }
            
            // Set the image of this annotation
            print("Cast Successful")
            
            setImage(urlString: customAnnotation?.profileImage, annotationView: annotationView!, border:customAnnotation!.border!)

        
        
        }
        
        annotationView!.canShowCallout = true
        
        return annotationView

    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        
        
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseOut, animations: {
            view.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
        }, completion: nil)
        
        
        print("Annotation tap has been detected")
        let customAnote = view.annotation as? CustomPointAnnotation
        
        guard customAnote != nil else { return }
        
        print("UID of annotation \(customAnote!.uid ?? "No UID")")
        
        // Can detect the UID associated with the annotation very good
        
        if customAnote!.uid != nil {
            
            // Store uid to be shown into static variable
            self.displayUID = customAnote!.uid
            
            
            // Create instance of detailCardViewController and pass in the UID
            if detailCard != nil {
                
                detailCard?.cardUID = self.displayUID
                
                detailCard?.modalPresentationStyle = .overFullScreen
                            
                let transition = CATransition()
                transition.duration = 0.5
                transition.type = .push
                transition.subtype = .fromRight
                transition.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
                view.window!.layer.add(transition, forKey: kCATransition)
                
                present(detailCard!, animated: false, completion: nil)
                

            }

            
        }
        
        


    }
    
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        
        
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseOut, animations: {
            view.transform = CGAffineTransform(scaleX: 1, y: 1)
        }, completion: nil)
        
    }
    
    

    
    


    
    
}



extension EncounterViewController {
    
    func handleEncounter(){
        
        let actionSheet = UIAlertController(title: "Made an Encounter?", message: "Confirm to see other people who've also made an encounter", preferredStyle: .alert)
        
        let confirmAction = UIAlertAction(title: "Confirm", style: .default) { (action) in
            
            self.confirmedECT()
            
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        actionSheet.addAction(confirmAction)
        actionSheet.addAction(cancelAction)
        
        self.present(actionSheet, animated: true)
        
    }
    
    func confirmedECT(){
                guard locationManager.location?.coordinate != nil else { return }
                
                let timestamp = fetchTime() // Time in seconds
                
                let coordinate = locationManager.location!.coordinate
                
                // Retrieve the documentID to store into the user's profile
                
                let encounterReference = fsRef.collection(Con.Firestore.encounters).document()
                
                let encounterID = encounterReference.documentID
                
                // Store relevant information into the encounter document
                encounterReference.setData([Con.Firestore.long: coordinate.longitude, Con.Firestore.lat:coordinate.latitude, Con.Firestore.uid:selfUID as Any, Con.Firestore.timestamp:timestamp, Con.Firestore.profileImage:imageURLString as Any, Con.Firestore.border:borderFloat as Any])
                
                // Store the encounterID into the current user's profile so information about this 'encounter' can be retrieved later
                
                fsRef.collection(Con.Firestore.users).document(selfUID!).collection(Con.Firestore.activeEncounters).document(encounterID).setData([Con.Firestore.timestamp : timestamp, Con.Firestore.long:coordinate.longitude, Con.Firestore.lat:coordinate.latitude])
                
                // I think that code above creates a document with the encounterID but let's have a look, maybe we need to set a value into the fields
                
                // Recenter map
                
                centerViewOnUserLocation()
                
                // Pop up window to tell user the encounter action was successful
                Alert.showBasicAlert(on: self, with: "Ready to Encounter", message: "You are now visible on the Encounter Map")
                
                // Begin fetch for other users within the vicinity and time

        //        fetchEncounterMatches(coordinate.longitude, coordinate.latitude, timestamp)
                
                // Instead of fetching on the current location, reload from activeEncounters
                reloadEncounters()
    }
    
}
