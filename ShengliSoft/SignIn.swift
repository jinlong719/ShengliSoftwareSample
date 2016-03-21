//
//  SignIn.swift
//  Resume
//
//  Created by Admin on 10/11/15.
//  Copyright © 2015 iCloudTest. All rights reserved.
//


class SignIn{
    var userName: String?
    var password: String?
    var loggingInEnded: Bool!
    
    
    init(user: String, pass: String){
        self.userName = user
        self.password = pass
    }
    
    func signInUser() throws{
        guard hasEmptyFields() else {
            throw Error.EmptyField
        }
    }
    
    
    func hasEmptyFields() -> Bool {
        
        if !userName!.isEmpty && !password!.isEmpty {
            return true
        }
        return false
    }

}