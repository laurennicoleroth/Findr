//
//  SignUpViewController.swift
//  Findr
//
//  Created by Lauren Nicole Roth on 8/31/15.
//  Copyright (c) 2015 Findr. All rights reserved.
//

import Foundation
import Parse
import Bolts
import ParseFacebookUtilsV4

class SignUpViewController: UIViewController {
    
    @IBOutlet var genderSwitch: UISwitch!
    
    @IBAction func signUp(sender: AnyObject) {
        
        var user = PFUser.currentUser()
        
        if genderSwitch.on {
//            user["interestedIn"] = "female"
        } else {
//            user["interestedIn"] = "male"
        }
//        user.save()
        
    }
    
    @IBOutlet var profilePic: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var user = PFUser.currentUser()
 
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
