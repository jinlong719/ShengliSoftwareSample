//
//  tcpSocket.swift
//  ShengliSoft
//
//  Created by LandCruiser on 3/6/16.
//  Copyright © 2016 iCloudTest. All rights reserved.
//

import Foundation
import CocoaAsyncSocket


//



class tcpSocket: NSObject, GCDAsyncSocketDelegate {
    
    
    var bSocket = GCDAsyncSocket()
    var cuMsg: UInt16 = 0
    func sendSocket(sMsgType: UInt16, sendData: NSData){
        self.cuMsg = sMsgType
        if self.bSocket != nil{
            self.bSocket.disconnect()
            print("-------------------------------------------------------------------")
            print("Socket for \(sMsgType) was just disconnected with server at \(NSDate())")
            print("-------------------------------------------------------------------")
            print("")
        }
        self.bSocket.delegate = self
        self.bSocket.delegateQueue = dispatch_get_main_queue()
        do{
            try self.bSocket.connectToHost(SERVER_IP, onPort: UInt16(SERVER_PORT))
            self.bSocket.writeData(sendData, withTimeout: -1, tag: 0)
            self.bSocket.readDataWithTimeout(-1, tag: 0)
            if self.bSocket.isDisconnected{
                print("")
                print("***************************** Attention ****************************")
                print("Unexpectedly Socket for \(sMsgType) has disconnected with \(SERVER_IP): \(SERVER_PORT) at \(NSDate())")
                print("********************************************************************")
                print("")
            }
            print("++++++++++++++++++ \(self.cuMsg) ++++++++++++++++++")
            print("Status: \(CURRENT_STATUS)")
            print("Sent \(sMsgType): \(sendData.length) Bytes")
        }catch let error as NSError{
            print("Connection Error: \(error.localizedDescription)")
        }
    }
    
