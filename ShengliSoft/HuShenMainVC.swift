//
//  HuShenMainVC.swift
//  ShengliSoft
//
//  Created by Admin on 11/4/15.
//  Copyright © 2015 iCloudTest. All rights reserved.
//

import UIKit
//

var midDetailedValues: [HuShenViewDetailValue] = []
var midHuShenStocks:[HuShenTableData] = []
var selectedIndex: Int!
var selectedSection: Int!

class HuShenMainVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate {
    ///
    //MARK: - parse above received data from server for 沪深股的详细数值显示
    struct rRelatedData {
        var msgTyp: UInt
        var sessionID: String
        var indexName: String
        var marketPrice: Int32
        var udRate: Int32
        var udValue: Int32
        var paraTyp: Int32
        var reserved: String
    }
    struct LenRalatedData {
        var lenMsg: Int16
        var lenSID: Int16
        var lenINm: Int16
        var lenMIx: Int16
        var lenUdR: Int16
        var lenUpV: Int16
        var lenPaT: Int16
        var lenRev: Int16
    }
    func toReqMsgOfDetailData(data: NSData) -> rRelatedData{
        var unarchivedResData = LenRalatedData(
            lenMsg: 1,
            lenSID: 32,
            lenINm: 32,
            lenMIx: 4,
            lenUdR: 4,
            lenUpV: 4,
            lenPaT: 1,
            lenRev: 2
        )
        let archivedData = data.subdataWithRange(NSMakeRange(0, 0))
        archivedData.getBytes(&unarchivedResData, length: 80)
        
        let msgRange = NSMakeRange(0, 1)
        let sIDRange = NSMakeRange(1, 32)
        let indexRange = NSMakeRange(33, 32)
        let marketRange = NSMakeRange(65, 4)
        let udRateRange = NSMakeRange(69, 4)
        let upValueRange = NSMakeRange(73, 4)
        let paraTypeRange = NSMakeRange(77, 1)
        let reserved = NSMakeRange(78, 2)
        
        let msgBody = data.subdataWithRange(msgRange)
        var msgInt:UInt = 0
        msgBody.getBytes(&msgInt, range: msgRange)
        
        let sidBody = data.subdataWithRange(sIDRange)
        let sessionID = self.toString(sidBody)
        
        let indexBody = data.subdataWithRange(indexRange)
        let indexN = self.toString(indexBody)
        
        let marketBody = data.subdataWithRange(marketRange)
        var marketRate: Int32 = 0
        marketBody.getBytes(&marketRate, length: sizeofValue(marketRate))
        
        let udRateBody = data.subdataWithRange(udRateRange)
        var udRate: Int32 = 0
        udRateBody.getBytes(&udRate, length: sizeofValue(udRate))
        
        let udPriceBody = data.subdataWithRange(upValueRange)
        var udPrice: Int32 = 0
        udPriceBody.getBytes(&udPrice, length: sizeofValue(udPrice))
        
        let typeBody = data.subdataWithRange(paraTypeRange)
        var typInt:Int32 = 0
        typeBody.getBytes(&typInt, length: sizeof(UInt8))
        
        let reserve = data.subdataWithRange(reserved)
        let reserv = self.toString(reserve)
        
        let returned = rRelatedData(
            msgTyp: msgInt,
            sessionID: sessionID,
            indexName: indexN,
            marketPrice: marketRate,
            udRate: udRate,
            udValue: udPrice,
            paraTyp: typInt,
            reserved: reserv
        )
        return returned
    }
    // MARK: Getting String from server NSData
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
    //Definition for HuShenStocks
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
    
    var parentNavigationController: UINavigationController!
    
    @IBOutlet weak var dataView: UIScrollView!

    let stockNames: [String] = ["上证指数","深圳成指","创业板指","中小","沪深"]
    // Initialization of Parameters for dataview
    var wasReceivedDetailedValues: Bool = false
    var wasCompleted: Bool = false
    
    @IBOutlet weak var hushenTableView: UITableView!
    
    var refreshController = UIRefreshControl()
    
    //Call to get the detailed Value of shangHai, shenzhen and chuangyeban.
    var relatedValues = HuShenDataView()
    var relatedData: [HuShenDataView.rRelatedData] = []
    
