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

    override func viewDidLoad() {
        super.viewDidLoad()
        
        var user = PFUser()
        user.username = "myUsername"
        user.password = "myPassword"
        user.email = "email@example.com"
        
        user.signUpInBackgroundWithBlock {
            (succeeded: Bool, error: NSError?) -> Void in
            if let error = error {
                let errorString = error.userInfo?["error"] as? NSString
                // Show the errorString somewhere and let the user try again.
            } else {
                // Hooray! Let them use the app now.
            }
        }
        
        facebookLogin()
    }
    
    @IBAction func facebookLogin() {
        let permissions = ["public_profile", "email"]
        
        PFFacebookUtils.logInInBackgroundWithReadPermissions(permissions as [AnyObject]) {
            (user: PFUser?, error: NSError?) -> Void in
            if let user = user {
                if user.isNew {
                    println("User signed up and logged in through Facebook!")
                } else {
                    println("User logged in through Facebook!")
                }
            } else {
                println("Uh oh. The user cancelled the Facebook login.")
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

