//
//  loginController.swift
//  firewater
//
//  Created by Preksha Koirala on 4/29/16.
//  Copyright © 2016 Preksha Koirala. All rights reserved.
//

import Foundation
import UIKit


class loginController:UIViewController{
    
    @IBOutlet weak var memailField: UITextField!
    @IBOutlet weak var mpassField: UITextField!
    
    @IBOutlet weak var mloginButton: UIButton!
    @IBOutlet weak var msignupButton: UIButton!
    
    
    
    @IBAction func mloginAction(sender: AnyObject) {
        
        firebaseStuff.sharedInstance.doLogin(memailField.text!, pass:mpassField.text!);
        
        
    }
    
    
    
    @IBAction func msignupAction(sender: AnyObject) {
        
        firebaseStuff.sharedInstance.createUser(memailField.text!, pass:mpassField.text!);
        
        
    }
    
    
    
}