    //Call to get the information of stocks for shanghai, shenzhen and chuangeban.
    var quoteNews = QuoteListNews()
    var exchangeIDs: [UInt8] = [100, 101]
    //Detailed value color converting
    var oneButView = UIView()
    
    func relDataButtonView(butSize: CGSize, butCount: Int) -> UIView{
        
        self.oneButView.frame.origin = CGPointMake(0, 0)
        let padding = CGSizeMake(10, 10)
        self.oneButView.frame.size.height = butSize.height// + 2 + padding.height
        self.oneButView.frame.size.width = (butSize.width + padding.width)*CGFloat(butCount)
        var butPos = CGPointMake(padding.width*0.5, padding.height*0.5)
        var itemPos = CGPointMake(padding.width*0.5, 10)
        let itemSize = CGSize(width: butSize.width, height: 15)
        let butIncrement = butSize.width + padding.width
        for i in 0...(butCount-1){
            // label definition
            let mainPriceLbl = UILabel()
            let ratePriceLbl = UILabel()
            let namePriceLbl = UILabel()
            if self.wasReceivedDetailedValues{
                let txtColor = self.floatToUIColor(midDetailedValues[i].upDownRate)
                mainPriceLbl.text = "\(midDetailedValues[i].marketPrice)"
                mainPriceLbl.font = UIFont(name: "Futura", size: 14)
                mainPriceLbl.textColor = txtColor
                mainPriceLbl.textAlignment = .Center
                ratePriceLbl.text = "\(midDetailedValues[i].upDownPercent) % "
                ratePriceLbl.font = UIFont(name: "Futura", size: 14)
                ratePriceLbl.textColor = txtColor
                ratePriceLbl.textAlignment = .Center
                namePriceLbl.text = self.stockNames[i]
                namePriceLbl.textAlignment = .Center
                namePriceLbl.textColor = txtColor
            }else{
                mainPriceLbl.text = "xxx.xx"
                mainPriceLbl.textAlignment = .Center
                ratePriceLbl.text = "xxx.xx % "
                ratePriceLbl.textAlignment = .Center
                namePriceLbl.text = self.stockNames[i]
                namePriceLbl.textAlignment = .Center
            }
            let button: UIButton = UIButton(type: .Custom) as UIButton
            button.frame.size = butSize
            button.frame.origin = butPos
            mainPriceLbl.frame.size = itemSize
            mainPriceLbl.frame.origin = itemPos
            ratePriceLbl.frame.size = itemSize
            ratePriceLbl.frame.origin = itemPos
            ratePriceLbl.frame.origin.y = itemPos.y + mainPriceLbl.frame.origin.y + 5
            namePriceLbl.frame.size = itemSize
            namePriceLbl.frame.origin = itemPos
            namePriceLbl.frame.origin.y = itemPos.y + mainPriceLbl.frame.origin.y + ratePriceLbl.frame.origin.y
            butPos.x = butPos.x + butIncrement
            itemPos.x += butIncrement
            button.backgroundColor = UIColor(red: 50/255, green: 50/255, blue: 50/255, alpha: 1.0)
            button.addTarget(self, action: "valButPressed:", forControlEvents: .TouchUpInside)
            self.oneButView.addSubview(button)
            button.tag = i + 100
            self.oneButView.addSubview(mainPriceLbl)
            self.oneButView.addSubview(ratePriceLbl)
            self.oneButView.addSubview(namePriceLbl)
        }
        return self.oneButView
    }
    // Detailed data tapped processing part
    func valButPressed(sender: UIButton){
        print("No: \(sender.tag) button pressed")
    }
    // deciding +/- of the value and set color according price
    func floatToUIColor(pric: Float) -> UIColor
    {
        if pric > 0
        {
            return UIColor.redColor()
        }else {
            return UIColor.greenColor()
        }
    }
    // MARK: Timer
    var timerIsRunning = true
    var timerSet = NSTimer()
    var timeData: [GuPiaoData!] = []
    //
    func timerRunning(){
        if self.timerIsRunning{
            timerSet = NSTimer.scheduledTimerWithTimeInterval(3, target: self, selector: Selector("getHuShenStocks"), userInfo: nil, repeats: true)
        }
    }
    //
    override func viewWillAppear(animated: Bool) {
        print("HuShenGu Page was loaded")
        self.startIndex = 1
        self.endIndex = self.stocksAmounts
        self.cnt = 0
        self.dataCnt = 0
        self.timerIsRunning = false
        self.timerSet.invalidate()
        self.getHuShenStocks()
    }
    override func viewWillDisappear(animated: Bool) {
        timerSet.invalidate()
        self.timerIsRunning = false
//        self.dataView = nil
        // Remove all notificationCenters of this controller
//        NSNotificationCenter.defaultCenter().removeObserver(self, name: "getData", object: nil)
//        NSNotificationCenter.defaultCenter().removeObserver(self, name: "getHuShenStocks", object: nil)
    }
    
    
    override func viewDidLoad() {
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "gotData:", name:"getData", object: nil )
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "gotHuShenStocks:", name:"getHuShenStocks", object: nil )
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "dispHuShenStocks:", name:"dispHuShenStocks", object: nil )
        super.viewDidLoad()
 
        self.hushenTableView.delegate = self
        self.hushenTableView.dataSource = self
        // MARK: - Pull to refresh on TableView
        self.refreshController.addTarget(self, action: "didRefreshList:", forControlEvents: .ValueChanged)
        self.refreshController.backgroundColor = UIColor(red: 50/255, green: 50/255, blue: 50/255, alpha: 1)
        self.refreshController.attributedTitle = NSAttributedString(string: "Last updated on \(NSDate())")
        self.hushenTableView.addSubview(self.refreshController)
        self.timerIsRunning = true
        self.loadingScrollView()
        
    }
    //MARK: - Making Scroll view.
    let viewItemW: CGFloat = 110
    let viewItemH: CGFloat = 70
    let viewItemGap: CGFloat = 5
    
    func loadingScrollView(){
        self.oneButView.backgroundColor = UIColor(red: 20/255, green: 20/255, blue: 20/255, alpha: 1.0)
        let scrollingView = self.relDataButtonView(CGSizeMake(viewItemW, viewItemH), butCount: 5)
        self.dataView.frame = scrollingView.frame
        self.dataView.contentSize = scrollingView.frame.size
        self.dataView.addSubview(scrollingView)
        self.dataView.showsHorizontalScrollIndicator = false
        self.dataView.indicatorStyle = .Default
    }
    // Transmite data to server
    var myExchageIDs:[UInt8] = [100, 101, 101, 101, 101]
    var myDataType: [UInt8] = [0,1,2,3,4]
    var huShenStocks: [HuShenTableData] = []
    var cnt = 0
    var dataCnt = 0
    //Notification player
    var isScrolled: Bool = false
    var stocksAmounts: UInt16 = 10
    var startIndex: UInt16 = 1
    var endIndex: UInt16 = 0
    
    func gotData(notification: NSNotification){
        
        let data = notification.userInfo!["response"] as! NSData
        let msgRange = NSMakeRange(0, 1)
        let msgBody = data.subdataWithRange(msgRange)
        var msgInt:UInt8 = 0
        msgBody.getBytes(&msgInt, range: msgRange)
        print("----------------- Finished ----------------------")
        
        dispatch_async(dispatch_get_main_queue()){
            let getData = self.toReqMsgOfDetailData(data)
            let myData: HuShenViewDetailValue = HuShenViewDetailValue(
                market: Float(getData.marketPrice)/10000,
                udPrice: Float(getData.udValue)/10000,
                udPercent: Float(getData.udRate)/10000
            )
            midDetailedValues.append(myData)
            self.cnt++
            self.dataCnt++
            if self.cnt > 4{
                self.refreshController.endRefreshing()
//                self.loadingScrollView()
                self.wasCompleted = true
                self.wasReceivedDetailedValues = true
                self.quoteNews.msgType = 106
                self.quoteNews.secType = 100
                self.quoteNews.sessionID = sessionIDD
                self.quoteNews.exchangeID = self.exchangeIDs
                self.quoteNews.symbolName = "000000"
                self.quoteNews.sortParaName = "price"
                self.quoteNews.sortType = 0
                //Did the pointer detect the end of screen?
                if self.isScrolled{
                    self.endIndex = self.endIndex + self.stocksAmounts
                    print("^^^^^^^^^^^^^^^^ Loading more stocks from \(self.startIndex)th to \(self.endIndex) ^^^^^^^^^^^^^^^^^^")
                }
                self.quoteNews.startIndex = self.startIndex
                self.quoteNews.endIndex = self.endIndex
                self.quoteNews.selectedIndex = 0
                self.quoteNews.gName = []
                self.quoteNews.gCountries = []
                self.quoteNews.sendData()
            }else{
                self.timerIsRunning = false
                self.timerSet.invalidate()
                self.getHuShenStocks()
            }
        }
    }
    // Variables initialization for getting HuShenStocks
    var gName: [String] = []
    var gCountries: [String] = []
    var gPrices: [Double] = []
    var gIndex: [String] = []
    var gPercets: [Double] = []
    var guInfos = [GuPiaoData!]()
    
    func gotHuShenStocks(notification: NSNotification){
        
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
            case 206:
                break
            case 207:
                let dataStruct = self.toNews(tmpData)
                self.gName.append(dataStruct.symName)
                self.gCountries.append("")
                self.gPrices.append(Double(dataStruct.symPric)/10000)
                self.gPercets.append(Double(dataStruct.symRate)/10000)
                self.gIndex.append(dataStruct.symCode)
            case 208:
                if tmpSockets.count != 1{
                    print("------------------- Finished --------------------")
                    print("")
                }
                let endData = self.endMsgToNSData(tmpData)
                if endData.results == "Y"
                {
                    self.huShenStocks = []
                    // Reloading tableView data on requested viewController
                    let huShenStock = HuShenTableData(
                        secName: "沪深A股",
                        gName: self.gName,
                        gCountries: self.gCountries,
                        gPrices: self.gPrices,
                        gIndex: self.gIndex,
                        gPercents: self.gPercets
                    )
                    self.gName = []
                    self.gCountries = []
                    self.gPrices = []
                    self.gIndex = []
                    self.gPercets = []
                    self.huShenStocks.append(huShenStock)
                    midHuShenStocks = []
                    midHuShenStocks = self.huShenStocks
                    //        self.hushenData = midHuShenStocks
                    dispatch_async(dispatch_get_main_queue()){
                        UIView.transitionWithView(self.hushenTableView,
                            duration: 0.35,
                            options: .TransitionCrossDissolve,
                            animations: {
                                () -> Void in
                                self.loadingScrollView()
                                self.hushenTableView.reloadData()
                                self.timerIsRunning = true
                                self.timerRunning()
                                self.cnt = 0
                                self.dataCnt = 0
                                self.isScrolled = false
                            },
                            completion: nil
                        )
                    }
//                    NSNotificationCenter.defaultCenter().postNotificationName("dispHuShenStocks", object: nil)
                }
            default :
                break
            }
        }
    }
    
    func dispHuShenStocks(notification: NSNotification){
        
//        self.hushenData = midHuShenStocks
        dispatch_async(dispatch_get_main_queue()){
            UIView.transitionWithView(self.hushenTableView,
                duration: 0.35,
                options: .TransitionCrossDissolve,
                animations: {
                    () -> Void in
                    self.loadingScrollView()
                    self.hushenTableView.reloadData()
                    self.timerIsRunning = true
                    self.timerRunning()
                    self.cnt = 0
                    self.dataCnt = 0
                },
                completion: nil
            )
        }        
    }
    //Load more rows on the end of scrolling tableview.
    
    func getHuShenStocks(){
        if self.isScrolled{
//            print("Loaded more from \(self.startIndex)th to \(self.endIndex)th")
        }
        self.timerIsRunning = false
        self.timerSet.invalidate()
        self.relatedValues.cnt = self.cnt
        self.relatedValues.dataCnt = self.dataCnt
        self.relatedValues.sendData()
        self.wasCompleted = false
    }
    
    func didRefreshList(sender: AnyObject){
        self.cnt = 0
        self.dataCnt = 0
        self.getHuShenStocks()
        self.hushenTableView.reloadData()
//        self.refreshController.endRefreshing()
    }
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.huShenStocks.count
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.huShenStocks[section].guCountry.count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell  = tableView.dequeueReusableCellWithIdentifier("hushenCell") as! HuShenTVC
        
        cell.guNameLbl.text = self.huShenStocks[indexPath.section].guName[indexPath.row]
        cell.guIndexLbl.text = self.huShenStocks[indexPath.section].guIndex[indexPath.row]
        
        if self.huShenStocks[indexPath.section].guPercent[indexPath.row] > 0{
            cell.guPriceLbl.text = String(format: "%.2f", self.huShenStocks[indexPath.section].guPrice[indexPath.row])
            cell.guPriceLbl.textColor = UIColor(red: 226/255, green: 72/255, blue: 24/255, alpha: 1)
            cell.guDispLbl.text = String(format: "%.2f", self.huShenStocks[indexPath.section].guPercent[indexPath.row])+"%"
            cell.guDispLbl.backgroundColor = UIColor(red: 226/255, green: 72/255, blue: 24/255, alpha: 1)
        }else{
            cell.guPriceLbl.text = String(format: "%.2f", self.huShenStocks[indexPath.section].guPrice[indexPath.row])
            cell.guPriceLbl.textColor = UIColor(red: 5/255, green: 155/255, blue: 57/255, alpha: 1)
            cell.guDispLbl.text = String(format: "%.2f", self.huShenStocks[indexPath.section].guPercent[indexPath.row])+"%"
            cell.guDispLbl.backgroundColor = UIColor(red: 5/255, green: 155/255, blue: 57/255, alpha: 1)
        }
        
        /*
        cell.guCountryLbl.text = self.huShenStocks[indexPath.section].guCountry[indexPath.row]
        switch self.huShenStocks[indexPath.section].guCountry[indexPath.row]
        {
        case "SH":
            cell.guCountryLbl.backgroundColor = UIColor(red: 200/255, green: 80/255, blue: 10/255, alpha: 1)
        case "SZ":
            cell.guCountryLbl.backgroundColor = UIColor(red: 80/255, green: 200/255, blue: 10/255, alpha: 1)
        default:
            cell.guCountryLbl.backgroundColor = UIColor(red: 80/255, green: 80/255, blue: 80/255, alpha: 1)
        }
        */
        return cell
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        //        print("(Section, Title): (\(section), \(self.guArray[section].sectionName))")
        return self.huShenStocks[section].sectionName
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    
        let sectionLine: UIView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 1))
        sectionLine.backgroundColor = UIColor(red: 30/255, green: 30/255, blue: 30/255, alpha: 1.0)
        let sectionName: UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 40))
        let sectionArrow: UILabel = UILabel(frame: CGRect(x: self.view.frame.size.width-40, y: 0, width: 40, height: 40))
        sectionArrow.text = "☞☞☞"
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
            sectionName.text = self.huShenStocks[section].sectionName
            sectionName.alignmentRectForFrame(CGRect(x: 0, y: 10, width: 100, height: 40))
            sectionBtn.addTarget(self, action: "hushenBtnAction:", forControlEvents: UIControlEvents.TouchUpInside)
        }else if section == 1
        {
//            sectionBtn.setTitle(self.guArray[section].sectionName, forState: UIControlState.Normal)
            sectionName.text = self.huShenStocks[section].sectionName
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
        selectedIndex = indexPath.row
        selectedSection = indexPath.section
        selectedString = "hushengu"
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let guDetailVC: GuDetailMainViewController = storyBoard.instantiateViewControllerWithIdentifier("gudetailView") as! GuDetailMainViewController
        self.parentNavigationController.pushViewController(guDetailVC, animated: true)
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
    
    //Adding new rows when scrolling tableView
    func scrollViewDidScroll(scrollView: UIScrollView) {
        let currentOffset = scrollView.contentOffset.y
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height
        
        if (maximumOffset - currentOffset) <= 40 {
            self.isScrolled = true
            CURRENT_STATUS = "Loading more rows"
            self.getHuShenStocks()
        }
    }

    
}