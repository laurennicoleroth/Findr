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
    var i = 2
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
        
//        addPerson("https://pbs.twimg.com/media/CLmRStwWwAALDQU.jpg")
        addPerson()
    }
    
    
    func addPerson() {
        var newUser = PFUser() as PFUser!
        var imgURL: NSURL = NSURL(string: "https://pbs.twimg.com/media/CLmRStwWwAALDQU.jpg")!
        let request: NSURLRequest = NSURLRequest(URL: imgURL)
        NSURLConnection.sendAsynchronousRequest(
            request, queue: NSOperationQueue.mainQueue(),
            completionHandler: {(response: NSURLResponse!,data: NSData!,error: NSError!) -> Void in
                if error == nil {
                    var image = UIImage(data: data)
                    var file = PFFile(data: UIImageJPEGRepresentation(image, 1.0))
                    println(file)
                    newUser["picture"] = file
                    newUser["gender"] = "female"
                    var lat = Double(37 + self.i)
                    var lon = Double(-122 + self.i)
                    self.i = self.i + 10
                    var location = PFGeoPoint(latitude: lat, longitude: lon)
                    newUser["location"] = location
                    newUser.username = "\(self.i)"
                    newUser.password = "password"
                    newUser.signUp()
                }
        })
       
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
