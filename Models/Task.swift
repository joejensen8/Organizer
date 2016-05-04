//
//  Task.swift
//  Organizer
//
//  Created by Joseph Jensen on 4/4/16.
//  Copyright © 2016 Joseph Jensen. All rights reserved.
//

import Foundation
import CoreData


class Task: NSManagedObject {

    convenience init (name: String, subName: String, dueDate: NSDate?) {
        self.init(managedObjectContext: AppDelegate.sharedManagedObjectContext)
        self.name = name
        self.subName = subName
        if let date = dueDate {
            self.dueDate = date
        } else {
            self.dueDate = nil
        }
        self.dueDate = dueDate
        self.editing = false
        self.notes = ""
    }
    
}