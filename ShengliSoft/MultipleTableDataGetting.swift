//
//  MultipleTableDataGetting.swift
//  ShengliSoft
//
//  Created by Admin on 11/25/15.
//  Copyright © 2015 iCloudTest. All rights reserved.
//

import Foundation
import UIKit
import CocoaAsyncSocket


// 
var midMultipleData: [HuShenGuMultipleTableData] = []

class MultipleTableDataGetting{
    
    // MARK: - Message type is 108
    //Request for Current quote list news to server(msgType: 108)
    struct quoteReq {
        var msgType: UInt16
        var sessionID: String
        var secType: UInt8
        var exchgeType: UInt8
        var sortName: String
        var sortTyp: UInt8
        var startIndex: UInt16
        var endIndex: UInt16
        var reserved: String
    }
    struct lenQuoteReq {
        var lenMsg: UInt8
        var lenSID: UInt8
        var lenSec: UInt8
        var lenExc: UInt8
        var lenSort: UInt8
        var lenSType: UInt8
        var lenStrt: Int16
        var lenEnd: Int16
        var lenRes: UInt8
    }
    func quoteToNSData(var quote: quoteReq) -> NSData{
        var archivedOneGuReq = lenQuoteReq(lenMsg: 1,
            lenSID: 32,
            lenSec: 1,
            lenExc: 1,
            lenSort: 32,
            lenSType: 1,
            lenStrt: 1,
            lenEnd: 1,
            lenRes: 2)
        let metaData = NSData(bytes: &archivedOneGuReq, length: 0)
        let archivedData = NSMutableData(data: metaData)
        archivedData.appendBytes(&quote.msgType, length: 1)
        archivedData.appendBytes(quote.sessionID, length: 32)
        archivedData.appendBytes(&quote.secType, length: 1)
        archivedData.appendBytes(&quote.exchgeType, length: 1)
        archivedData.appendBytes(quote.sortName, length: 32)
        archivedData.appendBytes(&quote.sortTyp, length: 1)
        archivedData.appendBytes(&quote.startIndex, length: 1)
        archivedData.appendBytes(&quote.endIndex, length: 1)
        archivedData.appendBytes(quote.reserved, length: 2)
        return archivedData
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
    // MARK: - the parameters initialization for sending data to the server
    var msgType: UInt16!
    var sessionStr: String!
    var securityType: UInt8!
    var exchangeIDs: [UInt8] = [100, 101]
    var symName: String!
    var symParaName: String!
    var sortParaName: String!
    var sortType: UInt8!
    var startIndex: UInt16!
    var endIndex: UInt16!
    var selectedExchangeID: UInt8!
    var stateOfReceived: String!
    var selectedIndex: Int = 0
    var guCountry: String!
    //GCDAsyncSocket Definition
    var socketHelper = tcpSocket()
    //Sending function
    func clientSending(){
        self.selectedExchangeID = self.exchangeIDs[self.selectedIndex]
        self.stateOfReceived = "Started"
        if self.selectedExchangeID == 100
        {
            self.guCountry = "SH"
        }else if self.selectedExchangeID == 101{
            self.guCountry = "SZ"
        }
        
        let quoteListNews: quoteReq = quoteReq(
            msgType: self.msgType,
            sessionID: sessionIDD,
            secType: self.securityType,
            exchgeType: 0,
            sortName: self.sortParaName,
            sortTyp: self.sortType,
            startIndex: self.startIndex,
            endIndex: self.endIndex,
            reserved: ""
        )
        let sendData = self.quoteToNSData(quoteListNews)
        CURRENT_STATUS = "Getting Multicolumn Table Data"
        self.socketHelper.sendSocket(self.msgType, sendData: sendData)
    }
}