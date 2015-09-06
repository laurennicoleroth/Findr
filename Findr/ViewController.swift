//
//  ViewController.swift
//  Findr
//
//  Created by Lauren Nicole Roth on 8/28/15.
//  Copyright (c) 2015 Findr. All rights reserved.
//

import UIKit
import Parse
import Bolts
import ParseFacebookUtilsV4

class ViewController: UIViewController {
    
    @IBOutlet weak var loginCancelledLabel: UILabel!
    
    @IBAction func signIn(sender: AnyObject) {
        let permissions = ["public_profile", "email"]
        self.loginCancelledLabel.alpha = 0.0
        

        PFFacebookUtils.logInInBackgroundWithReadPermissions(permissions as [AnyObject]) {
            (user: PFUser?, error: NSError?) -> Void in
            if let user = user {
                if user.isNew {
                    println("User signed up and logged in through Facebook!")
                    
                    self.performSegueWithIdentifier("signUp", sender: self)
                    
                } else {
                    println("User logged in through Facebook!")
                    self.performSegueWithIdentifier("signUp", sender: self)
                }
            } else {
                println("Uh oh. The user cancelled the Facebook login.")
                self.loginCancelledLabel.alpha = 1.0
            }
        }
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

