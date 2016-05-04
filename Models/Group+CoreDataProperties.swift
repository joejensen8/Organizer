//
//  Group+CoreDataProperties.swift
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

extension Group {

    @NSManaged var editing: NSNumber?
    @NSManaged var name: String?
    @NSManaged var subName: String?
    @NSManaged var tasks: NSSet?

}
