//
//  GuDetailDataClass.swift
//  ShengliSoft
//
//  Created by Admin on 11/26/15.
//  Copyright © 2015 iCloudTest. All rights reserved.
//

import Foundation


class GuSummaryData{
    
    var guName: String
    var guPrice: Double
    var guUDValue: Double
    var guUDRate: Double
    var highestPrice: Double
    var lowestPrice: Double
    var openPrice: Double
    var preClosed: Double
    var totVolumn: Double
    var turnOver: Double
    var turnOverRate: Double
    var topLimitedPrice: Double
    var bottomLimitedPrice: Double
    var comittee: Double
    var amountRatio: Double
    var amplitude: Double
    var priceEarningRatio: Double
    var volRatio: Double
    var marketPrice: Double
    var currencyValue: Double
    var guCode: String
    var guCountry: String
    
    init(gName: String, gPrice: Double, gUdValue: Double, gUdRate: Double, highest: Double, lowest: Double, open: Double, preClosed: Double, totalVol: Double, turnOver: Double, turnRate: Double, topLimited: Double, bottomLimited: Double,comittee: Double, amountRatio: Double, amplitude: Double, priceEarningRatio: Double, volRatio: Double, marketPrice: Double, currency: Double, symbol: String, guCountry: String){
        self.guName = gName
        self.guPrice = gPrice
        self.guUDValue = gUdRate
        self.guUDRate = gUdRate
        self.highestPrice = highest
        self.lowestPrice = lowest
        self.openPrice = open
        self.preClosed = preClosed
        self.totVolumn = totalVol
        self.turnOver = turnOver
        self.turnOverRate = turnRate
        self.topLimitedPrice = topLimited
        self.bottomLimitedPrice = bottomLimited
        self.comittee = comittee
        self.amountRatio = amountRatio
        self.amplitude = amplitude
        self.priceEarningRatio = priceEarningRatio
        self.volRatio = volRatio
        self.marketPrice = marketPrice
        self.currencyValue = currency
        self.guCode = symbol
        self.guCountry = guCountry
    }
}
class GuLEV2Data {
    var bidP1: Double
    var bidP2: Double
    var bidP3: Double
    var bidP4: Double
    var bidP5: Double
    var bidV1: Double
    var bidV2: Double
    var bidV3: Double
    var bidV4: Double
    var bidV5: Double
    var askP1: Double
    var askP2: Double
    var askP3: Double
    var askP4: Double
    var askP5: Double
    var askV1: Double
    var askV2: Double
    var askV3: Double
    var askV4: Double
    var askV5: Double
    
    init(bp1: Double,bp2:Double,bp3:Double,bp4:Double,bp5:Double,bv1: Double,bv2: Double,bv3: Double,bv4: Double,bv5: Double,ap1: Double,ap2: Double,ap3: Double,ap4: Double,ap5: Double,av1: Double,av2: Double,av3: Double,av4: Double,av5: Double){
        self.bidP1 = bp1
        self.bidP2 = bp2
        self.bidP3 = bp3
        self.bidP4 = bp4
        self.bidP5 = bp5
        self.bidV1 = bv1
        self.bidV2 = bv2
        self.bidV3 = bv3
        self.bidV4 = bv4
        self.bidV5 = bv5
        self.askP1 = ap1
        self.askP2 = ap2
        self.askP3 = ap3
        self.askP4 = ap4
        self.askP5 = ap5
        self.askV1 = av1
        self.askV2 = av2
        self.askV3 = av3
        self.askV4 = av4
        self.askV5 = av5
    }
    
}
class GuTimeSaleData{
    var time: String
    var price: Double
    var volumn: Double
    init(time: String, price: Double, volumn: Double){
        self.time = time
        self.price = price
        self.volumn = volumn
    }
}
class GuKchartData {
    
    var currentTime: String
    var symbolName: String
    var symbol: String
    var price: Double
    var upDown: Double
    var upDownRate: Double
    var highest: Double
    var lowest: Double
    var openPrice: Double
    var preClosedPrice: Double
    var totalVol: Double
    var turnOver: Double
    var av5: Double
    var av10: Double
    var av20: Double
    
    init(cuTime: String, symbolName: String, symbol: String, price: Double, upDown: Double, upDownRate: Double, highest: Double, lowest: Double, openPrice: Double, preClosed: Double, totalVolumn: Double, turnOver: Double, average5: Double, average10: Double, average20: Double){
        self.currentTime = cuTime
        self.symbolName = symbolName
        self.symbol = symbol
        self.price = price
        self.upDown = upDown
        self.upDownRate = upDownRate
        self.highest = highest
        self.lowest = lowest
        self.openPrice = openPrice
        self.preClosedPrice = preClosed
        self.totalVol = totalVolumn
        self.turnOver = turnOver
        self.av5 = average5
        self.av10 = average10
        self.av20 = average20
    }
    
    
}