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

//        PFGeoPoint.geoPointForCurrentLocationInBackground {
//            (geoPoint: PFGeoPoint?, error: NSError?) -> Void in
//            if error == nil {
//                var user = PFUser.currentUser() as PFUser!
//                user["location"] = geoPoint
//
//                var query = PFUser.query()
//                query!.whereKey("location", nearGeoPoint:geoPoint!)
//                query!.limit = 10
//                query!.findObjectsInBackgroundWithBlock {
//                    (users: [AnyObject]?, error: NSError?) -> Void in
//                    
//                    if error == nil {
//                        // The find succeeded.
//                        println("Successfully retrieved \(users!.count) users.")
//                        // Do something with the found objects
//                        if let users = users as? [PFObject] {
//                            for user in users {
//                                println(user.objectId)
//                                self.usernames.append(user["username"] as! String)
//                                self.userPictures.append(user["picture"] as! PFFile)
//                            }
//                        }
//                    } else {
//                        // Log details of the failure
//                        println("Error: \(error!) \(error!.userInfo!)")
//                    }
//                }
//            } else {
//                println(error)
//            }
//        }
        
        
        
        loadPositiveSingle()
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
