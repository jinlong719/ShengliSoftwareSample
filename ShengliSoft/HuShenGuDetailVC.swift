//
//  HuShenGuDetailVC.swift
//  ShengliSoft
//
//  Created by Admin on 11/5/15.
//  Copyright © 2015 iCloudTest. All rights reserved.
//

import UIKit

var eIndex: UInt16 = 9999

class HuShenGuDetailVC: UIViewController, XCMultiTableViewDelegate, XCMultiTableViewDataSource, UIScrollViewDelegate {
    //Socket frame definition
    // Start to send quote list news to app. msgType 210s
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
    // End msgType: 212
    struct endMsg {
        var msgTyp: UInt8
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
        var msgInt:UInt8 = 0
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
    //Main multiple tableView data receiving process Message Type is 211
    struct valOfStock {
        var msgTyp: UInt16
        var sessionID: String
        var symName: String
        var symCode: String
        var symPric: Int32
        var upDownRate: Int32
        var upDown: Int32
        var bidVol: Int32
        var bidPrice: Int32
        var askPrice: Int32
        var askVol: Int32
        var lastQuantity: Int32
        var totalVol: Int32
        var openPrice: Int32
        var highestPrice: Int32
        var lowestPrice: Int32
        var preClosedPrice: Int32
        var turnOver: Int64
        var upperLimitedPrice: Int32
        var lowerLimitedPrice: Int32
        var averagePrice: Int32
        var amplitude: Int32
        
