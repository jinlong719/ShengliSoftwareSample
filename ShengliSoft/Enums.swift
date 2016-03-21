//
//  Enums.swift
//  Resume
//
//  Created by Admin on 10/10/15.
//  Copyright © 2015 iCloudTest. All rights reserved.
//


enum Error: ErrorType{
    case EmptyField
    case PasswordDoNotMatch
    case InvalidEmail
    case IncorrectSignIn
    case InvalidPassword
}

extension Error: CustomStringConvertible
{
    var description: String{
        switch self{
        case .EmptyField:
            return "请填写所有字段"
        case .PasswordDoNotMatch:
            return "密码不匹配"
        case .InvalidEmail:
            return "请输入有效电子邮件"
        case .IncorrectSignIn:
            return "用户标识或密码正确"
        case .InvalidPassword:
            return "密码必须是8个或更多字符，\n和包括数字和大写字母"
        }
    }
}