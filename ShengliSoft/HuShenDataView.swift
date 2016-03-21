//
//  HuShenDataView.swift
//  ShengliSoft
//
//  Created by Admin on 11/15/15.
//  Copyright © 2015 iCloudTest. All rights reserved.
//  ++++++++++++++++++MsgType:++++++++++++++++++
//  ***********     107 -> 209     *************
//  ++++++++++++++++++++++++++++++++++++++++++++

import Foundation
import CocoaAsyncSocket



class HuShenDataView{

    //MARK： －沪深股的详细数值显示
    struct reqMsgOfDetailData {
        var msgTyp: UInt8
        var sessionID: String
        var exchangeID: UInt8
        var dataTyp: UInt8
        var reserved: String
    }
    struct LenReqMsg {
        var lenMsg: Int16
        var lenSID: Int16
        var lenEID: Int16
        var lenTyp: Int16
        var lenRev: Int16
    }
    func reqToNSData(var reqMsg: reqMsgOfDetailData) -> NSData{
        var archivedOneGuReq = LenReqMsg(
            lenMsg: 1,
            lenSID: 32,
            lenEID: 1,
            lenTyp: 1,
            lenRev: 5
        )
        let metaData = NSData(bytes: &archivedOneGuReq, length: 0)
        let archivedData = NSMutableData(data: metaData)
        archivedData.appendBytes(&reqMsg.msgTyp, length: 1)
        archivedData.appendBytes(reqMsg.sessionID, length: 32)
        archivedData.appendBytes(&reqMsg.exchangeID, length: 1)
        archivedData.appendBytes(&reqMsg.dataTyp, length: 32)
        archivedData.appendBytes(reqMsg.reserved, length: 2)
        return archivedData
    }
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
        let strLen = data.length
        var bIndex: Int = 0
        repeat{
            let charBody = data.subdataWithRange(NSMakeRange(bIndex, 1))
            if bIndex+1<strLen{
                if let subString = String(data: charBody, encoding: NSUTF8StringEncoding){
                    if subString != "\0"{
                        retString += "\(subString)"
                    }
                }
            }
            bIndex += 1
        }while (strLen-bIndex)>0
        return retString
    }

    
    // Transmite data to server
    var myExchageIDs:[UInt8] = [100, 101, 101, 101, 101]
    var myDataType: [UInt8] = [0,1,2,3,4]
    
    var cnt = 0
    var dataCnt = 0
    var socketHelper = tcpSocket()
    
    func sendData(){
        if self.dataCnt < 5 && self.cnt < 5{
            let relatedData = reqMsgOfDetailData(
                msgTyp: 107,
                sessionID: sessionIDD,
                exchangeID: self.myExchageIDs[self.dataCnt],
                dataTyp: self.myDataType[self.dataCnt],
                reserved: ""
            )
            let sendData = self.reqToNSData(relatedData)
            CURRENT_STATUS = "Getting detailed information of HuShenStocks"
            self.socketHelper.sendSocket(107, sendData: sendData)
        }else{
            self.dataCnt = 0
            self.cnt = 0
        }
    }    
}





