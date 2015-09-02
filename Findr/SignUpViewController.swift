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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var fbRequest = FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id"])
        fbRequest.startWithCompletionHandler({ (FBSDKGraphRequestConnection, result, error) -> Void in
            
            if (error == nil && result != nil) {
                let facebookData = result as! NSDictionary //FACEBOOK DATA IN DICTIONARY
                let userEmail = (facebookData.objectForKey("email") as? String)
                let userPicture = (facebookData.objectForKey("picture") as? String)
                let userId = (facebookData.objectForKey("id") as? NSString)
                
                var imgURLString = "http://graph.facebook.com/" + (userId! as String) + "/picture?type=large"
                var imgURL = NSURL(string: imgURLString)
                var imageData = NSData(contentsOfURL: imgURL!)
                if let url  = NSURL(string: imgURLString),
                    image = NSData(contentsOfURL: url)
                {
                    self.profilePic.image = UIImage(data: image)
                    var currentUser = PFUser.currentUser()
                    if currentUser != nil {
                        let imageData = UIImagePNGRepresentation(self.profilePic.image)
                        let imageFile = PFFile(name:"profile.png", data:imageData)
                        
                        var profile = PFObject(className:"Profile")
                        profile["userId"] = userId
                        profile["imageName"] = "Profile Picture from Facebook"
                        profile["imageFile"] = imageFile
                        profile.saveInBackground()
                    } else {
                        // Show the signup or login screen
                    }
                
                }
            }
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func signUp(sender: AnyObject) {
        
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