        var Reserve: String
    }
    struct lenValOfStock {
        var lenMsg: UInt8
        var lenSID: UInt8
        var lenSym: UInt8
        var lenSCo: UInt8
        var lenSPr: UInt8
        var lenSRt: UInt8
        var lenUdR: UInt8
        var lenBiV: UInt8
        var lenBiP: UInt8
        var lenAsP: UInt8
        var lenAsV: UInt8
        var lenLaQ: UInt8
        var lenToV: UInt8
        var lenOpP: UInt8
        var lenHiP: UInt8
        var lenLoP: UInt8
        var lenPCP: UInt8
        var lenTOv: UInt8
        var lenULP: UInt8
        var lenLLP: UInt8
        var lenAvP: UInt8
        var lenAmp: UInt8
        var lenRev: UInt8
    }
    func toStock(data: NSData) -> valOfStock{
        var unarchivedResData = lenValOfStock(
            lenMsg: 1,
            lenSID: 32,
            lenSym: 32,
            lenSCo: 32,
            lenSPr: 4,
            lenSRt: 4,
            lenUdR: 4,
            lenBiV: 4,
            lenBiP: 4,
            lenAsP: 4,
            lenAsV: 4,
            lenLaQ: 4,
            lenToV: 8,
            lenOpP: 4,
            lenHiP: 4,
            lenLoP: 4,
            lenPCP: 4,
            lenTOv: 8,
            lenULP: 4,
            lenLLP: 4,
            lenAvP: 4,
            lenAmp: 4,
            lenRev: 7
        )
        let archivedData = data.subdataWithRange(NSMakeRange(0, 0))
        archivedData.getBytes(&unarchivedResData, length: 120)
        
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
        let udRange = NSMakeRange(105, 4)
        let bidVolRange = NSMakeRange(109, 4)
        let bidPriceRange = NSMakeRange(113, 4)
        let askPriceRange = NSMakeRange(117, 4)
        let askVolRange = NSMakeRange(121, 4)
        let lastQuRange = NSMakeRange(125, 4)
        let totalVolRange = NSMakeRange(129, 8)
        let openPriceRange = NSMakeRange(137, 4)
        let highestPriceRange = NSMakeRange(141, 4)
        let lowestPriceRange = NSMakeRange(145, 4)
        let preClosePriceRange = NSMakeRange(149, 4)
        let turnOverRange = NSMakeRange(153, 8)
        let uppPriceRange = NSMakeRange(161, 4)
        let lowPriceRange = NSMakeRange(165, 4)
        let averagePriceRange = NSMakeRange(169, 4)
        let ampRange = NSMakeRange(173, 4)
        
        let reserved = NSMakeRange(177, 7)
        
        
        let msgBody = data.subdataWithRange(msgRange)
        var msgInt:UInt16 = 0
        msgBody.getBytes(&msgInt, range: msgRange)
        
        let sidBody = data.subdataWithRange(sIDRange)
        let sessionID = self.toString(sidBody)
        
        let nameBody = data.subdataWithRange(nameRange)
        let name = self.toString(nameBody)
        
        let codeBody = data.subdataWithRange(codeRange)
        let code = self.toString(codeBody)
        
        let priceBody = data.subdataWithRange(pricRange)
        var price: Int32 = 0
        priceBody.getBytes(&price, length: sizeofValue(price))
        
        let rateBody = data.subdataWithRange(rateRange)
        var rate: Int32 = 0
        rateBody.getBytes(&rate, length: sizeofValue(rate))
        
        let udBody = data.subdataWithRange(udRange)
        var ud: Int32 = 0
        udBody.getBytes(&ud, length: sizeofValue(ud))
        
        let bidVolBody = data.subdataWithRange(bidVolRange)
        var bidVol: Int32 = 0
        bidVolBody.getBytes(&bidVol, length: sizeofValue(bidVol))
        
        let bidPriceBody = data.subdataWithRange(bidPriceRange)
        var bidPrice: Int32 = 0
        bidPriceBody.getBytes(&bidPrice, length: sizeofValue(bidPrice))
        
        let askPriceBody = data.subdataWithRange(askPriceRange)
        var askPrice: Int32 = 0
        askPriceBody.getBytes(&askPrice, length: sizeofValue(askPrice))
        
        let askVolBody = data.subdataWithRange(askVolRange)
        var askVol: Int32 = 0
        askVolBody.getBytes(&askVol, length: sizeofValue(askVol))
        
        let lastQuBody = data.subdataWithRange(lastQuRange)
        var lastQu: Int32 = 0
        lastQuBody.getBytes(&lastQu, length: sizeofValue(lastQu))
        
        let totVolBody = data.subdataWithRange(totalVolRange)
        var totVol: Int32 = 0
        //        var totVol: Int32 = 0
        totVolBody.getBytes(&totVol, length: sizeofValue(totVol))
        
        let openPriceBody = data.subdataWithRange(openPriceRange)
        var openPrice: Int32 = 0
        openPriceBody.getBytes(&openPrice, length: sizeofValue(openPrice))
        
        let highestPriceBody = data.subdataWithRange(highestPriceRange)
        var highestPrice: Int32 = 0
        highestPriceBody.getBytes(&highestPrice, length: sizeofValue(highestPrice))
        
        let lowestPriceBody = data.subdataWithRange(lowestPriceRange)
        var lowestPrice: Int32 = 0
        lowestPriceBody.getBytes(&lowestPrice, length: sizeofValue(lowestPrice))
        
        let preClosePriceBody = data.subdataWithRange(preClosePriceRange)
        var preClosePrice: Int32 = 0
        preClosePriceBody.getBytes(&preClosePrice, length: sizeofValue(preClosePrice))
        
        let turnOverBody = data.subdataWithRange(turnOverRange)
        var turnOver: Int64 = 0
        //        var turnOver: Int32 = 0
        turnOverBody.getBytes(&turnOver, length: sizeofValue(turnOver))
        
        let uppPriceBody = data.subdataWithRange(uppPriceRange)
        var uppPrice: Int32 = 0
        uppPriceBody.getBytes(&uppPrice, length: sizeofValue(uppPrice))
        
        let lowPriceBody = data.subdataWithRange(lowPriceRange)
        var lowPrice: Int32 = 0
        lowPriceBody.getBytes(&lowPrice, length: sizeofValue(lowPrice))
        
        let averagePriceBody = data.subdataWithRange(averagePriceRange)
        var averagePrice: Int32 = 0
        averagePriceBody.getBytes(&averagePrice, length: sizeofValue(averagePrice))
        
        let ampBody = data.subdataWithRange(ampRange)
        var amp: Int32 = 0
        ampBody.getBytes(&amp, length: sizeofValue(amp))
        
        
        let reserve = data.subdataWithRange(reserved)
        let reserv = self.toString(reserve)
        
        let returned = valOfStock(
            msgTyp: msgInt,
            sessionID: sessionID,
            symName: name,
            symCode: code,
            symPric: price,
            upDownRate: rate,
            upDown: ud,
            bidVol: bidVol,
            bidPrice: bidPrice,
            askPrice: askPrice,
            askVol: askVol,
            lastQuantity: lastQu,
            totalVol: totVol,
            openPrice: openPrice,
            highestPrice: highestPrice,
            lowestPrice: lowestPrice,
            preClosedPrice: preClosePrice,
            turnOver: turnOver,
            upperLimitedPrice: uppPrice,
            lowerLimitedPrice: lowPrice,
            averagePrice: averagePrice,
            amplitude: amp,
            Reserve: reserv
        )
        
        return returned
    }
    // MARK: String
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
    var headData: NSMutableArray = NSMutableArray(capacity: 10)
    var leftTableData: NSMutableArray = NSMutableArray(capacity: 10)
    var rightTableData: NSMutableArray = NSMutableArray(capacity: 10)
    var index: Int = 0
    var backController: UIViewController!
    var vIndex: Int!
    var exchangeIDs: [UInt8!] = [100, 101]
    var isGotPara: Bool = false
    
