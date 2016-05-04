//
//  Task+CoreDataProperties.swift
//  Organizer
//
//  Created by Joseph Jensen on 4/13/16.
//  Copyright © 2016 Joseph Jensen. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Task {

    @NSManaged var dueDate: NSDate?
    @NSManaged var editing: NSNumber?
    @NSManaged var name: String?
    @NSManaged var notes: String?
    @NSManaged var subName: String?
    @NSManaged var group: Group?

}
