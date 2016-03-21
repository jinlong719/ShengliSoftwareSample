//
//  LoginVC.swift
//  ShengLiJinRong
//
//  Created by Admin on 10/25/15.
//  Copyright © 2015 iCloudTest. All rights reserved.
//
import UIKit
import Foundation
import CocoaAsyncSocket

var userModel: User!
//var SERVER_IP: String = "192.168.1.136"
//var SERVER_PORT: Int = 30021

var sessionIDD: String!

class LoginVC: UIViewController, UITextFieldDelegate{
    //Mark: - Making signIn Data
    struct checkVersion {
        var msgType: Int16
        var version: String
        var reserve: String
    }
    struct ArchivedCheck {
        var msgType: Int16
        var lenVersion: Int16
        var lenReserved: Int16
    }
    func archive(var check: checkVersion) -> NSData{
        var archivedChk = ArchivedCheck(msgType: 1, lenVersion: 32, lenReserved: 7)
        let metaData = NSData(bytes: &archivedChk, length: 0)
        let archivedData = NSMutableData(data: metaData)
        archivedData.appendBytes(&check.msgType, length: 1)
        archivedData.appendBytes(check.version, length: 32)
        archivedData.appendBytes(check.reserve, length: 7)
        return archivedData
    }
    // MARK: - Paring the received data from server.
    struct reData {
        var msgType: Int16
        var results: String
        var reasonS: String
        var reserve: String
    }
    struct LengthResData {
        var msgType: Int16
        var lenRessults: Int16
        var lenReasons: Int16
        var lenReserve: Int16
    }
    func unarchivedResData(data: NSData) -> reData
    {
        var unarchivedData = LengthResData(msgType: 1, lenRessults: 1, lenReasons: 128, lenReserve: 6)
        let archivedData = data.subdataWithRange(NSMakeRange(0, 0))
        archivedData.getBytes(&unarchivedData, length: 136)
        
        let msgRange = NSMakeRange(0, 1)
        let resRange = NSMakeRange(1, 1)
        let reaRange = NSMakeRange(2, 128)
        let reserved = NSMakeRange(130, 6)
        let msgBody = data.subdataWithRange(msgRange)
        var msgInt: Int16 = 0
        msgBody.getBytes(&msgInt, range: msgRange)
        
        let resData = data.subdataWithRange(resRange)
        let results = NSString(data: resData, encoding: NSUTF8StringEncoding) as! String
        
        let reaStr = data.subdataWithRange(reaRange)
        let reasonS = self.toString(reaStr)
        
        let reserve = data.subdataWithRange(reserved)
        let reservedStr = String(data: reserve, encoding: NSUTF8StringEncoding)
        

        let returnedData = reData(msgType: msgInt, results: results, reasonS: reasonS, reserve: reservedStr!)
        return returnedData
        
    }
    