    let tableView = XCMultiTableView()
    var multiDataClass = MultipleTableDataGetting()
    var selfView: UIScrollView!
    
    //Back Button define
    @IBAction func backBtn(sender: UIBarButtonItem) {
        
        
        self.navigationController!.popViewControllerAnimated(true)
    }
    override func viewWillAppear(animated: Bool) {
        self.requestMultipleData()
    }
    
    override func viewDidLoad() {
        //
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "gotMultiTableData:",name:"getMultipleTableData", object: nil )
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor(red: 50/255, green: 50/255, blue: 50/255, alpha: 1)
        self.initData()
//        self.requestMultipleData()
        tableView.frame = CGRect(x: 0, y: self.navigationController!.navigationBar.frame.height+20, width: self.view.frame.size.width, height: self.view.frame.size.height - 49 - self.navigationController!.navigationBar.frame.height-20)
        tableView.datasource = self
        tableView.delegate = self
        tableView.leftHeaderEnable = true
        tableView.backgroundColor = UIColor(red: 0.3, green: 0.3, blue: 0.3, alpha: 1.0)
        
        self.selfView = UIScrollView(frame: CGRect(x: 0, y: -self.navigationController!.navigationBar.frame.height-20, width: self.view.frame.size.width, height: 1000))
        self.selfView.delegate = self
        self.selfView.addSubview(tableView)
        self.view.addSubview(selfView)
        

//        self.view.addSubview(tableView)
    }
    
