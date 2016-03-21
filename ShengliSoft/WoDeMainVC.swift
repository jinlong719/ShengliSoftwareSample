//
//  WoDeMainVC.swift
//  ShengLiJinRong
//
//  Created by Admin on 10/25/15.
//  Copyright © 2015 iCloudTest. All rights reserved.
//

import UIKit

class WoDeMainVC: UIViewController, UITextFieldDelegate, TCPClientDelegate {
    
    //Mark: - Define for
    struct logOutMsg {
        var msgType: Int16
        var sessionID: String
        var reserved: String
    }
    struct ArchivedLogOut {
        var lenMsg: Int16
        var lenSes: Int16
        var lenRes: Int16
    }
    func dataForNSData(var logOut: logOutMsg) -> NSData{
        var archivedLogOut = ArchivedLogOut(lenMsg: 1, lenSes: 32, lenRes: 7)
        let metaData = NSData(bytes: &archivedLogOut, length: 0)
        let archivedData = NSMutableData(data: metaData)
        archivedData.appendBytes(&logOut.msgType, length: 1)
        archivedData.appendBytes(logOut.sessionID, length: 32)
        archivedData.appendBytes(logOut.reserved, length: 7)
        return archivedData
    }
    // NSData to logOutMsg
    struct retMsg {
        var msgType: Int16
        var sessionID: String
        var results: String
        var reasonS: String
        var reserve: String
    }
    struct LengthLogOut {
        var lenMsg: Int16
        var lenSID: Int16
        var lenRes: Int16
        var lenRea: Int16
        var reserved: Int16
    }
    func reConvert(data: NSData) -> retMsg{
        var unarchivedResData = LengthLogOut(lenMsg: 1, lenSID: 32, lenRes: 1, lenRea: 128, reserved: 6)
        let archivedData = data.subdataWithRange(NSMakeRange(0, 0))
        archivedData.getBytes(&unarchivedResData, length: 168)
        
        let msgRange = NSMakeRange(0, 1)
        let sIDRange = NSMakeRange(1, 32)
        let resRange = NSMakeRange(33, 1)
        let reaRange = NSMakeRange(34, 128)
        let reserved = NSMakeRange(162, 6)
        
        let msgBody = data.subdataWithRange(msgRange)
        var msgInt:Int16 = 0
        msgBody.getBytes(&msgInt, range: msgRange)
        
        let sidBody = data.subdataWithRange(sIDRange)
        let sessionID = self.toString(sidBody)
        
        let results = data.subdataWithRange(resRange)
        let resStr = String(data: results, encoding: NSUTF8StringEncoding)!
        
        let reasonR = data.subdataWithRange(reaRange)
        let reasons = self.toString(reasonR)
        
        let reserve = data.subdataWithRange(reserved)
        let reserv = self.toString(reserve)
        
        let returned = retMsg(msgType: msgInt, sessionID: sessionID, results: resStr, reasonS: reasons, reserve: reserv)
        return returned
    }
    func toString(data: NSData) -> String{
        var retString: String = ""
        let strLen = data.length
        var bIndex: Int = 0
        repeat{
            let charBody = data.subdataWithRange(NSMakeRange(bIndex, 1))
            if bIndex+1<strLen{
                if let subString = String(data: charBody, encoding: NSUTF8StringEncoding){
                    if subString != "\0"{
                        retString += "\(subString)"
                    }
                }
            }
            bIndex += 1
        }while (strLen-bIndex)>0
        return retString
    }
    //MARK: - Password change
    //Mark: - Define for
    struct pwdMsg {
        var msgType: Int16
        var sessionID: String
        var userID: String
        var oldPwd: String
        var newPwd: String
        var reserved: String
    }
    struct ArchivedPwd {
        var lenMsg: Int16
        var lenSes: Int16
        var lenUID: Int16
        var lenOld: Int16
        var lenNew: Int16
        var lenRes: Int16
    }
    func struToNSData(var chgPwd: pwdMsg) -> NSData{
        var archivedLogOut = ArchivedPwd(lenMsg: 1, lenSes: 32, lenUID: 16, lenOld: 65, lenNew: 65, lenRes: 5)
        let metaData = NSData(bytes: &archivedLogOut, length: 0)
        let archivedData = NSMutableData(data: metaData)
        archivedData.appendBytes(&chgPwd.msgType, length: 1)
        archivedData.appendBytes(chgPwd.sessionID, length: 32)
        archivedData.appendBytes(chgPwd.userID, length: 16)
        archivedData.appendBytes(chgPwd.oldPwd, length: 65)
        archivedData.appendBytes(chgPwd.newPwd, length: 65)
        archivedData.appendBytes(chgPwd.reserved, length: 5)
        return archivedData
    }
    // NSData to logOutMsg
    struct retPwd {
        var msgType: Int16
        var sessionID: String
        var results: String
        var reasonS: String
        var reserve: String
    }
    struct LengthPwd {
        var lenMsg: Int16
        var lenSID: Int16
        var lenRes: Int16
        var lenRea: Int16
        var reserved: Int16
    }
    func NSDataToStru(data: NSData) -> retPwd{
        var unarchivedResData = LengthLogOut(lenMsg: 1, lenSID: 32, lenRes: 1, lenRea: 128, reserved: 6)
        let archivedData = data.subdataWithRange(NSMakeRange(0, 0))
        archivedData.getBytes(&unarchivedResData, length: 168)
        
        let msgRange = NSMakeRange(0, 1)
        let sIDRange = NSMakeRange(1, 32)
        let resRange = NSMakeRange(33, 1)
        let reaRange = NSMakeRange(34, 128)
        let reserved = NSMakeRange(162, 6)
        
        let msgBody = data.subdataWithRange(msgRange)
        var msgInt:Int16 = 0
        msgBody.getBytes(&msgInt, range: msgRange)
        
        let sidBody = data.subdataWithRange(sIDRange)
        let sessionID = self.toString(sidBody)
        
        let results = data.subdataWithRange(resRange)
        let resStr = self.toString(results)
        
        let reasonR = data.subdataWithRange(reaRange)
        let reasons = self.toString(reasonR)
        
        let reserve = data.subdataWithRange(reserved)
        let reserv = self.toString(reserve)
        
        let returned = retPwd(msgType: msgInt, sessionID: sessionID, results: resStr, reasonS: reasons, reserve: reserv)
        return returned
    }
    /////
    
    
    
