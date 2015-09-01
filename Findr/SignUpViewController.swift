//
//  SignUpViewController.swift
//  Findr
//
//  Created by Lauren Nicole Roth on 9/1/15.
//  Copyright (c) 2015 Findr. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController {


    @IBOutlet var genderSwitch: UISwitch!
    @IBOutlet var profilePic: UIImageView!
    @IBOutlet var signUp: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
