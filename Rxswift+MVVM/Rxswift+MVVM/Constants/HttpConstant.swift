//
//  HttpConstant.swift
//  UBanHuiXueTech
//
//  Created by 潘强 on 2019/3/12.
//  Copyright © 2019 USI Technology (Shenzhen) Company. All rights reserved.
//

// url常量
import UIKit
import Foundation

//是否打印
let LOG_ENABLED = false

// MARK: - 服务器地址

#if false //测试环境
public enum UrlHostType:String {
    case Base = "https://c.m.163.com/"
}
//开发环境
//public enum UrlHostType:String {
//    case Base = "https://c.m.163.com/"
//}

#else
//生产环境
public enum UrlHostType:String {
    case Base = "https://c.m.163.com/"
}
#endif

// MARK: -- 网络请求接口
enum RequestUrlType:String {
    case GetNewsList = "dlist/article/dynamic"
}


enum NetWorkErrorCode: Int {
    case InvalidMobileNumber = 109005
    case HeadMasterAccount = 123456
}

