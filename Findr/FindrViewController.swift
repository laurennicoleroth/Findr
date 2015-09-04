//
//  FindrViewController.swift
//  Findr
//
//  Created by Lauren Nicole Roth on 9/4/15.
//  Copyright (c) 2015 Findr. All rights reserved.
//

import UIKit

class FindrViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        println(PFUser.currentUser())

        PFGeoPoint.geoPointForCurrentLocationInBackground {
            (geoPoint: PFGeoPoint?, error: NSError?) -> Void in
            if error == nil {
                println(geoPoint)
                if let location = PFUser.currentUser()?["location"] as? PFGeoPoint {
                    println(location)
                }
            } else {
                println("something went wrong")
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
