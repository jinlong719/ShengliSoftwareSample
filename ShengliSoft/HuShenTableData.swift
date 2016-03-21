//
//  HuShenTableData.swift
//  ShengliSoft
//
//  Created by Admin on 11/23/15.
//  Copyright © 2015 iCloudTest. All rights reserved.
//

import Foundation


class HuShenTableData {
    var sectionName: String
    var guCountry: [String]
    var guPrice: [Double]
    var guIndex: [String]
    var guPercent: [Double]
    var guName: [String]
    
    init(secName: String, gName: [String], gCountries: [String], gPrices:[Double], gIndex: [String], gPercents: [Double]){
        self.sectionName = secName
        self.guCountry = gCountries
        self.guPrice = gPrices
        self.guIndex = gIndex
        self.guPercent = gPercents
        self.guName = gName
    }
}