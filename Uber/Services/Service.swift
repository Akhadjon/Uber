//
//  Service.swift
//  Uber
//
//  Created by Akhadjon Abdukhalilov on 11/18/20.
//

import Foundation
import Firebase

let DB_REF = Database.database().reference()
let REF_USERS = DB_REF.child("users")
struct Service{
    
    static let shared = Service()
    let currentUid = Auth.auth().currentUser?.uid
    
    func fetchUserData(completion:@escaping(User)->Void){
    
        REF_USERS.child(currentUid!).observeSingleEvent(of: .value) { (snapshot) in
            guard let dictionary = snapshot.value as? [String:Any] else{ return }
            let user = User(dictionry: dictionary)
            completion(user)
        }
    }
}
