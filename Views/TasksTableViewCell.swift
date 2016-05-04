//
//  TasksTableViewCell.swift
//  Organizer
//
//  Created by Joseph Jensen on 4/8/16.
//  Copyright © 2016 Joseph Jensen. All rights reserved.
//

import Foundation
import UIKit

class TasksTableViewCell: UITableViewCell {
    
    @IBOutlet weak var TitleLabel: UILabel!
    @IBOutlet weak var DateLabel: UILabel!
    
    func loadItem(title: String, subtitle: String, date: NSDate) {
        TitleLabel.text = title
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "EEE, MMM dd"
        DateLabel.text = dateFormatter.stringFromDate(date)
    }
    
    func loadItem(title: String, subtitle: String) {
        TitleLabel.text = title
        DateLabel.text = "None"
    }
}
