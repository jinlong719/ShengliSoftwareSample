//
//  SignUpVC.swift
//  ShengLiJinRong
//
//  Created by Admin on 10/25/15.
//  Copyright © 2015 iCloudTest. All rights reserved.
//

import UIKit
// Mark: - Spinner activity Indicator
let app = UIApplication.sharedApplication().delegate as! AppDelegate

class SignUpVC: UIViewController, UITextFieldDelegate, TCPClientDelegate {
//MARK: - Making send data
    struct signUp {
        var msgType: Int8
        var userID: String
        var userPass: String
        var userMail: String
        var reservd: String
    }
    struct ArchivedSignUp {
        var msgType: Int8
        var lengthUserID: Int8
        var lengthUserPass: Int8
        var lengthUserMail: Int8
        var lengthReserved: Int8
    }
    func archive(var user: signUp) -> NSData
    {
        var archivedSignUp = ArchivedSignUp(
            msgType: 1,
            lengthUserID: 16,
            lengthUserPass: 65,
            lengthUserMail: 64,
            lengthReserved: 6
        )
        let metaData = NSData(bytes: &archivedSignUp, length: 0)
        let archivedData = NSMutableData(data: metaData)
        archivedData.appendBytes(&user.msgType, length: 1)
        archivedData.appendBytes(user.userID, length: 16)
        archivedData.appendBytes(user.userPass, length: 65)
        archivedData.appendBytes(user.userMail, length: 64)
        archivedData.appendBytes(user.reservd, length: 6)
        
        
        return archivedData
    }
// MARK: - Making receive data
    struct resData {
        var msgType: Int16
        var results: String
        var msgBody: String
        var reserved: String
    }
    struct LengthResData {
        var msgType: Int16
        var results: Int16
        var lenMsg: Int16
        var lenRes: Int16
    }
    func unarchive(data: NSData) -> resData
    {
        var unarchivedResData = LengthResData(msgType: 1, results: 1, lenMsg: 128, lenRes: 6)
      
        let archivedData = data.subdataWithRange(NSMakeRange(0, 0))
        archivedData.getBytes(&unarchivedResData, length: 136)
        
        let msgRange = NSMakeRange(0, 1)
        let resRange = NSMakeRange(1, 1)
        let reaRange = NSMakeRange(2, 128)
        let reserved = NSMakeRange(130, 6)
        
        let msgBody = data.subdataWithRange(msgRange)
        var msgInt:Int16 = 0
        
        msgBody.getBytes(&msgInt, range: msgRange)
        
        let results = data.subdataWithRange(resRange)
        let resStr = NSString(data: results, encoding: NSUTF8StringEncoding) as! String
        let reasonR = data.subdataWithRange(reaRange)
        let reasons = self.toString(reasonR)
        
        let reserve = data.subdataWithRange(reserved)
        let reserv = self.toString(reserve)
        
        let returned = resData(msgType: msgInt, results: resStr, msgBody: reasons, reserved: reserv)
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
    
//    let app = UIApplication.sharedApplication().delegate as! AppDelegate
 
    var client: TCPClient!
    var user = signUp!()
    @IBOutlet weak var userID: FloatLabelTextField!
    @IBOutlet weak var userEmail: FloatLabelTextField!
    @IBOutlet weak var userPwd: FloatLabelTextField!
    @IBOutlet weak var userPwdConfirnTxt: FloatLabelTextField!
    @IBOutlet weak var errLbl: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // TextField dismiss
        self.userEmail.delegate = self
        self.userPwd.delegate = self
        self.userPwdConfirnTxt.delegate = self
        //
//        self.userID.text = "Aa123"
//        self.userEmail.text = "a@a.com"
//        self.userPwd.text = "1TgaTga2"
//        self.userPwdConfirnTxt.text = "1TgaTga2"
        self.userID.text = ""
        self.userEmail.text = ""
        self.userPwd.text = ""
        self.userPwdConfirnTxt.text = ""

        
    }
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.userEmail.resignFirstResponder()
        self.userPwdConfirnTxt.resignFirstResponder()
        self.userPwd.resignFirstResponder()
        self.view.endEditing(true)
    }
    func signUpToServer()
    {
        if self.client != nil {
//            self.client.close()
        }
        let sendData = self.archive(user)
        self.client = TCPClient(addr: SERVER_IP, port: SERVER_PORT)
        self.client.delegate = self
        self.client.connectServer(timeout: 10)
        self.client.send(data: sendData)
        print("Send to server: \(100)")
    }
    func client(client: TCPClient, connectSververState state: ClientState) {
        print(state)
    }
    func client(client: TCPClient, receivedData data: NSData) {
        dispatch_async(dispatch_get_main_queue()){
            let recieved = self.unarchive(data)
            //        print("Recieved: \(recieved)")
            app.hideWaitingScreen()
            if recieved.results == "Y"
            {
                let alert = self.signupSuccessAlert()
                self.presentViewController(alert, animated: true, completion: nil)
            }else
            {
                self.errLbl.text = "用户注册失败!"
                self.errLbl.sizeToFit()
            }
        }
    }
    //
    @IBAction func signupBtn(sender: UIButton) {
    // MARK: - Checking the input parameters with normal credititional rules
        app.showWaitingScreen("用户注册中...", bShowText: true, size: CGSizeMake(150, 100))
        let signup = SignUp(uID: self.userID.text!, uEmail: self.userEmail.text!, pass: self.userPwd.text!, coPass: self.userPwdConfirnTxt.text!)
        do {
            try signup.signUpUser()
            user = signUp(
                msgType: 100,
                userID: self.userID.text!,
                userPass: self.userPwd.text!,
                userMail: self.userEmail.text!,
                reservd: ""
            )
            self.signUpToServer()
        } catch let error as Error {
            self.errLbl.text = error.description
            self.errLbl.sizeToFit()
            app.hideWaitingScreen()
        } catch {
            self.errLbl.text = "你错了！再试一次。"
            self.errLbl.sizeToFit()
            app.hideWaitingScreen()
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func signupSuccessAlert() -> UIAlertController {
        let alertView = UIAlertController(title: "注册成功", message: "现在，您可以登录进行完全访问", preferredStyle: UIAlertControllerStyle.Alert)
        alertView.addAction(UIAlertAction(title: "登录", style: .Default, handler: {(alertAction) -> Void in
            self.dismissViewControllerAnimated(true, completion: nil)
        }))
        alertView.addAction(UIAlertAction(title: "取消", style: .Cancel, handler: nil))
        return alertView
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
