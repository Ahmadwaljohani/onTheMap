//
//  API.swift
//  onTheMap
//
//  Created by Ahmad on 05/10/1440 AH.
//  Copyright © 1440 Ahmad. All rights reserved.
//

import Foundation

class API{
    static var UNKey: String!
    
    static var fName: String!
    static var lName: String!
    static func login (_ username : String!, _ password : String!, completion: @escaping (Bool, String, Error?)->()) {
        
        var request = URLRequest(url: URL(string: "https://onthemap-api.udacity.com/v1/session")!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = "{\"udacity\": {\"username\": \"\(username!)\", \"password\": \"\(password!)\"}}".data(using: .utf8)
        
        
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in if error != nil {
                completion(false,"",error)
                
                return
            }
 
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode else {
   
                let statusCodeError = NSError(domain: NSURLErrorDomain, code: 0, userInfo: nil)
                
                completion(false,"",statusCodeError)
                
                return
            }

            if statusCode >= 200  && statusCode < 300 {
                
                //Skipping the first 5 characters
                let range = (5..<data!.count)
                let newData = data?.subdata(in: range) /* subset response data! */

                let loginDictionary = try! JSONSerialization.jsonObject(with: newData!, options: []) as? [String : Any]
                
                //Get the unique key of the user
                let accountDictionary = loginDictionary? ["account"] as? [String : Any]
                let uniqueKey = accountDictionary? ["key"] as? String ?? " "
                UNKey = uniqueKey
                completion (true, uniqueKey, nil)
            } else {
               completion(false,"",error)
            }
        }
        //Start the task
        task.resume()
    }
    
    
    static func getLocation (completion: @escaping ([Location]?, Error?) -> ()) {
        var request = URLRequest (url: URL (string: "https://onthemap-api.udacity.com/v1/StudentLocation?limit=100&order=-updatedAt")!)
        
        request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
        
        request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
        
        let task = URLSession.shared.dataTask(with: request) {data, response, error in if error != nil {
                completion(nil, error)
                return
            }

            guard let statusCode = (response as? HTTPURLResponse)?.statusCode else {
       
                let statusCodeError = NSError(domain: NSURLErrorDomain, code: 0, userInfo: nil)
                completion(nil, statusCodeError)
                return
            }
            
            if statusCode >= 200 && statusCode < 300 {
                
                //Get an object based on the received data in JSON format
                let jsonObject = try! JSONSerialization.jsonObject(with: data!, options: [])
                
                guard let jsonD = jsonObject as? [String: Any]
                else {return}
                 let resultsArray = jsonD["results"] as? [[String:Any]]
                
           
                guard let array = resultsArray else {return}
                let dataObject = try! JSONSerialization.data(withJSONObject: array, options: .prettyPrinted)
                let studentsLocations = try! JSONDecoder().decode([Location].self, from: dataObject)
                completion (studentsLocations, nil)
            }
        }
        
        task.resume()
    }
        
        
    static func logout(completion : @escaping ()->()){
        let sharedCookieStorage = HTTPCookieStorage.shared
        var req = URLRequest(url: URL(string: "https://onthemap-api.udacity.com/v1/session")!)
        var xsrfCookie: HTTPCookie? = nil
        req.httpMethod = "DELETE"
       
        for cookie in sharedCookieStorage.cookies! {
            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
            req.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        let session = URLSession.shared
        let task = session.dataTask(with: req) { data, response, error in if error != nil {
                return
            }
            let Skip = (5..<data!.count)
            let Data = data?.subdata(in: Skip)
        }
        task.resume()
    }
    
    
    static func getInformation(completion: @escaping ()->()) {
        
        let req = URLRequest(url: URL(string: "https://onthemap-api.udacity.com/v1/users/\(UNKey!)")!)
        let task = URLSession.shared.dataTask(with: req) { data, response, error in
            if error != nil {
                return
            }
            let Skip = (5..<data!.count)
            let Data = data?.subdata(in: Skip)
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode else {
                let statusCodeError = NSError(domain: NSURLErrorDomain, code: 0, userInfo: nil)
                return
            }
            if statusCode >= 200 && statusCode < 300 {
                
                let jsonObject = try! JSONSerialization.jsonObject(with: Data!, options: [.allowFragments])
                guard let jsonDictionary = jsonObject as? [String : Any] else {return}
           
                let firstName = jsonDictionary ["first_name"]  as! String
                
                let lastName = jsonDictionary ["last_name"]  as! String
                
                fName = firstName
                lName = lastName
                
                completion()
            }
            
        }
        task.resume()
    }
    
    static func addLocation(studentLocation: Location, completion : @escaping (Error?) ->()){
        
        var req = URLRequest(url: URL(string: "https://onthemap-api.udacity.com/v1/StudentLocation")!)
        
        req.httpMethod = "POST"
req.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let requestString = "{\"uniqueKey\": \"\(UNKey!)\", \"firstName\": \"\(studentLocation.firstName ?? "")\", \"lastName\": \"\(studentLocation.lastName ?? "")\",\"mapString\": \"\(studentLocation.mapString!)\", \"mediaURL\": \"\(studentLocation.mediaURL ?? "")\",\"latitude\": \(studentLocation.latitude!), \"longitude\": \(studentLocation.longitude!)}"
        req.httpBody = requestString.data(using: .utf8)
        let task = URLSession.shared.dataTask(with: req) { data, response, error in
            if error != nil {
                return
            }
            completion(error)
        }
        task.resume()
    }
        
    }
    
    
    
    

