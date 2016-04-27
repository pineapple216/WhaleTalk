//
//  ChatCreationDelegate.swift
//  WhaleTalk
//
//  Created by Koen Hendriks on 27/04/16.
//  Copyright © 2016 Koen Hendriks. All rights reserved.
//

import Foundation
import CoreData

protocol ChatCreationDelegate {
    
    func created(chat chat: Chat, inContext context: NSManagedObjectContext)
}