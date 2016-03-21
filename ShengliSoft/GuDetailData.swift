//
//  GuDetailData.swift
//  ShengliSoft
//
//  Created by Admin on 11/26/15.
//  Copyright © 2015 iCloudTest. All rights reserved.
//

import Foundation
import CocoaAsyncSocket



var midKchartData: [GuKchartData] = []
var midSumData: GuSummaryData!
var midTimeSaleData:[GuTimeSaleData] = []
var midLEV2Data: GuLEV2Data!
var statusOfSocket: String!

class GuDetailData: NSObject, TCPClientDelegate, GCDAsyncSocketDelegate {
    
    //Outgoing messages to server
    struct GuSumData {
        var msgType: UInt8 //110, 111, 109
        var sessionID: String
        var secType: UInt8
        var exgType: UInt8
        var symbol: String
        var reserved: String
    }
    struct lenOneGuSumData {
        var lenMsg: Int16
        var lensID: Int16
        var lenSec: Int16
        var lenExg: Int16
        var lenSym: Int16
        var lenRes: Int16
    }
    func toNSData(var oneGu: GuSumData) -> NSData{
        var archivedOneGuReq = lenOneGuSumData(lenMsg: 1, lensID: 32, lenSec: 1, lenExg: 1, lenSym: 32, lenRes: 5)
        let metaData = NSData(bytes: &archivedOneGuReq, length: 0)
        let archivedData = NSMutableData(data: metaData)
        archivedData.appendBytes(&oneGu.msgType, length: 1)
        archivedData.appendBytes(oneGu.sessionID, length: 32)
        archivedData.appendBytes(&oneGu.secType, length: 1)
        archivedData.appendBytes(&oneGu.exgType, length: 1)
        archivedData.appendBytes(oneGu.symbol, length: 32)
        archivedData.appendBytes(oneGu.reserved, length: 5)
        return archivedData
    }
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
        print("Price body: \(priceBody)")
        var price: Int = 0
        priceBody.getBytes(&price, length: sizeofValue(price))
        
        let rateBody = data.subdataWithRange(udRateRange)
        print("Rate Binary: \(rateBody)")
        var rate: Int = 0
        rateBody.getBytes(&rate, length: sizeofValue(rate))
        
