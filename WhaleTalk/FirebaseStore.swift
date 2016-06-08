//
//  FirebaseStore.swift
//  WhaleTalk
//
//  Created by Koen Hendriks on 01/06/16.
//  Copyright © 2016 Koen Hendriks. All rights reserved.
//

import Foundation
import Firebase
import CoreData

class FirebaseStore {
    private let context: NSManagedObjectContext
    private let rootRef = Firebase(url: "https://koen-whaletalk.firebaseio.com")
    
    private var currentPhoneNumber: String? {
        set(phoneNumber){
            NSUserDefaults.standardUserDefaults().setObject(phoneNumber, forKey: "phoneNumber")
        }
        get{
            return NSUserDefaults.standardUserDefaults().objectForKey("phoneNumber") as? String
        }
    }
    
    init(context: NSManagedObjectContext){
        self.context = context
    }
    
    func hasAuth() -> Bool {
        return rootRef.authData != nil
    }
}

extension FirebaseStore: RemoteStore{
    func startSyncing() {
        
    }
    
    func store(inserted inserted: [NSManagedObject], updated: [NSManagedObject], deleted: [NSManagedObject]) {
        
    }
    
    func signUp(phonenumber phoneNumber: String, email: String, password: String, succes: () -> (), error errorCallback: (errorMessage: String) -> ()) {
        
        rootRef.createUser(email, password: password, withValueCompletionBlock: {
            error, result in
            if error != nil{
                errorCallback(errorMessage: error.description)
            }
            else{
                let newUser = [
                    "phoneNumber" : phoneNumber
                ]
                self.currentPhoneNumber = phoneNumber
                let uid = result["uid"] as! String
                self.rootRef.childByAppendingPath("users").childByAppendingPath("uid").setValue(newUser)
                self.rootRef.authUser(email, password: password, withCompletionBlock: {
                    error, authData in
                    
                    if error != nil{
                        errorCallback(errorMessage: error.description)
                    }
                    else{
                        succes()
                    }
                })
            }
        })
    }
}