    //
    func requestMultipleData(){
        midMultipleData.removeAll()
        self.multiDataClass.msgType = 108
        self.multiDataClass.sessionStr = sessionIDD
        self.multiDataClass.securityType = 100
        self.multiDataClass.symParaName = "Price"
        self.multiDataClass.sortParaName = "Price"
        self.multiDataClass.sortType = 0
        self.multiDataClass.startIndex = 0
        self.multiDataClass.endIndex = 50
        self.multiDataClass.clientSending()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func initData()
    {
        // initialization of parameters
        self.leftTableData.removeAllObjects()
        self.rightTableData.removeAllObjects()
        self.headData.removeAllObjects()
        headData.addObject("2.最新价")
        headData.addObject("3.涨跌幅％")
        headData.addObject("4.涨跌")
        headData.addObject("5.买量")
        headData.addObject("6.买价")
        headData.addObject("7.卖价")
        headData.addObject("8.卖量")
        headData.addObject("9.现量")
        headData.addObject("10.总量")
        headData.addObject("11.今开")
        headData.addObject("12.最高")
        headData.addObject("13.最低")
        headData.addObject("14.昨收")
        headData.addObject("15.总金额")
        headData.addObject("16.涨停")
        headData.addObject("17.跌停")
        headData.addObject("18.均价")
        headData.addObject("19.振幅")
        
        let one: NSMutableArray = NSMutableArray(capacity: 10)
        for i in 0..<midMultipleData.count
        {
            let addString: String = midMultipleData[i].name+"\n"+midMultipleData[i].code
            one.addObject(addString)
        }
        leftTableData.addObject(one)
        let oneR: NSMutableArray = NSMutableArray(capacity: 10)
        for i in 0..<midMultipleData.count
        {
            let ary: NSMutableArray = NSMutableArray(capacity: 10)
            ary.addObject(String(format: "%.2f", midMultipleData[i].recentPrice))
            ary.addObject(String(format: "%.2f", midMultipleData[i].udRate))
            ary.addObject(String(format: "%.2f", midMultipleData[i].udValue))
            ary.addObject(midMultipleData[i].sellAmount)
            ary.addObject(String(format: "%.2f", midMultipleData[i].sellPrice))
            ary.addObject(String(format: "%.2f", midMultipleData[i].buyPrice))
            ary.addObject(midMultipleData[i].buyAmount)
            ary.addObject(midMultipleData[i].nowAmount)
            ary.addObject(midMultipleData[i].totAmount)
            ary.addObject(String(format: "%.2f", midMultipleData[i].openPrice))
            ary.addObject(String(format: "%.2f", midMultipleData[i].highestPrice))
            ary.addObject(String(format: "%.2f", midMultipleData[i].lowestPrice))
            ary.addObject(String(format: "%.2f", midMultipleData[i].preClosePrice))
            ary.addObject(String(format: "%.2f", midMultipleData[i].turnOver))
            ary.addObject(String(format: "%.2f", midMultipleData[i].upLimitedPrice))
            ary.addObject(String(format: "%.2f", midMultipleData[i].lowLimitedPrice))
            ary.addObject(String(format: "%.2f", midMultipleData[i].averagePrice))
            ary.addObject(String(format: "%.2f", midMultipleData[i].amplitude))
            oneR.addObject(ary)
            
//            ary.addObject(String(format: "%.2f", midMultipleData[i].recentPrice*100))
//            ary.addObject(midMultipleData[i].udRate.roundTo2f)
//            ary.addObject(midMultipleData[i].udValue.roundTo2f)
//            ary.addObject(midMultipleData[i].sellAmount.roundTo2f)
//            ary.addObject(midMultipleData[i].sellPrice.roundTo2f)
//            ary.addObject(midMultipleData[i].buyPrice.roundTo2f)
//            ary.addObject(midMultipleData[i].buyAmount.roundTo2f)
//            ary.addObject(midMultipleData[i].nowAmount.roundTo2f)
//            ary.addObject(midMultipleData[i].totAmount.roundTo2f)
//            ary.addObject(midMultipleData[i].openPrice.roundTo2f)
//            ary.addObject(midMultipleData[i].highestPrice.roundTo2f)
//            ary.addObject(midMultipleData[i].lowestPrice.roundTo2f)
//            ary.addObject(midMultipleData[i].preClosePrice.roundTo2f)
//            ary.addObject(midMultipleData[i].turnOver.roundTo2f)
//            ary.addObject(midMultipleData[i].upLimitedPrice.roundTo2f)
//            ary.addObject(midMultipleData[i].lowLimitedPrice.roundTo2f)
//            ary.addObject(midMultipleData[i].averagePrice.roundTo2f)
//            ary.addObject(midMultipleData[i].amplitude)
//            oneR.addObject(ary)
        }
        rightTableData.addObject(oneR)
    }
    
    
    // XCMultiColumnTableViewDataSource
    func numberOfSectionsInTableView(tableView: XCMultiTableView!) -> UInt {
        return 1
    }
    
    func arrayDataForTopHeaderInTableView(tableView: XCMultiTableView!) -> [AnyObject]! {
        let hHeadData =  headData.copy() as! [AnyObject]
        return hHeadData
    }
    @objc(arrayDataForLeftHeaderInTableView:InSection:)
    func arrayDataForLeftHeaderInTableView(tableView: XCMultiTableView!, inSection section: UInt) -> [AnyObject]! {
        return leftTableData.objectAtIndex(Int(section)) as! [AnyObject]
    }
    @objc(arrayDataForContentInTableView:InSection:)
    func arrayDataForContentInTableView(tableView: XCMultiTableView!, inSection section: UInt) -> [AnyObject]! {
        return rightTableData.objectAtIndex(Int(section)) as! [AnyObject]
    }
    func tableView(tableView: XCMultiTableView!, inColumn column: Int) -> AlignHorizontalPosition {
//        return AlignHorizontalPosition.Center
        return AlignHorizontalPosition.Right
    }
    func tableView(tableView: XCMultiTableView!, contentTableCellWidth column: UInt) -> CGFloat {
        if (column == 0)
        {
            return 120
        }
        return 120
    }
    
    func tableView(tableView: XCMultiTableView!, cellHeightInRow row: UInt, inSection section: UInt) -> CGFloat {
        
        var hCell = CGFloat!()
        if section == 0
        {
            hCell = 80
        }else {
            hCell = 80
        }
        //print("Row: \(row), \(hCell)")
        return hCell
    }

    func tableView(tableView: XCMultiTableView!, bgColorInSection section: UInt, inRow row: UInt, inColumn column: UInt) -> UIColor! {
        return UIColor(red: 50/255, green: 50/255, blue: 50/255, alpha: 1.0)
    }
    
    func tableView(tableView: XCMultiTableView!, headerBgColorInColumn column: UInt) -> UIColor! {
        return UIColor(red: 50/255, green: 50/255, blue: 50/255, alpha: 1)
    }
    func vertexName() -> String! {
        return "1.名称代码";
    }
   
    // XCMultiTableViewDelegate
    func tableViewWithType(tableViewType: MultiTableViewType, didSelectRowAtIndexPath indexPath: NSIndexPath!) {
        selectedString = "multiData"
        selectedIndex = indexPath.row
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let guDetailVC: GuDetailMainViewController = storyBoard.instantiateViewControllerWithIdentifier("gudetailView") as! GuDetailMainViewController
        self.navigationController!.pushViewController(guDetailVC, animated: true)
    }
    func scrollViewDidScroll(scrollView: UIScrollView) {
        print("Scrolled")
    }
    
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        print("Here is the bottom of the View")
    }
    
