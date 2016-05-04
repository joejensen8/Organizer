//
//  GroupTableViewCell.swift
//  Organizer
//
//  Created by Joseph Jensen on 4/6/16.
//  Copyright © 2016 Joseph Jensen. All rights reserved.
//

import Foundation
import UIKit

class GroupTableViewCell: UITableViewCell {
    
    @IBOutlet weak var TitleLabel: UILabel!
    @IBOutlet weak var EditButton: UIButton!
    
    func loadItem(title: String, subtitle: String) {
        if subtitle != "" {
            TitleLabel.text = "\(title) - \(subtitle)"
        } else {
            TitleLabel.text = title
        }
    }
}
