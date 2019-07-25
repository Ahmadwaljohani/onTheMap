//
//  TableVC.swift
//  onTheMap
//
//  Created by Ahmad on 06/10/1440 AH.
//  Copyright © 1440 Ahmad. All rights reserved.
//

import UIKit

class TableVC: UITableViewController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateTable()
    }
    
    
    @IBAction func logoutButtonTappedAction(_ sender: UIBarButtonItem) {
        API.logout {
        }
        DispatchQueue.main.async {
            self.dismiss(animated: true, completion: nil)
        }
        
    }

    func updateTable(){
        API.getLocation () {(studentsLocations, error) in
            DispatchQueue.main.async {
                
                if error != nil {
                    self.handleErrorMessage(errorMessage: "Sorry Couldn't complete your request there was an error")
                    return
                }
                if studentsLocations == nil {
                    self.handleErrorMessage(errorMessage: "Sorry couldn't complete loading locations There was an error ")
                    return
                }
                
                studentInfo.studentInformation = studentsLocations!
                self.tableView.reloadData()
            }
        }
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return studentInfo.studentInformation.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        
        let student = studentInfo.studentInformation[indexPath.row]
        cell.textLabel?.text = "\(student.firstName ?? "Loading") \(student.lastName ?? "")"
        cell.detailTextLabel?.text = student.mediaURL ?? ""
        cell.imageView?.image = #imageLiteral(resourceName: "icon_pin")
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let student = studentInfo.studentInformation[indexPath.row]
        URLError(url: student.mediaURL!)
        UIApplication.shared.open(URL(string: student.mediaURL!)!)
    }
    
    func handleErrorMessage(errorMessage: String){
        let errorMessageAlert = UIAlertController(title: "Falid!", message: errorMessage, preferredStyle: .alert)
        errorMessageAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(errorMessageAlert,animated: true, completion: nil)
    }
    func URLError(url: String) -> Bool {
        guard url.contains("https") || url.contains("http") else {
            let errorURL = UIAlertController(title: "Error", message: "Url invaild", preferredStyle: .alert)
            errorURL.addAction(UIAlertAction(title: "Dismes", style: .default, handler: nil))
            self.present(errorURL, animated: true, completion: nil)
            return false
        }
        return true
    }
    


    
    @IBAction func ref(_ sender: Any) {
        self.updateTable()
    }
    @IBAction func add(_ sender: Any) {
        self.performSegue(withIdentifier: "Table:addLocation", sender: nil)
    }
}
