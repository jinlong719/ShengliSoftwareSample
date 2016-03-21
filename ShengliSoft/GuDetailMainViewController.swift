//
//  GuDetailMainViewController.swift
//  ShengliSoft
//
//  Created by EagleWind on 12/8/15.
//  Copyright © 2015 iCloudTest. All rights reserved.
//

import UIKit
import Charts
import CocoaAsyncSocket


var selectedString: String!
var shouldRefresh: Bool = false


class GuDetailTVC: UITableViewCell{
    
    @IBOutlet weak var timeCell: UILabel!
    @IBOutlet weak var priceCell: UILabel!
    @IBOutlet weak var volCell: UILabel!
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: true)
    }
}

class GuDetailMainViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, ChartViewDelegate {
    //Socket communication part
    //MARK: -Summary
    struct guSumDataReceived {
        var msgTyp: UInt16
        var sessionID: String
        var symName: String
        var symCode: String
        var price: Int
        var udRate: Int
        var udValue: Int
        var highestPrice: Int32
        var lowestPrice: Int32
        var openPrice: Int32
        var preClosedPrice: Int32
        var totalVol: Int64
        var turnOver: Int64
        var turnOverRate: Int
        var upLimitedPrice: Int32
        var amplitude: Int32
        var volRatio: Int32
        var commitee: Int32
        var lowLimitedPrice: Int32
        var priceEarningRatio: Int32
        var marketPrice: Int64
        var currencyValue: Int64
        var reserved: String
    }
    struct lenGuSumDataReceived {
        var lenMsg: Int16
        var lenSID: Int16
        var lenSyN: Int16
        var lenSyC: Int16
        var lenPrc: Int16
        var lenUdR: Int16
        var lenUdV: Int16
        var lenHiP: Int16
        var lenLoP: Int16
        var lenOpP: Int16
        var lenPrP: Int16
        var lenToV: Int16
        var lenTuO: Int16
        var lenTOR: Int16
        var lenULP: Int16
        var lenAmp: Int16
        var lenVoR: Int16
        var lenCom: Int16
        var lenLLP: Int16
        var lenPER: Int16
        var lenMaP: Int16
        var lenCuV: Int16
        var lenRev: Int16
    }
    
    func toSumData(data: NSData) -> guSumDataReceived{
        var unarchivedResData = lenGuSumDataReceived(
            lenMsg: 1,
            lenSID: 32,
            lenSyN: 32,
            lenSyC: 32,
            lenPrc: 8,
            lenUdR: 4,
            lenUdV: 4,
            lenHiP: 4,
            lenLoP: 4,
            lenOpP: 4,
            lenPrP: 4,
            lenToV: 8,
            lenTuO: 8,
            lenTOR: 4,
            lenULP: 4,
            lenAmp: 4,
            lenVoR: 4,
            lenCom: 4,
            lenLLP: 4,
            lenPER: 4,
            lenMaP: 8,
            lenCuV: 8,
            lenRev: 3
        )
        
        let archivedData = data.subdataWithRange(NSMakeRange(0, 0))
        archivedData.getBytes(&unarchivedResData, length: 192)
        
        let msgRange = NSMakeRange(0, 1)
        let sIDRange = NSMakeRange(1, 32)
        let nameRange = NSMakeRange(33, 32)
        let codeRange = NSMakeRange(65, 32)
        let pricRange = NSMakeRange(97, 4)
        let udRateRange = NSMakeRange(101, 4)
        let udValueRange = NSMakeRange(105, 4)
        let highestPriceRange = NSMakeRange(109, 4)
        let lowestPriceRange = NSMakeRange(113, 4)
        let openPriceRange = NSMakeRange(117, 4)
        let preClosePriceRange = NSMakeRange(121, 4)
        let totVolRange = NSMakeRange(125, 8)
        let turnOverRange = NSMakeRange(133, 8)
        let turnOverRateRange = NSMakeRange(141, 4)
        let uppPriceRange = NSMakeRange(145, 4)
        let ampRange = NSMakeRange(149, 4)
        let volRatioRange = NSMakeRange(153, 4)
        let commiteeRange = NSMakeRange(157, 4)
        let lowPriceRange = NSMakeRange(161, 4)
        let priceEarnRatioRange = NSMakeRange(165, 4)
        let marketPriceRange = NSMakeRange(169, 8)
        let currencyValRange = NSMakeRange(177, 8)
        let reserved = NSMakeRange(185, 7)
        
        
        let msgBody = data.subdataWithRange(msgRange)
        var msgInt:UInt16 = 0
        msgBody.getBytes(&msgInt, range: msgRange)
        
        let sidBody = data.subdataWithRange(sIDRange)
        let sessionID = self.toStr(sidBody)
        
        let nameBody = data.subdataWithRange(nameRange)
        let name = self.toStr(nameBody)
        
        let codeBody = data.subdataWithRange(codeRange)
        let code = self.toStr(codeBody)
        
        let priceBody = data.subdataWithRange(pricRange)
//        print("Price body: \(priceBody)")
        var price: Int = 0
        priceBody.getBytes(&price, length: sizeofValue(price))
        
        let rateBody = data.subdataWithRange(udRateRange)
//        print("Rate Binary: \(rateBody)")
        var rate: Int = 0
        rateBody.getBytes(&rate, length: sizeofValue(rate))
        
        let udValBody = data.subdataWithRange(udValueRange)
//        print("udVal Binary: \(udValBody)")
        var udVal: Int = 0
        udValBody.getBytes(&udVal, length: sizeofValue(udVal))
        
        let highestBody = data.subdataWithRange(highestPriceRange)
        var highest: Int32 = 0
        highestBody.getBytes(&highest, length: sizeofValue(highest))
        
        let lowestBody = data.subdataWithRange(lowestPriceRange)
        var lowest: Int32 = 0
        lowestBody.getBytes(&lowest, length: sizeofValue(lowest))
        
        let openPriceBody = data.subdataWithRange(openPriceRange)
        var openPrice: Int32 = 0
        openPriceBody.getBytes(&openPrice, length: sizeofValue(openPrice))
        
        let preClosedBody = data.subdataWithRange(preClosePriceRange)
        var preClosed: Int32 = 0
        preClosedBody.getBytes(&preClosed, length: sizeofValue(preClosed))
        
        let totVolBody = data.subdataWithRange(totVolRange)
        var totVol: Int64 = 0
        totVolBody.getBytes(&totVol, length: sizeofValue(totVol))
        
        let turnOverBody = data.subdataWithRange(turnOverRange)
        var turnOver: Int64 = 0
        turnOverBody.getBytes(&turnOver, length: sizeofValue(turnOver))
        
        let turnOverRateBody = data.subdataWithRange(turnOverRateRange)
        var turnOverRate: Int = 0
        turnOverRateBody.getBytes(&turnOverRate, length: sizeofValue(turnOverRate))
        
        let upperPriceBody = data.subdataWithRange(uppPriceRange)
        var upperPrice: Int32 = 0
        upperPriceBody.getBytes(&upperPrice, length: sizeofValue(upperPrice))
        
        let ampBody = data.subdataWithRange(ampRange)
        var amp: Int32 = 0
        ampBody.getBytes(&amp, length: sizeofValue(amp))
        
        let volRatioBody = data.subdataWithRange(volRatioRange)
        var volRatio: Int32 = 0
        volRatioBody.getBytes(&volRatio, length: sizeofValue(volRatio))
        
        let committeeBody = data.subdataWithRange(commiteeRange)
        var committee: Int32 = 0
        //        var turnOver: Int32 = 0
        committeeBody.getBytes(&committee, length: sizeofValue(committee))
        
        let lowPriceBody = data.subdataWithRange(lowPriceRange)
        var lowPrice: Int32 = 0
        lowPriceBody.getBytes(&lowPrice, length: sizeofValue(lowPrice))
        
        let priceEarnRatioBody = data.subdataWithRange(priceEarnRatioRange)
        var priceEarnRatio: Int32 = 0
        
        priceEarnRatioBody.getBytes(&priceEarnRatio, length: sizeofValue(priceEarnRatio))
        let marketPriceBody = data.subdataWithRange(marketPriceRange)
        
        var marketPrice: Int64 = 0
        marketPriceBody.getBytes(&marketPrice, length: sizeofValue(marketPrice))
        
        let currencyBody = data.subdataWithRange(currencyValRange)
        var currency: Int64 = 0
        currencyBody.getBytes(&currency, length: sizeofValue(currency))
        
        
        let reserve = data.subdataWithRange(reserved)
        let reserv = NSString(data: reserve, encoding: NSUTF8StringEncoding) as! String
        
        let returned = guSumDataReceived(
            msgTyp: msgInt,
            sessionID: sessionID,
            symName: name,
            symCode: code,
            price: price,
            udRate: rate,
            udValue: udVal,
            highestPrice: highest,
            lowestPrice: lowest,
            openPrice: openPrice,
            preClosedPrice: preClosed,
            totalVol: totVol,
            turnOver: turnOver,
            turnOverRate: turnOverRate,
            upLimitedPrice: upperPrice,
            amplitude: amp,
            volRatio: volRatio,
            commitee: committee,
            lowLimitedPrice: lowPrice,
            priceEarningRatio: priceEarnRatio,
            marketPrice: marketPrice,
            currencyValue: currency,
            reserved: reserv
        )
//        print("Summary Datas: \(returned)")
        return returned
    }
    ///
    // MARK: -TimeSale data
    struct guTimeSale {
        var msgType: UInt16
        var sessionID: String
        var cuTime: String
        var cuPrice: Int32
        var cuVolumn: Int32
        var reserved: String
    }
    struct lenGuTimeSale {
        var lenMsg: Int16
        var lenSID: Int16
        var lenCuT: Int16
        var lenCuP: Int16
        var lenCuV: Int16
        var lenRev: Int16
    }
    func toTimeSale(data: NSData) -> guTimeSale{
        var unarchivedResData = lenGuTimeSale(
            lenMsg: 1,
            lenSID: 32,
            lenCuT: 32,
            lenCuP: 4,
            lenCuV: 4,
            lenRev: 7
        )
        let archivedData = data.subdataWithRange(NSMakeRange(0, 0))
        archivedData.getBytes(&unarchivedResData, length: 192)
        
        let msgRange = NSMakeRange(0, 1)
        let sIDRange = NSMakeRange(1, 32)
        let cuTRange = NSMakeRange(33, 32)
        let cuPRange = NSMakeRange(65, 4)
        let cuVRange = NSMakeRange(69, 4)
        let revRange = NSMakeRange(73, 7)
        
        let msgBody = data.subdataWithRange(msgRange)
        var msgInt: UInt16 = 0
        msgBody.getBytes(&msgInt, range: msgRange)
        
        let sessionID = data.subdataWithRange(sIDRange)
        let sessionStr = self.toStr(sessionID)
        
        let cuTimeBody = data.subdataWithRange(cuTRange)
        let cuTime = self.toStr(cuTimeBody)
        
        
        let cuPBody = data.subdataWithRange(cuPRange)
        var cuPrice: Int32 = 0
        cuPBody.getBytes(&cuPrice, length: sizeofValue(cuPrice))
        
        let cuVBody = data.subdataWithRange(cuVRange)
        var cuVol: Int32 = 0
        cuVBody.getBytes(&cuVol, length: sizeofValue(cuVol))
        
        let revBody = data.subdataWithRange(revRange)
        let reserved = self.toStr(revBody)
        
        let returnedData = guTimeSale(
            msgType: msgInt,
            sessionID: sessionStr,
            cuTime: cuTime,
            cuPrice: cuPrice,
            cuVolumn: cuVol,
            reserved: reserved
        )
        return returnedData
    }
    
