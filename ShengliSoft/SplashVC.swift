//
//  SplashVC.swift
//  ShengLiJinRong
//
//  Created by Admin on 10/25/15.
//  Copyright © 2015 iCloudTest. All rights reserved.
//

import UIKit
import CocoaAsyncSocket



class SplashVC: UIViewController, TCPClientDelegate, GCDAsyncSocketDelegate {
    
    var client: TCPClient!
    
    func client(client: TCPClient, connectSververState state: ClientState) {
        let status = state.hashValue
        if status == 2
        {
            let alert = UIAlertController(title: "警告",
                                        message: "服务器号错了 \n 再试一试？",
                                 preferredStyle: UIAlertControllerStyle.Alert)
            
            let actionBtn = UIAlertAction(title: "是", style: UIAlertActionStyle.Default, handler: {
                alert -> Void in
                self.getIPandTest()
            })
            alert.addAction(actionBtn)
            self.presentViewController(alert, animated: true, completion: nil)
        }else{
            SERVER_IP = self.serverN
            SERVER_PORT = self.portN
        }
    }
    func client(client: TCPClient, receivedData data: NSData) {
        
    }
    
    var serverN: String!
    var portN: Int!
    func getIPandTest(){
        let alertController = UIAlertController(title: "服务器地址和连接口号", message: "请输入您的服务器地址和连接口号", preferredStyle: UIAlertControllerStyle.Alert)
        
        let saveAction = UIAlertAction(title: "测试", style: UIAlertActionStyle.Default, handler: {
            alert -> Void in
            
            self.serverN = alertController.textFields![0].text! as String
            self.portN = Int(alertController.textFields![1].text!)
            if self.serverN != nil && self.portN != nil{
                self.client = TCPClient(addr: self.serverN, port: self.portN)
                self.client.delegate = self
                self.client.connectServer(timeout: 3)
            }else{
                self.getIPandTest()
            }
        })
        
        alertController.addTextFieldWithConfigurationHandler { (textField : UITextField!) -> Void in
            textField.placeholder = "IP地址"
            textField.keyboardType = .NumbersAndPunctuation
            textField.text = self.serverN
        }
        alertController.addTextFieldWithConfigurationHandler { (textField : UITextField!) -> Void in
            textField.placeholder = "端口号"
            if self.portN != nil{
                textField.text = "\(self.portN)"
            }
            textField.keyboardType = .NumbersAndPunctuation
        }        
        alertController.addAction(saveAction)
        dispatch_async(dispatch_get_main_queue(), {
            self.presentViewController(alertController, animated: true, completion: nil)
        })
    }
    func testUser(){
        if let ssIP = userDefaults.objectForKey("sIP") as? String{
//            sessionIDD = ssID.componentsSeparatedByString("\0")[0]
            SERVER_PORT = userDefaults.objectForKey("sPort") as! Int
            SERVER_IP = ssIP
//            SERVER_IP = userDefaults.objectForKey("sIP") as! String
            
//            let vc = self.storyboard!.instantiateViewControllerWithIdentifier("zixuanguMainView")
//            self.presentViewController(vc, animated: true, completion: nil)
            self.serverN = ssIP
            self.portN = SERVER_PORT
            self.getIPandTest()
        }else{
            self.getIPandTest()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.testUser()

    }
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        self.client.close()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    // Seeing part of whole part.
    @IBAction func liaojieBtn(sender: AnyObject) {
        let alert = UIAlertController(title: "快速了解金融页",
            message: "开发中",
            preferredStyle: UIAlertControllerStyle.Alert)
        
        alert.addAction(UIAlertAction(title: "好的",
            style: UIAlertActionStyle.Default,
            handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    // MARK : - Parsing received data from server and change the state of this UI.
    


}
