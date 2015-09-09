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
   
    override func viewDidLoad() {
        super.viewDidLoad()
      
        //Create some men
//        addPerson("http://vignette4.wikia.nocookie.net/charmed/images/3/37/Jon-hamm-435.jpg/revision/latest?cb=20130906140210", gender: "Male", preference: "Women", fullname: "Jon Hamm")
//        addPerson("http://img2.timeinc.net/people/i/2005/specials/beauties05/beautiespoll/cowen.jpg", gender: "Male",  preference: "Women", fullname: "Clive Owen")
//        addPerson("http://images2.static-bluray.com/products/22/2874_1_front.jpg", gender: "Male", preference: "Women", fullname: "Cillian Murphy")
//         addPerson("http://parade.com/wp-content/uploads/2014/05/05-18-14-Sunday-with-Patrick-Stewart-ftr.jpg", gender: "Male", preference: "Women", fullname: "Patrick Stewart")
        
        //Create some women
//        addPerson("http://i.huffpost.com/gadgets/slideshows/412452/slide_412452_5206684_free.jpg", gender: "Female",  preference: "Men", fullname: "Angelina Jolie")
//        addPerson("http://www.billboard.com/files/styles/promo_650/public/media/taylor-swift_press-2013-650.jpg", gender: "Female", preference: "Men", fullname: "Taylor Swift")
//        addPerson("http://media2.popsugar-assets.com/files/2014/04/03/639/n/29590734/681f7f299a24848d_478045075_10.xxxlarge_2x/i/Cat-Deeley.jpg", gender: "Female", preference: "Men", fullname: "Cat Deeley")
//        addPerson("http://i.telegraph.co.uk/multimedia/archive/02179/1989_2179531a.jpg", gender: "Female", preference: "Men", fullname: "Claudia Schiffer")
    }
    
    
    func addPerson(url: String, gender: String, preference: String, fullname: String) {
        var newUser = PFUser() as PFUser!
        var imgURL: NSURL = NSURL(string: url)!
        
        let request: NSURLRequest = NSURLRequest(URL: imgURL)
        NSURLConnection.sendAsynchronousRequest(
            request, queue: NSOperationQueue.mainQueue(),
            completionHandler: {(response: NSURLResponse!,data: NSData!,error: NSError!) -> Void in
                if error == nil {
                    var image = UIImage(data: data)
                    var file = PFFile(data: UIImageJPEGRepresentation(image, 1.0))
                    newUser["picture"] = file
                    newUser["gender"] = gender
                    newUser["preference"] = preference
                    newUser["fullname"] = fullname
                    var lat = Double(Int(arc4random_uniform(100)+1))
                    var lon = Double(Int(arc4random_uniform(100)+1))
                    var location = PFGeoPoint(latitude: lat, longitude: lon)
                    newUser["location"] = location
                    var name = "\(fullname)" + String(Int(arc4random_uniform(100)+1))
                    let username = name.stringByReplacingOccurrencesOfString(" ", withString: "").lowercaseString
                    newUser.username = username
                    newUser.password = "password"
                    newUser.signUp()
                } else {
                    println(error)
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
