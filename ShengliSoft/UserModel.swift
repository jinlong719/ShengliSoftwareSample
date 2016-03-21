//
//  UserModel.swift
//  ShengliSoft
//
//  Created by Admin on 11/13/15.
//  Copyright © 2015 iCloudTest. All rights reserved.
//

import Foundation

class User{
    var userID: String
    var userPwd: String
    var userEmail: String
    var sessionID: String
    var myStocks: [String]
    init(uID: String, uPwd: String, uEmail: String, uSID: String, myStocks: [String]){
        self.userID = uID
        self.userPwd = uPwd
        self.userEmail = uEmail
        self.sessionID = uSID
        self.myStocks = myStocks
    }
    
}
