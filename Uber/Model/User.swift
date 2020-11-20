//
//  User.swift
//  Uber
//
//  Created by Akhadjon Abdukhalilov on 11/18/20.
//

import Foundation
import CoreLocation

struct User {
    let fullname:String
    let email:String
    let accountType:Int
    var location:CLLocation?
    let uid:String
    
    init(uid:String,dictionry:[String:Any]){
        self.uid = uid
        self.fullname = dictionry["fullname"] as? String ?? ""
        self.email = dictionry["email"] as? String ?? ""
        self.accountType = dictionry["accountType"] as? Int ?? 0
    }
}
