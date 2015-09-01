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
    
    var xFromCenter:CGFloat = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    func loadPositiveSingle() {
        var positiveSingle: UILabel = UILabel(frame: CGRectMake(self.view.bounds.width / 2 - 100, self.view.bounds.height / 2 - 50, 200, 100))
        positiveSingle.text = "Positive Single"
        positiveSingle.textAlignment = NSTextAlignment.Center
        self.view.addSubview(positiveSingle)
        
        var gesture = UIPanGestureRecognizer(target: self, action: Selector("wasDragged:"))
        positiveSingle.addGestureRecognizer(gesture)
        
        positiveSingle.userInteractionEnabled = true
    }
    
    @IBAction func signIn(sender: AnyObject) {
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
    
    @IBAction func facebookLogin() {
            }
    
    func createProfile() {
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
    }
    
    func wasDragged(gesture: UIPanGestureRecognizer) {
        
        let translation = gesture.translationInView(self.view)
        var positiveSingle = gesture.view!
        
        xFromCenter += translation.x
        
        var scale = min(100 / abs(xFromCenter), 1)
        
        positiveSingle.center = CGPoint(x: positiveSingle.center.x + translation.x, y: positiveSingle.center.y + translation.y)
        
        gesture.setTranslation(CGPointZero, inView: self.view)
        
        var rotation:CGAffineTransform = CGAffineTransformMakeRotation(xFromCenter / 200)
        positiveSingle.transform = rotation
        
        var stretch:CGAffineTransform = CGAffineTransformScale(rotation, scale, scale)
        
        positiveSingle.transform = stretch
        
        if positiveSingle.center.x < 100 {
            println("Not Chosen")
        } else if positiveSingle.center.x > self.view.bounds.width - 100 {
            println("Chosen")
        }

        if gesture.state == UIGestureRecognizerState.Ended {
            
            positiveSingle.center = CGPointMake(self.view.bounds.width / 2, self.view.bounds.height / 2)
            
            scale = max(abs(xFromCenter)/100, 1)
            rotation = CGAffineTransformMakeRotation(0)
            stretch = CGAffineTransformScale(rotation, scale, scale)
            
            positiveSingle.transform = stretch
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

