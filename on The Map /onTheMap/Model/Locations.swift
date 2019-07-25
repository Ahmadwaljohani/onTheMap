//
//  Locations.swift
//  onTheMap
//
//  Created by Ahmad on 05/10/1440 AH.
//  Copyright © 1440 Ahmad. All rights reserved.
//

import Foundation

class studentInfo {
    static var studentInformation : [Location] = [Location]()
}
struct Location : Codable {
    var createdAt : String?
    var firstName : String?
    var lastName : String?
    var latitude : Double?
    var longitude : Double?
    var mapString : String?
    var mediaURL : String?
    var objectId : String?
    var uniqueKey : String?
    var updatedAt : String?
}

extension Location {
    init(mapString: String, mediaURL: String) {
        self.mapString = mapString
        self.mediaURL = mediaURL
    }

}
