//
//  BigDetailVC.swift
//  ShengliSoft
//
//  Created by Admin on 11/11/15.
//  Copyright © 2015 iCloudTest. All rights reserved.
//

import UIKit

class BigDetailVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // MARK: - View 90 deg Rotation
        let rotValue = UIInterfaceOrientation.LandscapeLeft.rawValue
        UIDevice.currentDevice().setValue(rotValue, forKey: "orientation")

        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(animated: Bool) {
        let rotValue = UIInterfaceOrientation.LandscapeLeft.rawValue
        UIDevice.currentDevice().setValue(rotValue, forKey: "orientation")
        

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
