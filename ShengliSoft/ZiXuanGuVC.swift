//
//  ZiXuanGuVC.swift
//  ShengliSoft
//
//  Created by Admin on 11/3/15.
//  Copyright © 2015 iCloudTest. All rights reserved.
//

import UIKit
var shouldAddGus: Bool = false

class ZiXuanGuVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    // Start to send quote list news to app. msgType 206, (222)
    struct startMsg {
        var msgTyp: UInt8
        var sessionID: String
        var reserved: String
    }
    struct LenStrtMsg {
        var lenMsg: UInt8
        var lenSID: UInt8
        var lenRes: UInt8
    }
    func toStruct(data: NSData)-> startMsg
    {
        var unarchivedResData = LenStrtMsg(lenMsg: 1, lenSID: 32, lenRes: 7)
        let archivedData = data.subdataWithRange(NSMakeRange(0, 0))
        archivedData.getBytes(&unarchivedResData, length: 40)
        
        let msgRange = NSMakeRange(0, 1)
        let sIDRange = NSMakeRange(1, 32)
        let reserved = NSMakeRange(33, 7)
        
        let msgBody = data.subdataWithRange(msgRange)
        var msgInt:UInt8 = 0
        msgBody.getBytes(&msgInt, range: msgRange)
        
        let sidBody = data.subdataWithRange(sIDRange)
        let sessionID = self.toString(sidBody)
        
        let reserve = data.subdataWithRange(reserved)
        let reserv = self.toString(reserve)
        
        let returned = startMsg(msgTyp: msgInt, sessionID: sessionID, reserved: reserv)
        return returned
    }
    // End msgType: 208,(224)
    struct endMsg {
        var msgTyp: Int
        var sessionID: String
        var results: String
        var reasons: String
        var reserved: String
    }
    struct LenEndMsg {
        var lenMsg: UInt8
        var lenSID: UInt8
        var lenRes: UInt8
        var lenRea: UInt8
        var lenRev: UInt8
    }
    
    func endMsgToNSData(data: NSData)-> endMsg
    {
        var unarchivedResData = LenEndMsg(lenMsg: 1, lenSID: 32, lenRes: 1, lenRea: 128, lenRev: 6)
        let archivedData = data.subdataWithRange(NSMakeRange(0, 0))
        archivedData.getBytes(&unarchivedResData, length: 168)
        
        let msgRange = NSMakeRange(0, 1)
        let sIDRange = NSMakeRange(1, 32)
        let resRange = NSMakeRange(33, 1)
        let reaRange = NSMakeRange(34, 128)
        let revRange = NSMakeRange(162, 6)
        
        let msgBody = data.subdataWithRange(msgRange)
        var msgInt:Int = 0
        msgBody.getBytes(&msgInt, range: msgRange)
        
        let sidBody = data.subdataWithRange(sIDRange)
        let sessionID = self.toString(sidBody)
        
        let ResBody = data.subdataWithRange(resRange)
        let results = NSString(data: ResBody, encoding: NSUTF8StringEncoding) as! String
        
        let ReaBody = data.subdataWithRange(reaRange)
        let reasonS = self.toString(ReaBody)
        
        let reserve = data.subdataWithRange(revRange)
        let reserv = self.toString(reserve)
        
        let returned = endMsg(msgTyp: msgInt, sessionID: sessionID, results: results, reasons: reasonS, reserved: reserv)
        return returned
    }
    // MARK: - Receive the main data from server.207（223）
    struct newsOfQuote {
        var msgTyp: UInt8
        var sessionID: String
        var symName: String
        var symCode: String
        var symPric: Int
        var symRate: Int
        var Reserve: String
    }
    struct lenNewsOfQuote {
        var lenMsg: UInt8
        var lenSID: UInt8
        var lenSym: UInt8
        var lenSCo: UInt8
        var lenSPr: UInt8
        var lenSRt: UInt8
        var lenRev: UInt8
    }
    func toNews(data: NSData) -> newsOfQuote{
        var unarchivedResData = lenNewsOfQuote(
            lenMsg: 1,
            lenSID: 32,
            lenSym: 32,
            lenSCo: 32,
            lenSPr: 4,
            lenSRt: 4,
            lenRev: 7
        )
        let archivedData = data.subdataWithRange(NSMakeRange(0, 0))
        archivedData.getBytes(&unarchivedResData, length: 112)
        
        //        var cgf: CGFloat = 5.123456
        //        var data = NSData(bytes: &cgf, length: sizeofValue(cgf))
        //        var cgf1: CGFloat = 0
        //        data.getBytes(&cgf1, length: sizeofValue(cgf1))
        
        let msgRange = NSMakeRange(0, 1)
        let sIDRange = NSMakeRange(1, 32)
        let nameRange = NSMakeRange(33, 32)
        let codeRange = NSMakeRange(65, 32)
        let pricRange = NSMakeRange(97, 4)
        let rateRange = NSMakeRange(101, 4)
        let reserved = NSMakeRange(105, 7)
        
        let msgBody = data.subdataWithRange(msgRange)
        var msgInt:UInt8 = 0
        msgBody.getBytes(&msgInt, range: msgRange)
        
        let sidBody = data.subdataWithRange(sIDRange)
        let sessionID = toString(sidBody)
        
        let nameBody = data.subdataWithRange(nameRange)
        let name = self.toString(nameBody)
        
        
        let codeBody = data.subdataWithRange(codeRange)
        let code = toString(codeBody)
        
        let priceBody = data.subdataWithRange(pricRange)
        var price: Int = 0
        priceBody.getBytes(&price, length: sizeofValue(price))
        
        let rateBody = data.subdataWithRange(rateRange)
        var rate: Int = 0
        rateBody.getBytes(&rate, length: sizeofValue(rate))
        
        let reserve = data.subdataWithRange(reserved)
        let reserv = self.toString(reserve)
        
        let returned = newsOfQuote(msgTyp: msgInt, sessionID: sessionID, symName: name, symCode: code, symPric: price, symRate: rate, Reserve: reserv)
        return returned
    }
    //
    
    func toString(data: NSData) -> String{
        var retString: String = ""
        var retNSData: NSData!
        let strLen = data.length
        for iIndex in 0..<strLen{
            let charBody = data.subdataWithRange(NSMakeRange(iIndex, 1))
            if let subString = String(data: charBody, encoding: NSUTF8StringEncoding){
                if subString == "\0"{
                    retNSData = data.subdataWithRange(NSMakeRange(0, iIndex))
                    break
                }
            }
        }
        retString = String(data: retNSData, encoding: NSUTF8StringEncoding)!
        return retString
    }
    var parentNavigationController: UINavigationController!
    
    @IBOutlet weak var tableView: UITableView!
    
    var zixuanGus: [newsOfQuote] = []
    var ziXuanGu = QuoteListNews()
    var refreshController = UIRefreshControl()
    // Data for displaying on UI
    var guDatas: [GuPiaoData!] = []
    var exchangeIDs: [UInt8!] = [100, 101]
    var isPassed: Bool = false
    var stIndex: Int = 0
    
    override func viewWillDisappear(animated: Bool) {
        timerSet.invalidate()
        self.timerIsRunning = false
        self.timerSet.invalidate()
        self.ziXuanGu.socketHelper.bSocket.disconnect()
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.getGus()
        self.timerIsRunning = true
        self.timerRunning()
        print("Timer Set in ZiXuanGu")
    }
    override func viewDidLoad() {
        //NotificationCenter
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "gotMyStocks:",name:"getMyStocks", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "dispMyStocks:",name:"dispMyStocks", object: nil)
        
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        // MARK: - refreshing wit pulling on TableView
        self.refreshController.addTarget(self, action: "didRefreshList:", forControlEvents: .ValueChanged)
        self.refreshController.backgroundColor = UIColor(red: 50/255, green: 50/255, blue: 50/255, alpha: 1)
        self.refreshController.attributedTitle = NSAttributedString(string: "Last updated on \(NSDate())")
        self.tableView.addSubview(self.refreshController)
        self.getGus()
    }
    // MARK: Timer
    var timerIsRunning = true
    var timerSet = NSTimer()
    var newStockData: [GuPiaoData!] = []
    var oldStockData: [GuPiaoData!] = []
    
    func timerRunning(){
        
        if self.timerIsRunning{
            timerSet = NSTimer.scheduledTimerWithTimeInterval(4, target: self, selector: Selector("getGus"), userInfo: nil, repeats: true)
        }
    }
    var gName: [String] = []
    var gCountries: [String] = []
    var gPrices: [Double] = []
    var gIndex: [String] = []
    var gPercets: [Double] = []
    var sockets: [NSData] = []
    var guInfos = [GuPiaoData!]()
    var huShenStocks: [HuShenTableData] = []
    
    func dispMyStocks(notification: NSNotification){
        //load data here
        self.newStockData = []
        self.newStockData = midData
        dispatch_async(dispatch_get_main_queue()){
            self.isPassed = true
            wasZXG = true//ZiXuanGu was completed.
            UIView.transitionWithView(self.tableView,
                duration: 0.35,
                options: .TransitionCrossDissolve,
                animations: {
                    () -> Void in
                    self.tableView.reloadData()
                    self.oldStockData = self.newStockData
                },
                completion: nil
            )
            
            self.timerIsRunning = true
            self.timerRunning()
            self.refreshController.endRefreshing()
            
        }
    }
    
    func gotMyStocks(notification: NSNotification){
        let data = notification.userInfo!["response"] as! NSData
        let tmpSockets = fixingSockets(data)
        var stockIndex: Int16 = 1
        for tmpData in tmpSockets{
            let msgRange = NSMakeRange(0, 1)
            let msgBody = tmpData.subdataWithRange(msgRange)
            var msgInt:UInt8 = 0
            msgBody.getBytes(&msgInt, range: msgRange)
            print(" \(stockIndex++))\(msgInt): \(tmpData.length) Bytes in \(data.length) Bytes")
            switch msgInt
            {
            case 222:
                break
            case 223:
                let dataStruct = self.toNews(tmpData)
                let resGuData = GuPiaoData(
                    gCountry: "",
                    gName: dataStruct.symName,
                    gPrice: (Double(dataStruct.symPric)/10000).roundTo2f,
                    gRate: (Double(dataStruct.symRate)/10000).roundTo2f,
                    gCode: dataStruct.symCode
                )
                if shouldAddGus{
                    midData.append(resGuData)
                }else{
                    self.guInfos.append(resGuData)
                }
            case 224:
                if tmpSockets.count != 1{
                    print("Finished")
                    print("++++++++++++++++++++++++++")
                    print("")
                }
                let endData = self.endMsgToNSData(tmpData)
                if endData.results == "Y"
                {
                    //Processing for display data to proper viewcontroller.
                    if shouldAddGus{
                        shouldAddGus = !shouldAddGus
                        self.guInfos = []
                        NSNotificationCenter.defaultCenter().postNotificationName("dispMyStocks", object: nil)
                        return
                    }else{
                        midData = []
                        midData = self.guInfos
                        self.guInfos = []
                        NSNotificationCenter.defaultCenter().postNotificationName("dispMyStocks", object: nil)
                        return
                    }
                }
            default :
                break
            }
        }
    }
    
    func getGus(){
        if self.timerIsRunning{
            CURRENT_STATUS = "Getting started my Stocks"
            self.ziXuanGu.msgType = 114
            self.ziXuanGu.secType = 110
            self.ziXuanGu.symbolName = "中国股票"
            self.ziXuanGu.sortParaName = "Price"
            self.ziXuanGu.sortType = 0
            self.ziXuanGu.startIndex = 0
            self.ziXuanGu.endIndex = 10
            self.ziXuanGu.selectedIndex = 0
            self.ziXuanGu.sendData()
            //
            self.timerIsRunning = false
            self.timerSet.invalidate()
        }
    }
    
    @IBAction func addGuBtn(sender: UIButton) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc: GuPiaoMuLuTableVC = storyBoard.instantiateViewControllerWithIdentifier("guPiaoView") as! GuPiaoMuLuTableVC
        self.parentNavigationController!.pushViewController(vc, animated: true)
    }
    
    func didRefreshList(sender: AnyObject){
        self.getGus()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Sorting part of table data with name, price, changedvalue
    @IBAction func sortWithNameBtn(sender: UIButton) {
        
        self.tableView.reloadData()
    }
    @IBAction func sortWithPriceBtn(sender: UIButton) {
        
        self.tableView.reloadData()
    }
    @IBAction func sortWithdisPriceBtn(sender: UIButton) {
        
        self.tableView.reloadData()
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.newStockData.count == 0{
            return 1
        }
        return self.newStockData.count
    }
    func tableView(tableView: UITableView, didEndDisplayingCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        if !self.oldStockData.isEmpty {
            let gradientView: GradientView = GradientView(frame: cell.frame)
            if self.newStockData[indexPath.row].guPrice > self.oldStockData[indexPath.row].guPrice{
                gradientView.firstColor = UIColor(red: 1, green: 0, blue: 0, alpha: 0.1)
                gradientView.secondColor = cell.backgroundColor!
            }else{
                gradientView.firstColor = UIColor(red: 0, green: 1, blue: 0, alpha: 0.1)
                gradientView.secondColor = cell.backgroundColor!
            }
            cell.addSubview(gradientView)
            print("Cell No: \(indexPath.row)")
        }
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("wodeguCell", forIndexPath: indexPath) as! WodeGuTVC
        if self.newStockData.count == 0
        {
            // Configure the cell...
            
            cell.wodeguNameLbl.text = nil
            cell.wodeguPercentLbl.text = nil
            cell.wodeguPercentLbl.backgroundColor = nil
            cell.wodeguPriceLbl.text = nil
            cell.wodeguPriceLbl.textColor = nil
            cell.wodeguIndex.text = nil
        }else{
            cell.wodeguNameLbl.text = self.newStockData[indexPath.row].guName
            if self.newStockData[indexPath.row].guRate > 0
            {
                cell.wodeguPercentLbl.text = String(format: "%.2f", self.newStockData[indexPath.row].guRate)+"%"
                cell.wodeguPercentLbl.backgroundColor = UIColor(
                    red: 226/255,
                    green: 72/255,
                    blue: 24/255,
                    alpha: 1)
                cell.wodeguPriceLbl.text = String(format: "%.2f", self.newStockData[indexPath.row].guPrice)
                cell.wodeguPriceLbl.textColor = UIColor(
                    red: 225/255,
                    green: 72/255,
                    blue: 24/255,
                    alpha: 1)
                
            }else
            {
                cell.wodeguPercentLbl.text = String(format: "%.2f", self.newStockData[indexPath.row].guRate)+"%"
                cell.wodeguPercentLbl.backgroundColor = UIColor(
                    red: 5/255,
                    green: 156/255,
                    blue: 57/255,
                    alpha: 1)
                cell.wodeguPriceLbl.text = String(format: "%.2f", self.newStockData[indexPath.row].guPrice)
                cell.wodeguPriceLbl.textColor = UIColor(
                    red: 5/255,
                    green: 156/255,
                    blue: 57/255,
                    alpha: 1)
            }
            
            cell.wodeguIndex.text = self.newStockData[indexPath.row].guCode
            
        }
        return cell
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        selectedString = "zixuangu"
        selectedIndex = indexPath.row
        selectedSection = indexPath.section
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let guDetailVC: GuDetailMainViewController = storyBoard.instantiateViewControllerWithIdentifier("gudetailView") as! GuDetailMainViewController
        self.parentNavigationController.pushViewController(guDetailVC, animated: true)
    }
    
    var stockAddDel: stockAddDeleteClass = stockAddDeleteClass()
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == UITableViewCellEditingStyle.Delete {
            self.stockAddDel.wasAdding = false
            self.stockAddDel.secType = 100
            self.stockAddDel.symbol = self.newStockData[indexPath.row].guCode
            if self.newStockData[indexPath.row].guCountry == "SH"{
                
                self.stockAddDel.selectedExchangeID = 100
            }else if self.newStockData[indexPath.row].guCountry == "SZ" {
                self.stockAddDel.selectedExchangeID = 101
            }
            self.stockAddDel.sendData()
            self.newStockData.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
        }
    }
    
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let currentOffset = scrollView.contentOffset.y
        let maxiumOffset = scrollView.contentSize.height - scrollView.frame.size.height
        if (maxiumOffset - currentOffset) < -40{
            print("Loading more")
            shouldAddGus = true
            print("Over Loaded")
            self.stIndex++
            if self.timerIsRunning{
                self.ziXuanGu.msgType = 114
                self.ziXuanGu.secType = 110
                self.ziXuanGu.symbolName = "中国股票"
                self.ziXuanGu.sortParaName = "Price"
                self.ziXuanGu.sortType = 0
                self.ziXuanGu.startIndex = 1
                self.ziXuanGu.endIndex = 10
                self.ziXuanGu.selectedIndex = 0
                self.ziXuanGu.sendData()
                //
                self.timerIsRunning = false
                self.timerSet.invalidate()
            }
        }
    }
    
    /*
    func scrollViewDidScroll(scrollView: UIScrollView) {
    let offset = scrollView.contentOffset
    let bounds = scrollView.bounds
    let size = scrollView.contentSize
    let inSet = scrollView.contentInset
    let y: Float = Float(offset.y + bounds.size.height - inSet.bottom)
    let h: Float = Float(size.height)
    let reloadDistance: Float = 10
    if (y > h + reloadDistance){
    shouldAddGus = true
    print("Over Loaded")
    self.stIndex++
    if self.timerIsRunning{
    self.ziXuanGu.msgType = 114
    self.ziXuanGu.secType = 110
    self.ziXuanGu.symbolName = "中国股票"
    self.ziXuanGu.sortParaName = "Price"
    self.ziXuanGu.sortType = 0
    self.ziXuanGu.startIndex = 10*self.stIndex
    self.ziXuanGu.endIndex = 10*self.stIndex + 9
    self.ziXuanGu.selectedIndex = 0
    self.ziXuanGu.sendData()
    //
    self.timerIsRunning = false
    self.timerSet.invalidate()
    }
    }
    }
    */
    
}