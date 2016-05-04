//
//  Group.swift
//  Organizer
//
//  Created by Joseph Jensen on 4/4/16.
//  Copyright © 2016 Joseph Jensen. All rights reserved.
//

import Foundation
import CoreData


class Group: NSManagedObject {

    convenience init (name: String, subName: String) {
        self.init(managedObjectContext: AppDelegate.sharedManagedObjectContext)
        self.name = name
        self.subName = subName
        self.editing = false
    }

}