    func client(client: TCPClient, connectSververState state: ClientState) {
        let status = state.hashValue
        if status == 2
        {
            if isLogOut
            {
                //LogOut
                let alert = UIAlertController(title: "密码修改失败",
                    message: "密码修改失败",
                    preferredStyle: UIAlertControllerStyle.Alert)
                
                alert.addAction(UIAlertAction(title: "好的",
                    style: UIAlertActionStyle.Default,
                    handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
            }else{
                // Password change
                let alert = UIAlertController(title: "密码修改失败",
                    message: "密码修改失败",
                    preferredStyle: UIAlertControllerStyle.Alert)
                
                alert.addAction(UIAlertAction(title: "好的",
                    style: UIAlertActionStyle.Default,
                    handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
            }
            
        }
    }
    func client(client: TCPClient, receivedData data: NSData) {
        let msgRange = NSMakeRange(0, 1)
        let msgBody = data.subdataWithRange(msgRange)
        var msgInt:UInt8 = 0
        msgBody.getBytes(&msgInt, range: msgRange)
        switch msgInt
        {
        case 203:
            // LogOut
            if self.isLogOut{
                self.isLogOut = false
                dispatch_async(dispatch_get_main_queue()) { [weak self] in
                    //            print("\(SERVER_IP): \(SERVER_PORT): \(data)")
                    let receivedData = self!.reConvert(data)
                    if receivedData.results == "Y"
                    {
                        app.hideWaitingScreen()
                        let loginVC: LoginVC! = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("loginView") as! LoginVC
                        self!.presentViewController(loginVC, animated: true, completion: nil)
                    }else {
                        app.hideWaitingScreen()
                        let alert = UIAlertController(title: "警告",
                            message: "用户登出失败",
                            preferredStyle: UIAlertControllerStyle.Alert)
                        
                        alert.addAction(UIAlertAction(title: "好的",
                            style: UIAlertActionStyle.Default,
                            handler: nil))
                        self!.presentViewController(alert, animated: true, completion: nil)
                    }
                }
            }
        case 204:
            // Password change
            if !self.isLogOut{
                dispatch_async(dispatch_get_main_queue()) { [weak self] in
                    //            print("\(SERVER_IP): \(SERVER_PORT): \(data)")
                    let receivedData = self!.reConvert(data)
                    if receivedData.results == "Y"
                    {
                        app.hideWaitingScreen()
                    }else {
                        app.hideWaitingScreen()
                        let alert = UIAlertController(title: "密码修改失败",
                            message: "密码修改失败",
                            preferredStyle: UIAlertControllerStyle.Alert)
                        
                        alert.addAction(UIAlertAction(title: "好的",
                            style: UIAlertActionStyle.Default,
                            handler: nil))
                        self!.presentViewController(alert, animated: true, completion: nil)
                    }
                }
            }
        default:
            break
        }
    }
    
    var client = TCPClient!()
    var isLogOut: Bool = false
    var userLogOut: logOutMsg!
    
    @IBOutlet weak var oldPwdTxt: FloatLabelTextField!
    @IBOutlet weak var newPwdTxt: FloatLabelTextField!
    @IBOutlet weak var confirmTxt: FloatLabelTextField!
    @IBAction func changeBtn(sender: UIButton) {
        self.isLogOut = false
        if ((self.oldPwdTxt.text != nil) && (self.newPwdTxt.text != nil) && (self.confirmTxt.text != nil))
        {
            if self.newPwdTxt.text == self.confirmTxt.text
            {
                app.showWaitingScreen("密码修正中...", bShowText: true, size: CGSizeMake(150, 100))
                dispatch_async(dispatch_get_main_queue()){ [weak self] in
                    self!.chngPwd()
                }
            }else{
                let alert = UIAlertController(title: "警告",
                    message: "密码不匹配",
                    preferredStyle: UIAlertControllerStyle.Alert)
                
                alert.addAction(UIAlertAction(title: "好的",
                    style: UIAlertActionStyle.Default,
                    handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
            }
        }else{
            let alert = UIAlertController(title: "警告",
                message: "请填写所有字段",
                preferredStyle: UIAlertControllerStyle.Alert)
            
            alert.addAction(UIAlertAction(title: "好的",
                style: UIAlertActionStyle.Default,
                handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    @IBAction func logOutBtn(sender: UIButton) {
        self.isLogOut = true
        app.showWaitingScreen("用户等出中...", bShowText: true, size: CGSizeMake(150, 100))
        dispatch_async(dispatch_get_main_queue()){ [weak self] in
            self!.logOut()
        }
    }
    func logOut(){
        //        self.stateOfSocket = "Version checking"
        userLogOut = logOutMsg(msgType: 103, sessionID: sessionIDD, reserved: "")
        if self.client != nil {
//            self.client.close()
        }
        let sendData = self.dataForNSData(userLogOut)
        self.client = TCPClient(addr: SERVER_IP, port: SERVER_PORT)
        self.client.delegate = self
        self.client.connectServer(timeout: 10)
        self.client.send(data: sendData)
        print("103: \(sendData.length)")
    }
    
    var chgePwd = pwdMsg!()
    func chngPwd(){
        //        self.stateOfSocket = "Version checking"
        chgePwd = pwdMsg(msgType: 104, sessionID: sessionIDD, userID: "aaaa", oldPwd: self.oldPwdTxt.text!, newPwd: self.newPwdTxt.text!, reserved: "")
        if self.client != nil {
//            self.client.close()
        }
        let sendData = self.struToNSData(chgePwd)
        self.client = TCPClient(addr: SERVER_IP, port: SERVER_PORT)
        self.client.delegate = self
        self.client.connectServer(timeout: 10)
        self.client.send(data: sendData)
        print("104: \(sendData.length)")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.oldPwdTxt.delegate = self
        self.newPwdTxt.delegate = self
        self.confirmTxt.delegate = self
        
        self.oldPwdTxt.text = ""
        self.newPwdTxt.text = ""
        self.confirmTxt.text = ""
        
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.oldPwdTxt.resignFirstResponder()
        self.newPwdTxt.resignFirstResponder()
        self.confirmTxt.resignFirstResponder()
        self.view.endEditing(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
