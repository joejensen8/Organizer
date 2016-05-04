//
//  AddTaskViewController.swift
//  Organizer
//
//  Created by Joseph Jensen on 3/29/16.
//  Copyright © 2016 Joseph Jensen. All rights reserved.
//

import UIKit

class AddTaskViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var taskNameTextField: UITextField!
    @IBOutlet weak var taskDescriptionTextField: UITextField!
    @IBOutlet weak var taskDueDateTextField: UITextField!
    var dueDate: NSDate?
    
    var datePicker = UIDatePicker()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        datePicker.datePickerMode = UIDatePickerMode.Date
        taskDueDateTextField.inputView = datePicker
        datePicker.addTarget(self, action: #selector(AddTaskViewController.datePickerUpdate(_:)), forControlEvents: UIControlEvents.ValueChanged)
    }

    func datePickerUpdate(sender: UIDatePicker) {
        let timeFormatter = NSDateFormatter()
        timeFormatter.dateStyle = .LongStyle
        timeFormatter.timeStyle = .NoStyle
        taskDueDateTextField.text = timeFormatter.stringFromDate(sender.date)
        dueDate = sender.date
    }
    

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "unwindFromAddNewTask" {
            if let vc = segue.destinationViewController as? TasksTableViewController {
                // should do some defensive programming and not let user input all spaces
                
                if let name = taskNameTextField.text{
                    if name != "" { vc.incomingNewTaskName = name }
                    else { vc.incomingNewTaskName = nil }
                } else {
                    vc.incomingNewTaskName = nil
                }
                if let desc = taskDescriptionTextField.text {
                    if desc != "" { vc.incomingNewTaskDescriptor = desc }
                    else { vc.incomingNewTaskDescriptor = nil }
                } else {
                    vc.incomingNewTaskDescriptor = nil
                }
                if let date = dueDate {
                    vc.incomingNewTaskDueDate = date
                } else {
                    vc.incomingNewTaskDueDate = nil
                }
            }
        }
    }

}
