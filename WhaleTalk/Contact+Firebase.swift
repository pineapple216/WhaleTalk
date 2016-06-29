//
//  Contact+Firebase.swift
//  WhaleTalk
//
//  Created by Koen Hendriks on 29/06/16.
//  Copyright © 2016 Koen Hendriks. All rights reserved.
//

import Foundation
import Firebase
import CoreData

extension Contact: FirebaseModel{
    
    static func new(forPhoneNumber phoneNumberVal: String, rootRef: Firebase, inContext context: NSManagedObjectContext) -> Contact {
        let contact = NSEntityDescription.insertNewObjectForEntityForName("Contact", inManagedObjectContext: context) as! Contact
        let phoneNumber = NSEntityDescription.insertNewObjectForEntityForName("PhoneNumber", inManagedObjectContext: context) as! PhoneNumber
        phoneNumber.contact = contact
        phoneNumber.registered = true
        phoneNumber.value = phoneNumberVal
        contact.getContactId(context, phoneNumber: phoneNumberVal, rootRef: rootRef)
        return contact
    }
    
    static func existing(withPhoneNumber phoneNumber: String, rootRef: Firebase, inContext context: NSManagedObjectContext) -> Contact? {
        
        let request = NSFetchRequest(entityName: "phoneNumber")
        request.predicate = NSPredicate(format: "value = %@", phoneNumber)
        
        do{
            if let results = try context.executeFetchRequest(request) as? [PhoneNumber] where results.count > 0 {
                let contact = results.first!.contact!
                
                if contact.storageId == nil{
                    contact.getContactId(context, phoneNumber: phoneNumber, rootRef: rootRef)
                }
                return contact
            }
        }
        catch{print("Error Fetching")}
        return nil
    }
    
    func getContactId(context: NSManagedObjectContext, phoneNumber: String, rootRef: Firebase){
        rootRef.childByAppendingPath("users").queryOrderedByChild("phoneNumber").queryEqualToValue(phoneNumber).observeSingleEventOfType(.Value, withBlock: {
            snapshot in
            guard let user = snapshot.value as? NSDictionary else {return}
            let uid = user.allKeys.first as? String
            context.performBlock{
                self.storageId = uid
                do{
                    try context.save()
                }catch {print("Error saving")}
            }
        })
    }
    
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
                    self.observeStatus(rootRef, context: context)
                })
            })
        }
    }
    
    func observeStatus(rootRef: Firebase, context: NSManagedObjectContext){
        rootRef.childByAppendingPath("users/"+storageId!+"/status").observeEventType(.Value, withBlock: { snapshot in
            guard let status = snapshot.value as? String else {return}
            context.performBlock{
                self.status = status
                do{
                    try context.save()
                }
                catch{
                    print("Error saving")
                }
            }
        })
    }
}