    // MARK: -LEV2
    struct guLEV2Data {
        var msgType: UInt16
        var sessionID: String
        var bidPrice1: Int32
        var bidPrice2: Int32
        var bidPrice3: Int32
        var bidPrice4: Int32
        var bidPrice5: Int32
        var bidVol1: Int32
        var bidVol2: Int32
        var bidVol3: Int32
        var bidVol4: Int32
        var bidVol5: Int32
        var askPrice1: Int32
        var askPrice2: Int32
        var askPrice3: Int32
        var askPrice4: Int32
        var askPrice5: Int32
        var askVol1: Int32
        var askVol2: Int32
        var askVol3: Int32
        var askVol4: Int32
        var askVol5: Int32
        var reserev: String
    }
    
    struct lenLEV2Data {
        var lenMsg: Int16
        var lenSID: Int16
        var lenBP1: Int16
        var lenBP2: Int16
        var lenBP3: Int16
        var lenBP4: Int16
        var lenBP5: Int16
        var lenBV1: Int16
        var lenBV2: Int16
        var lenBV3: Int16
        var lenBV4: Int16
        var lenBV5: Int16
        var lenAP1: Int16
        var lenAP2: Int16
        var lenAP3: Int16
        var lenAP4: Int16
        var lenAP5: Int16
        var lenAV1: Int16
        var lenAV2: Int16
        var lenAV3: Int16
        var lenAV4: Int16
        var lenAV5: Int16
        var lenRev: Int16
    }
    func toLEV2Data(data: NSData) -> guLEV2Data{
        var unarchivedResData = lenLEV2Data(
            lenMsg: 1,
            lenSID: 32,
            lenBP1: 4,
            lenBP2: 4,
            lenBP3: 4,
            lenBP4: 4,
            lenBP5: 4,
            lenBV1: 4,
            lenBV2: 4,
            lenBV3: 4,
            lenBV4: 4,
            lenBV5: 4,
            lenAP1: 4,
            lenAP2: 4,
            lenAP3: 4,
            lenAP4: 4,
            lenAP5: 4,
            lenAV1: 4,
            lenAV2: 4,
            lenAV3: 4,
            lenAV4: 4,
            lenAV5: 4,
            lenRev: 7
        )
        let archivedData = data.subdataWithRange(NSMakeRange(0, 0))
        archivedData.getBytes(&unarchivedResData, length: 120)
        
        let msgRange = NSMakeRange(0, 1)
        let sIDRange = NSMakeRange(1, 32)
        
        let msgBody = data.subdataWithRange(msgRange)
        var msgInt :UInt16 = 0
        msgBody.getBytes(&msgInt, length: sizeofValue(msgInt))
        
        let sessionBody = data.subdataWithRange(sIDRange)
        let sessionString = self.toStr(sessionBody)
        
        let bp1 = data.subdataWithRange(NSMakeRange(33, 4))
        var bidPrice1: Int32 = 0
        bp1.getBytes(&bidPrice1, length: sizeofValue(bidPrice1))
        
        let bp2 = data.subdataWithRange(NSMakeRange(37, 4))
        var bidPrice2: Int32 = 0
        bp2.getBytes(&bidPrice2, length: sizeofValue(bidPrice2))
        
        let bp3 = data.subdataWithRange(NSMakeRange(41, 4))
        var bidPrice3: Int32 = 0
        bp3.getBytes(&bidPrice3, length: sizeofValue(bidPrice3))
        
        let bp4 = data.subdataWithRange(NSMakeRange(45, 4))
        var bidPrice4: Int32 = 0
        bp4.getBytes(&bidPrice4, length: sizeofValue(bidPrice4))
        
        let bp5 = data.subdataWithRange(NSMakeRange(49, 4))
        var bidPrice5: Int32 = 0
        bp5.getBytes(&bidPrice5, length: sizeofValue(bidPrice5))
        
        let bv1 = data.subdataWithRange(NSMakeRange(53, 4))
        var bidVol1: Int32 = 0
        bv1.getBytes(&bidVol1, length: sizeofValue(bidVol1))
        
        let bv2 = data.subdataWithRange(NSMakeRange(57, 4))
        var bidVol2: Int32 = 0
        bv2.getBytes(&bidVol2, length: sizeofValue(bidVol2))
        
        let bv3 = data.subdataWithRange(NSMakeRange(61, 4))
        var bidVol3: Int32 = 0
        bv3.getBytes(&bidVol3, length: sizeofValue(bidVol3))
        
        let bv4 = data.subdataWithRange(NSMakeRange(65, 4))
        var bidVol4: Int32 = 0
        bv4.getBytes(&bidVol4, length: sizeofValue(bidVol4))
        
        let bv5 = data.subdataWithRange(NSMakeRange(69, 4))
        var bidVol5: Int32 = 0
        bv5.getBytes(&bidVol5, length: sizeofValue(bidVol5))
        
        let askP1 = data.subdataWithRange(NSMakeRange(73, 4))
        var askPrice1: Int32 = 0
        askP1.getBytes(&askPrice1, length: sizeofValue(askPrice1))
        
        let askP2 = data.subdataWithRange(NSMakeRange(77, 4))
        var askPrice2: Int32 = 0
        askP2.getBytes(&askPrice2, length: sizeofValue(askPrice2))
        
        let askP3 = data.subdataWithRange(NSMakeRange(81, 4))
        var askPrice3: Int32 = 0
        askP3.getBytes(&askPrice3, length: sizeofValue(askPrice3))
        
        let askP4 = data.subdataWithRange(NSMakeRange(85, 4))
        var askPrice4: Int32 = 0
        askP4.getBytes(&askPrice4, length: sizeofValue(askPrice4))
        
        let askP5 = data.subdataWithRange(NSMakeRange(89, 4))
        var askPrice5: Int32 = 0
        askP5.getBytes(&askPrice5, length: sizeofValue(askPrice5))
        
        let askV1 = data.subdataWithRange(NSMakeRange(93, 4))
        var askVol1: Int32 = 0
        askV1.getBytes(&askVol1, length: sizeofValue(askVol1))
        
        let askV2 = data.subdataWithRange(NSMakeRange(97, 4))
        var askVol2: Int32 = 0
        askV2.getBytes(&askVol2, length: sizeofValue(askVol2))
        
        let askV3 = data.subdataWithRange(NSMakeRange(101, 4))
        var askVol3: Int32 = 0
        askV3.getBytes(&askVol3, length: sizeofValue(askVol3))
        
        let askV4 = data.subdataWithRange(NSMakeRange(105, 4))
        var askVol4: Int32 = 0
        askV4.getBytes(&askVol4, length: sizeofValue(askVol4))
        
        let askV5 = data.subdataWithRange(NSMakeRange(109, 4))
        var askVol5: Int32 = 0
        askV5.getBytes(&askVol5, length: sizeofValue(askVol5))
        
        let reserved = data.subdataWithRange(NSMakeRange(113, 7))
        let reservedStr = NSString(data: reserved, encoding: NSUTF8StringEncoding) as! String
        
        let returnedData = guLEV2Data(
            msgType: msgInt,
            sessionID: sessionString,
            bidPrice1: bidPrice1,
            bidPrice2: bidPrice2,
            bidPrice3: bidPrice3,
            bidPrice4: bidPrice4,
            bidPrice5: bidPrice5,
            bidVol1: bidVol1,
            bidVol2: bidVol2,
            bidVol3: bidVol3,
            bidVol4: bidVol4,
            bidVol5: bidVol5,
            askPrice1: askPrice1,
            askPrice2: askPrice2,
            askPrice3: askPrice3,
            askPrice4: askPrice4,
            askPrice5: askPrice5,
            askVol1: askVol1,
            askVol2: askVol2,
            askVol3: askVol3,
            askVol4: askVol4,
            askVol5: askVol5,
            reserev: reservedStr
        )
        return returnedData
    }
    // Main Data 217
    struct kChartData {
        var msgType: Int16
        var sessionID: String
        var currentTime: String
        var currentPrice: Int32
        var highestPrice: Int32
        var lowestPrice: Int32
        var openPrice: Int32
        var preClosedPrice: Int32
        var totalVol: Double
        var turnOver: Double
        var upDown: Int32
        var amplitude: Int32
        var turnOverRate: Int32
        var currencyValue: Double
        var volumn: Double
        var averageVol5: Double
        var averageVol10: Double
        var averageVol20: Double
        var reserved: String
    }
    struct lenKchartData {
        var lenMsg: Int16
        var lenSID: Int16
        var lenCuT: Int16
        var lenCuP: Int16
        var lenHiP: Int16
        var lenLoP: Int16
        var lenOpP: Int16
        var lenPCP: Int16
        var lenToV: Int16
        var lenTuO: Int16
        var lenUpD: Int16
        var lenAmp: Int16
        var lenTOR: Int16
        var lenCuV: Int16
        var lenVol: Int16
        var lenAV5: Int16
        var lenAV10: Int16
        var lenAV20: Int16
        var lenRev: Int16
    }
    // Convert kchartdata from NSData 217
    func toKchartData(data: NSData) -> kChartData{
        var unarchivedResData = lenKchartData(
            lenMsg: 1,
            lenSID: 32,
            lenCuT: 32,
            lenCuP: 4,
            lenHiP: 4,
            lenLoP: 4,
            lenOpP: 4,
            lenPCP: 4,
            lenToV: 8,
            lenTuO: 8,
            lenUpD: 4,
            lenAmp: 4,
            lenTOR: 4,
            lenCuV: 8,
            lenVol: 8,
            lenAV5: 8,
            lenAV10: 8,
            lenAV20: 8,
            lenRev: 7
        )
        
        let archivedData = data.subdataWithRange(NSMakeRange(0, 0))
        archivedData.getBytes(&unarchivedResData, length: 160)
        
        let msgRange = NSMakeRange(0, 1)
        let sIDRange = NSMakeRange(1, 32)
        let cuTRange = NSMakeRange(33, 32)
        let cuPriceRange = NSMakeRange(65, 4)
        let highestPriceRange = NSMakeRange(69, 4)
        let lowestPriceRange = NSMakeRange(73, 4)
        let openPriceRange = NSMakeRange(77, 4)
        let preClosePriceRange = NSMakeRange(81, 4)
        let totVolRange = NSMakeRange(85, 8)
        let turnOverRange = NSMakeRange(93, 8)
        let upDownPriceRange = NSMakeRange(101, 4)
        let ampRange = NSMakeRange(105, 4)
        let turnOverRateRange = NSMakeRange(109, 4)
        let currencyValRange = NSMakeRange(113, 8)
        let volRange = NSMakeRange(121, 8)
        let av5Range = NSMakeRange(129, 8)
        let av10Range = NSMakeRange(137, 8)
        let av20Range = NSMakeRange(145, 8)
        let reserved = NSMakeRange(153, 7)
        
        
        let msgBody = data.subdataWithRange(msgRange)
        var msgInt:Int16 = 0
        msgBody.getBytes(&msgInt, range: msgRange)
        
        let sidBody = data.subdataWithRange(sIDRange)
        let sessionID = self.toStr(sidBody)
        
        let cuTimeBody = data.subdataWithRange(cuTRange)
        let cuTime = self.toStr(cuTimeBody)
        
        let cuPriceBody = data.subdataWithRange(cuPriceRange)
        var cuPrice: Int32 = 0
        cuPriceBody.getBytes(&cuPrice, length: sizeofValue(cuPrice))
        
        let highestBody = data.subdataWithRange(highestPriceRange)
        var highest: Int32 = 0
        highestBody.getBytes(&highest, length: sizeofValue(highest))
        
        let lowestBody = data.subdataWithRange(lowestPriceRange)
        var lowest: Int32 = 0
        lowestBody.getBytes(&lowest, length: sizeofValue(lowest))
        
        let openPriceBody = data.subdataWithRange(openPriceRange)
        var openPrice: Int32 = 0
        openPriceBody.getBytes(&openPrice, length: sizeofValue(openPrice))
        
        let preClosedBody = data.subdataWithRange(preClosePriceRange)
        var preClosed: Int32 = 0
        preClosedBody.getBytes(&preClosed, length: sizeofValue(preClosed))
        
        let totVolBody = data.subdataWithRange(totVolRange)
        var totVol: Double = 0
        totVolBody.getBytes(&totVol, length: sizeofValue(totVol))
        
        let turnOverBody = data.subdataWithRange(turnOverRange)
        var turnOver: Double = 0
        //        var totVol: Int32 = 0
        turnOverBody.getBytes(&turnOver, length: sizeofValue(turnOver))
        
        let upDownBody = data.subdataWithRange(upDownPriceRange)
        var upDownPrice: Int32 = 0
        upDownBody.getBytes(&upDownPrice, length: sizeofValue(upDownPrice))
        
        let ampBody = data.subdataWithRange(ampRange)
        var amp: Int32 = 0
        ampBody.getBytes(&amp, length: sizeofValue(amp))
        
        let turnOverRateBody = data.subdataWithRange(turnOverRateRange)
        var turnOverRate: Int32 = 0
        turnOverRateBody.getBytes(&turnOverRate, length: sizeofValue(turnOverRate))
        
        let currencyBody = data.subdataWithRange(currencyValRange)
        var currency: Double = 0
        currencyBody.getBytes(&currency, length: sizeofValue(currency))
        
        let volBody = data.subdataWithRange(volRange)
        var volumn: Double = 0
        volBody.getBytes(&volumn, length: sizeofValue(volumn))
        
        let av5Body = data.subdataWithRange(av5Range)
        var av5Vol: Double = 0
        av5Body.getBytes(&av5Vol, length: sizeofValue(av5Vol))
        
        let av10Body = data.subdataWithRange(av10Range)
        var av10Vol: Double = 0
        av10Body.getBytes(&av10Vol, length: sizeofValue(av10Vol))
        
        let av20Body = data.subdataWithRange(av20Range)
        var av20Vol: Double = 0
        av20Body.getBytes(&av20Vol, length: sizeofValue(av20Vol))
        
        let reserve = data.subdataWithRange(reserved)
        let reserv = self.toStr(reserve)
        
        let returnedData = kChartData(
            msgType: msgInt,
            sessionID: sessionID,
            currentTime: cuTime,
            currentPrice: cuPrice,
            highestPrice: highest,
            lowestPrice: lowest,
            openPrice: openPrice,
            preClosedPrice: preClosed,
            totalVol: totVol,
            turnOver: turnOver,
            upDown: upDownPrice,
            amplitude: amp,
            turnOverRate: turnOverRate,
            currencyValue: currency,
            volumn: volumn,
            averageVol5: av5Vol,
            averageVol10: av10Vol,
            averageVol20: av20Vol,
            reserved: reserv
        )
        return returnedData
    }
    
    
    //Convert NSData to String
    func toStr(data: NSData) -> String{
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

    
    

    @IBOutlet weak var mainScrollView: UIScrollView!
    //Parameters Initialization
    var guName: UILabel!
    var guIncDecPrice: UILabel!
    var guPubDate: UILabel!
    var guCountry: UIImage!
    
    // Initialization of the stock detail data received from server
    var isGotDetailedData: Bool = false
    
    // Time Sale tableView
   
    @IBOutlet weak var timeTableView: UITableView!
    //
    //sell 5
    @IBOutlet weak var bidPrice1: UILabel!
    @IBOutlet weak var bidPrice2: UILabel!
    @IBOutlet weak var bidPrice3: UILabel!
    @IBOutlet weak var bidPrice4: UILabel!
    @IBOutlet weak var bidPrice5: UILabel!
    @IBOutlet weak var bidVol1: UILabel!
    @IBOutlet weak var bidVol2: UILabel!
    @IBOutlet weak var bidVol3: UILabel!
    @IBOutlet weak var bidVol4: UILabel!
    @IBOutlet weak var bidVol5: UILabel!
    //Buy 5
    @IBOutlet weak var askPrice1: UILabel!
    @IBOutlet weak var askPrice2: UILabel!
    @IBOutlet weak var askPrice3: UILabel!
    @IBOutlet weak var askPrice4: UILabel!
    @IBOutlet weak var askPrice5: UILabel!
    @IBOutlet weak var askVol1: UILabel!
    @IBOutlet weak var askVol2: UILabel!
    @IBOutlet weak var askVol3: UILabel!
    @IBOutlet weak var askVol4: UILabel!
    @IBOutlet weak var askVol5: UILabel!
    
    var isAdded: Bool = false
    var stockAddDel: stockAddDeleteClass = stockAddDeleteClass()
    
    @IBOutlet weak var addDelBtn: UIButton!
    @IBAction func BtnTapped(sender: AnyObject) {
        if self.xData.count == 0{
            return
        }
        
        let okAction: UIAlertAction!
        let cancelAction = UIAlertAction(title: "不", style: UIAlertActionStyle.Cancel, handler: nil)
        var msgString: String!
        var alertController: UIAlertController!
        
        if self.isAdded{
            msgString = "您要删除这个股票吗？"
            okAction = UIAlertAction(title: "是", style: UIAlertActionStyle.Default, handler: {
                alertController -> Void in
                self.addDelBtn.setTitle("+自选", forState: UIControlState.Normal)
                self.isAdded = !self.isAdded
                self.stockAddDel.wasAdding = false// deleting a stock
                self.stockAddDel.secType = 100
                self.stockAddDel.selectedExchangeID = 100
                switch selectedString
                {
                case "zixuangu":
                    self.stockAddDel.symbol = midData[selectedIndex].guCode
                case "hushengu":
                    self.stockAddDel.symbol = midHuShenStocks[selectedSection].guIndex[selectedIndex]
                case "multiData":
                    self.stockAddDel.symbol = midMultipleData[selectedIndex].code
                default:
                    break
                }
                self.stockAddDel.sendData()
            })
        }else{
            msgString = "您要添加这个股票到自选股吗？"
            okAction = UIAlertAction(title: "是", style: UIAlertActionStyle.Default, handler: {
                alertController -> Void in
                self.addDelBtn.setTitle("-自选", forState: UIControlState.Normal)
                self.isAdded = !self.isAdded
                self.stockAddDel.wasAdding = true// adding a stock
                self.stockAddDel.secType = 100
                self.stockAddDel.selectedExchangeID = 100
                switch selectedString
                {
                case "zixuangu":
                    self.stockAddDel.symbol = midData[selectedIndex].guCode
                case "hushengu":
                    self.stockAddDel.symbol = midHuShenStocks[selectedSection].guIndex[selectedIndex]
                case "multiData":
                    self.stockAddDel.symbol = midMultipleData[selectedIndex].code
                default:
                    break
                }
                self.stockAddDel.sendData()
            })
        }
        alertController = UIAlertController(title: "警告", message: msgString, preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        dispatch_async(dispatch_get_main_queue()){
            self.presentViewController(alertController, animated: true, completion: nil)
        }
    }

    //MARK: Searching any stock in my stocks.
    func isInMyStock(indexStr: String) -> Bool{
        var retBool: Bool = false
        for i in 0..<midData.count{
            if indexStr == midData[i].guCode{
                retBool = true
            }
        }
        return retBool
    }
    
    
    
    
    //detailed parameters display:
    @IBOutlet weak var codeRateLbl: UILabel!
    @IBOutlet weak var guNameLbl: UILabel!
    @IBOutlet weak var mainPrice: UILabel!
    @IBOutlet weak var mainInDecAndChange: UILabel!
    @IBOutlet weak var topPrice: UILabel!
    @IBOutlet weak var botPrice: UILabel!
    @IBOutlet weak var openPrice: UILabel!
    @IBOutlet weak var yesterdayPrice: UILabel!
    @IBOutlet weak var transAmount: UILabel!
    @IBOutlet weak var transPrice: UILabel!
    @IBOutlet weak var collectRate: UILabel!
    @IBOutlet weak var magPercent: UILabel!
    @IBOutlet weak var amountRate: UILabel!
    @IBOutlet weak var feeRate: UILabel!
    @IBOutlet weak var earningRate: UILabel!
    @IBOutlet weak var eachHand: UILabel!
    @IBOutlet weak var marketPrice: UILabel!
    @IBOutlet weak var incStopPrice: UILabel!
    @IBOutlet weak var decStopPrice: UILabel!
    @IBOutlet weak var tradingPrice: UILabel!
  
    @IBOutlet weak var graphViewCell: UIView!
    
    @IBOutlet weak var kgraphView: CombinedChartView!
    @IBOutlet weak var wuDangPercentView: UIView!
    @IBOutlet weak var rPercentLbl: UILabel!
    @IBOutlet weak var lPercentLbl: UILabel!
    
    
    var guDetailData = GuDetailData()
    
    
    var detailWindows: detailView = detailView(frame: CGRect(x: 20, y: 20, width: 120, height: 180))
    @IBAction func backBtn(sender: UIBarButtonItem) {
        
        self.navigationController!.popViewControllerAnimated(true)
    }
    
    
    
    var fenshiBtn: UIButton = UIButton(type: UIButtonType.Custom)
    var dayKBtn: UIButton = UIButton(type: UIButtonType.Custom)
    var weekKBtn: UIButton = UIButton(type: UIButtonType.Custom)
    var monthKBtn: UIButton = UIButton(type: UIButtonType.Custom)
    var minuteSortBtn: UIButton = UIButton(type: UIButtonType.Custom)
    
    
    func minuteSortTapped(sender: AnyObject) {
        self.initButtonColorAndSize(sender.tag)
    }
    func btnTapped(sender: UIButton) {
        self.initButtonColorAndSize(sender.tag)
    }
    @IBAction func counterViewTaped(gesture: UITapGestureRecognizer?)
    {
        GxData.removeAll()
        GpriceData.removeAll()
        GopenPrice.removeAll()
        GclosePrice.removeAll()
        Glowest.removeAll()
        Ghighest.removeAll()
        GvolData.removeAll()
        
        var cTimes: [String] = []
        var cPrice: [Double] = []
        var cOpen: [Double] = []
        var cClose: [Double] = []
        var cLow: [Double] = []
        var cHighest: [Double] = []
        var cVol: [Double] = []
        for item in 0..<midKchartData.count
        {
            cTimes.append(midKchartData[item].currentTime)
            cPrice.append(Double(midKchartData[item].price))
            cOpen.append(Double(midKchartData[item].openPrice))
            cClose.append(Double(midKchartData[item].preClosedPrice))
            cLow.append(Double(midKchartData[item].lowest))
            cHighest.append(Double(midKchartData[item].highest))
            cVol.append(Double(midKchartData[item].totalVol))
        }
        GxData = cTimes
        GpriceData = cPrice
        GopenPrice = cOpen
        GclosePrice = cClose
        Glowest = cLow
        Ghighest = cHighest
        GvolData = cVol
        let chartView: ChartMainVC = storyboard?.instantiateViewControllerWithIdentifier("chartMainView") as! ChartMainVC
        self.presentViewController(chartView, animated: true, completion: nil)
    }
    //Get view size
    var scrnW: CGFloat!
    var scrnH: CGFloat!
    //    var xData: [String] = []
    //    var yData: [Double] = []
    
    //    let xData: [String] = ["10.00","10.10","10.20","10.30","10.40","10.50","11.00","11.10","11.20","11.30","11.40","11.50","12.00"]
    //    let yData: [Double] = [11.00,11.00,10.00,12.00,10.00,14.00,15.00,20.00,22.00,30.00,40.00,25.00,10.00]
    //MARK: - When the self was dismissed, the popView parameters initialization
    var isGraphViewShowing: Bool = false
    var refreshController = UIRefreshControl()
    
    // MARK: - Views on This ViewController.
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(true)
        
    }
    func initChartPara(){
//        self.xData = []
        midKchartData = []
        self.priceChartDataSet = nil
        self.avPriceChartDataSet = nil
        self.volChartDataSet = nil
        //K- chart view
        self.candleChartDataSet = nil
        self.sma5ChartDataSet = nil
        self.sma10ChartDataSet = nil
        self.sma20ChartDataSet = nil
        self.vol5ChartDataSet = nil
        self.vol10ChartDataSet = nil
        self.vol20ChartDataSet = nil
    }
    override func viewDidDisappear(animated: Bool) {

        super.viewDidDisappear(true)
        self.isGraphViewShowing = false
        self.initChartPara()
        timerSet.invalidate()
        self.timerIsRunning = false
        midTimeSaleData.removeAll()
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        CURRENT_STATUS = "Getting the Stock information and K-chart data"
    }
    
    override func viewDidLoad() {
        
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "gotGuDetailDataFromServer:",name:"gotGuDetailData", object: nil )
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "loadList:",name:"getGuDetailData", object: nil )
        super.viewDidLoad()
        
        
        //K-Chart button color initialization
        self.isGotDetailedData = false
        self.fenshiBtn.tag = 1
        self.fenshiBtn.setTitle("分时", forState: UIControlState.Normal)
        self.fenshiBtn.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        self.fenshiBtn.hidden = false
        
