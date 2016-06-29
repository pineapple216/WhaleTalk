//
//  FirebaseModel.swift
//  WhaleTalk
//
//  Created by Koen Hendriks on 29/06/16.
//  Copyright © 2016 Koen Hendriks. All rights reserved.
//

import Foundation
import Firebase
import CoreData

protocol FirebaseModel {
    func upload(rootRef: Firebase, context: NSManagedObjectContext)
}