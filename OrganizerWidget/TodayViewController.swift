//
//  TodayViewController.swift
//  OrganizerWidget
//
//  Created by Joseph Jensen on 4/13/16.
//  Copyright © 2016 Joseph Jensen. All rights reserved.
//

import UIKit
import NotificationCenter

class TodayViewController: UIViewController, NCWidgetProviding {
    
    @IBOutlet weak var firstLabel: UILabel!
    @IBOutlet weak var secondLabel: UILabel!
    @IBOutlet weak var thirdLabel: UILabel!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // These are hardcoded examples: can't access core data in extension without App Group - which requires a Developer Account
        firstLabel.text = "Exam - Thu, Apr 28"
        secondLabel.text = "Exam - Fri, Apr 29"
        thirdLabel.text = "Presentation - Mon, May 2"
    }
    
    func widgetPerformUpdateWithCompletionHandler(completionHandler: ((NCUpdateResult) -> Void)) {
        // Perform any setup necessary in order to update the view.

        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData

        completionHandler(NCUpdateResult.NewData)
    }
    
}
