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
    private let rootRef = Firebase(url: "https://koen-whaletalk.firebaseapp.com")
    
    init(context: NSManagedObjectContext){
        self.context = context
    }
    
    func hasAuth() -> Bool {
        return rootRef.authData != nil
    }
}