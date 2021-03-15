//
//  AppointLocation.swift
//  Grading
//
//  Created by Aira on 16.03.2021.
//

import Foundation
import MapKit
import SwiftyJSON

class AppointLocation: NSObject {
    var location: CLLocationCoordinate2D!
    var note: String = ""
    var photos: [String] = [String]()
    
    func initWithJSON(obj: JSON) {
        let locationInfo = obj["location"]
        let latInfo: String = locationInfo["lat"].stringValue
        let lngInfo: String = locationInfo["long"].stringValue
        location = CLLocationCoordinate2D(latitude: CLLocationDegrees(latInfo.stringToCGFloat()), longitude: CLLocationDegrees(lngInfo.stringToCGFloat()))
        
        note = obj["note"].stringValue
        let photoArr = obj["photos"].arrayValue
        for item in photoArr {
            photos.append(item.stringValue)
        }
    }
}