        let udValBody = data.subdataWithRange(udValueRange)
        print("udVal Binary: \(udValBody)")
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
        print("Summary Datas: \(returned)")
        return returned
    }
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
    //MARK: String
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
    // MARK: - K-chart view data
    //Request part
    struct reqKchartData {
        var msgType: UInt8
        var sessionS: String
        var candleType: Int
        var securityType: UInt8
        var exchangeID: UInt8
        var symName: String
        var beginIndex: Int16
        var endIndex: Int16
        var reserved: String
    }
    struct lenReqKchartData {
        var lenMsg: Int16
        var lenSID: Int16
        var lenCan: Int16
        var lenSeT: Int16
        var lenEID: Int16
        var lenSyN: Int16
        var lenBeI: Int16
        var lenEnI: Int16
        var lenRev: Int16
    }
    func toReqNSData(var kchart: reqKchartData) -> NSData{
        var archivedReqKchart = lenReqKchartData(
            lenMsg: 1,
            lenSID: 32,
            lenCan: 1,
            lenSeT: 1,
            lenEID: 1,
            lenSyN: 32,
            lenBeI: 1,
            lenEnI: 1,
            lenRev: 2
        )
        let metaData = NSData(bytes: &archivedReqKchart, length: 0)
        let archivedData = NSMutableData(data: metaData)
        archivedData.appendBytes(&kchart.msgType, length: 1)
        archivedData.appendBytes(kchart.sessionS, length: 32)
        archivedData.appendBytes(&kchart.candleType, length: 1)
        archivedData.appendBytes(&kchart.securityType, length: 1)
        archivedData.appendBytes(&kchart.exchangeID, length: 1)
        archivedData.appendBytes(kchart.symName, length: 32)
        archivedData.appendBytes(&kchart.beginIndex, length: 1)
        archivedData.appendBytes(&kchart.endIndex, length: 1)
        archivedData.appendBytes(kchart.reserved, length: 2)
        
        return archivedData
    }
    //MARK: - Getting K chartView data
    // Start message 216
    struct startMsg {
        var msgType: UInt8
        var sessionID: String
        var reserved: String
    }
    struct lenStartMsg {
        var lenMsg: Int16
        var lenSID: Int16
        var lenRev: Int16
    }
    func toNSDataStart(data: NSData) -> startMsg{
        var unarchivedResData = lenStartMsg(lenMsg: 1, lenSID: 32, lenRev: 7)
        let archivedData = data.subdataWithRange(NSMakeRange(0, 0))
        archivedData.getBytes(&unarchivedResData, length: 40)
        
        let msgRange = NSMakeRange(0, 1)
        let sIDRange = NSMakeRange(1, 32)
        let reserved = NSMakeRange(33, 7)
        
        let msgBody = data.subdataWithRange(msgRange)
        var msgInt:UInt8 = 0
        msgBody.getBytes(&msgInt, range: msgRange)
        
        let sidBody = data.subdataWithRange(sIDRange)
        let sessionID = NSString(data: sidBody, encoding: NSUTF8StringEncoding) as! String
        
        let reserve = data.subdataWithRange(reserved)
        let reserv = NSString(data: reserve, encoding: NSUTF8StringEncoding) as! String
        
        let returned = startMsg(msgType: msgInt, sessionID: sessionID, reserved: reserv)
        return returned
    }
    // End Message 218
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
        let sessionID = NSString(data: sidBody, encoding: NSUTF8StringEncoding) as! String
        
        let ResBody = data.subdataWithRange(resRange)
        let results = NSString(data: ResBody, encoding: NSUTF8StringEncoding) as! String
        
        let ReaBody = data.subdataWithRange(reaRange)
        let reasonS = NSString(data: ReaBody, encoding: NSUTF8StringEncoding) as! String
        
        let reserve = data.subdataWithRange(revRange)
        let reserv = NSString(data: reserve, encoding: NSUTF8StringEncoding) as! String
        
        let returned = endMsg(msgTyp: msgInt, sessionID: sessionID, results: results, reasons: reasonS, reserved: reserv)
        return returned
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
    
    //MARK: - Parameters initialization
    var msgType: UInt8!
    var sessionStr: String!
    var securityType: UInt8!
    var exchangeIDs: [UInt8] = [100, 101]
    var symName: String!
    var symParaName: String!
    var sortParaName: String!
    var sortType: UInt8!
    var startIndex: Int16!
    var endIndex: Int16!
    var selectedExchangeID: UInt8!
    var stateOfReceived: String!
    var selectedIndex: Int = 0
    var guCountry: String!
    
    var numOfTimeSale: Int!
    
    //K-chart data
    var candleType: Int!
    
    var client: TCPClient!
    //GCDAsyncSocket
    var bSocket = GCDAsyncSocket()
    
    func sendingData(){
//        self.selectedExchangeID = self.exchangeIDs[self.selectedIndex]
        self.stateOfReceived = "Started"
        if self.selectedExchangeID == 100
        {
            self.guCountry = "SH"
        }else if self.selectedExchangeID == 101{
            self.guCountry = "SZ"
        }
        
//        if self.client != nil {
//            self.client.close()
//        }
        switch self.msgType
        {
        case 112:// k-chart data
            let guDetailedData: reqKchartData = reqKchartData(
                msgType: self.msgType,
                sessionS: sessionIDD,
                candleType: self.candleType,
                securityType: self.securityType,
                exchangeID: 0,
                symName: self.symName,
                beginIndex: self.startIndex,
                endIndex: self.endIndex,
                reserved: ""
            )
            
            let sendData = self.toReqNSData(guDetailedData)
            self.sendSocket(self.msgType, sendData: sendData)
//            self.client = TCPClient(addr: SERVER_IP, port: SERVER_PORT)
//            self.client.delegate = self
//            self.client.connectServer(timeout: 10000)
//            self.client.send(data: sendData)
            
//            print("GuDetail: \(self.msgType): \(sendData.length)")
        default: // Summary, Time Sale, LEV2 data
            let guDetailedData: GuSumData = GuSumData(
                msgType: self.msgType,
                sessionID: sessionIDD,
                secType: self.securityType,
                exgType: 0,
                symbol: self.symName,
                reserved: ""
            )
            let sendData = self.toNSData(guDetailedData)
            self.sendSocket(self.msgType, sendData: sendData)
//            self.client = TCPClient(addr: SERVER_IP, port: SERVER_PORT)
//            self.client.delegate = self
//            self.client.connectServer(timeout: 10000)
//            self.client.send(data: sendData)
//            print("GuDetail: \(self.msgType): \(sendData.length)")
        }
    }
    
    func sendSocket(msg: UInt8, sendData: NSData){
        if self.bSocket != nil{
            self.bSocket.disconnect()
            print("Socket was just initialized!")
        }
        self.bSocket.delegate = self
        self.bSocket.delegateQueue = dispatch_get_main_queue()
        do{
            try self.bSocket.connectToHost(SERVER_IP, onPort: UInt16(SERVER_PORT))
            print("0: Initialized Socket channel")
            self.bSocket.writeData(sendData, withTimeout: -1, tag: 0)
            self.bSocket.readDataWithTimeout(-1, tag: 0)
            print("0: \(msg): \(sendData.length)")
        }catch let error as NSError{
            print("Connection Error: \(error.localizedDescription)")
        }
    }
    
    
    func client(client: TCPClient, connectSververState state: ClientState) {
//        print("Gudetail: \(state.rawValue)")
    }
    
    //GCDAsyncSocket Received data processing
    func socket(sock: GCDAsyncSocket!, didConnectToHost host: String!, port: UInt16) {
        print("1: connected \(host): \(port)")
    }
    var sIndex: Int = 0
    func socket(sock: GCDAsyncSocket!, didReadData data: NSData!, withTag tag: Int) {
        
        
        statusOfSocket = self.stateOfReceived
        dispatch_async(dispatch_get_main_queue()){
            [weak self] in
            let tmpData = fixingSockets(data)
            for tmpSocket in tmpData{
                let msgRange = NSMakeRange(0, 1)
                let msgBody = tmpSocket.subdataWithRange(msgRange)
                var msgInt:UInt8 = 0
                msgBody.getBytes(&msgInt, range: msgRange)
                print("GuDetail: \(msgInt): \(tmpSocket.length): in \(data.length)")
//                if msgInt != 216 || msgInt != 217 || msgInt != 218{
//                    self!.bSocket.disconnect()
//                }
                switch msgInt
                {
                case 214: // Summary
                    let resSumData = self!.toSumData(tmpSocket)
                    var guCountryCode: String!
                    
                    switch self!.selectedExchangeID
                    {
                    case 100:
                        guCountryCode = "SH"
                    case 101:
                        guCountryCode = "SZ"
                    default:
                        break
                    }
                    
                    self!.stateOfReceived = "Summary data received"
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
                    print("GU Summary: \(midSumData.totVolumn): \(midSumData.turnOver)")
                    self!.msgType = 111
                    //                    self!.client.close()
                    self!.sendingData()
                    
                case 215: // TimeSale
                    let receivedTimeSaleData = self!.toTimeSale(tmpSocket)
                    let oneTimeSale = GuTimeSaleData(
                        time: receivedTimeSaleData.cuTime,
                        price: Double(receivedTimeSaleData.cuPrice)/10000,
                        volumn: Double(receivedTimeSaleData.cuVolumn)
                    )
                    midTimeSaleData.append(oneTimeSale)
                    print("GuName: TimeSale")
                    self!.stateOfReceived = "Time Sale data received"
                    self!.msgType = 109// calling the LEV2 data
                    self!.sendingData()
                    
                    //                    if self!.numOfTimeSale > 0{
                    //                        self!.stateOfReceived = "In receiving the TimeSale data"
                    //                        //
                    //                        let receivedTimeSaleData = self!.toTimeSale(tmpSocket)
                    //                        let oneTimeSale = GuTimeSaleData(
                    //                            time: receivedTimeSaleData.cuTime,
                    //                            price: Double(receivedTimeSaleData.cuPrice)/10000,
                    //                            volumn: Double(receivedTimeSaleData.cuVolumn)
                    //                        )
                    //                        midTimeSaleData.append(oneTimeSale)
                    //
                    ////                        self!.msgType = 111
                    ////                        self!.numOfTimeSale  = self!.numOfTimeSale - 1
                    ////                        self!.sendingData()
                    //                    }else{
                    //                        print("GuName: TimeSale")
                    //                        self!.numOfTimeSale = 0
                    //                        self!.stateOfReceived = "Time Sale data received"
                    //                        self!.msgType = 109// calling the LEV2 data
                    //                        self!.sendingData()
                    //                    }
                    
                case 213: // LEV2
                    let receivedLEV2Data = self!.toLEV2Data(tmpSocket)
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
                    self!.stateOfReceived = "Received LEV2 data"
                    self!.msgType = 112// calling the K-chart data
                    self!.sendingData()
                case 216:// k-chart data start
                    print("GuName: K- Chart Data Started")
                    self!.stateOfReceived = "K-chart data receiving started"
                    self!.bSocket.readDataWithTimeout(-1, tag: 0)
                case 217:// k-chart data
                    self!.sIndex += 1
                    self!.stateOfReceived = "In receiving k-chart data"
                    let kChart = self!.toKchartData(tmpSocket)
                    let ChartData = GuKchartData(
                        cuTime: kChart.currentTime,
                        symbolName: self!.symName,
                        symbol: self!.symName,
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
                    print("GuName: K-Chart Data Receiving \(self!.sIndex)")
                    self!.bSocket.readDataWithTimeout(-1, tag: 0)
                case 218:// k-chart data end
                    self!.sIndex = 0
                    self!.stateOfReceived = "K-chart data ended"
                    print("GuName: K-Chart Data finished")
                    NSNotificationCenter.defaultCenter().postNotificationName("getGuDetailData", object: nil)
                default:
                    break
                }
            }
        }
    
    }
    func client(client: TCPClient, receivedData data: NSData) {

        statusOfSocket = self.stateOfReceived
        dispatch_async(dispatch_get_main_queue()){
            [weak self] in
            let tmpData = fixingSockets(data)
            for tmpSocket in tmpData{
                let msgRange = NSMakeRange(0, 1)
                let msgBody = tmpSocket.subdataWithRange(msgRange)
                var msgInt:UInt8 = 0
                msgBody.getBytes(&msgInt, range: msgRange)
                print("GuDetail: \(msgInt): \(tmpSocket.length)")
                switch msgInt
                {
                case 214: // Summary
                    let resSumData = self!.toSumData(tmpSocket)
                    var guCountryCode: String!
                    
                    switch self!.selectedExchangeID
                    {
                    case 100:
                        guCountryCode = "SH"
                    case 101:
                        guCountryCode = "SZ"
                    default:
                        break
                    }
                    
                    self!.stateOfReceived = "Summary data received"
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
                    print("GU Summary: \(midSumData.totVolumn): \(midSumData.turnOver)")
                    self!.msgType = 111
//                    self!.client.close()
                    self!.sendingData()
                    
                case 215: // TimeSale
                    let receivedTimeSaleData = self!.toTimeSale(tmpSocket)
                    let oneTimeSale = GuTimeSaleData(
                        time: receivedTimeSaleData.cuTime,
                        price: Double(receivedTimeSaleData.cuPrice)/10000,
                        volumn: Double(receivedTimeSaleData.cuVolumn)
                    )
                    midTimeSaleData.append(oneTimeSale)
                    print("GuName: TimeSale")
                    self!.stateOfReceived = "Time Sale data received"
                    self!.msgType = 109// calling the LEV2 data
                    self!.sendingData()
                    
//                    if self!.numOfTimeSale > 0{
//                        self!.stateOfReceived = "In receiving the TimeSale data"
//                        //
//                        let receivedTimeSaleData = self!.toTimeSale(tmpSocket)
//                        let oneTimeSale = GuTimeSaleData(
//                            time: receivedTimeSaleData.cuTime,
//                            price: Double(receivedTimeSaleData.cuPrice)/10000,
//                            volumn: Double(receivedTimeSaleData.cuVolumn)
//                        )
//                        midTimeSaleData.append(oneTimeSale)
//                        
////                        self!.msgType = 111
////                        self!.numOfTimeSale  = self!.numOfTimeSale - 1
////                        self!.sendingData()
//                    }else{
//                        print("GuName: TimeSale")
//                        self!.numOfTimeSale = 0
//                        self!.stateOfReceived = "Time Sale data received"
//                        self!.msgType = 109// calling the LEV2 data
//                        self!.sendingData()
//                    }
                    
                case 213: // LEV2
                    let receivedLEV2Data = self!.toLEV2Data(tmpSocket)
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
                    self!.stateOfReceived = "Received LEV2 data"
                    self!.msgType = 112// calling the K-chart data
                    self!.sendingData()
                case 216:// k-chart data start
                    print("GuName: K- Chart Data Started")
                    self!.stateOfReceived = "K-chart data receiving started"
                case 217:// k-chart data
                    self!.stateOfReceived = "In receiving k-chart data"
                    let kChart = self!.toKchartData(tmpSocket)
                    let ChartData = GuKchartData(
                        cuTime: kChart.currentTime,
                        symbolName: self!.symName,
                        symbol: self!.symName,
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
                    print("GuName: K-Chart Data Receiving")
                case 218:// k-chart data end
                    self!.stateOfReceived = "K-chart data ended"
                    print("GuName: K-Chart Data finished")
                    NSNotificationCenter.defaultCenter().postNotificationName("getGuDetailData", object: nil)
                default:
                    break
                }
            }
        }
    }
}