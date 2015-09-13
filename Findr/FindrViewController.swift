//
//  FindrViewController.swift
//  Findr
//
//  Created by Lauren Nicole Roth on 9/4/15.
//  Copyright (c) 2015 Findr. All rights reserved.
//

import UIKit

class FindrViewController: UIViewController {
    
    var xFromCenter:CGFloat = 0
    var usernames = [String]()
    var userPictures = [PFFile]()
    var currentUser = 0
   
    override func viewDidLoad() {
        super.viewDidLoad()

        PFGeoPoint.geoPointForCurrentLocationInBackground {
            (geoPoint: PFGeoPoint?, error: NSError?) -> Void in
            if error == nil {
                var user = PFUser.currentUser() as PFUser!
                user["location"] = geoPoint
                println(PFUser.currentUser()!["preference"]!)
                var query = PFUser.query()
//    TODO:            query!.whereKey("location", nearGeoPoint:geoPoint!)
                query!.whereKey("username", notEqualTo: PFUser.currentUser()!.username!)
                query!.whereKey("gender", equalTo: "Male")
                query!.limit = 10
                query!.findObjectsInBackgroundWithBlock {
                    (users: [AnyObject]?, error: NSError?) -> Void in
                    
                    if error == nil {
                        // The find succeeded.
                        println("Successfully retrieved \(users!.count) users.")
                        if let users = users as? [PFObject] {
                            for user in users {
                                println(user.objectId)
                                self.usernames.append(user["username"] as! String)
                                self.userPictures.append(user["picture"] as! PFFile)
                                
                            }
                            
                            println(self.currentUser)
                            
                            let userImageFile = self.userPictures[self.currentUser] as PFFile
                            userImageFile.getDataInBackgroundWithBlock {
                                (imageData: NSData?, error: NSError?) -> Void in
                                if error == nil {
                                    if let imageData = imageData {
                                        let image = UIImage(data:imageData)
                                        
                                        var userImage: UIImageView = UIImageView(frame: CGRectMake(0, 0, self.view.frame.width, self.view.frame.height))
                                        userImage.image = image
                                        userImage.contentMode = UIViewContentMode.ScaleAspectFit
                                        self.view.addSubview(userImage)
                                       
                                        var gesture = UIPanGestureRecognizer(target: self, action: Selector("wasDragged:"))
                                        userImage.addGestureRecognizer(gesture)
                                     
                                        userImage.userInteractionEnabled = true
                                    }
                                }
                            }
                        }
                        
                        
                        
                    } else {
                        // Log details of the failure
                        println("Error: \(error!) \(error!.userInfo!)")
                    }
                }
            } else {
                println("No more users")
            }
        }
        
//        loadPositiveSingle()
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadPositiveSingle() {
        
        var draggableBackground: DraggableViewBackground = DraggableViewBackground(frame: self.view.frame)
        self.view.addSubview(draggableBackground)
    }
    
    func wasDragged(gesture: UIPanGestureRecognizer) {
        
        let translation = gesture.translationInView(self.view)
        var label = gesture.view!
        
        xFromCenter += translation.x
        
        var scale = min(100 / abs(xFromCenter), 1)
        
        label.center = CGPoint(x: label.center.x + translation.x, y: label.center.y + translation.y)
        gesture.setTranslation(CGPointZero, inView: self.view)
        var rotation:CGAffineTransform = CGAffineTransformMakeRotation(xFromCenter / 200)
        var stretch:CGAffineTransform = CGAffineTransformScale(rotation, scale, scale)
        label.transform = stretch
       
        
        if gesture.state == UIGestureRecognizerState.Ended {
            var username = self.usernames[self.currentUser]
            var user = PFUser.currentUser() as PFUser!
            
            if label.center.x < 100 {
                println("Rejected")
                
                println(user)
                println(username)
                user.addUniqueObject(username, forKey:"rejected")
                user.saveInBackgroundWithBlock {
                    (success: Bool, error: NSError?) -> Void in
                    if (success) {
                        println("success")
                    } else {
                        println("failure")
                    }
                }
                
                self.currentUser++
                
            } else if label.center.x > self.view.bounds.width - 100 {
                println("Accepted")
                
                println(user)
                println(username)
//                user.addUniqueObject(username, forKey:"accepted")
//                user.saveInBackground()

                self.currentUser++
            }
            
            label.removeFromSuperview()
            
            if self.currentUser < self.userPictures.count {
            
                var userImage: UIImageView = UIImageView(frame: CGRectMake(0, 0, self.view.frame.width, self.view.frame.height))
                
                let userImageFile = self.userPictures[self.currentUser] as PFFile
                userImageFile.getDataInBackgroundWithBlock {
                    (imageData: NSData?, error: NSError?) -> Void in
                    if error == nil {
                        if let imageData = imageData {
                            let image = UIImage(data:imageData)
                            
                            var userImage: UIImageView = UIImageView(frame: CGRectMake(0, 0, self.view.frame.width, self.view.frame.height))
                            userImage.image = image
                            userImage.contentMode = UIViewContentMode.ScaleAspectFit
                            self.view.addSubview(userImage)
                            
                            var gesture = UIPanGestureRecognizer(target: self, action: Selector("wasDragged:"))
                            userImage.addGestureRecognizer(gesture)
                            
                            userImage.userInteractionEnabled = true
                            
                            self.xFromCenter = 0
                        }
                    }
                }
            } else {
                println("No more users")
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
