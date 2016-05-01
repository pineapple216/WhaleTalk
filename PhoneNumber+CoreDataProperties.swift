//
//  PhoneNumber+CoreDataProperties.swift
//  WhaleTalk
//
//  Created by Koen Hendriks on 01/05/16.
//  Copyright © 2016 Koen Hendriks. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension PhoneNumber {

    @NSManaged var value: String?
    @NSManaged var contact: Contact?

}
