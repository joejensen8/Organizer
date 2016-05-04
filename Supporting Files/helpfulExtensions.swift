//
//  managedObjectExtension.swift
//  Organizer
//
//  Created by Joseph Jensen on 4/6/16.
//  Copyright © 2016 Joseph Jensen. All rights reserved.
//

import Foundation
import CoreData
import UIKit

extension NSManagedObject {
    public class func entityName() -> String {
        let name = NSStringFromClass(self)
        return name.componentsSeparatedByString(".").last!
    }
    
    convenience init(managedObjectContext: NSManagedObjectContext) {
        let entityName = self.dynamicType.entityName()
        let entity = NSEntityDescription.entityForName(entityName, inManagedObjectContext: managedObjectContext)!
        self.init(entity: entity, insertIntoManagedObjectContext: managedObjectContext)
    }
}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
}