    var stocks: [HuShenGuMultipleTableData] = []
    func gotMultiTableData(notification: NSNotification){
        var stockIndex: Int16 = 1
        let data = notification.userInfo!["response"] as! NSData
        let tmpData = fixingSockets(data)
        for tmpSocket in tmpData{
            let msgRange = NSMakeRange(0, 1)
            let msgBody = tmpSocket.subdataWithRange(msgRange)
            var msgInt:UInt8 = 0
            msgBody.getBytes(&msgInt, range: msgRange)
            switch msgInt
            {
            case 210:
                break
            case 211:
                print(" \(stockIndex++))\(msgInt): \(tmpSocket.length) Bytes in \(data.length) Bytes")
                let dataStruct = self.toStock(tmpSocket)
                let resGuData = HuShenGuMultipleTableData(
                    name: dataStruct.symName,
                    code: dataStruct.symCode,
                    recPrice: (Double(dataStruct.symPric)/10000).roundTo2f,
                    udRate: (Double(dataStruct.upDownRate)/10000).roundTo2f,
                    udValue: (Double(dataStruct.upDown)/1000).roundTo2f,
                    selAmount: Double(dataStruct.bidVol).roundTo2f,
                    selPrice: (Double(dataStruct.bidPrice)/10000).roundTo2f,
                    buyAmount: Double(dataStruct.askVol).roundTo2f,
                    buyPrice: (Double(dataStruct.askPrice)/10000).roundTo2f,
                    nowAmount: Double(dataStruct.lastQuantity).roundTo2f,
                    totAmount: (Double(dataStruct.totalVol)).roundTo2f,
                    openPrice: (Double(dataStruct.openPrice)/10000).roundTo2f,
                    highestPrice: (Double(dataStruct.highestPrice)/10000).roundTo2f,
                    lowestPrice: (Double(dataStruct.lowestPrice)/10000).roundTo2f,
                    preClosedPrice: (Double(dataStruct.preClosedPrice)/10000).roundTo2f,
                    turnOver: Double(dataStruct.turnOver)/10000.roundTo2f,
                    upLimit: (Double(dataStruct.upperLimitedPrice)/10000).roundTo2f,
                    lowLimit: (Double(dataStruct.lowerLimitedPrice)/10000).roundTo2f,
                    average: (Double(dataStruct.averagePrice)/10000).roundTo2f,
                    amplitude: Double(dataStruct.amplitude)/10000.roundTo2f
                )
                self.stocks.append(resGuData)
            case 212:
                print(" \(stockIndex++))\(msgInt): \(tmpSocket.length) Bytes in \(data.length) Bytes")
                if tmpData.count != 1{
                    print("------------------- Finished --------------------")
                    print("")
                }
                let endData = self.endMsgToNSData(tmpSocket)
                if endData.results == "Y"
                {
                    //Processing for display data to proper viewcontroller.
                    midMultipleData = self.stocks
                    eIndex = UInt16(midMultipleData.count)
                    dispatch_async(dispatch_get_main_queue()){
                        //            [weak self] in
                        self.isGotPara = true
                        self.initData()
                        self.tableView.reloadData()
                    }
                }
            default:
                break
            }
        }
    }
}
