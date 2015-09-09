//
//  SignUpViewController.swift
//  Findr
//
//  Created by Lauren Nicole Roth on 9/1/15.
//  Copyright (c) 2015 Findr. All rights reserved.
//

import UIKit
import Parse
import Bolts
import ParseFacebookUtilsV4

class SignUpViewController: UIViewController {


    @IBOutlet var genderSwitch: UISwitch!
    @IBOutlet var profilePic: UIImageView!
    @IBOutlet var signUp: UIButton!
    @IBOutlet var userNameLabel: UILabel!
    
    override func viewDidLoad() {
       super.viewDidLoad()
    }
    

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func signUp(sender: AnyObject) {
        
        var currentUser = PFUser.currentUser() as PFUser!
        
        if genderSwitch.on {
            currentUser["preference"] = "women"

        } else {
            currentUser["preference"] = "men"
        }
        
        currentUser.saveInBackground()
        
        storeFacebookData()
        storeLocation()
    }
    
    
    func storeFacebookData() {
        let currentUser = PFUser.currentUser() as PFUser!
        var fbRequest = FBSDKGraphRequest(graphPath: "me", parameters:
            ["fields": "id, email, gender, picture, first_name, last_name, bio"])
        fbRequest.startWithCompletionHandler({ (FBSDKGraphRequestConnection, result, error) -> Void in
            if (error == nil && result != nil) {
                let facebookData = result as! NSDictionary
                let userEmail = (facebookData.objectForKey("email") as! String)
                let userGender = (facebookData.objectForKey("gender") as! String)
                let userFirstName = (facebookData.objectForKey("first_name") as! String)
                let userLastName = (facebookData.objectForKey("last_name") as! String)
                let userId = (facebookData.objectForKey("id") as! String)
                
                var imgURLString = "http://graph.facebook.com/" + (userId as String) + "/picture?type=large"
                var imgURL: NSURL = NSURL(string: imgURLString)!
                let request: NSURLRequest = NSURLRequest(URL: imgURL)
                NSURLConnection.sendAsynchronousRequest(
                    request, queue: NSOperationQueue.mainQueue(),
                    completionHandler: {(response: NSURLResponse!,data: NSData!,error: NSError!) -> Void in
                        if error == nil {
                            var image = UIImage(data: data)
                            var file = PFFile(data: UIImageJPEGRepresentation(image, 1.0))
                            currentUser["picture"] = file
                            currentUser["fullname"] = userFirstName + " " + userLastName
                            currentUser["gender"] = userGender
                            currentUser["email"] = userEmail
                            currentUser.saveInBackground()
                        }
                })
            } else {
                println("something went wrong in the request")
            }
            
        })
        
    }
    
    func storeLocation() {
        PFGeoPoint.geoPointForCurrentLocationInBackground {
            (geoPoint: PFGeoPoint?, error: NSError?) -> Void in
            if error == nil {
                var user = PFUser.currentUser() as PFUser!
                user["location"] = geoPoint
                user.saveInBackground()
                
            } else {
                println(error)
            }
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
