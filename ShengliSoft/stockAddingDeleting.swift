//
//  stockAddingDeleting.swift
//  ShengliSoft
//
//  Created by EagleWind on 12/5/15.
//  Copyright © 2015 iCloudTest. All rights reserved.
//

class stockAddDeleteClass: TCPClientDelegate {
    
    //Sending data part of 115 and 116 (stock adding and deleting)
    struct stockAddDel {
        var msgType: UInt8
        var sessionID: String
        var secType: UInt8
        var exgType: UInt8
        var symbol: String
        var reserved: String
    }
    struct lenStockAddDel {
        var lenMsg: Int16
        var lensID: Int16
        var lenSec: Int16
        var lenExg: Int16
        var lenSym: Int16
        var lenRes: Int16
    }
    func toNSData(var oneGu: stockAddDel) -> NSData{
        var archivedOneGuReq = lenStockAddDel(lenMsg: 1, lensID: 32, lenSec: 1, lenExg: 1, lenSym: 32, lenRes: 5)
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
    // MARK: - Receive the main data from server.225 stock adding
    struct newsOfQuote {
        var msgTyp: UInt8
        var sessionID: String
        var symName: String
        var symCode: String
        var symPric: Double
        var symRate: Double
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
            lenSPr: 8,
            lenSRt: 8,
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
        let pricRange = NSMakeRange(97, 8)
        let rateRange = NSMakeRange(105, 8)
        let reserved = NSMakeRange(113, 7)
        
        let msgBody = data.subdataWithRange(msgRange)
        var msgInt:UInt8 = 0
        msgBody.getBytes(&msgInt, range: msgRange)
        
        let sidBody = data.subdataWithRange(sIDRange)
        let sessionID = NSString(data: sidBody, encoding: NSUTF8StringEncoding) as! String
        
        let nameBody = data.subdataWithRange(nameRange)
        let name = NSString(data: nameBody, encoding: NSUTF8StringEncoding) as! String
        
        let codeBody = data.subdataWithRange(codeRange)
        let code = NSString(data: codeBody, encoding: NSUTF8StringEncoding) as! String
        
        let priceBody = data.subdataWithRange(pricRange)
        var price: Double = 0
        priceBody.getBytes(&price, length: sizeofValue(price))
        
        let rateBody = data.subdataWithRange(rateRange)
        var rate: Double = 0
        rateBody.getBytes(&rate, length: sizeofValue(rate))
        
        let reserve = data.subdataWithRange(reserved)
        let reserv = NSString(data: reserve, encoding: NSUTF8StringEncoding) as! String
        
        let returned = newsOfQuote(msgTyp: msgInt, sessionID: sessionID, symName: name, symCode: code, symPric: price, symRate: rate, Reserve: reserv)
        return returned
    }
    // End msgType: 226
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
    var stateOfReceived: String!
    var client: TCPClient!
    var statusOfSocket: String!
    var secType: UInt8!
    var msgType: UInt8!
    var sessionID: String!
    var selectedExchangeID: UInt8!
    var wasAdding: Bool = false

    var symbol: String!

    
    func sendData(){
        if self.wasAdding{
            //stock adding msg
            self.stateOfReceived = "stock adding"
            self.msgType = 115
        }else {
            //stock deleting msg
            self.stateOfReceived = "stock deleting"
            self.msgType = 116
        }
        if self.client != nil {
//            self.client.close()
        }
        let quoteListNews: stockAddDel = stockAddDel(
            msgType: self.msgType,
            sessionID: sessionIDD,
            secType: self.secType,
            exgType: self.selectedExchangeID,
            symbol: self.symbol,
            reserved: "")
        let sendData = self.toNSData(quoteListNews)
        print("\(self.msgType): \(sendData.length)")
        self.client = TCPClient(addr: SERVER_IP, port: SERVER_PORT)
        self.client.delegate = self
        self.client.connectServer(timeout: 3)
        self.client.send(data: sendData)
    }
    
    func client(client: TCPClient, connectSververState state: ClientState) {
        
    }
    func client(client: TCPClient, receivedData data: NSData) {
        
    }
}