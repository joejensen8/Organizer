//
//  AddGroupViewController.swift
//  Organizer
//
//  Created by Joseph Jensen on 3/29/16.
//  Copyright © 2016 Joseph Jensen. All rights reserved.
//

import UIKit

class AddGroupViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var groupNameTextField: UITextField!
    @IBOutlet weak var groupDescriptorTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTextFieldDelegation()
        self.hideKeyboardWhenTappedAround()
    }
    
    private func setupTextFieldDelegation() { // meaningless method name
        groupNameTextField.delegate = self
        groupDescriptorTextField.delegate = self
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if (textField === groupNameTextField) {
            groupDescriptorTextField.becomeFirstResponder()
        } else if (textField === groupDescriptorTextField) {
            groupDescriptorTextField.resignFirstResponder()
        }
        
        return true
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "unwindToGroups" {
            if let vc = segue.destinationViewController as? GroupsTableViewController {
                // pass to the groups view controller the newly constructed group
                // should do some defensive programming and not let a ton of spaces create group
                
                if let name = groupNameTextField.text{
                    if name != "" { vc.incomingNewGroupName = name }
                    else { vc.incomingNewGroupName = nil }
                } else {
                    vc.incomingNewGroupName = nil
                }
                if let desc = groupDescriptorTextField.text {
                    if desc != "" { vc.incomingNewGroupDescriptor = desc }
                    else { vc.incomingNewGroupDescriptor = nil }
                } else {
                    vc.incomingNewGroupDescriptor = nil
                }
            }
        }
    }

}
