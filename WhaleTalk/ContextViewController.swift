//
//  ContextViewController.swift
//  WhaleTalk
//
//  Created by Koen Hendriks on 11/05/16.
//  Copyright © 2016 Koen Hendriks. All rights reserved.
//

import Foundation
import CoreData

protocol ContextViewController {
    var context: NSManagedObjectContext?{get set}
}