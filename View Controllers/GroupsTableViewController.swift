//
//  GroupsTableViewController.swift
//  Organizer
//
//  Created by Joseph Jensen on 3/29/16.
//  Copyright © 2016 Joseph Jensen. All rights reserved.
//

import UIKit
import CoreData

class GroupsTableViewController: UITableViewController {
    
    var groups = [Group]()
    var incomingNewGroupName: String?
    var incomingNewGroupDescriptor: String?
    var rowEditButtonPressed: Int = 0
    
    override func viewDidAppear(animated: Bool) {
        fetchGroupData()
        self.tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchGroupData()
    }
    
    @IBAction func editButtonPressed(sender: UIBarButtonItem) {
        self.editing = !self.editing
        
        // try to get edit button in each cell to be disabled and disappear
        
        // switch name of button when editing to cancel
        let edit = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Edit, target: self, action: #selector(GroupsTableViewController.editButtonPressed(_:)))
        let done = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Done, target: self, action: #selector(GroupsTableViewController.editButtonPressed(_:)))
        
        if self.editing {
            navigationBar.setLeftBarButtonItems([done], animated: true)
        } else {
            navigationBar.setLeftBarButtonItems([edit], animated: true)
        }
    }
    
    @IBOutlet weak var navigationBar: UINavigationItem!
    
    private func saveContext() {
        let moc = AppDelegate.sharedManagedObjectContext
        do {
            try moc.save()
        } catch {
            print ("error saving")
        }
    }
    
    private func fetchGroupData() {
        groups.removeAll()
        let moc = AppDelegate.sharedManagedObjectContext
        let fetchRequest = NSFetchRequest(entityName: "Group")
        
        do {
            groups = try moc.executeFetchRequest(fetchRequest) as! [Group]
        } catch {
            fatalError("Failed to fetch groups: \(error)")
        }
        sortGroups()
        //addAllTasksGroup()
    }
    
    private func sortGroups() {
        groups.sortInPlace({ $0.name?.lowercaseString < $1.name?.lowercaseString })
    }
    

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groups.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: GroupTableViewCell = tableView.dequeueReusableCellWithIdentifier("groups", forIndexPath: indexPath) as! GroupTableViewCell

        // Configure the cell...
        let label = groups[indexPath.row]
        
        cell.loadItem(label.name!, subtitle: label.subName!)
        cell.EditButton.tag = indexPath.row
        cell.EditButton.addTarget(self, action: #selector(GroupsTableViewController.toEditController), forControlEvents: .TouchUpInside)

        if indexPath.item % 2 == 1 {
            cell.TitleLabel.textColor = UIColor.darkGrayColor()
        }

        return cell
    }
    
    func toEditController (sender: UIButton) {
        rowEditButtonPressed = sender.tag
        print(rowEditButtonPressed)
        self.performSegueWithIdentifier("editGroup", sender: self)
    }

    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            let moc = AppDelegate.sharedManagedObjectContext
            moc.deleteObject(groups[indexPath.row] as NSManagedObject)
            groups.removeAtIndex(indexPath.row)
            saveContext()
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }

    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "toMyGroup" {
            if let vc = segue.destinationViewController as? TasksTableViewController {
                if let selectedGroup = tableView.indexPathForSelectedRow?.row {
                    // give reference of the group to task view controller
                    vc.group = groups[selectedGroup]
                }
            }
        }

        if segue.identifier == "editGroup" {
            if let vc = segue.destinationViewController as? EditGroupViewController {
                if let myName = groups[rowEditButtonPressed].name {
                    vc.groupName = myName
                }
                if let myDesc = groups[rowEditButtonPressed].subName {
                    vc.groupDescriptor = myDesc
                }
                groups[rowEditButtonPressed].editing = true
                
            }
        }
    }
    
    @IBAction func unwindToGroups(segue: UIStoryboardSegue) {
        // need to create new group and save it to core data
        var name: String = ""
        var description: String = ""
        if let myName = incomingNewGroupName {
            name = myName
            incomingNewGroupName = nil
        }
        if let myDescription = incomingNewGroupDescriptor {
            description = myDescription
            incomingNewGroupDescriptor = nil
        }
        if name != "" {
            _ = Group(name: name, subName: description)
            //try! temp.managedObjectContext?.save()
            saveContext()
            fetchGroupData()
            self.tableView.reloadData()
        }
    }
    
    @IBAction func unwindFromEditGroup(segue: UIStoryboardSegue) {
        var name: String = ""
        var description: String = ""
        
        if let myName = incomingNewGroupName {
            name = myName
            incomingNewGroupName = nil
        }
        if let myDescription = incomingNewGroupDescriptor {
            description = myDescription
            incomingNewGroupDescriptor = nil
        }
        
        if name != "" {
            for g in groups {
                if g.editing == true { // bad style saying a boolean == true, but it doesn't work if I don't put the '== true' part
                    g.editing = false
                    g.name = name
                    g.subName = description
                    //try! g.managedObjectContext?.save()
                }
            }
            saveContext()
            fetchGroupData()
            self.tableView.reloadData()
        }
    }
    
}
