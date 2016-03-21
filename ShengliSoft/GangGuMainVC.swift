//
//  GangGuMainVC.swift
//  ShengliSoft
//
//  Created by Admin on 11/3/15.
//  Copyright © 2015 iCloudTest. All rights reserved.
//

import UIKit

class GangGuMainVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var parentNavigationController: UINavigationController!
    
    @IBOutlet weak var gangguTableView: UITableView!
    var refreshController = UIRefreshControl()
    override func viewDidLoad() {
        super.viewDidLoad()
        // TableView datasource and delegate
        self.gangguTableView.delegate = self
        self.gangguTableView.dataSource = self
        // MARK: - Pull to refresh on TableView
        self.refreshController.addTarget(self, action: "didRefreshList:", forControlEvents: .ValueChanged)
        self.refreshController.backgroundColor = UIColor(red: 50/255, green: 50/255, blue: 50/255, alpha: 1)
        self.refreshController.attributedTitle = NSAttributedString(string: "Last updated on \(NSDate())")
        self.gangguTableView.addSubview(self.refreshController)
        
    }
    func didRefreshList(sender: AnyObject){
        self.gangguTableView.reloadData()
        self.refreshController.endRefreshing()
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell  = tableView.dequeueReusableCellWithIdentifier("gangguCell")!
        return cell
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