    // MARK: - Struct parameters creation for signing in.
    struct userSignIn {
        var msgType: Int16
        var userIDD: String
        var userPas: String
        var reserved: String
    }
    struct ArchivedSignIn{
        var msgType: Int16
        var lenUserIDD: Int16
        var lenUserPas: Int16
        var lenReserve: Int16
    }
    func archiveLogin(var login: userSignIn) -> NSData{
        var archivedLogin = ArchivedSignIn(msgType: 1, lenUserIDD: 16, lenUserPas: 65, lenReserve: 6)
        let metaData = NSData(bytes: &archivedLogin, length: 0)
        let archivedData = NSMutableData(data: metaData)
        archivedData.appendBytes(&login.msgType, length: 1)
        archivedData.appendBytes(login.userIDD, length: 16)
        archivedData.appendBytes(login.userPas, length: 65)
        archivedData.appendBytes(login.reserved, length: 6)
        return archivedData
    }
    // MARK: - Decompiling 
    struct retData {
        var msgType: Int16
        var sessionID: String
        var results: String
        var reasonS: String
        var reserved: String
    }
    struct LenRetData {
        var lenMsg: Int16
        var lenSID: Int16
        var lenRes: Int16
        var lenRea: Int16
        var lenRev: Int16
    }
    func unarchivedLogin(data: NSData) -> retData
    {
        var unarchivedResData = LenRetData(lenMsg: 1, lenSID: 32, lenRes: 1, lenRea: 128, lenRev: 6)
        
        let archivedData = data.subdataWithRange(NSMakeRange(0, 0))
        archivedData.getBytes(&unarchivedResData, length: 168)
        
        let msgRange = NSMakeRange(0, 1)
        let sesRange = NSMakeRange(1, 32)
        let resRange = NSMakeRange(33, 1)
        let reaRange = NSMakeRange(34, 128)
        let reserved = NSMakeRange(162, 6)
        
        let msgBody = data.subdataWithRange(msgRange)
        var msgInt:Int16 = 0
        msgBody.getBytes(&msgInt, range: msgRange)
        
        let sessionStr = data.subdataWithRange(sesRange)
        let sessionID = self.toString(sessionStr)

        
        let resStr = data.subdataWithRange(resRange)
        let results = NSString(data: resStr, encoding: NSUTF8StringEncoding) as! String
        
        let reasonR = data.subdataWithRange(reaRange)
        let reasonS = self.toString(reasonR)
      
        let reserve = data.subdataWithRange(reserved)
        let reserv = NSString(data: reserve, encoding: NSUTF8StringEncoding) as! String
        
        let returned = retData(msgType: msgInt, sessionID: sessionID, results: results, reasonS: reasonS, reserved: reserv)
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
    
    var wasChecked: Bool = false
    var msgChk: checkVersion!
    var userLogin: userSignIn!
    // Socket definition
    var socketHelper = tcpSocket()
    
    
    @IBOutlet weak var userNameLbl: FloatLabelTextField!
    @IBOutlet weak var userPwdLbl: FloatLabelTextField!
    @IBOutlet weak var errLbl: UILabel!
    
    
    override func viewDidLoad() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "NotiVerAndLogin:", name: "verAndLogin", object: nil )
        super.viewDidLoad()
        
        
        self.userNameLbl.delegate = self
        self.userPwdLbl.delegate = self
        self.userNameLbl.text = "abcABC123"
        self.userPwdLbl.text = "1TgaTga2"
        self.userNameLbl.resignFirstResponder()
        
    }
    func NotiVerAndLogin(notification: NSNotification){
        let data = notification.userInfo!["response"] as! NSData
        let msgRange = NSMakeRange(0, 1)
        let msgBody = data.subdataWithRange(msgRange)
        var msgInt:UInt8 = 0
        msgBody.getBytes(&msgInt, range: msgRange)
        switch msgInt{
        case 202:
            dispatch_async(dispatch_get_main_queue()) { [weak self] in
                let receivedData = self!.unarchivedLogin(data)
                if self!.wasChecked{
                    if receivedData.results == "Y"
                    {
                        sessionIDD = receivedData.sessionID
                        app.hideWaitingScreen()
                        self!.wasChecked = false
                        // MARK: Pass to next UI
                        //                    userDefaults.setObject(receivedData.sessionID, forKey: "sessID")
                        userDefaults.setObject(SERVER_IP, forKey: "sIP")
                        userDefaults.setObject(SERVER_PORT, forKey: "sPort")
                        userModel = User(uID: self!.userNameLbl.text!, uPwd: self!.userPwdLbl.text!, uEmail: "", uSID: "", myStocks: [])
                        userDefaults.synchronize()
                        //                        self!.client.close()
                        let vc = self!.storyboard?.instantiateViewControllerWithIdentifier("zixuanguMainView")
                        self!.showViewController(vc!, sender: vc)
                    }else {
                        app.hideWaitingScreen()
                        self!.errLbl.text = "版本检证失败了"
                        self!.errLbl.sizeToFit()
                    }
                }
            }
        case 201:
            dispatch_async(dispatch_get_main_queue()) { [weak self] in
                let receivedData = self!.unarchivedResData(data)
                if receivedData.results == "Y"
                {
                    self!.wasChecked = true
                    app.hideWaitingScreen()
                    self!.SignInToServer()
                }else {
                    app.hideWaitingScreen()
                    self!.errLbl.text = "版本检证失败了"
                    self!.errLbl.textColor = UIColor.whiteColor()
                    self!.errLbl.sizeToFit()
                }
            }
        default:
            break
        }
    }
    func CheckingVersion(){
        msgChk = checkVersion(msgType: 101, version: "1.0", reserve: "")
        let sendData = self.archive(msgChk)
        CURRENT_STATUS = "Version Checking"
        self.socketHelper.sendSocket(101, sendData: sendData)
    }
    
    func SignInToServer(){
        
        //MARK: - define of signin data 
        app.showWaitingScreen("用户登录中...", bShowText: true, size: CGSizeMake(150, 100))
        let signIn = SignIn(user: self.userNameLbl.text!, pass: self.userPwdLbl.text!)
        do {
            try signIn.signInUser()
            userLogin = userSignIn(msgType: 102, userIDD: self.userNameLbl.text!, userPas: self.userPwdLbl.text!, reserved: "")
            let sendData = self.archiveLogin(userLogin)
            CURRENT_STATUS = "User Login"
            self.socketHelper.sendSocket(102, sendData: sendData)
        } catch let error as Error{
            self.errLbl.text = error.description
            self.errLbl.sizeToFit()
        } catch {
            self.errLbl.text = "很抱歉有些事情出了问题，请重试"
            self.errLbl.sizeToFit()
        }
    }
   
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.userNameLbl.resignFirstResponder()
        self.userPwdLbl.resignFirstResponder()
        self.view.endEditing(true)
    }
    
    @IBAction func logInBtn(sender: UIButton) {
        self.view.endEditing(true)
        self.errLbl.text = nil
        app.showWaitingScreen("版本检证中...", bShowText: true, size: CGSizeMake(150, 100))
        dispatch_async(dispatch_get_main_queue()) {
            self.CheckingVersion()
        }
    }
    
    
    // Wechat login function part
    @IBAction func wechatBtn(sender: UIButton) {
        let alert = UIAlertController(title: "微信登录",
            message: "开发中",
            preferredStyle: UIAlertControllerStyle.Alert)
        
        alert.addAction(UIAlertAction(title: "好的",
            style: UIAlertActionStyle.Default,
            handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    // QQ login function
    @IBAction func qqBtn(sender: AnyObject) {
        let alert = UIAlertController(title: "QQ登录",
            message: "开发中",
            preferredStyle: UIAlertControllerStyle.Alert)
        
        alert.addAction(UIAlertAction(title: "好的",
            style: UIAlertActionStyle.Default,
            handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    // 新浪登录功能
    @IBAction func sinaBtn(sender: UIButton) {
        let alert = UIAlertController(title: "新浪登录",
            message: "开发中",
            preferredStyle: UIAlertControllerStyle.Alert)
        
        alert.addAction(UIAlertAction(title: "好的",
            style: UIAlertActionStyle.Default,
            handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
}
