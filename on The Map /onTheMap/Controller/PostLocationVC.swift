//
//  PostLocationVC.swift
//  onTheMap
//
//  Created by Ahmad on 07/10/1440 AH.
//  Copyright © 1440 Ahmad. All rights reserved.
//

import UIKit
import MapKit

class PostLocationVC : UIViewController, MKMapViewDelegate{
     var Slocation: Location!
    
    @IBOutlet weak var map: MKMapView!
    
    func handleErrorMessage(errorMessage: String){
        let errorMessageAlert = UIAlertController(title: "Error!", message: errorMessage, preferredStyle: .alert)
        errorMessageAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(errorMessageAlert, animated: true, completion: nil)
    }
    
    func mapViewDidFinishRenderingMap(_ mapView: MKMapView, fullyRendered: Bool) {
        
        guard let Slocation = Slocation else { return }

        let coordinate = CLLocationCoordinate2D(latitude: CLLocationDegrees(Slocation.latitude!), longitude: CLLocationDegrees(Slocation.longitude!))
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        annotation.title = Slocation.mapString
        mapView.addAnnotation(annotation)
        
        let region = MKCoordinateRegion(center: coordinate, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        mapView.setRegion(region, animated: true)
    }

    @IBAction func finish(_ sender: Any) {
        API.getInformation {
           self.Slocation.firstName = API.fName
           self.Slocation.lastName = API.lName
            API.addLocation(studentLocation: self.Slocation){(error) in
                DispatchQueue.main.async {
                    if error == nil { self.dismiss(animated: true, completion: nil) }
                    else { self.handleErrorMessage(errorMessage: "Couldn't complete your request there was an error") }
                }
              }
            }
          }
 }
