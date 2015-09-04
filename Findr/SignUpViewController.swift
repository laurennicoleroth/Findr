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
    @IBOutlet var aboutText: UITextView!
    
    
    override func viewDidLoad() {
       super.viewDidLoad()

      facebookGraphRequest()
        
//       getUserProfile()
    }
    
    func getUserProfile() {
        var query = PFQuery(className:"Profile")
        let username = String(stringInterpolationSegment: PFUser.currentUser()!.username!)
        query.whereKey("createdBy", equalTo: username)
        query.findObjectsInBackgroundWithBlock {
            (objects: [AnyObject]?, error: NSError?) -> Void in
            if error == nil {
                if let objects = objects as? [PFObject] {
                    for object in objects {
                        self.userNameLabel.text = object["fullName"] as? String
                        if let userPicture = object["image"] as? PFFile {
                            userPicture.getDataInBackgroundWithBlock { (imageData: NSData?, error: NSError?) -> Void in
                                if (error == nil) {
                                    self.profilePic.image = UIImage(data:imageData!)
                                }
                            }
                        }
                    }
                }
                
            } else {
                // Log details of the failure
                println("Error: \(error!) \(error!.userInfo!)")
                self.facebookGraphRequest()
            }
        }
    }
    
    func facebookGraphRequest() {
        var fbRequest = FBSDKGraphRequest(graphPath: "me", parameters:
            ["fields": "id, email, gender, picture, first_name, last_name, bio"])
        fbRequest.startWithCompletionHandler({ (FBSDKGraphRequestConnection, result, error) -> Void in
            
            if (error == nil && result != nil) {
                let facebookData = result as! NSDictionary //FACEBOOK DATA IN DICTIONARY
                let userEmail = (facebookData.objectForKey("email") as! String)
                let userGender = (facebookData.objectForKey("gender") as! String)
                let userFirstName = (facebookData.objectForKey("first_name") as! String)
                let userLastName = (facebookData.objectForKey("last_name") as! String)
                self.userNameLabel.text = userFirstName + " " + userLastName
                //                let userPicture = (facebookData.objectForKey("picture"))
                let userId = (facebookData.objectForKey("id") as! String)
                
                var imgURLString = "http://graph.facebook.com/" + (userId as String) + "/picture?type=large"
                var imgURL = NSURL(string: imgURLString)
                var imageData = NSData(contentsOfURL: imgURL!)
                if let url  = NSURL(string: imgURLString),
                    image = NSData(contentsOfURL: url)
                {
                    self.profilePic.image = UIImage(data: image)
                    var currentUser = PFUser.currentUser() as! PFUser!
                    if currentUser != nil {
                        let imageData = UIImagePNGRepresentation(self.profilePic.image)
                        let imageFile = PFFile(name:"profile.png", data:imageData)
                        
                        currentUser["fullname"] = userFirstName + " " + userLastName
                        currentUser.saveInBackground()
                        
                    } else {
                        // Show the signup or login screen
                    }
                    
                }
            }
            
        })

    }
    
    func createProfile() {
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func signUp(sender: AnyObject) {
        var profile = PFObject(className:"Profile")
        facebookGraphRequest()
        
        if genderSwitch.on {
            profile["preference"] = "women"
            profile.saveInBackgroundWithBlock {
                (success: Bool, error: NSError?) -> Void in
                if (success) {
                    println("Profile pref for women has been saved")
                } else {
                    println("There was a problem, check error.description")
                    println(error!.description)
                }
            }
        } else {
            profile["preference"] = "men"
            profile.saveInBackgroundWithBlock {
                (success: Bool, error: NSError?) -> Void in
                if (success) {
                    println("Profile pref for men has been saved")
                } else {
                    println("There was a problem, check error.description")
                    println(error!.description)
                }
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
