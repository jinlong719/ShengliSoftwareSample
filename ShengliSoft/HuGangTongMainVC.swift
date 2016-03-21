//
//  HuGangTongMainVC.swift
//  ShengliSoft
//
//  Created by Admin on 11/3/15.
//  Copyright © 2015 iCloudTest. All rights reserved.
//

import UIKit

class HuGangTongMainVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var parentNavigationController: UINavigationController!
    var refreshController = UIRefreshControl()

    // Initial data defination!
    let wodeguCountries: [String!] = ["SH", "SH", "SH", "HK", "HK", "HK","SH", "SH", "SH", "HK", "HK", "HK","SH", "SH", "SH", "HK", "HK", "HK"]
    let wodeguNames: [String!] = ["上海指数", "中国冲车","中信登券","恒生指数","腾讯控股","金山软件","上海指数", "中国冲车","中信登券","恒生指数","腾讯控股","金山软件","上海指数", "中国冲车","中信登券","恒生指数","腾讯控股","金山软件"]
    let wodeguPrices: [Double!] = [3412.43, 14.440, 15.700, 23151.94, 149.200, 18.000, 3412.43, 14.440, 15.700, 23151.94, 149.200, 18.000, 3412.43, 14.440, 15.700, 23151.94, 149.200, 18.000]
    let wodeguPercents: [Double!] = [1.3,-1.03,2.28,1.34,1.98,2.16,1.3,-1.03,2.28,1.34,1.98,2.16,1.3,-1.03,2.28,1.34,1.98,2.16]
    let wodeguIndexes: [String!] = ["000001", "601766","600030","800000","00700","123456","000001", "601766","600030","800000","00700","123456","000001", "601766","600030","800000","00700","123456"]
    
    struct guMulu {
        var sectionName: String!
        var guCountry: [String!]
        var guPrice: [Double!]
        var guIndex: [String!]
        var guPercent: [Double!]
        var guName: [String!]
    }
    var guArray = [guMulu]()
    @IBOutlet weak var hugangtongTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        guArray = [
            guMulu(
                sectionName: "沪深A股",
                guCountry: self.wodeguCountries,
                guPrice: self.wodeguPrices,
                guIndex: self.wodeguIndexes,
                guPercent: self.wodeguPercents,
                guName: self.wodeguNames
            ),
            guMulu(
                sectionName: "创业板",
                guCountry: self.wodeguCountries,
                guPrice: self.wodeguPrices,
                guIndex: self.wodeguIndexes,
                guPercent: self.wodeguPercents,
                guName: self.wodeguNames
            )
        ]
        
        self.hugangtongTableView.delegate = self
        self.hugangtongTableView.dataSource = self
        // MARK: - Pull to refresh on TableView
        self.refreshController.addTarget(self, action: "didRefreshList:", forControlEvents: .ValueChanged)
        self.refreshController.backgroundColor = UIColor(red: 50/255, green: 50/255, blue: 50/255, alpha: 1)
        self.refreshController.attributedTitle = NSAttributedString(string: "Last updated on \(NSDate())")
        self.hugangtongTableView.addSubview(self.refreshController)
        //        //Setting for getting news from server
        //        self.quoteNews.secType = 100
        //        self.quoteNews.exchangeID = 100
        //        self.quoteNews.symbolName = "News"
        //        self.quoteNews.sortParaName = "Price"
        //        self.quoteNews.sortType = 0
        //        self.quoteNews.startIndex = 0
        //        self.quoteNews.endIndex = 10
        //        self.quoteNews.sessionID = "abc"
        
        //        self.quoteNews.quoteListOfNews()
        //Getting related value for shanghai, shenzhen, chuangyeban. on the top view.
        
    }
    func didRefreshList(sender: AnyObject){
        //        self.dispRelatedValue()
        self.hugangtongTableView.reloadData()
        self.refreshController.endRefreshing()
    }
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        //        print("Section: \(self.guArray.count)")
        return self.guArray.count
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //        print("(Section, Number): (\(section), \(self.guArray[section].guCountry.count))")
        return self.guArray[section].guCountry.count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell  = tableView.dequeueReusableCellWithIdentifier("hugangtongCell")
        
