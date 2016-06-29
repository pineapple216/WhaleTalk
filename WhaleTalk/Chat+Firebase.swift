//
//  Chat+Firebase.swift
//  WhaleTalk
//
//  Created by Koen Hendriks on 29/06/16.
//  Copyright © 2016 Koen Hendriks. All rights reserved.
//

import Foundation
import Firebase
import CoreData

extension Chat: FirebaseModel{
    
    static func new(forStorageId storageId: String, rootRef: Firebase, inContext context: NSManagedObjectContext) -> Chat {
        let chat = NSEntityDescription.insertNewObjectForEntityForName("Chat", inManagedObjectContext: context) as! Chat
        chat.storageId = storageId
        rootRef.childByAppendingPath("chats/"+storageId+"/meta").observeSingleEventOfType(.Value, withBlock: {
            snapshot in
            guard let data = snapshot.value as? NSDictionary else {return}
            guard let partipantsDict = data["participants"] as? NSMutableDictionary else {return}
            partipantsDict.removeObjectForKey(FirebaseStore.currentPhoneNumber!)
            let participants = partipantsDict.allKeys.map{
                (phoneNumber: AnyObject) -> Contact in
                let phoneNumber = phoneNumber as! String
                return Contact.existing(withPhoneNumber: phoneNumber, rootRef: rootRef, inContext: context) ?? Contact.new(forPhoneNumber: phoneNumber, rootRef: rootRef, inContext: context)
            }
            let name = data["name"] as? String
            context.performBlock{
                chat.participants = NSSet(array: participants)
                chat.name = name
                do{
                    try context.save()
                }
                catch{
                    print("Error saving new Chat")
                }
            }
        })
        return chat
    }
    
    static func existing(storageId storageId: String, inContext context: NSManagedObjectContext) -> Chat? {
        let request = NSFetchRequest(entityName: "Chat")
        request.predicate = NSPredicate(format: "storageId = %@", storageId)
        do{
            if let results = try context.executeFetchRequest(request) as? [Chat] where results.count > 0 {
                if let chat = results.first{
                    return chat
                }
            }
        }
        catch{
            print("Error Fetching Chats")
        }
        return nil
    }
    
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