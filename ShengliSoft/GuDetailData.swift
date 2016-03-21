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

class GuDetailData{
    
    //Outgoing messages to server
    struct GuSumData {
        var msgType: UInt16 //110, 109
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
    //TimeSale data messages to server
    struct reqTimeSaleData {
        var msgType: UInt16 //111
        var sessionID: String
        var secType: UInt8
        var exgType: UInt8
        var timePos: Int64
        var timeNum: Int64
        var symbol: String
        var reserved: String
    }
    struct lenTimeSaleData {
        var lenMsg: Int16
        var lensID: Int16
        var lenSec: Int16
        var lenExg: Int16
        var lenSym: Int16
        var lenPos: Int16
        var lenNum: Int16
        var lenRes: Int16
    }
    func timeSaleToNSData(var oneGu: reqTimeSaleData) -> NSData{
        var archivedOneGuReq = lenTimeSaleData(lenMsg: 1, lensID: 32, lenSec: 1, lenExg: 1, lenSym: 32, lenPos: 8, lenNum: 8, lenRes: 5)
        let metaData = NSData(bytes: &archivedOneGuReq, length: 0)
        let archivedData = NSMutableData(data: metaData)
        archivedData.appendBytes(&oneGu.msgType, length: 1)
        archivedData.appendBytes(oneGu.sessionID, length: 32)
        archivedData.appendBytes(&oneGu.secType, length: 1)
        archivedData.appendBytes(&oneGu.exgType, length: 1)
        archivedData.appendBytes(oneGu.symbol, length: 32)
        archivedData.appendBytes(&oneGu.timePos, length: 8)
        archivedData.appendBytes(&oneGu.timeNum, length: 8)
        archivedData.appendBytes(oneGu.reserved, length: 5)
        return archivedData
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
        var msgType: UInt16
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
    
    //MARK: - Parameters initialization
    var msgType: UInt16!
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
    //TimeSale Data request
    var timeSalePos: Int64!
    var timeSaleNum: Int64!
    
    //K-chart data
    var candleType: Int!
    
    var client: TCPClient!
    //GCDAsyncSocket
    var socketHelper = tcpSocket()
    
    func sendingData(){
//        self.selectedExchangeID = self.exchangeIDs[self.selectedIndex]
        self.stateOfReceived = "Started"
        if self.selectedExchangeID == 100
        {
            self.guCountry = "SH"
        }else if self.selectedExchangeID == 101{
            self.guCountry = "SZ"
        }
        switch self.msgType
        {
        case 111:// TimeSale data request
            let reqTimeSale = reqTimeSaleData(
                  msgType: self.msgType,
                sessionID: sessionIDD,
                  secType: self.securityType,
                  exgType: 100,
                  timePos: self.timeSalePos,
                  timeNum: self.timeSaleNum,
                   symbol: self.symName,
                 reserved: ""
            )
            let sendData = self.timeSaleToNSData(reqTimeSale)
            print("\(self.msgType): Sent \(sendData.length) Bytes to server \(reqTimeSale)")
            self.socketHelper.sendSocket(self.msgType, sendData: sendData)
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
            self.socketHelper.sendSocket(self.msgType, sendData: sendData)
            
        default: // Summary, LEV2 data
            let guDetailedData: GuSumData = GuSumData(
                msgType: self.msgType,
                sessionID: sessionIDD,
                secType: self.securityType,
                exgType: 0,
                symbol: self.symName,
                reserved: ""
            )
            let sendData = self.toNSData(guDetailedData)
            self.socketHelper.sendSocket(self.msgType, sendData: sendData)
        }
    }
}