    func socket(sock: GCDAsyncSocket!, didConnectToHost host: String!, port: UInt16) {
//        print("\(self.cuMsg) - (\(host): \(port))")
    }
    func socket(sock: GCDAsyncSocket!, didReadData data: NSData!, withTag tag: Int) {
        
        let msgType = getMsgTypeFromNSData(data)
        switch msgType{
        case 200:
            dispatch_async(dispatch_get_main_queue()){
                print("Received \(msgType): \(data.length) Bytes")
                print("------------------- Finished --------------------")
                print("")
                NSNotificationCenter.defaultCenter().postNotificationName("", object: nil, userInfo: ["response": data])
            }
            break
        case 201:
            print("Received \(msgType): \(data.length) Bytes")
            print("------------------- Finished --------------------")
            print("")
            NSNotificationCenter.defaultCenter().postNotificationName("verAndLogin", object: nil, userInfo: ["response": data])
            break
        case 202:
            print("Received \(msgType): \(data.length) Bytes")
            print("------------------- Finished --------------------")
            print("")
            NSNotificationCenter.defaultCenter().postNotificationName("verAndLogin", object: nil, userInfo: ["response": data])
            break
        case 203:
            print("Received \(msgType): \(data.length) Bytes")
            print("------------------- Finished --------------------")
            print("")
            NSNotificationCenter.defaultCenter().postNotificationName("", object: nil, userInfo: ["response": data])
            break
        case 204:
            print("Received \(msgType): \(data.length) Bytes")
            print("------------------- Finished --------------------")
            print("")
            NSNotificationCenter.defaultCenter().postNotificationName("", object: nil, userInfo: ["response": data])
            break
        case 205:
            print("Received \(msgType): \(data.length) Bytes")
            print("--------------------------")
            print("")
            NSNotificationCenter.defaultCenter().postNotificationName("", object: nil, userInfo: ["response": data])
            break
        case 206:
            print("+++++++++++++++++++ \(self.cuMsg) : Started ++++++++++++++++++++++")
            print("Received \(msgType): \(data.length) Bytes")
            NSNotificationCenter.defaultCenter().postNotificationName("getHuShenStocks", object: nil, userInfo: ["response": data])
            self.bSocket.readDataWithTimeout(-1, tag: 0)
            break
        case 207:
            print("Received \(msgType): \(data.length) Bytes")
            NSNotificationCenter.defaultCenter().postNotificationName("getHuShenStocks", object: nil, userInfo: ["response": data])
            self.bSocket.readDataWithTimeout(-1, tag: 0)
            break
        case 208:
            NSNotificationCenter.defaultCenter().postNotificationName("getHuShenStocks", object: nil, userInfo: ["response": data])
            print("Received \(msgType): \(data.length) Bytes")
            print("------------------- Finished --------------------")
            break
        case 209:
            print("Received \(msgType): \(data.length) Bytes")
            NSNotificationCenter.defaultCenter().postNotificationName("getData", object: nil, userInfo: ["response": data])
            break
        case 210:
            print("+++++++++++++++++++ \(self.cuMsg) : Started ++++++++++++++++++++++")
            print("Received \(msgType): \(data.length)Bytes")
            NSNotificationCenter.defaultCenter().postNotificationName("getMultipleTableData", object: nil, userInfo: ["response": data])
            self.bSocket.readDataWithTimeout(-1, tag: 0)
            break
        case 211:
            print("Received \(msgType): \(data.length) Bytes")
            NSNotificationCenter.defaultCenter().postNotificationName("getMultipleTableData", object: nil, userInfo: ["response": data])
            self.bSocket.readDataWithTimeout(-1, tag: 0)
            break
        case 212:
            print("Received \(msgType): \(data.length) Bytes")
            NSNotificationCenter.defaultCenter().postNotificationName("getMultipleTableData", object: nil, userInfo: ["response": data])
            print("Received \(msgType): \(data.length) Bytes")
            print("-------------------         Finished         --------------------")
            break
        case 213:
            print("Received \(msgType): \(data.length)Bytes")
            NSNotificationCenter.defaultCenter().postNotificationName("", object: nil, userInfo: ["response": data])
            break
        case 214:
            print("Received \(msgType): \(data.length)Bytes")
            NSNotificationCenter.defaultCenter().postNotificationName("", object: nil, userInfo: ["response": data])
            break
        case 215:
            print("Received \(msgType): \(data.length)Bytes")
            NSNotificationCenter.defaultCenter().postNotificationName("", object: nil, userInfo: ["response": data])
            break
        case 216:
            print("Received \(msgType): \(data.length)Bytes")
            NSNotificationCenter.defaultCenter().postNotificationName("", object: nil, userInfo: ["response": data])
            break
        case 217:
            print("Received \(msgType): \(data.length)Bytes")
            NSNotificationCenter.defaultCenter().postNotificationName("", object: nil, userInfo: ["response": data])
            break
        case 218:
            print("Received \(msgType): \(data.length)Bytes")
            NSNotificationCenter.defaultCenter().postNotificationName("", object: nil, userInfo: ["response": data])
            break
        case 219:
            print("Received \(msgType): \(data.length)Bytes")
            NSNotificationCenter.defaultCenter().postNotificationName("", object: nil, userInfo: ["response": data])
            break
        case 220:
            print("Received \(msgType): \(data.length)Bytes")
            NSNotificationCenter.defaultCenter().postNotificationName("", object: nil, userInfo: ["response": data])
            break
        case 221:
            print("Received \(msgType): \(data.length)Bytes")
            NSNotificationCenter.defaultCenter().postNotificationName("", object: nil, userInfo: ["response": data])
            break
        case 222:
            
            print("+++++++++++++++++++ \(self.cuMsg) ++++++++++++++++++++++")
            print("Started")
            print("Received \(msgType): \(data.length) Bytes")
            NSNotificationCenter.defaultCenter().postNotificationName("getMyStocks", object: nil, userInfo: ["response": data])
            self.bSocket.readDataWithTimeout(-1, tag: 0)
            break
        case 223:
            print("Received \(msgType): \(data.length) Bytes")
            NSNotificationCenter.defaultCenter().postNotificationName("getMyStocks", object: nil, userInfo: ["response": data])
            self.bSocket.readDataWithTimeout(-1, tag: 0)
            break
        case 224:
            print("Received \(msgType): \(data.length) Bytes")
            NSNotificationCenter.defaultCenter().postNotificationName("getMyStocks", object: nil, userInfo: ["response": data])
            print("Finished")
            print("++++++++++++++++++++++++++++++++++++++++++++++++++++++++")
            print("")
            self.bSocket.readDataWithTimeout(-1, tag: 0)
            break
        case 225:
            self.bSocket.readDataWithTimeout(-1, tag: 0)
            print("Received \(msgType): \(data.length) Bytes")
            NSNotificationCenter.defaultCenter().postNotificationName("", object: nil, userInfo: ["response": data])
            break
        case 226:
            self.bSocket.readDataWithTimeout(-1, tag: 0)
            print("Received \(msgType): \(data.length) Bytes")
            NSNotificationCenter.defaultCenter().postNotificationName("", object: nil, userInfo: ["response": data])
            break
        case 227:
            print("Received \(msgType): \(data.length) Bytes")
            NSNotificationCenter.defaultCenter().postNotificationName("", object: nil, userInfo: ["response": data])
            break
        case 228:
            print("Received \(msgType): \(data.length)Bytes")
            NSNotificationCenter.defaultCenter().postNotificationName("", object: nil, userInfo: ["response": data])
            break
        default:
            break
        }
        
    }
    
    
}