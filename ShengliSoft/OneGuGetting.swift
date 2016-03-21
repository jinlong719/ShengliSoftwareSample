//
//  OneGuGetting.swift
//  ShengliSoft
//
//  Created by Admin on 11/14/15.
//  Copyright © 2015 iCloudTest. All rights reserved.



class OneGuGetting: TCPClientDelegate {
    
    struct OneGuReq {
        var msgType: Int16
        var sessionID: String
        var secType: Int8
        var exgType: Int8
        var symbol: String
        var reserved: String
    }
    struct lenOneGuReq {
        var lenMsg: Int16
        var lensID: Int16
        var lenSec: Int16
        var lenExg: Int16
        var lenSym: Int16
        var lenRes: Int16
    }
    func toNSData(var oneGu: OneGuReq) -> NSData{
        var archivedOneGuReq = lenOneGuReq(lenMsg: 1, lensID: 32, lenSec: 1, lenExg: 1, lenSym: 32, lenRes: 5)
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
    // Parsing the received data from the server
    struct OneGu {
        var msgType: Int16
        var sessionID: String
        var guName: String
        var guCode: String
        var guPrice: Float
        var guRate: Float
        var reserved: String
    }
    struct LenOneGu {
        var lenMsg: Int16
        var lenSID: Int16
        var lenName: Int16
        var lenCode: Int16
        var lenPrice: Int16
        var lenRate: Int16
        var lenResv: Int16
    }
    func toStruct(data: NSData)-> OneGu
    {
        var unarchivedResData = LenOneGu(lenMsg: 1, lenSID: 32, lenName: 32, lenCode: 32, lenPrice: 8, lenRate: 8, lenResv: 7)
        let archivedData = data.subdataWithRange(NSMakeRange(0, 0))
        archivedData.getBytes(&unarchivedResData, length: 120)
        
        let msgRange = NSMakeRange(0, 1)
        let sIDRange = NSMakeRange(1, 32)
        let nameRange = NSMakeRange(33, 32)
        let codeRange = NSMakeRange(65, 32)
        let pricRange = NSMakeRange(97, 8)
        let rateRange = NSMakeRange(105, 8)
        let reserved = NSMakeRange(113, 7)
        
        let msgBody = data.subdataWithRange(msgRange)
        var msgInt:Int16 = 0
        msgBody.getBytes(&msgInt, range: msgRange)
        
        let sidBody = data.subdataWithRange(sIDRange)
        let sessionID = NSString(data: sidBody, encoding: NSUTF8StringEncoding) as! String
        
        let nameBody = data.subdataWithRange(nameRange)
        let name = NSString(data: nameBody, encoding: NSUTF8StringEncoding) as! String
        
        let codeBody = data.subdataWithRange(codeRange)
        let code = NSString(data: codeBody, encoding: NSUTF8StringEncoding) as! String
        
        let priceBody = data.subdataWithRange(pricRange)
        var price: Float = 0
        priceBody.getBytes(&price, length: sizeof(Float))
        
        let rateBody = data.subdataWithRange(rateRange)
//        var rate: Float = 0
        var rate: float_t = 0
        rateBody.getBytes(&rate, length: sizeof(float_t))
        
        let reserve = data.subdataWithRange(reserved)
        let reserv = NSString(data: reserve, encoding: NSUTF8StringEncoding) as! String
        
        let returned = OneGu(msgType: msgInt, sessionID: sessionID, guName: name, guCode: code, guPrice: price, guRate: rate, reserved: reserv)
        return returned
    }
    
    var statusCode: Int!
    var client: TCPClient!
    //Current Socket connection state from data sent into server.
    func client(client: TCPClient, connectSververState state: ClientState) {
        self.statusCode = state.hashValue
    }
    
    
    //MARK: Received from Server
    func client(client: TCPClient, receivedData data: NSData) {
        dispatch_async(dispatch_get_main_queue()){
            [weak self] in
            let resOneGu = self!.toStruct(data)
            self!.returnedData.append(resOneGu)
            print("guGet: \(resOneGu)")
            self!.cnt++
            self!.sendData(self!.exchgeType, sID: self!.sessionID, secureType: self!.secureType)
        }
    }
    //
    var cnt: Int = 0
    var returnedData: [OneGu] = []
    var numOfGu: Int!
    var guNames: [String!] = []
    var exchgeType: Int8!
    var secureType: Int8!
    var sessionID: String!
    var hasReceived: Bool = false
    // MARK: - Sending data to server
    func sendData(exchgeType: Int8, sID: String, secureType: Int8){
        if self.guNames.count <= self.cnt
        {
            self.hasReceived = true
            print("ResData: \(self.returnedData)")
            return
        }else {
            let sendOne = OneGuReq(
                msgType: 105,
                sessionID: sessionIDD,
                secType: self.secureType,
                exgType: self.exchgeType,
                symbol: self.guNames[self.cnt],
                reserved: ""
            )
            
            if self.client != nil {
//                self.client.close()
            }
            let sendData = self.toNSData(sendOne)
            self.client = TCPClient(addr: SERVER_IP, port: SERVER_PORT)
            self.client.delegate = self
            self.client.connectServer(timeout: 3)
            self.client.send(data: sendData)
        }
    }
    
    //MARK: - multiple stock getting
    func multiGu() -> [OneGu]{
        self.cnt = 0
        self.numOfGu = guNames.count
        self.sendData(self.exchgeType, sID: self.sessionID, secureType: self.secureType)
        return self.returnedData
    }
}












