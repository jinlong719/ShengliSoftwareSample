//
//  HuShenGuMultipleTableData.swift
//  ShengliSoft
//
//  Created by Admin on 11/25/15.
//  Copyright © 2015 iCloudTest. All rights reserved.
//

import Foundation

class HuShenGuMultipleTableData{
    var name: String
    var code: String
    var recentPrice: Double
    var udRate: Double
    var udValue: Double
    var sellAmount: Double
    var sellPrice: Double
    var buyAmount: Double
    var buyPrice: Double
    var nowAmount: Double
    var totAmount: Double
    var openPrice: Double
    var highestPrice: Double
    var lowestPrice: Double
    var preClosePrice: Double
    var turnOver: Double
    var upLimitedPrice: Double
    var lowLimitedPrice: Double
    var averagePrice: Double
    var amplitude: Double
    
    init(name: String, code: String, recPrice: Double, udRate: Double, udValue:Double, selAmount: Double, selPrice: Double, buyAmount: Double, buyPrice: Double, nowAmount: Double, totAmount: Double, openPrice: Double, highestPrice: Double, lowestPrice: Double, preClosedPrice: Double, turnOver: Double, upLimit:Double, lowLimit: Double, average: Double, amplitude: Double){
        self.name = name
        self.code = code
        self.recentPrice = recPrice
        self.udRate = udRate
        self.udValue = udValue
        self.sellAmount = selAmount
        self.sellPrice = selPrice
        self.buyAmount = buyAmount
        self.buyPrice = buyPrice
        self.nowAmount = nowAmount
        self.totAmount = totAmount
        self.openPrice = openPrice
        self.highestPrice = highestPrice
        self.lowestPrice = lowestPrice
        self.preClosePrice = preClosedPrice
        self.turnOver = turnOver
        self.upLimitedPrice = upLimit
        self.lowLimitedPrice = lowLimit
        self.averagePrice = average
        self.amplitude = amplitude
    }
}

