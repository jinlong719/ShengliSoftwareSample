//
//  HuShenDetailValue.swift
//  ShengliSoft
//
//  Created by Admin on 11/23/15.
//  Copyright © 2015 iCloudTest. All rights reserved.
//

import Foundation


class HuShenViewDetailValue {
    var marketPrice: Float
    var upDownRate: Float
    var upDownPercent: Float
    
    init(market: Float, udPrice: Float, udPercent: Float){
        self.marketPrice = market
        self.upDownRate = udPrice
        self.upDownPercent = udPercent
    }
}