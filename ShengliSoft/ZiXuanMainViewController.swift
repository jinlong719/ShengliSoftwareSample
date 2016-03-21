//
//  ZiXuanMainViewController.swift
//  ShengliSoft
//
//  Created by Admin on 11/3/15.
//  Copyright © 2015 iCloudTest. All rights reserved.
//

import UIKit

class ZiXuanMainViewController: UIViewController,CAPSPageMenuDelegate {
    var parentNavigationController: UINavigationController!

    var pageMenu: CAPSPageMenu!
    var isClicked: Bool = false
    var selfTitle: String = "行情"
    @IBOutlet weak var titleBtn: UIButton!
    @IBAction func actionBtn(sender: UIButton) {
        
    }
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.parentNavigationController = self.navigationController
        let strBtn: String = self.selfTitle + ": 自选股"
        self.titleBtn.setTitle(strBtn, forState: UIControlState.Normal)
        self.tabBarView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillAppear(animated: Bool) {
//        self.tabBarView()
    }

    // MARK: - CAPSPageMenu
    func tabBarView()
    {
        // Scrollable Viewcontroller container define
        var controllerArray: [UIViewController] = []
        // Each viewcontroller define
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let zixuanguVC: ZiXuanGuVC = storyBoard.instantiateViewControllerWithIdentifier("zuxuanguView") as! ZiXuanGuVC
        zixuanguVC.parentNavigationController = self.navigationController
        zixuanguVC.title = "自选股"
        controllerArray.append(zixuanguVC)
        
        let hushenVC: HuShenMainVC = storyBoard.instantiateViewControllerWithIdentifier("hushenView") as! HuShenMainVC
        hushenVC.parentNavigationController = self.navigationController
        hushenVC.title = "沪深"
        controllerArray.append(hushenVC)
        
        let hugangtongVC: HuGangTongMainVC = storyBoard.instantiateViewControllerWithIdentifier("hugangtongView") as! HuGangTongMainVC
        hugangtongVC.parentNavigationController = self.navigationController
        hugangtongVC.title = "沪港通"
        controllerArray.append(hugangtongVC)
        
        let gangguVC: GangGuMainVC = storyBoard.instantiateViewControllerWithIdentifier("gangguView") as! GangGuMainVC
        gangguVC.parentNavigationController = self.navigationController
        gangguVC.title = "港股"
        controllerArray.append(gangguVC)
        
        let meiguVC: MeiGuMainVC = storyBoard.instantiateViewControllerWithIdentifier("meiguView") as! MeiGuMainVC
        meiguVC.parentNavigationController = self.navigationController
        meiguVC.title = "美股"
        controllerArray.append(meiguVC)
        
        let pMenuH: CGFloat = 40.0
        let parameters: [CAPSPageMenuOption] = [
            .MenuItemSeparatorWidth(4.3),
            .ScrollMenuBackgroundColor(UIColor(red: 38/255, green: 40/255, blue: 52/255, alpha: 1.0)),
            .ViewBackgroundColor(UIColor(red: 38/255, green: 40/255, blue: 52/255, alpha: 1.0)),
            .BottomMenuHairlineColor(UIColor(red: 20.0/255.0, green: 20.0/255.0, blue: 20.0/255.0, alpha: 0.1)),
            .SelectionIndicatorColor(UIColor(red: 18.0/255.0, green: 150.0/255.0, blue: 225.0/255.0, alpha: 1.0)),
            .MenuMargin(10),
            .MenuHeight(pMenuH),
            .SelectedMenuItemLabelColor(UIColor(red: 18.0/255.0, green: 150.0/255.0, blue: 225.0/255.0, alpha: 1.0)),
            .UnselectedMenuItemLabelColor(UIColor.whiteColor()),
            .MenuItemFont(UIFont(name: "HelveticaNeue-Medium", size: 14.0)!),
            .UseMenuLikeSegmentedControl(true),
            .MenuItemSeparatorRoundEdges(true),
            .SelectionIndicatorHeight(2.0),
            .MenuItemSeparatorPercentageHeight(0)
        ]
        // Initialize scroll menu
//        let tabH = self.tabBarController?.tabBar.frame.height
        let navH = self.navigationController?.navigationBar.frame.height
        let pageRect = CGRectMake(0.0, navH!+20, self.view.frame.width, self.view.frame.height-navH!-20.0)
        
        pageMenu = CAPSPageMenu(viewControllers: controllerArray, frame: pageRect, pageMenuOptions: parameters)
        // Optional Delegate
        pageMenu.delegate = self
        self.view.addSubview(pageMenu!.view)
    }
   
    
    
    func willMoveToPage(controller: UIViewController, index: Int) {
    }
    func didMoveToPage(controller: UIViewController, index: Int) {
        switch index{
        case 0:
            let strBtn: String = self.selfTitle + ": 自选股"
            self.titleBtn.setTitle(strBtn, forState: UIControlState.Normal)
        case 1:
            let strBtn: String = self.selfTitle + ": 沪深"
            self.titleBtn.setTitle(strBtn, forState: UIControlState.Normal)
        case 2:
            let strBtn: String = self.selfTitle + ": 沪港通"
            self.titleBtn.setTitle(strBtn, forState: UIControlState.Normal)
        case 3:
            let strBtn: String = self.selfTitle + ": 港股"
            self.titleBtn.setTitle(strBtn, forState: UIControlState.Normal)
        case 4:
            let strBtn: String = self.selfTitle + ": 美股"
            self.titleBtn.setTitle(strBtn, forState: UIControlState.Normal)
        default:
            break
        }
        
    }
}
