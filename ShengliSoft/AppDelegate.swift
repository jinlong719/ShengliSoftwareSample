//
//  AppDelegate.swift
//  ShengliSoft
//
//  Created by Admin on 10/30/15.
//  Copyright © 2015 iCloudTest. All rights reserved.
//

import UIKit
import Fabric
import Crashlytics



@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    let TAG_WAIT_SCREEN_VIEW = 1025
    let TAG_WAIT_SCREEN_INDICATOR = 1026
    let TAG_WAIT_SCREEN_LABEL = 1027



    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        UINavigationBar.appearance().barTintColor = UIColor(red: 38/255, green: 40/255, blue: 52/255, alpha: 1.0)
        UINavigationBar.appearance().tintColor = UIColor.whiteColor()
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName: UIColor(red: 122/255, green: 127/255, blue: 140/255, alpha: 1.0)]
        
        UITabBar.appearance().barTintColor = UIColor(red: 32/255, green: 30/255, blue: 34/255, alpha: 1.0)
        
        Fabric.with([Crashlytics.self])
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    // MARK: - ActivityIndicatorView
    func showWaitingScreen(strText:NSString, bShowText:Bool, size:CGSize)
    {
        
        
        let view = UIView(frame:CGRectMake(0, 0, UIScreen.mainScreen().bounds.size.width, UIScreen.mainScreen().bounds.size.height))
        
        view.tag = TAG_WAIT_SCREEN_VIEW
        view.backgroundColor = UIColor.clearColor()
        view.alpha = 1.0
        
        if (bShowText) {
            let subView = UIView()
            subView.backgroundColor = UIColor.blackColor()
            subView.alpha = 0.7
            
            var width = size.width
            var height = size.height
            
            subView.frame = CGRectMake(view.frame.size.width/2-width/2, view.frame.size.height/2-height/2, width, height)
            
            let indicatorView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.WhiteLarge)
            indicatorView.tag = TAG_WAIT_SCREEN_INDICATOR
            let rectIndicatorViewFrame = indicatorView.frame
            
            width = rectIndicatorViewFrame.size.width
            height = rectIndicatorViewFrame.size.height
            
            indicatorView.frame = CGRectMake(subView.frame.size.width/2-width/2, subView.frame.size.height/3-width/2, width, height)
            
            indicatorView.startAnimating()
            subView.addSubview(indicatorView)
            
            let label = UILabel(frame:CGRectMake(0, subView.frame.size.height * 1.6/3, subView.frame.size.width, subView.frame.size.height/3))
            label.text = strText as String
            
            label.backgroundColor = UIColor.clearColor()
            label.textAlignment = NSTextAlignment.Center
            
            label.textColor = UIColor.whiteColor()
            label.tag = TAG_WAIT_SCREEN_LABEL
            
            label.font = UIFont.systemFontOfSize(14)
            
            subView.addSubview(label)
            subView.layer.cornerRadius = 10.0//  = [Common roundCornersOnView:subView onTopLeft:YES topRight:YES bottomLeft:YES bottomRight:YES radius:10.0f]
            
            view.addSubview(subView)
        }
        
        window!.addSubview(view)
    }
    func hideWaitingScreen() {
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            let view = self.window!.viewWithTag(self.TAG_WAIT_SCREEN_VIEW)
            
            if (view != nil) {
                let indicatorView = view?.viewWithTag(self.TAG_WAIT_SCREEN_INDICATOR)
                
                if (indicatorView != nil){
                    (indicatorView as! UIActivityIndicatorView).stopAnimating()
                }
                view!.removeFromSuperview()
                
                let label = view!.viewWithTag(self.TAG_WAIT_SCREEN_LABEL)
                if (label != nil) {
                    label!.removeFromSuperview()
                }
            }
        })
    }

    

}

