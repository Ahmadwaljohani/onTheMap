//
//  AddLocationVC.swift
//  onTheMap
//
//  Created by Ahmad on 06/10/1440 AH.
//  Copyright © 1440 Ahmad. All rights reserved.
//

import UIKit
import CoreLocation

class AddLocationVC: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var olace: UITextField!
    
    @IBOutlet weak var link: UITextField!
    
    @IBOutlet weak var IND: UIActivityIndicatorView!
    
    
    func handleErrorMessage(errorMessage: String){
        let errorMessageAlert = UIAlertController(title: "Error", message: errorMessage, preferredStyle: .alert)
        errorMessageAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(errorMessageAlert, animated: true, completion: nil)
        self.IND.stopAnimating()
    }
    
    
    func geocodeCoordinates(_ studentLocation: Location) {
        
        CLGeocoder().geocodeAddressString(studentLocation.mapString!) { (placeMark, error) in
            DispatchQueue.main.async {
                if error != nil {
                    self.handleErrorMessage(errorMessage: "No Location Found")
                    return
                }
                else {
                    guard let FLocation = placeMark?.first?.location else { return }
                    var location = studentLocation
                    location.latitude = FLocation.coordinate.latitude
                    location.longitude = FLocation.coordinate.longitude
                    self.performSegue(withIdentifier: "post", sender: location)
                    self.IND.stopAnimating()
                }
            }
        }
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "post", let viewController = segue.destination as? PostLocationVC {
            viewController.Slocation = (sender as! Location)
        }
    }
    

    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
    func endEditingText(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    
    
  
    
    
    @IBAction func find(_ sender: Any) {
        self.IND.startAnimating()
        let link = self.link.text
        let location = self.olace.text
        if (location == "") || (link == "") {
            handleErrorMessage(errorMessage: "Please Enter a valid Location & Website")
            return
        }
        
        let studentLocation = Location(mapString: location!, mediaURL: link!)
        geocodeCoordinates(studentLocation)
        
    }
    
    @IBAction func CancelButtonAction(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
}
