//
//  GuPiaoData.swift
//  ShengliSoft
//
//  Created by Admin on 11/23/15.
//  Copyright © 2015 iCloudTest. All rights reserved.
//

import Foundation


class GuPiaoData{
    var guCountry: String
    var guName: String
    var guPrice: Double
    var guRate: Double
    var guCode: String
    
    init(gCountry: String, gName: String, gPrice: Double, gRate: Double, gCode: String){
        self.guCountry = gCountry
        self.guName = gName
        self.guPrice = gPrice
        self.guRate = gRate
        self.guCode = gCode
    }
}