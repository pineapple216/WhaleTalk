//
//  RemoteStore.swift
//  WhaleTalk
//
//  Created by Koen Hendriks on 31/05/16.
//  Copyright © 2016 Koen Hendriks. All rights reserved.
//

import Foundation
import CoreData

protocol RemoteStore {
    func signUp(phonenumber phoneNumber: String, email: String, password: String, succes: () -> (), error:(errorMessage: String) -> ())
    func startSyncing()
    func store(inserted inserted: [NSManagedObject], updated: [NSManagedObject], deleted: [NSManagedObject])
}
