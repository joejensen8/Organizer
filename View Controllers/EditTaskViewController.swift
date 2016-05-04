//
//  EditTaskViewController.swift
//  Organizer
//
//  Created by Joseph Jensen on 4/6/16.
//  Copyright © 2016 Joseph Jensen. All rights reserved.
//

import UIKit

class EditTaskViewController: UIViewController {

    @IBOutlet weak var taskNameTextField: UITextField!
    @IBOutlet weak var taskDescriptionTextField: UITextField!
    @IBOutlet weak var dueDateTextField: UITextField!
    
    var date: NSDate?
    
    var taskName: String?
    var taskDesc: String?
    var dueDate: NSDate?
    
    var datePicker = UIDatePicker()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        
        if let name = taskName {
            taskNameTextField.text = name
        }
        if let desc = taskDesc {
            taskDescriptionTextField.text = desc
        }
        if let dd = dueDate {
            let timeFormatter = NSDateFormatter()
            timeFormatter.dateStyle = .LongStyle
            timeFormatter.timeStyle = .NoStyle
            dueDateTextField.text = timeFormatter.stringFromDate(dd)
        }
        
        datePicker.datePickerMode = UIDatePickerMode.Date
        dueDateTextField.inputView = datePicker
        datePicker.addTarget(self, action: #selector(AddTaskViewController.datePickerUpdate(_:)), forControlEvents: UIControlEvents.ValueChanged)
    }
    
    func datePickerUpdate(sender: UIDatePicker) {
        let timeFormatter = NSDateFormatter()
        timeFormatter.dateStyle = .LongStyle
        timeFormatter.timeStyle = .NoStyle
        dueDateTextField.text = timeFormatter.stringFromDate(sender.date)
        date = sender.date
    }

    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "unwindFromEditTask" {
            if let vc = segue.destinationViewController as? MyTaskViewController {
                // send over data to my task
                if let name = taskNameTextField.text{
                    if name != "" { vc.incomingTaskName = name }
                    else { vc.incomingTaskName = nil }
                } else {
                    vc.incomingTaskName = nil
                }
                if let desc = taskDescriptionTextField.text {
                    if desc != "" { vc.incomingTaskDescription = desc }
                    else { vc.incomingTaskDescription = nil }
                } else {
                    vc.incomingTaskDescription = nil
                }
                if let dd = date {
                    vc.incomingDueDate = dd
                } else {
                    vc.incomingDueDate = nil
                }
            }
        }
    }

}
