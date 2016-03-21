//
//  Utilities.swift
//  ShengliSoft
//
//  Created by LandCruiser on 2/26/16.
//  Copyright © 2016 iCloudTest. All rights reserved.
//

import Foundation

// Initialization parameters of this project.
var SERVER_IP: String!
var SERVER_PORT: Int!
var CURRENT_STATUS: String!
var SESSION_ID: String!
var userDefaults = NSUserDefaults.standardUserDefaults()








let respondLen: [Int: Int] = [106: 40, 207:112, 208: 168, 107: 80, 210: 40, 211: 184, 212: 168, 213:120, 214:192, 215:80, 216: 40, 217: 160, 218: 168, 222: 40, 223: 112, 224: 168]

//MARKL: - Getting msgType from received NSData.
func getMsgTypeFromNSData(data: NSData) -> UInt16{
    var retMsgType: UInt16 = 0
    let msgRange = NSMakeRange(0, 1)
    let msgBody = data.subdataWithRange(msgRange)
    msgBody.getBytes(&retMsgType, range: msgRange)
    return retMsgType
}

func nsdataToJSON(data: NSData) -> AnyObject? {
    do {
        return try NSJSONSerialization.JSONObjectWithData(data, options: .MutableContainers)
    } catch let myJSONError {
        print(myJSONError)
    }
    return nil
}

// Convert from JSON to nsdata
func jsonToNSData(json: AnyObject) -> NSData?{
    do {
        return try NSJSONSerialization.dataWithJSONObject(json, options: NSJSONWritingOptions.PrettyPrinted)
    } catch let myJSONError {
        print(myJSONError)
    }
    return nil;
}

var socketProc: [Int: Int] = [206: 40, 207:112, 208: 168, 210: 40, 211: 184, 212: 168, 213:120, 214:192, 215:80, 216: 40, 217: 160, 218: 168, 222: 40, 223: 112, 224: 168]
//MARK:- Getting multiple NSData set from received data.
func fixingSockets(data: NSData) -> [NSData]{
    var returnSockets: [NSData] = []
    var tmpNSData: NSData!
    var trimedData: NSData!
    var socketLen = data.length
    var offNum: Int = 0
    tmpNSData = data
    repeat{
        for (key, value) in socketProc{
            if socketLen>0{
                let msgInt = getMsgTypeFromNSData(tmpNSData)                
                if key == Int(msgInt){
                    trimedData = data.subdataWithRange(NSMakeRange(offNum, value))
                    offNum += value
                    socketLen -= value
                    returnSockets.append(trimedData)
                    tmpNSData = data.subdataWithRange(NSMakeRange(offNum, socketLen))
                }
            }
        }
    }while socketLen > 0
    return returnSockets
}
//GradientView from top to bottom
@IBDesignable class GradientView: UIView{
    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    var firstColor: UIColor = UIColor.whiteColor()
    var secondColor: UIColor = UIColor.blackColor()
    override class func layerClass() -> AnyClass{
        return CAGradientLayer.self
    }
    override func layoutSubviews() {
        (layer as! CAGradientLayer).colors = [firstColor.CGColor, secondColor.CGColor]
    }
}
// Gradient view from left to right
func gradient(frame: CGRect) -> CAGradientLayer{
    let startColor = UIColor(red: 1, green: 0, blue: 0, alpha: 0.5)
    let endedColor = UIColor(red: 0, green: 1, blue: 0, alpha: 0.5)
    let layer = CAGradientLayer()
    layer.frame = frame
    layer.startPoint = CGPointMake(0, 0.5)
    layer.endPoint = CGPointMake(1, 0.5)
    layer.colors = [startColor, endedColor]
    return layer
}


extension Double {
    var roundTo2f: Double {return Double(round(100*self)/100)  }
    var roundTo3f: Double {return Double(round(1000*self)/1000) }
}
extension Float {
    var roundTo2f: Float {return Float(round(100*self)/100)  }
    var roundTo3f: Float {return Float(round(1000*self)/1000) }
}
func roundToPlaces(value:Double, places:Int) -> Double {
    let divisor = pow(10.0, Double(places))
    return round(value * divisor) / divisor
}