//        cell.guNameLbl.text = self.guArray[indexPath.section].guName[indexPath.row]
//        cell.guIndexLbl.text = self.guArray[indexPath.section].guIndex[indexPath.row]
//        cell.guPriceLbl.text = "\(self.guArray[indexPath.section].guPrice[indexPath.row])"
//        cell.guDispLbl.text = "\(self.guArray[indexPath.section].guPercent[indexPath.row])%  "
//        cell.guCountryLbl.text = self.guArray[indexPath.section].guCountry[indexPath.row]
        return cell!
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        //        print("(Section, Title): (\(section), \(self.guArray[section].sectionName))")
        return self.guArray[section].sectionName
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let sectionLine: UIView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 1))
        sectionLine.backgroundColor = UIColor(red: 30/255, green: 30/255, blue: 30/255, alpha: 1.0)
        let sectionName: UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 40))
        let sectionArrow: UILabel = UILabel(frame: CGRect(x: self.view.frame.size.width-40, y: 0, width: 40, height: 40))
        sectionArrow.text = "➡️"
        sectionArrow.textColor = UIColor(red: 0, green: 1, blue: 0, alpha: 1)
        sectionName.textColor = UIColor(red: 0, green: 1, blue: 0, alpha: 1.0)
        let sectionHearderView: UIView = UIView(frame: CGRect(x: 0.0,y: 0.0,width: self.view.frame.size.width,height: 40.0))
        sectionHearderView.backgroundColor = UIColor(red: 10/255, green: 10/255, blue: 10/255, alpha: 1)
        let sectionBtn: UIButton = UIButton(type: UIButtonType.Custom)
        sectionBtn.frame = CGRectMake(0,0,self.view.frame.size.width,40)
        sectionBtn.tag = section
        sectionBtn.hidden = false
        
        sectionBtn.backgroundColor = UIColor.clearColor()
        if section == 0
        {
            sectionName.text = self.guArray[section].sectionName
            sectionName.alignmentRectForFrame(CGRect(x: 0, y: 10, width: 100, height: 40))
            sectionBtn.addTarget(self, action: "hushenBtnAction:", forControlEvents: UIControlEvents.TouchUpInside)
        }else if section == 1
        {
            //            sectionBtn.setTitle(self.guArray[section].sectionName, forState: UIControlState.Normal)
            sectionName.text = self.guArray[section].sectionName
            sectionName.alignmentRectForFrame(CGRect(x: 0, y: 10, width: 100, height: 40))
            sectionBtn.addTarget(self, action: "chuangyebanBtnAction:", forControlEvents: UIControlEvents.TouchUpInside)
        }
        sectionHearderView.addSubview(sectionLine)
        sectionHearderView.addSubview(sectionName)
        sectionHearderView.addSubview(sectionBtn)
        sectionHearderView.addSubview(sectionArrow)
        return sectionHearderView
    }
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    // TableViewCell was tapped
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {

    }
    
    func hushenBtnAction(sender: UIButton!)
    {
        //hushenguDetailView
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let detailVC: HuShenGuDetailVC = storyBoard.instantiateViewControllerWithIdentifier("hushenguDetailView") as! HuShenGuDetailVC
        self.parentNavigationController!.pushViewController(detailVC, animated: true)
        
    }
    func chuangyebanBtnAction(sender: UIButton!)
    {
        //hushenguDetailView
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let detailVC: HuShenGuDetailVC = storyBoard.instantiateViewControllerWithIdentifier("hushenguDetailView") as! HuShenGuDetailVC
        self.parentNavigationController!.pushViewController(detailVC, animated: true)
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