        self.dayKBtn.tag = 2
        self.dayKBtn.setTitle("日K", forState: UIControlState.Normal)
        self.dayKBtn.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        self.dayKBtn.hidden = false
        self.weekKBtn.tag = 3
        self.weekKBtn.setTitle("周K", forState: UIControlState.Normal)
        self.weekKBtn.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        self.weekKBtn.hidden = false
        self.monthKBtn.tag = 4
        self.monthKBtn.setTitle("月K", forState: UIControlState.Normal)
        self.monthKBtn.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        self.monthKBtn.hidden = false
        self.minuteSortBtn.tag = 5
        self.minuteSortBtn.setTitle("分钟", forState: UIControlState.Normal)
        self.minuteSortBtn.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        self.minuteSortBtn.hidden = false
        self.initButtonColorAndSize(1)
        self.kgraphView.delegate = self
        self.kgraphView.drawMarkers = false
        self.kgraphView.legend.enabled = false
        self.detailWindows.alpha = 0.7
        self.detailWindows.tag = 100
        self.detailWindows.userInteractionEnabled = false
        
        // TableView
        self.timeTableView.delegate = self
        self.timeTableView.dataSource = self
        self.refreshing()
        
        
        // MARK: - Pull to refresh on TableView
        self.refreshController.addTarget(self, action: "didRefreshList:", forControlEvents: .ValueChanged)
        self.refreshController.backgroundColor = UIColor(red: 50/255, green: 50/255, blue: 50/255, alpha: 1)
        self.refreshController.attributedTitle = NSAttributedString(string: "Last updated on \(NSDate())")
        self.mainScrollView.addSubview(self.refreshController)
//        self.tableView.addSubview(self.refreshController)
        self.msgType = 110
        self.gettingGuDataFromServer()
        // Display add button
        if midData.count != 0{
            var myIndex: String!
            switch selectedString
            {
            case "zixuangu":
                myIndex = midData[selectedIndex].guCode
            case "hushengu":
                myIndex = midHuShenStocks[selectedSection].guIndex[selectedIndex]
            case "multiData":
                myIndex = midMultipleData[selectedIndex].code
            default:
                break
            }

            let isInStock = self.isInMyStock(myIndex)
            if isInStock{
                self.addDelBtn.setTitle("-自选", forState: UIControlState.Normal)
                self.isAdded = !self.isAdded
            }else{
                self.addDelBtn.setTitle("+自选", forState: UIControlState.Normal)
            }
        }
    }
    //MARK: -Summary timeSale, kchartview data, LEV2 data
    func gettingGuDataFromServer(){
        if self.timerIsRunning{
            self.guDetailData.msgType = self.msgType   //Summary data
            self.guDetailData.sessionStr = sessionIDD
            self.guDetailData.selectedExchangeID = 100
            switch selectedString
            {
            case "zixuangu":
                self.guDetailData.symName = midData[selectedIndex].guCode
            case "hushengu":
                self.guDetailData.symName = midHuShenStocks[selectedSection].guIndex[selectedIndex]
            case "multiData":
                self.guDetailData.symName = midMultipleData[selectedIndex].code
            default:
                break
            }
            self.symName = self.guDetailData.symName
//            self.guDetailData.symName = midHuShenStocks[selectedSection].guIndex[selectedIndex]

            self.guDetailData.symParaName = "Price"
            self.guDetailData.sortParaName = "Price"
            self.guDetailData.sortType = 0
            self.guDetailData.startIndex = 0
            self.guDetailData.endIndex = 240
            self.guDetailData.securityType = 101
            self.guDetailData.stateOfReceived = "Getting summary data"
            self.guDetailData.candleType = 1
            self.guDetailData.numOfTimeSale = 1
            //initialization of intermediate data
            if self.msgType == 111{
                self.guDetailData.timeSalePos = 0
                self.guDetailData.timeSaleNum = 100
            }
            self.guDetailData.sendingData()
            self.timerIsRunning = false
            self.timerSet.invalidate()
        }
    }
    func loadList(notification: NSNotification){
//        self.guDetailData.client.close()
        dispatch_async(dispatch_get_main_queue()){
            shouldRefresh = true
            self.isGotDetailedData = true
            self.refreshing()
            for nn in 0..<midKchartData.count{
                self.xData.append(midKchartData[nn].currentTime)
                self.price.append(Double(midKchartData[nn].price))
                self.opened.append(Double(midKchartData[nn].openPrice))
                self.closed.append(Double(midKchartData[nn].preClosedPrice))
                self.highest.append(Double(midKchartData[nn].highest))
                self.lowest.append(Double(midKchartData[nn].lowest))
                self.volVal.append(Double(midKchartData[nn].totalVol))
            }
            //Result View Making.
            self.setChart(self.xData, price: self.price, opened: self.opened, closed: self.closed, highest: self.highest, lowest: self.lowest, volVal: self.volVal, vol5: self.calcSMA(self.price, tT: 5), vol10: self.calcSMA(self.price, tT: 10), vol20: self.calcSMA(self.price, tT: 20))
            self.kgraphView.gridBackgroundColor = UIColor(red: 50/255, green: 50/255, blue: 50/255, alpha: 1.0)
            self.kgraphView.leftAxis.labelPosition = .InsideChart
            self.kgraphView.descriptionText = ""
            self.kgraphView.rightAxis.enabled = true
            self.kgraphView.xAxis.labelPosition = .BottomInside
            self.kgraphView.rightAxis.labelPosition = .InsideChart
            
//            self.guDetailData.client.close()
            self.timerIsRunning = true
            self.timerRunning()
        }        
    }
    
    func gettingDate() -> String{
        let date = NSDate()
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components([.Day, .Month, .Year, .Hour, .Minute], fromDate: date)
        
        //        let currentYear =  components.year
        let currentMonth = components.month
        let currentDay = components.day
        let currentHour = components.hour
        let currentMinute = components.minute
        let retString = "已收盘 \(currentMonth)/\(currentDay) \(currentHour):\(currentMinute)"
        return retString
    }
    // MARK: Timer
    var timerIsRunning = true
    var timerSet = NSTimer()
    var timeData: [GuPiaoData!] = []
    
    func timerRunning(){
        
//        if self.timerIsRunning{
//            timerSet = NSTimer.scheduledTimerWithTimeInterval(3, target: self, selector: Selector("gettingGuDataFromServer"), userInfo: nil, repeats: true)
//        }
    }
    
    
    // Refresh the tableview
    func refreshing(){
        if shouldRefresh{
            UIView.transitionWithView(self.timeTableView,
                duration: 0.35,
                options: .TransitionCrossDissolve,
                animations: {
                    () -> Void in
                    self.timeTableView.reloadData()
                },
                completion: nil
            )
            
            self.guNameLbl.text = midSumData.guName
//            self.codeRateLbl.text = "\(self.gettingDate())已收盘"
            self.codeRateLbl.text = "\(midSumData.guCode)"
            self.mainInDecAndChange.text = "\(String(format: "%.2f", midSumData.guUDValue)) \(String(format: "%.2f", midSumData.guUDRate))%"
            self.topPrice.text = "最  高:\(String(format: "%.2f", midSumData.highestPrice))"
            self.botPrice.text = "最  低:\(String(format: "%.2f", midSumData.lowestPrice))"
            if midSumData.guPrice < midSumData.preClosed{
                self.mainPrice.text = "\(String(format: "%.2f", midSumData.guPrice))⬇︎"
                self.botPrice.textColor = UIColor(red: 20/255, green: 180/255, blue: 10/255, alpha: 1.0)
                self.openPrice.textColor = UIColor.greenColor()
                self.yesterdayPrice.textColor = UIColor.greenColor()
                self.topPrice.textColor = UIColor.greenColor()
                self.botPrice.textColor = UIColor.greenColor()
                self.mainPrice.textColor = UIColor.greenColor()
                self.mainInDecAndChange.textColor = UIColor.greenColor()
            }else if midSumData.guPrice == 0 {
                self.botPrice.textColor = UIColor.whiteColor()
                self.openPrice.textColor = UIColor.whiteColor()
                self.yesterdayPrice.textColor = UIColor.whiteColor()
                self.topPrice.textColor = UIColor.whiteColor()
                self.botPrice.textColor = UIColor.whiteColor()
                self.mainPrice.textColor = UIColor.whiteColor()
                self.mainInDecAndChange.textColor = UIColor.whiteColor()
            
            }else{
                self.mainPrice.text = "\(String(format: "%.2f", midSumData.guPrice))⬆︎"
                self.botPrice.textColor = UIColor.redColor()
                self.openPrice.textColor = UIColor.redColor()
                self.yesterdayPrice.textColor = UIColor.redColor()
                self.topPrice.textColor = UIColor.redColor()
                self.botPrice.textColor = UIColor.redColor()
                self.mainPrice.textColor = UIColor.redColor()
                self.mainInDecAndChange.textColor = UIColor.redColor()
            }
            self.openPrice.text = "今  开:\(String(format: "%.2f", midSumData.openPrice))"
            self.yesterdayPrice.text = "昨  收:\(String(format: "%.2f", midSumData.preClosed))"
            self.transAmount.text = "成交量:\(String(format: "%.2f", midSumData.totVolumn))万手"
            self.transPrice.text = "成交额:\(String(format:"%.2f", midSumData.turnOver))亿"
            self.collectRate.text = "换手率:\(String(format: "%.2f", midSumData.turnOverRate))％"
            self.incStopPrice.text = "涨停价:\(String(format: "%.2f", midSumData.topLimitedPrice))"
            self.decStopPrice.text = "跌停价:\(String(format: "%.2f", midSumData.bottomLimitedPrice))"
            self.feeRate.text = "委  比:\(String(format: "%.2f", midSumData.comittee))％"
            self.amountRate.text = "量  比:\(String(format: "%.2f", midSumData.amplitude))"
            self.magPercent.text = "振  幅:\(String(format: "%.2f", midSumData.amountRatio))％"
            self.earningRate.text = "市盈率:\(String(format: "%.2f", midSumData.priceEarningRatio))"
            self.eachHand.text = "每  手: 100"
            self.marketPrice.text = "市  价:\(String(format: "%.2f", midSumData.marketPrice))亿"
            self.tradingPrice.text = "流通价:\(String(format: "%.2f", midSumData.currencyValue))亿"
            // LEV2 data
            self.bidPrice1.text = "\(String(format: "%.2f", midLEV2Data.bidP1))"
            self.bidPrice2.text = "\(String(format: "%.2f", midLEV2Data.bidP2))"
            self.bidPrice3.text = "\(String(format: "%.2f",midLEV2Data.bidP3))"
            self.bidPrice4.text = "\(String(format: "%.2f",midLEV2Data.bidP4))"
            self.bidPrice5.text = "\(String(format: "%.2f",midLEV2Data.bidP5))"
            self.bidVol1.text = "\(String(format: "%.0f",midLEV2Data.bidV1))"
            self.bidVol2.text = "\(String(format: "%.0f",midLEV2Data.bidV2))"
            self.bidVol3.text = "\(String(format: "%.0f",midLEV2Data.bidV3))"
            self.bidVol4.text = "\(String(format: "%.0f",midLEV2Data.bidV4))"
            self.bidVol5.text = "\(String(format: "%.0f",midLEV2Data.bidV5))"
            
            self.askPrice1.text = "\(String(format: "%.2f",midLEV2Data.askP1))"
            self.askPrice2.text = "\(String(format: "%.2f",midLEV2Data.askP2))"
            self.askPrice3.text = "\(String(format: "%.2f",midLEV2Data.askP3))"
            self.askPrice4.text = "\(String(format: "%.2f",midLEV2Data.askP4))"
            self.askPrice5.text = "\(String(format: "%.2f",midLEV2Data.askP5))"
            self.askVol1.text = "\(String(format: "%.0f",midLEV2Data.askV1))"
            self.askVol2.text = "\(String(format: "%.0f",midLEV2Data.askV2))"
            self.askVol3.text = "\(String(format: "%.0f",midLEV2Data.askV3))"
            self.askVol4.text = "\(String(format: "%.0f",midLEV2Data.askV4))"
            self.askVol5.text = "\(String(format: "%.0f",midLEV2Data.askV5))"
            
            let rPercent = (midLEV2Data.askV1+midLEV2Data.askV2+midLEV2Data.askV3+midLEV2Data.askV4+midLEV2Data.askV5)/(midLEV2Data.askV1+midLEV2Data.askV2+midLEV2Data.askV3+midLEV2Data.askV4+midLEV2Data.askV5+midLEV2Data.bidV1+midLEV2Data.bidV2+midLEV2Data.bidV3+midLEV2Data.bidV4+midLEV2Data.bidV5)
            let lPercent = 1-rPercent
            
            self.wuDangPercentView.backgroundColor = UIColor.greenColor()
            let addMask: UIView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width*CGFloat(lPercent), height: self.wuDangPercentView.frame.height))
            addMask.backgroundColor = UIColor(red: 200/255, green: 20/255, blue: 20/255, alpha: 1.0)
            self.wuDangPercentView.addSubview(addMask)
            
            self.rPercentLbl.text = "\(String(format: "%.2f", lPercent*100))%"
            self.rPercentLbl.sizeToFit()
            self.lPercentLbl.text = "\(String(format: "%.2f" , rPercent*100))%"
            self.lPercentLbl.sizeToFit()
            self.wuDangPercentView.addSubview(self.rPercentLbl)
            self.wuDangPercentView.addSubview(self.lPercentLbl)
        }else{
            self.guNameLbl.text = "xxxxxxx"
//            self.codeRateLbl.text = "\(self.gettingDate())已收盘"
            self.codeRateLbl.text = "xxxxxxx"
            self.mainPrice.text = "---"
            self.mainInDecAndChange.text = "－"
            self.topPrice.text = "最  高:－"
            self.botPrice.text = "最  低:－"
            self.openPrice.text = "今  开:－"
            self.yesterdayPrice.text = "昨  收:－"
            self.transAmount.text = "成交量:－"
            self.transPrice.text = "成交额:－"
            self.collectRate.text = "换手率:－"
            self.incStopPrice.text = "涨停价:－"
            self.decStopPrice.text = "跌停价:－"
            self.feeRate.text = "委  比:－"
            self.amountRate.text = "量  比:-"
            self.magPercent.text = "振  幅:-"
            self.earningRate.text = "市盈率:-"
            self.eachHand.text = "每  手: 不在"
            self.marketPrice.text = "市  价:-"
            self.tradingPrice.text = "流通价:-"
            // LEV2 data
            self.bidPrice1.text = "-"
            self.bidPrice2.text = "-"
            self.bidPrice3.text = "-"
            self.bidPrice4.text = "-"
            self.bidPrice5.text = "-"
            self.bidVol1.text = "-"
            self.bidVol2.text = "-"
            self.bidVol3.text = "-"
            self.bidVol4.text = "-"
            self.bidVol5.text = "-"
            
            self.askPrice1.text = "-"
            self.askPrice2.text = "-"
            self.askPrice3.text = "-"
            self.askPrice4.text = "-"
            self.askPrice5.text = "-"
            self.askVol1.text = "-"
            self.askVol2.text = "-"
            self.askVol3.text = "-"
            self.askVol4.text = "-"
            self.askVol5.text = "-"
            self.rPercentLbl.text = "xx%"
            self.lPercentLbl.text = "yy%"
        }
    }
    func didRefreshList(sender: AnyObject){
        
        self.refreshController.endRefreshing()
    }
    
    // MARK: -Touch event
    func chartValueSelected(chartView: ChartViewBase, entry: ChartDataEntry, dataSetIndex: Int, highlight: ChartHighlight) {
        
        detailWindows.ymdwLbl.text = "\(self.xData[entry.xIndex])"
        detailWindows.kaipanLbl.text = String(format: "%.2f",self.opened[entry.xIndex])
        detailWindows.chengjiaoliangLbl.text = "\(self.volVal[entry.xIndex])"
        detailWindows.zuigaoLbl.text = String(format: "%.2f",self.highest[entry.xIndex])
        detailWindows.zuidiLbl.text = String(format: "%.2f",self.lowest[entry.xIndex])
        detailWindows.shoupanLbl.text = String(format: "%.2f",self.closed[entry.xIndex])
        
        self.kgraphView.addSubview(detailWindows)
    }
    func chartValueNothingSelected(chartView: ChartViewBase) {
        if let viewWithTag = self.view.viewWithTag(100)
        {
            print("View has just dismissed.")
            viewWithTag.removeFromSuperview()
        }else{
            print("Not removed!")
        }
    }
    
    // MARK: - Draw line chart on LineChartView
    var priceChartDataSet: LineChartDataSet!
    var avPriceChartDataSet: LineChartDataSet!
    var volChartDataSet: BarChartDataSet!
    //K- chart view
    var candleChartDataSet: CandleChartDataSet!
    var sma5ChartDataSet: LineChartDataSet!
    var sma10ChartDataSet: LineChartDataSet!
    var sma20ChartDataSet: LineChartDataSet!
    var vol5ChartDataSet: LineChartDataSet!
    var vol10ChartDataSet: LineChartDataSet!
    var vol20ChartDataSet: LineChartDataSet!

    var opened: [Double] = []
    var closed: [Double] = []
    var highest: [Double] = []
    var lowest: [Double] = []
    var price: [Double] = []
    var volVal: [Double] = []
    var xData: [String] = []
    
    var vol5: [Double] = []
    var vol10: [Double] = []
    var vol20: [Double] = []
    var mainBarColors: [UIColor] = []
    
    func setChart(xData: [String], price: [Double], opened: [Double], closed: [Double],highest: [Double], lowest: [Double], volVal: [Double], vol5: [Double], vol10: [Double], vol20: [Double])
    {
        let mainAV = self.calcSMA(price, tT: 7)
        let av5Price = self.calcSMA(price, tT: 5)
        let av10Price = self.calcSMA(price, tT: 10)
        let av20Price = self.calcSMA(price, tT: 20)
        
        var mainPriceEntries: [ChartDataEntry] =  []
        var mainAVEntries: [ChartDataEntry] = []
        var volEntries: [BarChartDataEntry] = []
        var vol5Entries: [ChartDataEntry] = []
        var vol10Entries: [ChartDataEntry] = []
        var vol20Entries: [ChartDataEntry] = []
        var candleEntries: [CandleChartDataEntry] = []
        var av5Entries: [ChartDataEntry] = []
        var av10Entries: [ChartDataEntry] = []
        var av20Entries: [ChartDataEntry] = []
        
        for i in 0..<xData.count{
            mainPriceEntries.append(ChartDataEntry(value: price[i], xIndex: i))
            mainAVEntries.append(ChartDataEntry(value: mainAV[i], xIndex: i))
            volEntries.append(BarChartDataEntry(value: volVal[i]/100000, xIndex: i))
            vol5Entries.append(ChartDataEntry(value: vol5[i]/100000, xIndex: i))
            vol10Entries.append(ChartDataEntry(value: vol10[i]/100000, xIndex: i))
            vol20Entries.append(ChartDataEntry(value: vol20[i]/100000, xIndex: i))
            av5Entries.append(ChartDataEntry(value: av5Price[i], xIndex: i))
            av10Entries.append(ChartDataEntry(value: av10Price[i], xIndex: i))
            av20Entries.append(ChartDataEntry(value: av20Price[i], xIndex: i))
            
            candleEntries.append(CandleChartDataEntry(xIndex: i, shadowH: highest[i], shadowL: lowest[i], open: opened[i], close: closed[i]))
            if opened[i]>closed[i]{
                self.mainBarColors.append(UIColor(red: 1, green: 0, blue: 0, alpha: 1.0))
            }else{
                self.mainBarColors.append(UIColor(red: 0, green: 1, blue: 0, alpha: 1.0))
            }
            // 分时窗口定义
            self.priceChartDataSet = LineChartDataSet(yVals: mainPriceEntries)
            self.priceChartDataSet.drawCircleHoleEnabled = false
            self.priceChartDataSet.drawCirclesEnabled = false
            self.priceChartDataSet.colors = [UIColor(red: 50/255, green: 50/25, blue: 200/255, alpha: 1.0)]
            self.priceChartDataSet.fillColor = UIColor(red: 50/255, green: 50/255, blue: 200/255, alpha: 0.75)
            self.priceChartDataSet.lineWidth = 1.0
            self.priceChartDataSet.drawValuesEnabled = false
            //averaged price line
            self.avPriceChartDataSet = LineChartDataSet(yVals: mainAVEntries)
            self.avPriceChartDataSet.drawCirclesEnabled = false
            self.avPriceChartDataSet.colors = [UIColor(red: 180/255, green: 180/255, blue: 50/255, alpha: 1.0)]
            self.avPriceChartDataSet.lineWidth = 1.0
            self.avPriceChartDataSet.drawValuesEnabled = false
            //K－Chart view
            self.candleChartDataSet = CandleChartDataSet(yVals: candleEntries)
            self.candleChartDataSet.drawValuesEnabled = false
            self.candleChartDataSet.decreasingColor = UIColor(red: 0, green: 1, blue: 0, alpha: 1.0)
            self.candleChartDataSet.increasingColor = UIColor(red: 1, green: 0, blue: 0, alpha: 1.0)
            self.candleChartDataSet.shadowColorSameAsCandle = true
            self.candleChartDataSet.shadowWidth = 1.0
            //
            self.sma5ChartDataSet = LineChartDataSet(yVals: av5Entries)
            self.sma5ChartDataSet.lineWidth = 1.0
            self.sma5ChartDataSet.drawCirclesEnabled = false
            self.sma5ChartDataSet.drawValuesEnabled = false
            self.sma5ChartDataSet.colors = [UIColor(red: 173/255, green: 255/255, blue: 47/255, alpha: 1.0)]
            //
            self.sma10ChartDataSet = LineChartDataSet(yVals: av10Entries)
            self.sma10ChartDataSet.lineWidth = 1.0
            self.sma10ChartDataSet.drawCirclesEnabled = false
            self.sma10ChartDataSet.drawValuesEnabled = false
            self.sma10ChartDataSet.colors = [UIColor(red: 238/255, green: 48/255, blue: 167/288, alpha: 1.0)]
            self.sma20ChartDataSet = LineChartDataSet(yVals: av20Entries)
            self.sma20ChartDataSet.drawCirclesEnabled = false
            self.sma20ChartDataSet.lineWidth = 1.0
            self.sma20ChartDataSet.drawValuesEnabled = false
            self.sma20ChartDataSet.colors = [UIColor(red: 0, green: 0, blue: 156/255, alpha: 1.0)]
            // Volumn chart data
            self.volChartDataSet = BarChartDataSet(yVals: volEntries)
            self.volChartDataSet.drawValuesEnabled = false
            self.volChartDataSet.colors = self.mainBarColors
            self.vol5ChartDataSet = LineChartDataSet(yVals: vol5Entries)
            self.vol5ChartDataSet.drawCirclesEnabled = false
            self.vol5ChartDataSet.colors = [UIColor(red: 173/255, green: 255/255, blue: 47/255, alpha: 1.0)]
            self.vol5ChartDataSet.lineWidth = 1.0
            self.vol5ChartDataSet.drawValuesEnabled = false
            
            self.vol10ChartDataSet = LineChartDataSet(yVals: vol5Entries)
            self.vol10ChartDataSet.drawCirclesEnabled = false
            self.vol10ChartDataSet.colors = [UIColor(red: 238/255, green: 48/255, blue: 167/288, alpha: 1.0)]
            self.vol10ChartDataSet.lineWidth = 1.0
            self.vol10ChartDataSet.drawValuesEnabled = false
            
            self.vol20ChartDataSet = LineChartDataSet(yVals: vol5Entries)
            self.vol20ChartDataSet.drawCirclesEnabled = false
            self.vol20ChartDataSet.colors = [UIColor(red: 0, green: 0, blue: 156/255, alpha: 1.0)]
            self.vol20ChartDataSet.lineWidth = 1.0
            self.vol20ChartDataSet.drawValuesEnabled = false
            
            //
            let combinedData = CombinedChartData(xVals: self.xData)
            let lineData = LineChartData(xVals: self.xData, dataSets: [self.priceChartDataSet, self.avPriceChartDataSet])
            let barData = BarChartData(xVals: self.xData, dataSets: [self.volChartDataSet])
            combinedData.lineData = lineData
            combinedData.barData = barData
            self.kgraphView.data = combinedData
        }
        
        
    }
    
    func fenshiBtnTapped(sender: UIButton){
        self.initButtonColorAndSize(sender.tag)
        let combinedData = CombinedChartData(xVals: self.xData)
        let lineData = LineChartData(xVals: self.xData, dataSets: [self.priceChartDataSet, self.avPriceChartDataSet])
        let barData = BarChartData(xVals: self.xData, dataSets: [self.volChartDataSet])
        combinedData.lineData = lineData
        combinedData.barData = barData
        self.kgraphView.data = combinedData
    }
    func kriBtnTapped(sender: UIButton){
        self.initButtonColorAndSize(sender.tag)
        let combinedData = CombinedChartData(xVals: self.xData)
        let lineData = LineChartData(xVals: self.xData, dataSets: [self.sma5ChartDataSet,self.sma10ChartDataSet, self.sma20ChartDataSet])
        let candleChart = CandleChartData(xVals: self.xData, dataSets: [self.candleChartDataSet])
        combinedData.candleData = candleChart
        combinedData.lineData = lineData
        self.kgraphView.data = combinedData
    }
    
    func btnSetting()
    {
        self.fenshiBtn.addTarget(self, action: "fenshiBtnTapped:", forControlEvents: UIControlEvents.TouchUpInside)
        self.dayKBtn.addTarget(self, action: "kriBtnTapped:", forControlEvents: UIControlEvents.TouchUpInside)
        self.weekKBtn.addTarget(self, action: "btnTapped:", forControlEvents: UIControlEvents.TouchUpInside)
        self.monthKBtn.addTarget(self, action: "btnTapped:", forControlEvents: UIControlEvents.TouchUpInside)
        self.minuteSortBtn.addTarget(self, action: "minuteSortTapped:", forControlEvents: UIControlEvents.TouchUpInside)
        
        self.graphViewCell.addSubview(self.fenshiBtn)
        self.graphViewCell.addSubview(self.dayKBtn)
        self.graphViewCell.addSubview(self.weekKBtn)
        self.graphViewCell.addSubview(self.monthKBtn)
        self.graphViewCell.addSubview(self.minuteSortBtn)
    }
    
    func initButtonColorAndSize(tag: Int)
    {
        // Get View Size
        self.scrnW = self.view.frame.size.width
        self.scrnH = self.view.frame.size.height
        let gapBtn: CGFloat = 2
        let btnW: CGFloat = round(self.scrnW - gapBtn * 6) / 5
        let btnHH: CGFloat = 31
        
        //initialization of UIButtton size and interval in View.
        self.fenshiBtn.frame = CGRectMake(gapBtn, 5, btnW, btnHH)
        self.dayKBtn.frame = CGRectMake(gapBtn + btnW * 1 + gapBtn, 5, btnW, btnHH)
        self.weekKBtn.frame = CGRectMake(gapBtn + btnW * 2 + gapBtn * 2, 5, btnW, btnHH)
        self.monthKBtn.frame = CGRectMake(gapBtn + btnW * 3 + gapBtn * 3, 5, btnW, btnHH)
        self.minuteSortBtn.frame = CGRectMake(gapBtn + btnW * 4 + gapBtn * 4, 5, btnW, btnHH)
        
        self.fenshiBtn.backgroundColor = UIColor(red: 38/255, green: 40/255, blue: 52/255, alpha: 1)
        self.dayKBtn.backgroundColor = UIColor(red: 38/255, green: 40/255, blue: 52/255, alpha: 1)
        self.weekKBtn.backgroundColor = UIColor(red: 38/255, green: 40/255, blue: 52/255, alpha: 1)
        self.monthKBtn.backgroundColor = UIColor(red: 38/255, green: 40/255, blue: 52/255, alpha: 1)
        self.minuteSortBtn.backgroundColor = UIColor(red: 38/255, green: 40/255, blue: 52/255, alpha: 1)
        switch tag{
        case 1:
            self.fenshiBtn.backgroundColor = UIColor(red: 30/255, green: 30/255, blue: 38/255, alpha: 1)
            self.fenshiBtn.frame = CGRectMake(gapBtn, 5, btnW, btnHH + 1)
        case 2:
            self.dayKBtn.backgroundColor = UIColor(red: 30/255, green: 30/255, blue: 38/255, alpha: 1)
            self.dayKBtn.frame = CGRectMake(gapBtn + btnW * 1 + gapBtn * 1, 5, btnW, btnHH + 1)
        case 3:
            self.weekKBtn.backgroundColor = UIColor(red: 30/255, green: 30/255, blue: 38/255, alpha: 1)
            self.weekKBtn.frame = CGRectMake(gapBtn + btnW * 2 + gapBtn * 2, 5, btnW, btnHH + 1)
        case 4:
            self.monthKBtn.backgroundColor = UIColor(red: 30/255, green: 30/255, blue: 38/255, alpha: 1)
            self.monthKBtn.frame = CGRectMake(gapBtn + btnW * 3 + gapBtn * 3, 5, btnW, btnHH + 1)
        case 5:
            self.minuteSortBtn.backgroundColor = UIColor(red: 30/255, green: 30/255, blue: 38/255, alpha: 1)
            self.minuteSortBtn.frame = CGRectMake(gapBtn + btnW * 4 + gapBtn * 4, 5, btnW, btnHH + 1)
        default: break
            
        }
        self.btnSetting()
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isGotDetailedData
        {
            return midTimeSaleData.count
        }
        // #warning Incomplete implementation, return the number of rows
        return midTimeSaleData.count
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 15
    }

    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("timeSaleCell", forIndexPath: indexPath) as! GuDetailTVC

        // Configure the cell...

        cell.timeCell.text = "\(midTimeSaleData[indexPath.row].time)"
        cell.timeCell.textColor = UIColor.whiteColor()
        
        cell.priceCell.text = String(format:"%.2f", (midTimeSaleData[indexPath.row].price))
        cell.priceCell.textColor = UIColor(red: 200/255, green: 150/255, blue: 0, alpha: 1.0)
        
        cell.volCell.text = String(format: "%.0f", (midTimeSaleData[indexPath.row].volumn))
        cell.volCell.textColor = UIColor.greenColor()
        return cell
    }
    //MARK: - SocketCommunication receiving processing part
    var sIndex: Int = 0

    var msgType: UInt16 = 0
    var symName: String!
    
    func gotGuDetailDataFromServer(notification: NSNotification){
        let data = notification.userInfo!["response"] as! NSData
        let tmpData = fixingSockets(data)
        var stkIndex: Int16 = 1
        for tmpSocket in tmpData{
            let msgRange = NSMakeRange(0, 1)
            let msgBody = tmpSocket.subdataWithRange(msgRange)
            var msgInt:UInt8 = 0
            msgBody.getBytes(&msgInt, range: msgRange)
            switch msgInt
            {
            case 214: // Summary
                print("\(stkIndex++)) \(msgInt) : \(tmpSocket.length) Bytes in \(data.length) Bytes")
                let resSumData = self.toSumData(tmpSocket)
                let guCountryCode = "SH"
                midSumData = GuSummaryData(
                    gName: resSumData.symName,
                    gPrice: Double(resSumData.price)/10000,
                    gUdValue: Double(resSumData.udValue)/10000,
                    gUdRate: Double(resSumData.udRate)/10000,
                    highest: Double(resSumData.highestPrice)/10000,
                    lowest: Double(resSumData.lowestPrice)/10000,
                    open: Double(resSumData.openPrice)/10000,
                    preClosed: Double(resSumData.preClosedPrice)/10000,
                    totalVol: Double(resSumData.totalVol)/1000000,
                    turnOver: Double(resSumData.turnOver)/1000000000,
                    turnRate: Double(resSumData.turnOverRate)/1000,
                    topLimited: Double(resSumData.upLimitedPrice)/10000,
                    bottomLimited: Double(resSumData.lowLimitedPrice)/10000,
                    comittee: Double(resSumData.commitee)/10000,
                    amountRatio: Double(resSumData.amplitude)/10000,
                    amplitude: Double(resSumData.amplitude)/10000,
                    priceEarningRatio: Double(resSumData.priceEarningRatio)/10000,
                    volRatio: Double(resSumData.volRatio)/10000,
                    marketPrice: Double(resSumData.marketPrice)/1000000000,
                    currency: Double(resSumData.currencyValue)/1000000000,
                    symbol: resSumData.symCode,
                    guCountry: guCountryCode
                )
                self.msgType = 111
                //                    self!.client.close()
                self.timerIsRunning = !self.timerIsRunning
                self.gettingGuDataFromServer()
                
            case 227:
                print("\(msgInt) : \(tmpSocket.length) Bytes in \(data.length) Bytes Start to get TimeSale")
            case 215: // TimeSale
                print("\(stkIndex++)) \(msgInt) : \(tmpSocket.length) Bytes in \(data.length) Bytes")
                let receivedTimeSaleData = self.toTimeSale(tmpSocket)
                let oneTimeSale = GuTimeSaleData(
                    time: receivedTimeSaleData.cuTime,
                    price: Double(receivedTimeSaleData.cuPrice)/10000,
                    volumn: Double(receivedTimeSaleData.cuVolumn)
                )
                midTimeSaleData.append(oneTimeSale)
            case 228:
                print("\(msgInt) : \(tmpSocket.length) in \(data.length)")
                print("Total TimeSaleData : \(midTimeSaleData.count)")
                print("--------------------  TimeSaleData finished!  ------------------------")
                self.msgType = 109// calling the LEV2 data
                self.timerIsRunning = !self.timerIsRunning
                self.gettingGuDataFromServer()
                
                break
                
            case 213: // LEV2
                print("\(stkIndex++)) \(msgInt) : \(tmpSocket.length) Bytes in \(data.length) Bytes")
                let receivedLEV2Data = self.toLEV2Data(tmpSocket)
                midLEV2Data = GuLEV2Data(
                    bp1: Double(receivedLEV2Data.bidPrice1)/10000,
                    bp2: Double(receivedLEV2Data.bidPrice2)/10000,
                    bp3: Double(receivedLEV2Data.bidPrice3)/10000,
                    bp4: Double(receivedLEV2Data.bidPrice4)/10000,
                    bp5: Double(receivedLEV2Data.bidPrice5)/10000,
                    bv1: Double(receivedLEV2Data.bidVol1),
                    bv2: Double(receivedLEV2Data.bidVol2),
                    bv3: Double(receivedLEV2Data.bidVol3),
                    bv4: Double(receivedLEV2Data.bidVol4),
                    bv5: Double(receivedLEV2Data.bidVol5),
                    ap1: Double(receivedLEV2Data.askPrice1)/10000,
                    ap2: Double(receivedLEV2Data.askPrice2)/10000,
                    ap3: Double(receivedLEV2Data.askPrice3)/10000,
                    ap4: Double(receivedLEV2Data.askPrice4)/10000,
                    ap5: Double(receivedLEV2Data.askPrice5)/10000,
                    av1: Double(receivedLEV2Data.askVol1),
                    av2: Double(receivedLEV2Data.bidVol2),
                    av3: Double(receivedLEV2Data.bidVol3),
                    av4: Double(receivedLEV2Data.bidVol4),
                    av5: Double(receivedLEV2Data.bidVol5)
                )
                print("GuName: LEV2 Data")
                self.msgType = 112// calling the K-chart data
                self.timerIsRunning = !self.timerIsRunning
                self.gettingGuDataFromServer()
            case 216:// k-chart data start
                print("\(stkIndex++)) \(msgInt) : \(tmpSocket.length) Bytes in \(data.length) Bytes")
                print("K-Chart data receiving started")
            case 217:// k-chart data
                print("\(stkIndex++)) \(msgInt) : \(tmpSocket.length) Bytes in \(data.length) Bytes")
                self.sIndex += 1
                let kChart = self.toKchartData(tmpSocket)
                let ChartData = GuKchartData(
                    cuTime: kChart.currentTime,
                    symbolName: self.symName,
                    symbol: self.symName,
                    price: Double(kChart.currentPrice/10000).roundTo2f,
                    upDown: Double(kChart.upDown/10000).roundTo2f,
                    upDownRate: (Double(kChart.upDown)*100/Double(kChart.currentPrice)).roundTo2f,
                    highest: Double(kChart.highestPrice/10000).roundTo2f,
                    lowest: Double(kChart.lowestPrice/10000).roundTo2f,
                    openPrice: Double(kChart.openPrice/10000).roundTo2f,
                    preClosed: Double(kChart.preClosedPrice/10000).roundTo2f,
                    totalVolumn: Double(kChart.totalVol),
                    turnOver: Double(kChart.turnOver),
                    average5: Double(kChart.averageVol5),
                    average10: Double(kChart.averageVol10),
                    average20: Double(kChart.averageVol20)
                )
                midKchartData.append(ChartData)
            case 218:// k-chart data end
                print("\(stkIndex++)) \(msgInt) : \(tmpSocket.length) Bytes in \(data.length) Bytes")
                self.sIndex = 0
                print("Total : \(midKchartData.count) received from Server")
                print("------------------------ \(msgInt) : Finished ----------------------------")
                NSNotificationCenter.defaultCenter().postNotificationName("getGuDetailData", object: nil)
            default:
                print("Bug occured on the \(self.msgType)")
                break
            }
        }
        
    }
    // SMA tT: T-period SMA
    func calcSMA(datas: [Double], tT: Int) -> [Double]{
        var returnDatas: [Double] = []
        var sumN: Double = 0
        
        for nn in 0..<datas.count{
            var sumNN: Double = 0
            if nn<tT{
                sumN += datas[nn]
                let val = sumN/Double(nn+1)
                returnDatas.append(val)
            }else{
                for i in nn-tT..<nn{
                    sumNN += datas[i]
                }
                sumN = sumNN/Double(tT)
                returnDatas.append(sumN)
            }
        }
        return returnDatas
    }
    
    //EMA tT: T-period EMA calculation
    func calcEMA(datas: [Double], tT: Int) -> [Double]{
        let sma = self.calcSMA(datas, tT: tT)
        let kk = Double(2/(Double(tT)+1))
        var returnedData: [Double] = []
        var preVal: Double = 0
        var val = sma[0]
        returnedData.append(val)
        for nn in 1..<datas.count{
            val = sma[nn]*kk+preVal*(1-kk)
            returnedData.append(val)
            preVal = val
        }
        return returnedData
    }
}
