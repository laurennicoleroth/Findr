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
    
//    var fbloginView = FBLoginView(readPermissions: ["email", "public_profile"])
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Setup Push Notifications
//        let push = PFPush()
//        push.setChannel("Match")
//        push.setMessage("You and someone else just matched!")
//        push.sendPushInBackground()
//        
//        self.loginCancelledLabel.alpha = 0

    }
    
    @IBAction func signIn(sender: AnyObject) {
        
        let permissions = [ "email", "public_profile"]

        self.loginCancelledLabel.alpha = 0
        
        var user1 = PFUser.currentUser()
        println(user1)
        
        PFFacebookUtils.logInInBackgroundWithReadPermissions(permissions) {
            (user: PFUser?, error: NSError?) -> Void in
            if let user = user {
                if user.isNew {
                    println("User signed up and logged in through Facebook!")
                } else {
                    println("User logged in through Facebook!")
                }
            } else {
                println("Uh oh. The user cancelled the Facebook login.")
                self.loginCancelledLabel.alpha = 1.0
            }
        }
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


}

