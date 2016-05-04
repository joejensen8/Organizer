//
//  TasksTableViewController.swift
//  Organizer
//
//  Created by Joseph Jensen on 3/29/16.
//  Copyright © 2016 Joseph Jensen. All rights reserved.
//

import UIKit
import CoreData

class TasksTableViewController: UITableViewController {
    
    var group: Group?
    var tasks = [Task]()
    var incomingNewGroupName: String?
    var incomingNewGroupDescriptor: String?
    var incomingNewTaskName: String?
    var incomingNewTaskDescriptor: String?
    var incomingNewTaskDueDate: NSDate?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = group?.name
        reloadTaskData()
    }
    
    override func viewDidAppear(animated: Bool) {
        self.tableView.reloadData()
        self.title = group?.name
    }
    
    @IBOutlet weak var navigationBar: UINavigationItem!
    
    // changes left bar button... needs to change the edit button!
    @IBAction func editButtonPressed(sender: UIBarButtonItem) {
         self.editing = !self.editing
         
         // switch name of button when editing to cancel
         let edit = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Edit, target: self, action: #selector(GroupsTableViewController.editButtonPressed(_:)))
         let done = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Done, target: self, action: #selector(GroupsTableViewController.editButtonPressed(_:)))
         
         if self.editing {
            navigationBar.rightBarButtonItems?.removeLast()
            navigationBar.rightBarButtonItems?.append(done)
         } else {
            navigationBar.rightBarButtonItems?.removeLast()
            navigationBar.rightBarButtonItems?.append(edit)
         }
    }

    private func saveContext() {
        let moc = AppDelegate.sharedManagedObjectContext
        do {
            try moc.save()
        } catch {
            print ("error saving")
        }
    }
    
    private func reloadTaskData() {
        tasks.removeAll()
        // assign set of tasks to task array
        for t in (group?.tasks)! {
            tasks.append(t as! Task)
        }
        sortTaskData()
    }
    
    private func sortTaskData() {
        var tasksWithDate = [Task]()
        var tasksWithoutDate = [Task]()
        
        // Go through tasks and seperate tasks with date and tasks without date
        for task in tasks {
            if task.dueDate != nil {
                tasksWithDate.append(task)
            } else {
                tasksWithoutDate.append(task)
            }
        }
        
        // Sort tasks that have dates - earlier dates at the beginning with later dates at the end
        tasksWithDate.sortInPlace({ $0.dueDate!.compare($1.dueDate!) == NSComparisonResult.OrderedAscending })
        tasks.removeAll()
        tasks = tasksWithDate + tasksWithoutDate
    }
    

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("taskCell", forIndexPath: indexPath) as! TasksTableViewCell

        // Configure the cell...
        
        let label = tasks[indexPath.row]
        
        var name: String = ""
        var desc: String = ""
        
        if let myName = label.name {
            name = myName
        }
        if let myDesc = label.subName {
            desc = myDesc
        }
        if let myDate = label.dueDate {
            cell.loadItem(name, subtitle: desc, date: myDate)
        } else {
            cell.loadItem(name, subtitle: desc)
        }
        
        // coloring the due date text
        if let date = tasks[indexPath.row].dueDate {
            // compare with current date to set color
            let today = NSDate()
            
            let diffDateComponents = NSCalendar.currentCalendar().components([NSCalendarUnit.Year, NSCalendarUnit.Month, NSCalendarUnit.Day, NSCalendarUnit.Hour, NSCalendarUnit.Minute, NSCalendarUnit.Second], fromDate: today, toDate: date, options: NSCalendarOptions.init(rawValue: 0))
            
            if diffDateComponents.day < 1 {
                cell.DateLabel.textColor = UIColor.redColor()
            } else if diffDateComponents.day < 3 {
                cell.DateLabel.textColor = UIColor(colorLiteralRed: 221, green: 0, blue: 246, alpha: 1)
            } else {
                cell.DateLabel.textColor = UIColor.blueColor()
            }
            
        }

        return cell
    }

    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            // need to delete from core data here
            
            let moc = AppDelegate.sharedManagedObjectContext
            moc.deleteObject(tasks[indexPath.row] as NSManagedObject)
            tasks.removeAtIndex(indexPath.row)
            try! group?.managedObjectContext!.save()
            saveContext()
            self.tableView.reloadData()
            
            // tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "toMyTask" {
            if let vc = segue.destinationViewController as? MyTaskViewController {
                if let selectedTask = tableView.indexPathForSelectedRow?.row {
                    vc.task = tasks[selectedTask]
                }
            }
        }
    }
    
    // Unwind function that sets data accordingly when coming back from adding a new task
    @IBAction func unwindFromAddNewTask(segue: UIStoryboardSegue) {
        // need to grab 3 variables and save task to core data
        // need to create new group and save it to core data
        var name: String = ""
        var description: String = ""
        var date: NSDate?
        if let myName = incomingNewTaskName {
            name = myName
            incomingNewTaskName = nil
        }
        if let myDescription = incomingNewTaskDescriptor {
            description = myDescription
            incomingNewTaskDescriptor = nil
        }
        if let myDate = incomingNewTaskDueDate {
            date = myDate
            incomingNewTaskDueDate = nil
        } else {
            date = nil
        }
        if name != "" {
            let task = Task(name: name, subName: description, dueDate: date)
            group?.tasks =  group?.tasks?.setByAddingObject(task)
            try! task.managedObjectContext?.save()
            reloadTaskData()
            self.tableView.reloadData()
        }
    }

}
