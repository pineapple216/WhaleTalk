//
//  FirebaseModels.swift
//  WhaleTalk
//
//  Created by Koen Hendriks on 15/06/16.
//  Copyright © 2016 Koen Hendriks. All rights reserved.
//

import Foundation
import Firebase
import CoreData

protocol FirebaseModel {
    func upload(rootRef: Firebase, context: NSManagedObjectContext)
}

extension Contact: FirebaseModel{
    func upload(rootRef: Firebase, context: NSManagedObjectContext) {
        guard let phoneNumbers = phoneNumbers?.allObjects as? [PhoneNumber] else {return}
        
        for number in phoneNumbers {
            rootRef.childByAppendingPath("users").queryOrderedByChild("phoneNumber").queryEqualToValue(number.value).observeSingleEventOfType(.Value, withBlock: {
                    snapshot in
                guard let user = snapshot.value as? NSDictionary else {return}
                let uid = user.allKeys.first as? String
                context.performBlock({ 
                    self.storageId = uid
                    number.registered = true
                    do{
                        try context.save()
                    }
                    catch{
                        print("Error saving")
                    }
                })
            })
        }
    }
}

extension Chat: FirebaseModel{
    func upload(rootRef: Firebase, context: NSManagedObjectContext) {
        guard storageId == nil else {return}
        let ref = rootRef.childByAppendingPath("chats").childByAutoId()
        storageId = ref.key
        var data: [String: AnyObject] = ["id" :ref.key,]
        guard let participants = participants?.allObjects as? Contact else {return}
        var numbers = [FirebaseStore.currentPhoneNumber! : true]
        var userIds = [rootRef.authData.uid]
    }
}

extension Message: FirebaseModel{
    func upload(rootRef: Firebase, context: NSManagedObjectContext) {
        if chat?.storageId == nil{
            chat?.upload(rootRef, context: context)
        }
        let data = [
            "message"   : text!,
            "sender"    : FirebaseStore.currentPhoneNumber!
        ]
        guard let chat = chat, timestamp = timestamp, storageId = chat.storageId else {return}
        let timeInterval = String(Int(timestamp.timeIntervalSince1970 * 100000))
        rootRef.childByAppendingPath("chats/"+storageId+"/messages/"+timeInterval).setValue(data)
    }
}
















