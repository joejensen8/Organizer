//
//  MyTaskViewController.swift
//  Organizer
//
//  Created by Joseph Jensen on 3/29/16.
//  Copyright © 2016 Joseph Jensen. All rights reserved.
//

import UIKit

class MyTaskViewController: UIViewController {

    var task: Task?
    
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dueDateLabel: UILabel!
    @IBOutlet weak var notesTextView: UITextView!
    
    var incomingTaskName: String?
    var incomingTaskDescription: String?
    var incomingDueDate: NSDate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadTextFields()
        self.hideKeyboardWhenTappedAround()
    }
    
    override func viewWillDisappear(animated: Bool) {
        // need to save notes to task
        saveNotes()
    }
    
    private func saveNotes() {
        task?.notes = notesTextView.text
        try! task?.managedObjectContext?.save()
    }
    
    private func loadTextFields() {
        nameLabel.text = task?.name
        descriptionLabel.text = task?.subName
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "EEE, MMM dd"
        if let date = task?.dueDate {
            dueDateLabel.text = dateFormatter.stringFromDate(date)
        } else {
            dueDateLabel.text = "None"
        }
        notesTextView.text = task?.notes
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        saveNotes()
        if segue.identifier == "toEditTask" {
            if let vc = segue.destinationViewController as? EditTaskViewController {
                if let name = task?.name {
                    vc.taskName = name
                }
                if let desc = task?.subName {
                    vc.taskDesc = desc
                }
                if let due = task?.dueDate {
                    vc.dueDate = due
                }
                task?.editing = true
            }
        }
    }
    
    @IBAction func unwindFromEditTask(segue: UIStoryboardSegue) {
        var name: String = ""
        var description: String = ""
        var dueDate: NSDate?
        
        if let myName = incomingTaskName {
            name = myName
            incomingTaskName = nil
        }
        if let myDescription = incomingTaskDescription {
            description = myDescription
            incomingTaskDescription = nil
        }
        if let myDate = incomingDueDate {
            dueDate = myDate
            incomingDueDate = nil
        }

        if name != "" {
            task?.name = name
            task?.subName = description
            if let date = dueDate {
                task?.dueDate = date
            }
            loadTextFields()
            try! task?.managedObjectContext?.save()
        }
    }
 
}
