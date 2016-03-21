//
//  SignUp.swift
//  Resume
//
//  Created by Admin on 10/10/15.
//  Copyright © 2015 iCloudTest. All rights reserved.
//

class SignUp: NSObject {

    var userID: String?
    var userEmail: String?
    var userPass: String?
    var confPass: String?
    
    init(uID: String, uEmail: String, pass: String, coPass: String) {
        self.userID = uID
        self.userEmail = uEmail
        self.userPass = pass
        self.confPass = coPass
    }
    
    
    func signUpUser() throws -> Bool{
        guard hasEmptyValue() else {
            throw Error.EmptyField
        }
        
        guard isValid_Email() else {
            throw Error.InvalidEmail
        }
        guard validatePasswordsMatch() else {
            throw Error.PasswordDoNotMatch
        }
        guard checkPassSufficientComplexity() else {
            throw Error.InvalidPassword
        }
        return true        
    }
    
    func hasEmptyValue() -> Bool{
        if !userID!.isEmpty && !userEmail!.isEmpty && !confPass!.isEmpty
        {
            return true
        }
        return false
    }
    func isValid_Email() -> Bool
    {
        let emailEX = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9,-]+\\.[A-Za-z]{2,4}"
        let range = userEmail!.rangeOfString(emailEX, options: .RegularExpressionSearch)
        
        let results = range != nil ? true: false
        return results
    }
    func validatePasswordsMatch() ->Bool
    {
        if (userPass != confPass)
        {
            return false
        }
        return true
    }
    func checkPassSufficientComplexity() -> Bool
    {
        let captialLetterRegEX = ".*[A-Z]+.*"
        let textTest = NSPredicate(format: "SELF MATCHES %@", captialLetterRegEX)
        let capitalResult = textTest.evaluateWithObject(userPass!)
        print("Capital letter: \(capitalResult)")
        
        let numberRegEX = ".*[0-9]+.*"
        let textTest2 = NSPredicate(format: "SELF MATCHES %@", numberRegEX)
        let numberResult = textTest2.evaluateWithObject(userPass!)
        print("number included: \(numberResult)")
        
        let lengthResult = userPass!.characters.count >= 8
        print("Password length: \(lengthResult)")
        return capitalResult && numberResult && lengthResult
    }
    
}