//
//  ViewController.swift
//  onTheMap
//
//  Created by Ahmad on 05/10/1440 AH.
//  Copyright © 1440 Ahmad. All rights reserved.
//

import UIKit

class LoginVC: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var Email: UITextField!
    
    @IBOutlet weak var IND: UIActivityIndicatorView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.Email.delegate = self
        self.Password.delegate = self
        
        
    }
    @IBOutlet weak var Password: UITextField!
    
    @IBAction func Login(_ sender: Any) {
        let userEmail = Email.text
        let userPassword = Password.text
        
        if userEmail != "" || userPassword != "" {
            self.IND.startAnimating()
             API.login(userEmail , userPassword){(Success, key, error) in
                DispatchQueue.main.async {
                    if error != nil {
                      self.ErrorMSG(error: "Sorry there was an Error")
                        
                    }
                    if Success {
                        self.performSegue(withIdentifier: "login", sender: nil)
                        self.IND.stopAnimating()
                        self.Email.text = ""
                        self.Password.text = ""
                        
                    }
                    else {
                      self.ErrorMSG(error: "Wrong Email OR Password")
                        
                    }
                }
            }
            
            
        }
        else {
            
            ErrorMSG(error: "Please Enter an Email & Password")
            
        }
        
    }
    @IBAction func Signup(_ sender: Any) {
        guard let url = URL(string: "https://auth.udacity.com/sign-up") else {
            self.ErrorMSG(error: "invalid url")
            return
        }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
    
    func ErrorMSG (error: String){
      let Alert = UIAlertController(title: "Error", message: error, preferredStyle: .alert)
        
        Alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        self.IND.stopAnimating()
        
        self.present(Alert, animated: true, completion: nil)
        
    }
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
}

