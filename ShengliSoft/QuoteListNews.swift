//
//  QuoteListNews.swift
//  ShengliSoft
//
//  Created by Admin on 11/15/15.
//  Copyright © 2015 iCloudTest. All rights reserved.
//  ++++++++++++++++++MsgType:++++++++++++++++++
//  ***********  106 -> 206, 207, 208 **********
//  ++++++++++++++++++++++++++++++++++++++++++++
//  ++++++++++++++++++MsgType:++++++++++++++++++
//  ***********  114 -> 222, 223, 224  *********
//  ++++++++++++++++++++++++++++++++++++++++++++

import Foundation


var wasZXG: Bool = false
var midData: [GuPiaoData!] = []




class QuoteListNews {
    //Request for Current quote list news to server(msgType: 106)
    struct quoteReq {
        var msgType: UInt16
        var sessionID: String
        var secType: UInt8
        var exchgeType: UInt8
        var symbolName: String
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
        var lenSym: UInt8
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
            lenSym: 32,
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
        if self.msgType == 114{
            archivedData.appendBytes(&quote.symbolName, length: 32)
        }
        archivedData.appendBytes(&quote.sortTyp, length: 1)
        archivedData.appendBytes(&quote.startIndex, length: 1)
        archivedData.appendBytes(&quote.endIndex, length: 1)
        archivedData.appendBytes(quote.reserved, length: 2)
        return archivedData
    }
    // MARK: - Parsing data received from server

    var stateOfReceived: String!
    var statusOfSocket: String!
    var secType: UInt8!
    var msgType: UInt16 = 106
    var sessionID: String!
    var exchangeID: [UInt8] = [100, 101]
    var selectedExchangeID: UInt8!
    var selectedIndex: Int = 0
    var symbolName: String!
    var sortParaName: String!
    var sortType: UInt8!
    var startIndex: UInt16!
    var endIndex: UInt16!
    var isZiXuanGu: Bool = false
    var guInfos = [GuPiaoData!]()
    var guCountry: String!
    var huShenStocks: [HuShenTableData] = []
    var isHuShenStocks: Bool = true// HuShenStocks -> true, chuangyebanStocks -> false
    var sectionName: String!
    // Variables initialization for getting HuShenStocks
    var gName: [String] = []
    var gCountries: [String] = []
    var gPrices: [Double] = []
    var gIndex: [String] = []
    var gPercets: [Double] = []
    //GCDAsyncSocket definition
    var socketHelper = tcpSocket()
    
    // MARK: - Sending data to server
    func sendData(){

        if isHuShenStocks
        {
            self.sectionName = "沪深A股"
        }else{
            self.sectionName = "创业板"
        }
        self.selectedExchangeID = self.exchangeID[self.selectedIndex]
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
               secType: self.secType,
            exchgeType: 0,
            symbolName: self.symbolName,
              sortName: self.sortParaName,
               sortTyp: self.sortType,
            startIndex: self.startIndex,
              endIndex: self.endIndex,
              reserved: ""
        )
        let sendData = self.quoteToNSData(quoteListNews)
        self.socketHelper.sendSocket(msgType, sendData: sendData)
    }
}
