//
//  DriverAnnonation.swift
//  Uber
//
//  Created by Akhadjon Abdukhalilov on 11/18/20.
//

import UIKit
import MapKit

class DriverAnnonation:NSObject,MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var uid:String
    init(uid:String,coordinate:CLLocationCoordinate2D){
        self.uid = uid
        self.coordinate = coordinate
    }
    
}

