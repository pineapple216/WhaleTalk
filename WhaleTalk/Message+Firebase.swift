//
//  Message+Firebase.swift
//  WhaleTalk
//
//  Created by Koen Hendriks on 29/06/16.
//  Copyright © 2016 Koen Hendriks. All rights reserved.
//

import Foundation
import Firebase
import CoreData

extension Message: FirebaseModel{
    func upload(rootRef: Firebase, context: NSManagedObjectContext) {
        if chat?.storageId == nil{
            chat?.upload(rootRef, context: context)
        }
        let data = [
            "message" : text!,
            "sender" : FirebaseStore.currentPhoneNumber!
        ]
        guard let chat = chat, timestamp = timestamp, storageId = chat.storageId else {return}
        let timeInterval = String(Int64(timestamp.timeIntervalSince1970 * 100000))
        rootRef.childByAppendingPath("chats/"+storageId+"/messages/"+timeInterval).setValue(data)
    }
}